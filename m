Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab2LMCas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:30:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47903 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755741Ab2LMCan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:30:43 -0500
Date: Thu, 13 Dec 2012 02:30:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: [GIT PULL] regulator updates for v3.8
Message-ID: <20121213023040.GA23329@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9489e9dcae718d5fde988e4a684a0f55b5f94d17:

  Linux 3.7-rc7 (2012-11-25 17:59:19 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-3.8

for you to fetch changes up to 4ffc45c3604dd8e283884ce006faf0e955cbd9e6:

  Merge remote-tracking branch 'regulator/topic/sm8767' into regulator-next (2012-12-11 21:44:55 +0900)

----------------------------------------------------------------

regulator: Updates for v3.8

A fairly quiet release again, a couple of relatively small new features
and a bunch of driver specific work including yet more code elimination
and fixes from Axel Lin.

- Addidion of linear_min_sel for offsetting linear selectors in the
  helpers.
- Support for continuous voltage ranges for regulators with extremely
  high resolution.
- Drivers for AS3711, DA9055, MAX9873, TPS51632, TPS80031 and ARM vexpress.

----------------------------------------------------------------
Amit Daniel Kachhap (3):
      regulator: s5m8767: Fix to work when platform registers less regulators
      regulator: s5m8767: Fix to read the first DVS register.
      regulator: s5m8767: Fix to work even if no DVS gpio present

AnilKumar Ch (1):
      regulator: tps65910: fix BUG_ON() shown with vrtc regulator

Ashish Jangam (1):
      regulator: DA9055 regulator driver

Axel Lin (31):
      regulator: vexpress: Add terminating entry for vexpress_regulator_of_match table
      regulator: tps51632: Fix trivial typo for TPS51632 Kconfig help text
      regulator: da9055: Fix checking wrong value in da9055_gpio_init
      regulator: da9055: Properly handle voltage range that doesn't start with 0 offset
      regulator: max8973: Fix callback setting for max8973_dcdc_ops.enable
      regulator: tps80031: Trivial cleanups
      regulator: tps80031: Implement list_voltage and set n_voltages = 1 for fixed regulators
      regulator: tps65090: Add MODULE_ALIAS
      regulator: core: Allow specific minimal selector for starting linear mapping
      regulator: palmas: Use linear_min_sel and regulator_[map|list]_voltage_linear
      regulator: da9055: Use linear_min_sel and regulator_[map|list]_voltage_linear
      regulator: tps51632: Fix writing to wrong register when enable_pwm_dvfs is set
      regulator: da9055: Select maximum current in specific range for set_current_limit
      regulator: da9052: Ensure setting current limit within specific range
      regulator: as3711: Fix valid min_uV/max_UV checking in as3711_bound_check
      regulator: as3711: Fix the logic in as3711_sel_check
      regulator: pcf50633: Use linear_min_sel and regulator_[map|list]_voltage_linear
      regulator: tps51632: Use linear_min_sel and regulator_[map|list]_voltage_linear
      regulator: wm831x-dcdc: Ensure selected voltage falls within requested range
      regulator: wm831x-dcdc: Add MODULE_ALIAS for wm831x-boostp
      regulator: tps51632: Ensure [base|max]_voltage_uV pdata settings are valid
      regulator: palmas: Return raw register values as the selectors in [get|set]_voltage_sel
      regulator: palmas: Convert palmas_ops_smps to regulator_[get|set]_voltage_sel_regmap
      regulator: gpio-regulator: Add ifdef CONFIG_OF guard for regulator_gpio_of_match
      regulator: lp8788-ldo: Remove val array in lp8788_config_ldo_enable_mode
      regulator: tps80031: Convert tps80031_ldo_ops to linear_min_sel and list_voltage_linear
      regulator: lp8788-buck: Kill _gpio_request function
      regulator: max1586: Implement get_voltage_sel callback
      regulator: anatop: Use linear_min_sel with linear mapping
      regulator: anatop: Use regulator_[get|set]_voltage_sel_regmap
      regulator: core: Fix logic to determinate if regulator can change voltage

Bill Pemberton (3):
      regulator: remove use of __devexit_p
      regulator: remove use of __devinit
      regulator: remove use of __devexit

Frank Li (2):
      regulator: gpio-regulator: doc: Fix wrong key gpio-enable
      regulator: gpio-regulator: fix can't find regulator node in dt

Guennadi Liakhovetski (1):
      regulator: add a regulator driver for the AS3711 PMIC

Laxman Dewangan (11):
      regulator: tps51632: Add tps51632 regulator driver
      regulator: tps65090: Register all regulators in single probe call
      regulator: tps65090: rename driver name and regulator name
      regulator: tps65090: Add support for LDO regulators
      regulator: tps65090: add external control support for DCDC
      regulator: tps80031: add regulator driver for tps80031
      mfd: tps6586x: move regulator dt parsing to regulator driver
      regulator: tps80031: add prefix TPS80031 on common defines.
      regulator: max8973: add regulator driver support
      regulator: max8973: provide enable/disable if external control disabled
      regulator: tps6586x: fix build warning in debug build

Lee Jones (4):
      regulator: gpio-regulator: Allow use of GPIO controlled regulators though DT
      regulator: gpio-regulator: Catch 'no states property' misuse
      regulator: gpio-regulator: Fix logical error in for() loop
      regulator: gpio-regulator: gpio_set_value should use cansleep

Marek Szyprowski (1):
      regulators: add regulator_can_change_voltage() function

Mark Brown (44):
      regulator: lp8788-ldo: Staticise non-exported symbol
      regulator: core: Add regulator_is_supported_voltage_tol()
      Merge branches 'topic/tps51632', 'topic/tps80031', 'topic/vexpress', 'topic/max8925', 'topic/gpio' and 'topic/tps65090' of git://git.kernel.org/.../broonie/regulator into regulator-hotplug
      Merge branch 'topic/tps6586x' of git://git.kernel.org/.../broonie/regulator into regulator-hotplug
      regulator: wm831x: Set the new rather than old value for DVS VSEL
      Merge branch 'topic/hotplug' of git://git.kernel.org/.../broonie/regulator into regulator-max8997
      Merge branches 'topic/da9055' and 'topic/tps51632' of git://git.kernel.org/.../broonie/regulator into regulator-min
      regulator: arizona-ldo1: Add enable time
      regulator: arizona-ldo1: Support DVFS in default constraints
      regulator: arizona-ldo1: Add additional top voltage
      regulator: arizona-ldo1: Support 1.8V mode
      regulator: core: Log when a device causes a voltage constraint fail
      regulator: core: Say what unsupportable voltage constraints are
      regulator: arizona-micsupp: Add ramp time information
      Merge branch 'topic/tps51632' of git://git.kernel.org/.../broonie/regulator into regulator-min
      Merge remote-tracking branch 'regulator/fix/wm831x' into regulator-next
      Merge remote-tracking branch 'regulator/topic/arizona' into regulator-next
      Merge remote-tracking branch 'regulator/topic/as3711' into regulator-next
      Merge remote-tracking branch 'regulator/topic/change' into regulator-next
      Merge remote-tracking branch 'regulator/topic/da9052' into regulator-next
      Merge remote-tracking branch 'regulator/topic/da9055' into regulator-next
      Merge remote-tracking branch 'regulator/topic/gpio' into regulator-next
      Merge remote-tracking branch 'regulator/topic/hotplug' into regulator-next
      Merge remote-tracking branch 'regulator/topic/log' into regulator-next
      Merge remote-tracking branch 'regulator/topic/lp8788' into regulator-next
      Merge remote-tracking branch 'regulator/topic/max1586' into regulator-next
      Merge remote-tracking branch 'regulator/topic/max77686' into regulator-next
      Merge remote-tracking branch 'regulator/topic/max8973' into regulator-next
      Merge remote-tracking branch 'regulator/topic/max8997' into regulator-next
      Merge remote-tracking branch 'regulator/topic/min' into regulator-next
      Merge remote-tracking branch 'regulator/topic/palmas' into regulator-next
      Merge remote-tracking branch 'regulator/topic/s2mps11' into regulator-next
      Merge remote-tracking branch 'regulator/topic/stub' into regulator-next
      Merge remote-tracking branch 'regulator/topic/tol' into regulator-next
      Merge remote-tracking branch 'regulator/topic/tps516312' into regulator-next
      Merge remote-tracking branch 'regulator/topic/tps65090' into regulator-next
      Merge remote-tracking branch 'regulator/topic/tps6586x' into regulator-next
      Merge remote-tracking branch 'regulator/topic/tps65910' into regulator-next
      Merge remote-tracking branch 'regulator/topic/tps80031' into regulator-next
      Merge remote-tracking branch 'regulator/topic/wm831x' into regulator-next
      Merge remote-tracking branch 'regulator/topic/gpio' into regulator-next
      Merge branch 'topic/min' of git://git.kernel.org/.../broonie/regulator into regulator-change
      Merge remote-tracking branch 'regulator/topic/change' into regulator-next
      Merge remote-tracking branch 'regulator/topic/sm8767' into regulator-next

Pawel Moll (2):
      regulator: core: Support for continuous voltage range
      regulator: Versatile Express regulator driver

Philip Rakity (1):
      regulator: add missing prototype for regulator_is_supported_voltage

Qing Xu (2):
      regulator: max8925: support dt for regulator
      regulator: max8925: update dt regulator binding doc

Sangbeom Kim (1):
      regulator: s2mps11: Fix ramp delay value shift operation

Thomas Abraham (3):
      regulator: max8997: reorder buck1/2/5 dvs setup code
      regulator: max8997: limit the number of dvs registers programmed in non-dvs mode
      regulator: add device tree support for max8997

Yadwinder Singh Brar (3):
      regulator: max77686: Use already set opmode while re-enabling regulators.
      regulator: max77686: Add set_suspend_disable/set_suspend_mode callbacks.
      regulator: max77686: Make max77686_enable() static.

 .../bindings/regulator/gpio-regulator.txt          |   37 +
 .../bindings/regulator/max8925-regulator.txt       |   40 +
 .../bindings/regulator/max8997-regulator.txt       |  146 ++++
 .../devicetree/bindings/regulator/vexpress.txt     |   32 +
 drivers/mfd/Kconfig                                |    1 -
 drivers/mfd/max8997.c                              |   73 +-
 drivers/mfd/tps6586x.c                             |   76 +-
 drivers/mfd/wm5102-tables.c                        |    3 +
 drivers/regulator/88pm8607.c                       |    6 +-
 drivers/regulator/Kconfig                          |   54 ++
 drivers/regulator/Makefile                         |    6 +
 drivers/regulator/aat2870-regulator.c              |    4 +-
 drivers/regulator/ab3100.c                         |    6 +-
 drivers/regulator/ab8500.c                         |   12 +-
 drivers/regulator/ad5398.c                         |    6 +-
 drivers/regulator/anatop-regulator.c               |   34 +-
 drivers/regulator/arizona-ldo1.c                   |  136 +++-
 drivers/regulator/arizona-micsupp.c                |    8 +-
 drivers/regulator/as3711-regulator.c               |  369 +++++++++
 drivers/regulator/core.c                           |   42 +-
 drivers/regulator/da903x.c                         |    6 +-
 drivers/regulator/da9052-regulator.c               |   16 +-
 drivers/regulator/da9055-regulator.c               |  641 ++++++++++++++++
 drivers/regulator/db8500-prcmu.c                   |    6 +-
 drivers/regulator/dbx500-prcmu.c                   |    4 +-
 drivers/regulator/dummy.c                          |    2 +-
 drivers/regulator/fan53555.c                       |    6 +-
 drivers/regulator/fixed.c                          |    6 +-
 drivers/regulator/gpio-regulator.c                 |  112 ++-
 drivers/regulator/isl6271a-regulator.c             |    6 +-
 drivers/regulator/lp3971.c                         |    8 +-
 drivers/regulator/lp3972.c                         |    8 +-
 drivers/regulator/lp872x.c                         |    4 +-
 drivers/regulator/lp8788-buck.c                    |   24 +-
 drivers/regulator/lp8788-ldo.c                     |   25 +-
 drivers/regulator/max1586.c                        |   50 +-
 drivers/regulator/max77686.c                       |  170 ++++-
 drivers/regulator/max8649.c                        |    6 +-
 drivers/regulator/max8660.c                        |    6 +-
 drivers/regulator/max8907-regulator.c              |    6 +-
 drivers/regulator/max8925-regulator.c              |   78 +-
 drivers/regulator/max8952.c                        |    6 +-
 drivers/regulator/max8973-regulator.c              |  505 +++++++++++++
 drivers/regulator/max8997.c                        |  187 ++++-
 drivers/regulator/max8998.c                        |    6 +-
 drivers/regulator/mc13783-regulator.c              |    6 +-
 drivers/regulator/mc13892-regulator.c              |    6 +-
 drivers/regulator/mc13xxx-regulator-core.c         |    4 +-
 drivers/regulator/palmas-regulator.c               |  166 ++---
 drivers/regulator/pcap-regulator.c                 |    6 +-
 drivers/regulator/pcf50633-regulator.c             |  182 +----
 drivers/regulator/rc5t583-regulator.c              |    6 +-
 drivers/regulator/s2mps11.c                        |   16 +-
 drivers/regulator/s5m8767.c                        |   46 +-
 drivers/regulator/tps51632-regulator.c             |  342 +++++++++
 drivers/regulator/tps6105x-regulator.c             |    6 +-
 drivers/regulator/tps62360-regulator.c             |    8 +-
 drivers/regulator/tps65023-regulator.c             |    6 +-
 drivers/regulator/tps6507x-regulator.c             |    6 +-
 drivers/regulator/tps65090-regulator.c             |  254 +++++--
 drivers/regulator/tps65217-regulator.c             |    6 +-
 drivers/regulator/tps6524x-regulator.c             |    4 +-
 drivers/regulator/tps6586x-regulator.c             |  189 ++++-
 drivers/regulator/tps65910-regulator.c             |   13 +-
 drivers/regulator/tps65912-regulator.c             |    6 +-
 drivers/regulator/tps80031-regulator.c             |  788 ++++++++++++++++++++
 drivers/regulator/twl-regulator.c                  |    6 +-
 drivers/regulator/vexpress.c                       |  147 ++++
 drivers/regulator/virtual.c                        |    6 +-
 drivers/regulator/wm831x-dcdc.c                    |   31 +-
 drivers/regulator/wm831x-isink.c                   |    6 +-
 drivers/regulator/wm831x-ldo.c                     |   18 +-
 drivers/regulator/wm8400-regulator.c               |    6 +-
 drivers/regulator/wm8994-regulator.c               |    6 +-
 include/linux/mfd/arizona/registers.h              |   16 +
 include/linux/mfd/da9055/pdata.h                   |   27 +-
 include/linux/mfd/max8997-private.h                |    1 +
 include/linux/mfd/max8997.h                        |    1 +
 include/linux/mfd/tps65090.h                       |   35 +
 include/linux/mfd/tps6586x.h                       |    3 +
 include/linux/regulator/consumer.h                 |   13 +
 include/linux/regulator/driver.h                   |    5 +
 include/linux/regulator/max8973-regulator.h        |   72 ++
 include/linux/regulator/tps51632-regulator.h       |   47 ++
 include/linux/regulator/tps65090-regulator.h       |   50 --
 85 files changed, 4772 insertions(+), 775 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/gpio-regulator.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/max8925-regulator.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/max8997-regulator.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/vexpress.txt
 create mode 100644 drivers/regulator/as3711-regulator.c
 create mode 100644 drivers/regulator/da9055-regulator.c
 create mode 100644 drivers/regulator/max8973-regulator.c
 create mode 100644 drivers/regulator/tps51632-regulator.c
 create mode 100644 drivers/regulator/tps80031-regulator.c
 create mode 100644 drivers/regulator/vexpress.c
 create mode 100644 include/linux/regulator/max8973-regulator.h
 create mode 100644 include/linux/regulator/tps51632-regulator.h
 delete mode 100644 include/linux/regulator/tps65090-regulator.h
