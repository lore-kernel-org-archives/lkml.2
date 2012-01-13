Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635Ab2AMSCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:02:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:39567 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758606Ab2AMSB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:01:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="106848496"
Date: Fri, 13 Jan 2012 19:07:59 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Afzal Mohammed <afzal@ti.com>,
        Axel Lin <axel.lin@gmail.com>, Benoit Cousson <b-cousson@ti.com>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Donggeun Kim <dg77.kim@samsung.com>,
        Igor Grinberg <grinberg@compulab.co.il>,
        "Jett.Zhou" <jtzhou@marvell.com>, Jochen Friedrich <jochen@scram.de>,
        Jonghwan Choi <jhbird.choi@samsung.com>, Julia Lawall <julia@diku.dk>,
        Kevin Liu <kliu5@marvell.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        NeilBrown <neilb@suse.de>, Robin van der Gracht <robin@protonic.nl>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sangbeom Kim <sbkim73@samsung.com>, Shawn Guo <shawn.guo@linaro.org>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [GIT] [3.3] MFD pull request
Message-ID: <20120113180759.GN4925@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the MFD pull request for the Linux 3.3 merge window.
With this one we get a new MFD driver for Samsung's S5M PMIC. We also get a
LED driver and a MUIC one for Samsung's MFD MAX8997.
Besides that, STMPE can now be reached through SPI, and gained support for the
610 and 801 variants. mc13xx and twl got their initial device tree support,
and Mark sent his regular wm8xxx updates.

Thanks in advance for pulling those in.

The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:

  Linux 3.2 (2012-01-04 15:55:44 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next

Afzal Mohammed (1):
      mfd: Make TPS65910 usable without interrupts

Axel Lin (7):
      mfd: Don't declare jz4740_adc_cells const
      mfd: Convert to DEFINE_PCI_DEVICE_TABLE
      mfd: Use gpio_request_one from aat2870-core
      mfd: Use gpio_request_one from dm355evm_msp
      mfd: Use gpio_request_one from omap-usb-host
      mfd: Use gpio_request_one from twl6040-core
      mfd: Constify aat2870-core i2c_device_id table

Benoit Cousson (1):
      mfd: twl-core: Add initial DT support for twl4030/twl6030

Christian Gmeiner (1):
      mfd: Fix cs5535 section mismatch

Christoph Fritz (1):
      mfd: Add a dependency on HAVE_CLK for tc6393xb

Donggeun Kim (5):
      mfd: Add platform data for MAX8997 MUIC driver
      misc: Add driver support for MAX8997 MUIC
      mfd: Add platform data and devices for MAX8997 LED control
      leds: Add suuport for MAX8997-LED driver
      misc: Remove max8997-muic sysfs attributes

Igor Grinberg (1):
      mfd: Add power off functionality to TWL

Jett.Zhou (2):
      mfd: Fix 88pm860x test bank i2c interface bug
      mfd: Convert 88pm860x to use regmap api

Jochen Friedrich (2):
      ARM: sa11x0: Implement autoloading of codec and codec pdata for mcp bus.
      ARM: sa1100: Refactor mcp-sa11x0 to use platform resources.

Jonghwan Choi (1):
      mfd: Use standard device wakeup for handling max8998 wakeup device

Julia Lawall (1):
      mfd: Introduce missing kfree in 88pm860x probe routine

Kevin Liu (2):
      mfd: Add pm ops to max8925
      rtc: max8925: Add function to work as wakeup source

Lars-Peter Clausen (1):
      mfd: Remove redundant spi driver bus initialization

Linus Walleij (1):
      mfd: Unify abx500 headers in mfd/abx500

Mark Brown (15):
      mfd: Convert wm831x core driver to devm_kzalloc()
      mfd: Convert wm8994 to devm_kzalloc()
      mfd: Disable more pulls on WM8994
      mfd: Add basic device tree binding for wm8994
      mfd: Convert MFD drivers to use module_platform_driver
      mfd: Store wm8350 struct in core device driver data
      mfd: Convert WM8350 to devm_kzalloc()
      mfd: Constify WM8994 regulator_init_data
      mfd: Add WM1811A device ID to wm8994 driver
      mfd: Add missing mutex.h inclusion to WM8994 core.h
      mfd: Convert WM8400 to devm_kzalloc()
      mfd: Return an error on failed wm831x register writes
      mfd: Remove unused wm831x_irq_data_to_mask_reg()
      mfd: Still check other interrupts if we get a wm831x touchscreen IRQ
      mfd: Convert aat2870 to dev_pm_ops

NeilBrown (2):
      mfd: Set twl4030-irq tertiary interrupts to be nested/threaded.
      mfd: Fix twl4030-irq typo

Robin van der Gracht (1):
      mfd: Fixed unconditional reset of the mc13xxx ADC reading enable bits

Samuel Ortiz (3):
      mfd: Fix STMPE I2c build failure
      mfd: Fix stmpe build warning
      mfd: Fix stmpe section mismatch

Sangbeom Kim (3):
      mfd: Add S5M core driver
      mfd: Add s5m series irq driver
      mfd: Add S5M series configuration

Shawn Guo (2):
      mfd: Add device tree probe support for mc13xxx
      mfd: Improve mc13xxx dt binding document

Viresh Kumar (6):
      mfd: Add support for irq over gpio pin to stmpe
      mfd: Separate out STMPE controller and interface specific code
      mfd: Add support for STMPE SPI interface
      mfd: Add support for stmpe variant 610
      mfd: Add support for stmpe variant 801
      gpio: Add support for stmpe variant 801

 Documentation/devicetree/bindings/mfd/mc13xxx.txt  |   78 +++
 .../devicetree/bindings/mfd/twl-familly.txt        |   47 ++
 Documentation/devicetree/bindings/sound/wm8994.txt |   18 +
 arch/arm/mach-sa1100/assabet.c                     |   12 +
 arch/arm/mach-sa1100/cerf.c                        |   11 +
 arch/arm/mach-sa1100/collie.c                      |   18 +-
 arch/arm/mach-sa1100/generic.c                     |    7 +-
 arch/arm/mach-sa1100/include/mach/mcp.h            |    2 +
 arch/arm/mach-sa1100/lart.c                        |   10 +
 arch/arm/mach-sa1100/shannon.c                     |   11 +
 arch/arm/mach-sa1100/simpad.c                      |   18 +-
 arch/arm/mach-ux500/board-mop500.c                 |    4 +-
 arch/arm/mach-ux500/board-u5500.c                  |    2 +-
 .../mach-ux500/include/mach/irqs-board-mop500.h    |    2 +-
 drivers/gpio/gpio-stmpe.c                          |   25 +-
 drivers/input/misc/ab8500-ponkey.c                 |    2 +-
 drivers/leds/Kconfig                               |    7 +
 drivers/leds/Makefile                              |    1 +
 drivers/leds/leds-max8997.c                        |  372 ++++++++++++++
 drivers/mfd/88pm860x-i2c.c                         |  241 ++++++----
 drivers/mfd/Kconfig                                |   35 ++-
 drivers/mfd/Makefile                               |    3 +
 drivers/mfd/aat2870-core.c                         |   25 +-
 drivers/mfd/ab5500-core.c                          |    2 +-
 drivers/mfd/ab5500-debugfs.c                       |    2 +-
 drivers/mfd/ab8500-core.c                          |    2 +-
 drivers/mfd/ab8500-debugfs.c                       |    2 +-
 drivers/mfd/ab8500-gpadc.c                         |    4 +-
 drivers/mfd/ab8500-i2c.c                           |    2 +-
 drivers/mfd/ab8500-sysctrl.c                       |    4 +-
 drivers/mfd/cs5535-mfd.c                           |    8 +-
 drivers/mfd/dm355evm_msp.c                         |    3 +-
 drivers/mfd/intel_msic.c                           |   12 +-
 drivers/mfd/jz4740-adc.c                           |   14 +-
 drivers/mfd/lpc_sch.c                              |    2 +-
 drivers/mfd/max8925-i2c.c                          |   27 +
 drivers/mfd/max8997.c                              |    3 +-
 drivers/mfd/max8998.c                              |    6 +-
 drivers/mfd/mc13xxx-core.c                         |  111 +++--
 drivers/mfd/mcp-core.c                             |   44 ++-
 drivers/mfd/mcp-sa11x0.c                           |  182 +++++---
 drivers/mfd/omap-usb-host.c                        |   18 +-
 drivers/mfd/pcf50633-adc.c                         |   12 +-
 drivers/mfd/s5m-core.c                             |  176 +++++++
 drivers/mfd/s5m-irq.c                              |  487 +++++++++++++++++++
 drivers/mfd/sm501.c                                |    2 +-
 drivers/mfd/stmpe-i2c.c                            |  109 +++++
 drivers/mfd/stmpe-spi.c                            |  150 ++++++
 drivers/mfd/stmpe.c                                |  277 +++++++----
 drivers/mfd/stmpe.h                                |   53 ++
 drivers/mfd/t7l66xb.c                              |   16 +-
 drivers/mfd/tc6387xb.c                             |   14 +-
 drivers/mfd/ti-ssp.c                               |   12 +-
 drivers/mfd/timberdale.c                           |    2 +-
 drivers/mfd/tps65910-irq.c                         |    3 +-
 drivers/mfd/tps65910.c                             |    7 +-
 drivers/mfd/tps65912-spi.c                         |    1 -
 drivers/mfd/twl-core.c                             |   51 ++-
 drivers/mfd/twl4030-audio.c                        |   12 +-
 drivers/mfd/twl4030-irq.c                          |    3 +-
 drivers/mfd/twl4030-madc.c                         |   14 +-
 drivers/mfd/twl4030-power.c                        |   42 ++-
 drivers/mfd/twl6040-core.c                         |   20 +-
 drivers/mfd/ucb1x00-core.c                         |   48 ++-
 drivers/mfd/ucb1x00-ts.c                           |    2 +-
 drivers/mfd/vx855.c                                |    2 +-
 drivers/mfd/wm831x-core.c                          |    4 +-
 drivers/mfd/wm831x-i2c.c                           |    3 +-
 drivers/mfd/wm831x-irq.c                           |    8 +-
 drivers/mfd/wm831x-spi.c                           |    4 +-
 drivers/mfd/wm8350-core.c                          |    2 +
 drivers/mfd/wm8350-i2c.c                           |    4 +-
 drivers/mfd/wm8400-core.c                          |    7 +-
 drivers/mfd/wm8994-core.c                          |   37 +-
 drivers/misc/Kconfig                               |    8 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/ab8500-pwm.c                          |    2 +-
 drivers/misc/max8997-muic.c                        |  505 ++++++++++++++++++++
 drivers/regulator/ab8500.c                         |    2 +-
 drivers/rtc/rtc-ab8500.c                           |    2 +-
 drivers/rtc/rtc-max8925.c                          |   26 +
 drivers/usb/otg/ab8500-usb.c                       |    2 +-
 include/linux/i2c/twl.h                            |    2 +
 include/linux/mfd/88pm860x.h                       |    3 +-
 include/linux/mfd/{ab5500 => abx500}/ab5500.h      |    0
 .../mfd/{ab8500/gpadc.h => abx500/ab8500-gpadc.h}  |    0
 .../mfd/{ab8500/gpio.h => abx500/ab8500-gpio.h}    |    0
 .../{ab8500/sysctrl.h => abx500/ab8500-sysctrl.h}  |    0
 include/linux/mfd/{ => abx500}/ab8500.h            |    0
 include/linux/mfd/max8925.h                        |    2 +
 include/linux/mfd/max8997.h                        |   83 ++++-
 include/linux/mfd/mc13xxx.h                        |    8 +
 include/linux/mfd/mcp.h                            |    7 +-
 include/linux/mfd/s5m87xx/s5m-core.h               |  373 +++++++++++++++
 include/linux/mfd/s5m87xx/s5m-pmic.h               |  100 ++++
 include/linux/mfd/s5m87xx/s5m-rtc.h                |   84 ++++
 include/linux/mfd/stmpe.h                          |   16 +-
 include/linux/mfd/ucb1x00.h                        |    5 +-
 include/linux/mfd/wm8994/core.h                    |    1 +
 include/linux/mfd/wm8994/pdata.h                   |    8 +-
 include/linux/mod_devicetable.h                    |   11 +
 scripts/mod/file2alias.c                           |   13 +
 102 files changed, 3685 insertions(+), 562 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/mc13xxx.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/twl-familly.txt
 create mode 100644 Documentation/devicetree/bindings/sound/wm8994.txt
 create mode 100644 drivers/leds/leds-max8997.c
 create mode 100644 drivers/mfd/s5m-core.c
 create mode 100644 drivers/mfd/s5m-irq.c
 create mode 100644 drivers/mfd/stmpe-i2c.c
 create mode 100644 drivers/mfd/stmpe-spi.c
 create mode 100644 drivers/misc/max8997-muic.c
 rename include/linux/mfd/{ab5500 => abx500}/ab5500.h (100%)
 rename include/linux/mfd/{ab8500/gpadc.h => abx500/ab8500-gpadc.h} (100%)
 rename include/linux/mfd/{ab8500/gpio.h => abx500/ab8500-gpio.h} (100%)
 rename include/linux/mfd/{ab8500/sysctrl.h => abx500/ab8500-sysctrl.h} (100%)
 rename include/linux/mfd/{ => abx500}/ab8500.h (100%)
 create mode 100644 include/linux/mfd/s5m87xx/s5m-core.h
 create mode 100644 include/linux/mfd/s5m87xx/s5m-pmic.h
 create mode 100644 include/linux/mfd/s5m87xx/s5m-rtc.h
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
