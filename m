Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab2JAKbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:31:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42677 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753163Ab2JAKbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:31:14 -0400
Date: Mon, 1 Oct 2012 11:31:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girwdood <lrg@ti.com>
Subject: [GIT PULL] regulator updates for 3.7
Message-ID: <20121001103112.GH4360@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5698bd757d55b1bb87edd1a9744ab09c142abfc2:

  Linux 3.6-rc6 (2012-09-16 14:58:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-3.7

for you to fetch changes up to 6a2027abd2048f7f7fdcc6e11ff10b3d9b0d0899:

  Merge remote-tracking branches 'regulator/topic/core', 'regulator/topic/bypass', 'regulator/topic/tol', 'regulator/topic/drivers' and 'regulator/topic/tps6586x' into regulator-next (2012-09-28 14:45:07 +0100)

----------------------------------------------------------------

regulator: Updates for v3.7

- Support for putting regulators into bypass mode where they simply
  switch their input to the output (mainly used for low power retention).
- A new API for setting voltages based on a voltage plus tolerance
  rather than an explicit voltage range.
- Lots of cleanups and API updates from Axel Lin.
- New driver for MAX8907.

----------------------------------------------------------------
AnilKumar Ch (1):
      regulator: core: Try using the parent device for the default regmap

Arnd Bergmann (1):
      regulator: twl: make twl_info tables const

Axel Lin (32):
      regulator: core: Fix cast to pointer from integer of different size warning
      regulator: s2mps11: Use array to save pointer to rdev
      regulator: mc13xxx: Populate selector from mc13xxx_fixed_regulator_set_voltage
      regulator: twl: Fix checking voltage range in twl6030smps_set_voltage()
      regulator: twl: Convert twlsmps_ops to get_voltage_sel and map_voltage
      regulator: palmas: Convert palmas_ops_ldo to [get|set]_voltage_sel_regmap
      regulator: mc13783: Make mc13783_powermisc_rmw() lock protected
      regulator: mc13892: Make mc13892_powermisc_rmw() lock protected
      regulator: mc13892: Simplify implementation of mc13892_sw_regulator_set_voltage_sel()
      regulator: mc13892: Convert mc13892_sw_regulator_ops to get_voltage_sel
      regulator: lp8788-ldo: Set n_voltages to 1 for fixed voltage
      regulator: lp8788-buck: Remove lp8788_set_default_dvs_ctrl_mode function
      regulator: Use BUCK_FPWM_[MASK|SHIFT] macros to replace buck_pmap table
      regulator: tps6586x: Convert to regulator_[enable|disable|is_enabled|get_voltage_sel]_regmap
      regulator: wm831x-ldo: Check return value of wm831x_reg_read()
      regulator: wm8400: Simplify set REGULATOR_MODE_IDLE mode in wm8400_dcdc_set_mode
      regulator: ab8500: Set enable enable_time in regulator_desc
      regulator: max77686: initialize of_node param for regulator register
      regulator: max77686: Use array to save pointer to rdev
      regulator: wm831x-dcdc: set_current_limit should select the maximum current in specific range
      regulator: tps6524x: set_current_limit should select the maximum current in specific range
      regulator: lp872x: set_current_limit should select the maximum current in specific range
      regulator: da9052: set_current_limit should select the maximum current in specific range
      regulator: Update comment for set_current_limit callback of struct regulator_ops
      regulator: mc13xxx: Remove get_voltage implementation for single voltage regulators
      regulator: ab3100: Remove get_voltage implementation for regulator_ops_fixed
      regulator: ab8500: Remove get_voltage implementation for ab8500_regulator_fixed_ops
      regulator: isl6271a: Remove get_voltage implementation for isl_fixed_ops
      regulator: twl: Remove get_voltage implementation for single voltage regulators
      regulator: max8907: Fix n_voltages for MAX8907B SD1
      regulator: max8907: Properly set pmic pointer in max8907_regulator_remove()
      regulator: max8907: Add MODULE_ALIAS

Gaëtan Carlier (1):
      regulator: mc13783: add regulators sw1x and sw2x

Gyungoh Yoo (1):
      regulator: add MAX8907 driver

Kim, Milo (5):
      regulator: lp872x: remove regulator platform data dependency
      regulator: lp872x: set the default DVS mode
      regulator: lp872x: initialize the DVS mode
      regulator: lp872x: fix NULL pointer access problem
      regulator: lp872x: remove unnecessary function

Laxman Dewangan (2):
      regulator: core: increment open_count when regulator supply is set
      regulator: tps6586x: add support for SYS rail

Linus Walleij (1):
      regulator: ab8500: provide per-regulator shift

Mark Brown (15):
      regulator: core: Clarify grammar for dummy help text
      regulator: core: Use list_voltage() to read single voltage regulators
      regulator: Clarify documentation for regmap in the config
      regulator: core: Report microvolts in sysfs even with only list_voltage()
      regulator: core: Fast path non-deferred disables
      regulator: twl: Remove another unused variable warning
      regulator: core: Support bypass mode
      regulator: core: Provide regmap get/set bypass operations
      regulator: arizona-ldo: Support get/set bypass
      regulator: arizona-micsupp: Support get/set bypass
      regulator: wm831x-ldo: Add bypass support
      extcon: arizona: Use bypass mode for MICVDD
      regulator: aat2870: Don't explicitly initialise the first field
      regulator: arizona-ldo: Remove top voltage
      Merge remote-tracking branches 'regulator/topic/core', 'regulator/topic/bypass', 'regulator/topic/tol', 'regulator/topic/drivers' and 'regulator/topic/tps6586x' into regulator-next

Michael Jones (1):
      regulator: Fix space/tab confusion

Randy Dunlap (2):
      regulator: fix kernel-doc warnings in drivers/regulator/core.c
      regulator: fix kernel-doc warnings in drivers/regulator/core.c

Shawn Guo (1):
      regulator: add a new API regulator_set_voltage_tol()

Stephen Rothwell (1):
      regulator: using kfree() requires including slab.h

Stephen Warren (5):
      regulator: max8907: fix compile error when !CONFIG_OF
      regulator: max8907: fix use of possibly NULL idata
      regulator: deprecate regulator-compatible DT property
      regulator: tps65217.txt: remove regulator-compatible from DT docs
      regulator: tps6586x: remove regulator-compatible from DT docs

Uwe Kleine-König (1):
      regulator: make the dummy regulator's print_constraint more helpful

Yunfan Zhang (2):
      regulator: Fairchild fan53555 support
      regulator: fan53555: remove vsel_max not used

 Documentation/ABI/testing/sysfs-class-regulator    |   21 +
 .../devicetree/bindings/regulator/regulator.txt    |    5 +-
 .../devicetree/bindings/regulator/tps65217.txt     |   31 +-
 .../devicetree/bindings/regulator/tps6586x.txt     |   73 ++--
 arch/arm/mach-tegra/board-harmony-power.c          |   12 +-
 drivers/extcon/extcon-arizona.c                    |    5 +
 drivers/mfd/tps6586x.c                             |   13 +
 drivers/regulator/Kconfig                          |   38 +-
 drivers/regulator/Makefile                         |    2 +
 drivers/regulator/aat2870-regulator.c              |    2 +-
 drivers/regulator/ab3100.c                         |    6 -
 drivers/regulator/ab8500.c                         |   36 +-
 drivers/regulator/arizona-ldo1.c                   |    6 +-
 drivers/regulator/arizona-micsupp.c                |    5 +
 drivers/regulator/core.c                           |  153 +++++++-
 drivers/regulator/da9052-regulator.c               |    4 +-
 drivers/regulator/dummy.c                          |    2 +-
 drivers/regulator/fan53555.c                       |  322 +++++++++++++++
 drivers/regulator/isl6271a-regulator.c             |    6 -
 drivers/regulator/lp872x.c                         |   88 ++---
 drivers/regulator/lp8788-buck.c                    |   80 +---
 drivers/regulator/lp8788-ldo.c                     |    8 +
 drivers/regulator/max77686.c                       |   30 +-
 drivers/regulator/max8907-regulator.c              |  408 ++++++++++++++++++++
 drivers/regulator/mc13783-regulator.c              |   89 ++++-
 drivers/regulator/mc13892-regulator.c              |   77 ++--
 drivers/regulator/mc13xxx-regulator-core.c         |   17 +-
 drivers/regulator/mc13xxx.h                        |    1 -
 drivers/regulator/of_regulator.c                   |   25 +-
 drivers/regulator/palmas-regulator.c               |   45 +--
 drivers/regulator/s2mps11.c                        |   27 +-
 drivers/regulator/tps6524x-regulator.c             |   10 +-
 drivers/regulator/tps6586x-regulator.c             |   96 ++---
 drivers/regulator/twl-regulator.c                  |  110 +++---
 drivers/regulator/wm831x-dcdc.c                    |   11 +-
 drivers/regulator/wm831x-ldo.c                     |   12 +
 drivers/regulator/wm8400-regulator.c               |    7 +-
 include/linux/mfd/max77686.h                       |    1 +
 include/linux/mfd/tps6586x.h                       |    1 +
 include/linux/regulator/consumer.h                 |   15 +
 include/linux/regulator/driver.h                   |   18 +-
 include/linux/regulator/fan53555.h                 |   60 +++
 include/linux/regulator/machine.h                  |    2 +
 43 files changed, 1417 insertions(+), 563 deletions(-)
 create mode 100644 drivers/regulator/fan53555.c
 create mode 100644 drivers/regulator/max8907-regulator.c
 create mode 100644 include/linux/regulator/fan53555.h
