extends RefCounted
## Clip textured art to one rounded outer perimeter, keeping internal tile joins flat.

const CORNER_STEPS := 8

static func perimeter(bounds: Rect2, radius: float) -> PackedVector2Array:
	var points := PackedVector2Array()
	var inset := clampf(radius, 0.0, minf(bounds.size.x, bounds.size.y) * 0.5)
	if inset <= 0.0:
		return PackedVector2Array([bounds.position, Vector2(bounds.end.x, bounds.position.y), bounds.end, Vector2(bounds.position.x, bounds.end.y)])
	var centers := [
		Vector2(bounds.end.x - inset, bounds.position.y + inset),
		bounds.end - Vector2.ONE * inset,
		Vector2(bounds.position.x + inset, bounds.end.y - inset),
		bounds.position + Vector2.ONE * inset,
	]
	for corner in 4:
		for step in CORNER_STEPS + 1:
			var angle := (-0.5 + float(corner) * 0.5 + float(step) / CORNER_STEPS * 0.5) * PI
			points.append(centers[corner] + Vector2(cos(angle), sin(angle)) * inset)
	return points

static func draw_texture(canvas: CanvasItem, texture: Texture2D, bounds: Rect2, radius: float, tint := Color.WHITE) -> void:
	_draw_polygon(canvas, texture, perimeter(bounds, radius), bounds, Rect2(Vector2.ZERO, texture.get_size()), tint)
