local hud = {}
hud.shake = nil

function hud:create()
	hud.header = display.newGroup()
	hud.footer = display.newGroup()

	--game counter
	hud.ctr = display.newText(game.ctr, display.contentCenterX, -100, "media/Bungee-Regular.ttf", 32)
	hud.ctr:setFillColor(1,1,1)
	hud.ctr.id = "ctr"
	hud.ctr.zero = false

	--game score
	hud.score = display.newText("Score: " .. game.score, -15 + (display.contentCenterX / 4), (55 * game.rows + 80) + 140, "media/Bungee-Regular.ttf", 18)
	hud.score.anchorX = 0
	hud.score.id = "score"

	--pause button
	hud.pause = widget.newButton({
		id = "pause",
		label = "| |",

		x = display.contentWidth - 50,
		y =  -100,

		shape = "roundedRect",
		width = 50,
		height = 30,
		fillColor = {default = {1,1,1}, over = {0,0,0}},

		font = "media/Bungee-Regular.ttf",
		size = 64,
        labelColor = {default={0,0,0}, over={0,0,0}}
		})

	hud.settings = widget.newButton({
		id = "settings",
		label = "S",

		x = 50,
		y =  -100,

		shape = "roundedRect",
		width = 50,
		height = 30,
		fillColor = {default = {1,1,1}, over = {0,0,0}},

		font = "media/Bungee-Regular.ttf",
		size = 64,
        labelColor = {default={0,0,0}, over={0,0,0}}
		})

	hud.powerups = {}

	for i = 1, 3 do
		hud.powerups[i] = widget.newButton({
			id = tostring(i),
			label = tostring(i),

			x = 80 + (80 * (i - 1)),
			y = (display.contentHeight - 80) + 140,

			shape = "roundedRect",
			width = 75,
			height = 30,
			fillColor = {default = {1,1,1}, over = {0,0,0}},

			font = "media/Bungee-Regular.ttf",
			size = 13,
	        labelColor = {default={0,0,0}, over={0,0,0}}
			})
	end

	hud.header:insert(hud.ctr)
	hud.footer:insert(hud.score)
	hud.header:insert(hud.pause)
	hud.header:insert(hud.settings)

	for i = 1, 3 do
		hud.footer:insert(hud.powerups[i])
	end

	--event listeners
	Runtime:addEventListener("enterFrame", hud)
	hud.score:addEventListener("touch", hud)
	hud:animate()
end

function hud:remove()
	-- hud.ctr:removeSelf()
	-- hud.score:removeSelf()
	-- hud.pause:removeSelf()
	-- hud.settings:removeSelf()

	-- for i = 1, 3 do
	-- 	hud.powerups[i]:removeSelf()
	-- 	hud.powerups[i] = nil
	-- end
	-- hud.powerups = {}

	-- hud.ctr = nil
	-- hud.score = nil
	-- hud.pause = nil
	-- hud.settings = nil

	-- Runtime:removeEventListener("enterFrame", hud)
	transition.to(hud.header, {time = 500, y = -140, transition = easing.inBack, onComplete = function()
		hud.header:removeSelf()
	end})

	transition.to(hud.footer, {time = 500, y = 140, transition = easing.inBack, onComplete = function()
		hud.footer:removeSelf()
	end})
end

function hud:animate()
	transition.to(hud.header, {time = 500, y = 140, transition = easing.outBack})
	transition.to(hud.footer, {time = 500, y = -140, transition = easing.outBack})
end

function hud:enterFrame()
	hud.ctr.text = game.ctr
	hud.score.text = "Score: " .. game.score

	--test if counter is zero, and make the text change to show being done
	if game.ctr == 0 and hud.ctr.zero == false and #touch.points > 1 then
		hud.ctr.zero = true
		transition.to(hud.ctr, {time=150, xScale=1.5, yScale = 1.5, transition=easing.outSine})
		hud.shake = timer.performWithDelay(3000, function() game:shake(hud.ctr) end, 0)
	elseif (game.ctr ~= 0 and hud.ctr.zero == true) or (game.ctr == 0 and hud.ctr.zero == true and #touch.points == 0) then
		timer.cancel(hud.shake)
		transition.to(hud.ctr, {time=250, xScale=1, yScale = 1})
		hud.ctr.zero = false
	end

	--test if gamestate ~= game, then remove counter
	if game.state == "COMPUTE" and hud.ctr.alpha == 1 then
		game:shake(hud.ctr)
		transition.to(hud.ctr, {time = 150, alpha = 0, onStart = function() hud.ctr.alpha = 0.99 end})
	elseif game.state == "GAME" and hud.ctr.alpha == 0 then
		game:shake(hud.ctr)
		transition.to(hud.ctr, {time = 150, alpha = 1, onStart=function() hud.ctr.alpha = 0.01 end})
	end
end

function hud:touch(event)
	if event.target.id == "score" and event.phase == "ended" then
		composer.gotoScene("scenes.scene_menu")
		return true
	end
end

return hud