Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab2AIHhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:37:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49663 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753475Ab2AIHhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:37:51 -0500
Date: Sun, 8 Jan 2012 23:37:28 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Regulator updates for 3.3
Message-ID: <20120109073727.GF22134@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from the tree below to merge regulator API updates for
version 3.3  The major update here is the addition of device tree
support by Rajendra Nayak, and we also have a new driver for the
regulators on the DA9052 PMIC.  Otherwise most of the changes are
bug fixes and cleanups of one form or another.

The following changes since commit caca6a03d365883564885f2c1da3e88dcf65d139:

  Linux 3.2-rc3 (2011-11-23 20:20:28 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-linus

Ashish Jangam (2):
      regulator: DA9052/53 Regulator support
      regulator: Replace kzalloc with devm_kzalloc and if-else with a switch-case for da9052-regulator

Axel Lin (10):
      regulator: export of_get_regulator_init_data
      regulator: Checking return value of of_get_regulator_init_data
      regulator: Staticise of_get_fixed_voltage_config()
      regulator: Avoid potential NULL dereference in reg_fixed_voltage_probe()
      regulator: aat2870: Fix the logic of checking if no id is matched in aat2870_get_regulator
      regulator: aat2870: Remove a redundant bitwise and operation
      regulator: Convert virtual and userspace regulator consumer drivers to use module_platform_driver()
      regulator: da9052: Staticize non-exported symbols
      regulator: Fix the error handling if create_regulator fails
      regulator: Fix checking return value of create_regulator

Donggeun Kim (1):
      regulator: add regulator_bulk_force_disable function

Fabio Estevam (2):
      regulator: mc13783: Convert to devm_kzalloc()
      regulator: mc13892: Convert to devm_kzalloc()

Jonghwan Choi (2):
      regulator: Use regmap_read/write(), regmap_update_bits functions directly
      regulator: max8649 Convert max8649 to use regmap api

Kevin Liu (1):
      regulator: max8925: fix enabled/disabled judgement mistake

Kyle Manna (2):
      regulator: TPS65910: Move regulator defs to header
      regulator: TPS65910: Create an array for init data

Laxman Dewangan (1):
      regulator: Enable supply regulator if child rail is enabled.

Lothar Waﬂmann (1):
      regulator: fix use after free bug

Mark Brown (16):
      regulator: Don't report zero volts for the fixed voltage regulator
      regulator: Don't create voltage sysfs entries if we can't read voltage
      Merge branch 'for-linus' of git://git.kernel.org/.../broonie/regulator into regulator-next
      Merge remote-tracking branch 'regulator/topic/dt' into regulator-next
      Merge remote-tracking branch 'regulator/topic/dt' into regulator-next
      Merge remote-tracking branch 'regulator/topic/dt' into regulator-next
      Merge remote-tracking branch 'regulator/topic/dt' into regulator-next
      Merge remote-tracking branch 'regulator/for-linus' into regulator-next
      Merge remote-tracking branch 'regulator/for-linus' into regulator-next
      Merge remote-tracking branches 'regulator/topic/dt' and 'regulator/for-linus' into regulator-next
      regulator: Allow regulators to register with no init_data
      regulator: If a single voltage is set with device tree then set apply_uV
      Merge branch 'topic/dt' of git://git.kernel.org/.../broonie/regulator into regulator-next
      regulator: Update da9052-regulator for DT changes
      regulator: Convert wm831x regulator drivers to devm_kzalloc()
      regulator: Export regulator_is_supported_voltage()

MyungJoo Ham (1):
      regulator: add regulator_force_disable() definition for !CONFIG_REGULATOR

Rajendra Nayak (6):
      regulator: helper routine to extract regulator_init_data
      regulator: adapt fixed regulator driver to dt
      regulator: pass additional of_node to regulator_register()
      regulator: map consumer regulator based on device tree
      regulator: Fix compile break due to missing arguments to regulator_register
      regulator: Fix regulator_register() API signature in Documentation

Richard Zhao (2):
      regulator: pass regulator_register of_node in fixed voltage driver
      regulator: set constraints.apply_uV to 0 in of_get_fixed_voltage_config

Shawn Guo (4):
      regulator: fix label names used in device tree bindings
      regulator: pass device_node to of_get_regulator_init_data()
      regulator: mc13892: remove the unnecessary prefix from regulator name
      regulator: mc13892: add device tree probe support

Tero Kristo (1):
      regulator: twl: fix twl4030 support for smps regulators

 .../bindings/regulator/fixed-regulator.txt         |   29 +
 .../devicetree/bindings/regulator/regulator.txt    |   54 ++
 Documentation/power/regulator/regulator.txt        |    2 +-
 drivers/regulator/88pm8607.c                       |    2 +-
 drivers/regulator/Kconfig                          |    8 +
 drivers/regulator/Makefile                         |    2 +
 drivers/regulator/aat2870-regulator.c              |    6 +-
 drivers/regulator/ab3100.c                         |    2 +-
 drivers/regulator/ab8500.c                         |    2 +-
 drivers/regulator/ad5398.c                         |    2 +-
 drivers/regulator/bq24022.c                        |    2 +-
 drivers/regulator/core.c                           |  180 +++++--
 drivers/regulator/da903x.c                         |    2 +-
 drivers/regulator/da9052-regulator.c               |  606 ++++++++++++++++++++
 drivers/regulator/db8500-prcmu.c                   |    2 +-
 drivers/regulator/dummy.c                          |    2 +-
 drivers/regulator/fixed.c                          |   85 +++-
 drivers/regulator/gpio-regulator.c                 |    2 +-
 drivers/regulator/isl6271a-regulator.c             |    2 +-
 drivers/regulator/lp3971.c                         |    2 +-
 drivers/regulator/lp3972.c                         |    2 +-
 drivers/regulator/max1586.c                        |    2 +-
 drivers/regulator/max8649.c                        |  157 ++----
 drivers/regulator/max8660.c                        |    2 +-
 drivers/regulator/max8925-regulator.c              |   35 +-
 drivers/regulator/max8952.c                        |    2 +-
 drivers/regulator/max8997.c                        |    2 +-
 drivers/regulator/max8998.c                        |    2 +-
 drivers/regulator/mc13783-regulator.c              |    7 +-
 drivers/regulator/mc13892-regulator.c              |   47 ++-
 drivers/regulator/mc13xxx-regulator-core.c         |   57 ++
 drivers/regulator/mc13xxx.h                        |   26 +-
 drivers/regulator/of_regulator.c                   |   87 +++
 drivers/regulator/pcap-regulator.c                 |    2 +-
 drivers/regulator/pcf50633-regulator.c             |    2 +-
 drivers/regulator/tps6105x-regulator.c             |    3 +-
 drivers/regulator/tps65023-regulator.c             |   89 ++--
 drivers/regulator/tps6507x-regulator.c             |    2 +-
 drivers/regulator/tps6524x-regulator.c             |    2 +-
 drivers/regulator/tps6586x-regulator.c             |    2 +-
 drivers/regulator/tps65910-regulator.c             |   39 +-
 drivers/regulator/tps65912-regulator.c             |    2 +-
 drivers/regulator/twl-regulator.c                  |   48 ++-
 drivers/regulator/userspace-consumer.c             |   13 +-
 drivers/regulator/virtual.c                        |   12 +-
 drivers/regulator/wm831x-dcdc.c                    |   18 +-
 drivers/regulator/wm831x-isink.c                   |    7 +-
 drivers/regulator/wm831x-ldo.c                     |   18 +-
 drivers/regulator/wm8350-regulator.c               |    2 +-
 drivers/regulator/wm8400-regulator.c               |    2 +-
 drivers/regulator/wm8994-regulator.c               |    2 +-
 include/linux/mfd/mc13xxx.h                        |    1 +
 include/linux/mfd/tps65910.h                       |   30 +-
 include/linux/regulator/consumer.h                 |   13 +
 include/linux/regulator/driver.h                   |    4 +-
 include/linux/regulator/of_regulator.h             |   22 +
 sound/soc/codecs/sgtl5000.c                        |    2 +-
 57 files changed, 1414 insertions(+), 345 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/fixed-regulator.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/regulator.txt
 create mode 100644 drivers/regulator/da9052-regulator.c
 create mode 100644 drivers/regulator/of_regulator.c
 create mode 100644 include/linux/regulator/of_regulator.h
