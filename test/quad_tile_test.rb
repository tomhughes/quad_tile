require_relative "test_helper"

class QuadTileTest < Minitest::Test
  def test_tile_for_point
    assert_equal 3493907048, QuadTile.tile_for_point(51.0, 1.0)
    assert_equal 3493908088, QuadTile.tile_for_point(51.1, 1.0)
    assert_equal 3493913808, QuadTile.tile_for_point(51.1, 1.1)
    assert_equal 1221887424, QuadTile.tile_for_point(10.0, -123.0)
    assert_equal 2147483648, QuadTile.tile_for_point(-90.0, 0.0)
  end

  def test_tiles_for_area
    assert_equal [3493906992, 3493906993, 3493906996, 3493906997,
                  3493907040, 3493907041, 3493907044, 3493907045,
                  3493906994, 3493906995, 3493906998, 3493906999,
                  3493907042, 3493907043, 3493907046, 3493907047,
                  3493907000, 3493907001, 3493907004, 3493907005,
                  3493907048, 3493907049, 3493907052, 3493907053,
                  3493907002, 3493907003, 3493907006, 3493907007,
                  3493907050, 3493907051, 3493907054, 3493907055],
                 QuadTile.tiles_for_area(BoundingBox.new(0.99, 50.99, 1.01, 51.01))
    assert_equal [3493908065, 3493908068, 3493908069, 3493908080,
                  3493908081, 3493908084, 3493908085, 3493908256,
                  3493908067, 3493908070, 3493908071, 3493908082,
                  3493908083, 3493908086, 3493908087, 3493908258,
                  3493908073, 3493908076, 3493908077, 3493908088,
                  3493908089, 3493908092, 3493908093, 3493908264,
                  3493908075, 3493908078, 3493908079, 3493908090,
                  3493908091, 3493908094, 3493908095, 3493908266],
                 QuadTile.tiles_for_area(BoundingBox.new(0.99, 51.09, 1.01, 51.11))
    assert_equal [3493913705, 3493913708, 3493913709, 3493913720,
                  3493913721, 3493913724, 3493913725, 3493913896,
                  3493913707, 3493913710, 3493913711, 3493913722,
                  3493913723, 3493913726, 3493913727, 3493913898,
                  3493913793, 3493913796, 3493913797, 3493913808,
                  3493913809, 3493913812, 3493913813, 3493913984,
                  3493913795, 3493913798, 3493913799, 3493913810,
                  3493913811, 3493913814, 3493913815, 3493913986,
                  3493913801, 3493913804, 3493913805, 3493913816,
                  3493913817, 3493913820, 3493913821, 3493913992],
                 QuadTile.tiles_for_area(BoundingBox.new(1.09, 51.09, 1.11, 51.11))
    assert_equal [3509256924, 3509256925, 3509257096, 3509257097,
                  3509257100, 3509257101, 3509257112, 3509257113,
                  3509256926, 3509256927, 3509257098, 3509257099,
                  3509257102, 3509257103, 3509257114, 3509257115,
                  3509256948, 3509256949, 3509257120, 3509257121,
                  3509257124, 3509257125, 3509257136, 3509257137,
                  3509256950, 3509256951, 3509257122, 3509257123,
                  3509257126, 3509257127, 3509257138, 3509257139,
                  3509256956, 3509256957, 3509257128, 3509257129,
                  3509257132, 3509257133, 3509257144, 3509257145],
                 QuadTile.tiles_for_area(BoundingBox.new(9.99, -123.01, 10.01, -122.99))
    assert_equal [1252698792, 1252698793, 1252698796, 1252698797,
                  1252698794, 1252698795, 1252698798, 1252698799,
                  1610612736, 1610612737, 1610612740, 1610612741,
                  1610612738, 1610612739, 1610612742, 1610612743,
                  1610612744, 1610612745, 1610612748, 1610612749],
                 QuadTile.tiles_for_area(BoundingBox.new(-90.01, 0.0, -89.99, 0.01))
  end

  def test_sql_for_area
    assert_equal "( tile BETWEEN 3493906992 AND 3493907007 OR tile BETWEEN 3493907040 AND 3493907055 )",
                 QuadTile.sql_for_area(BoundingBox.new(0.99, 50.99, 1.01, 51.01), "")
    assert_equal "( tile BETWEEN 3493908067 AND 3493908071 OR tile BETWEEN 3493908075 AND 3493908095"\
                 " OR tile IN (3493908065,3493908073,3493908256,3493908258,3493908264,3493908266) )",
                 QuadTile.sql_for_area(BoundingBox.new(0.99, 51.09, 1.01, 51.11), "")
    assert_equal "( tile BETWEEN 3493913707 AND 3493913711 OR tile BETWEEN 3493913720 AND 3493913727"\
                 " OR tile BETWEEN 3493913795 AND 3493913799 OR tile BETWEEN 3493913804 AND 3493913805"\
                 " OR tile BETWEEN 3493913808 AND 3493913817 OR tile BETWEEN 3493913820 AND 3493913821"\
                 " OR tile IN (3493913705,3493913793,3493913801,3493913896,3493913898,3493913984,3493913986,3493913992) )",
                 QuadTile.sql_for_area(BoundingBox.new(1.09, 51.09, 1.11, 51.11), "")
    assert_equal "( tile BETWEEN 3509256924 AND 3509256927 OR tile BETWEEN 3509256948 AND 3509256951"\
                 " OR tile BETWEEN 3509256956 AND 3509256957 OR tile BETWEEN 3509257096 AND 3509257103"\
                 " OR tile BETWEEN 3509257112 AND 3509257115 OR tile BETWEEN 3509257120 AND 3509257129"\
                 " OR tile BETWEEN 3509257132 AND 3509257133 OR tile BETWEEN 3509257136 AND 3509257139"\
                 " OR tile BETWEEN 3509257144 AND 3509257145 )",
                 QuadTile.sql_for_area(BoundingBox.new(9.99, -123.01, 10.01, -122.99), "")
    assert_equal "( tile BETWEEN 1252698792 AND 1252698799 OR tile BETWEEN 1610612736 AND 1610612745"\
                 " OR tile BETWEEN 1610612748 AND 1610612749 )",
                 QuadTile.sql_for_area(BoundingBox.new(-90.01, 0.0, -89.99, 0.01), "")
  end
end
