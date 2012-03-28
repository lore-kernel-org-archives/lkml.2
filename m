Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab2C1JlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 05:41:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:12407 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423Ab2C1JlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 05:41:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="133970391"
Date: Wed, 28 Mar 2012 11:49:28 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT] [3.4] MFD pull request
Message-ID: <20120328094928.GE5759@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(For some reasons this one did not make it to lkml, so re-sending...)

Hi Linus,

This is the MFD pull request for Linux 3.4. This is what we have:

* 4 new drivers: Freescale i.MX on-chip Anatop, Ricoh's RC5T583 and TI's
TPS65090 and TPS65217.

* New variants support (8420, 8520 ab9540), cleanups and bug fixes for the
abx500 and db8500 ST-E chipsets.

* Some minor fixes and update for the wm8994 from Mark.

* The beginning of a long term TWL cleanup effort coming from the TI folks.

* Various fixes and cleanups for the s5m, TPS659xx, pm860x, and MAX8997
drivers.

Thanks in advance for pulling.

The following changes since commit b01543dfe67bb1d191998e90d20534dc354de059:

  Linux 3.3-rc4 (2012-02-18 15:53:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git tags/mfd_3.4-1

for you to fetch changes up to b8589e2a8065b8e7773742b60ae96b63b757bb69:

  gpio/twl: Add DT support to gpio-twl4030 driver (2012-03-22 13:05:55 +0100)

----------------------------------------------------------------
MFD changes for 3.4

----------------------------------------------------------------
AnilKumar Ch (1):
      mfd: Add new mfd device for TPS65217

Axel Lin (14):
      mfd: Add missing regmap_exit to free a previously allocated da9052 register map
      mfd: Fix section mismatch warning for da9052-spi
      mfd: Fix kcalloc parameters swapped
      mfd: Fix val_len parameters for s5m-core regmap_raw_write
      mfd: Make pcf50633_write_block() return 0 on success
      mfd: Fix typo for TPS65912
      mfd: Show correct device id for wm8400
      mfd: Initialize tps65912 irq platform data properly
      mfd: Remove unused io_lock mutex from da9052
      mfd: Include linux/mfd/pcf50633/pmic.h in pcf50633-gpio.c
      mfd: Include linux/mfd/pcf50633/mbc.h in pcf50633-irq.c
      mfd: Return proper error if s5m-core regmap_init_i2c fails
      mfd: Fix a typo in MFD_MAX8997 Kconfig entry
      mfd: Use DIV_ROUND_CLOSEST for sm501 clock

Bengt Jonsson (4):
      mfd: Spawned db8500 regulators update
      mfd: Support for the AB8500 AB8505 variant
      mfd: Add 8520 PRCMU variant to db8500-prcmu
      mfd: Add 8420 variant to db8500-prcmu

Benoit Cousson (8):
      mfd: Return twl6030_mmc_card_detect IRQ for board setup
      ARM: OMAP2+: board-omap4-*: Do not use anymore TWL6030_IRQ_BASE in board files
      mfd: Remove references already defineid in header file from twl-core
      mfd: Move twl-core IRQ allocation into twl[4030|6030]-irq files
      mfd: Make twl4030 SIH SPARSE_IRQ capable
      mfd: Replace twl-* pr_ macros by the dev_ equivalent and do various cleanups
      gpio/twl: Allocate irq_desc dynamically for SPARSE_IRQ support
      gpio/twl: Add DT support to gpio-twl4030 driver

Chanwoo Choi (1):
      mfd: Add platform data for MAX8997 haptic driver

Chris Blair (2):
      mfd: Add support for no-interrupt stmpe config
      gpio: Support no-irq stmpe mode

Daniel Lezcano (6):
      mfd: Decouple/recouple gic from the ux500 PRCMU
      mfd : Cleanup duplicate db8500 definitions
      mfd : Check if there are pending irq on the db8500 gic
      mfd : Copy the db8500 gic setting to the prcmu
      mfd : Check if the db8500 prcmu has pending irq
      mfd : Check if the other db8500 core is in WFI

Daniel Willerud (1):
      mfd: Remove db8500-prcmu U8400 legacy

Dmitry Torokhov (1):
      mfd: Add some da9052-i2c section annotations

Felipe Balbi (3):
      mfd: Make twl-core not depend on pdata->irq_base/end
      mfd: Remove unneeded header from twl-core
      mfd: Micro-optimization on twl4030 IRQ handler

Felipe Contreras (1):
      mfd: Trivial twl4030 code-style fixes

Govindraj.R (2):
      mfd: Remove omap-usb-host magic numbers for dev dma mask
      mfd: Move omap-usb-host usbhs init before allocing child dev

Hai Dong (1):
      mfd: Fix wm831x-spi table id name typo in MODULE_DEVICE_TABLE macro

Jean Delvare (1):
      mfd: Fix ACPI conflict check

Jesper Juhl (1):
      mfd: Remove unneeded version.h include from ab5500

Jett.Zhou (5):
      mfd: Add ability to wake the system for 88pm860x
      mfd: Add power control interface for pm8606 chip
      mfd: Code cleanup for pm8606 sub-dev initialization
      backlight: Modified power control of pm860x backlight
      led: Modified power control of pm860x led

Jonas Aaberg (1):
      mfd: Remove check for db8500 firmware bug

Jonghwan Choi (3):
      mfd: wm8350 variable dereferenced before check
      mfd: Fix possible s5m null pointer dereference
      mfd: Fix s5m error handling for invalid device type

Laxman Dewangan (6):
      mfd: Initialize tps65910 irq platform data properly
      mfd: Add itps65910 wakeup support
      mfd: Use regmap for tps65910 register access.
      mfd: Use correct variable name for tps65910 regmap config
      mfd: Add support for RICOH PMIC RC5T583
      mfd: Build rtc5t583 only if I2C config is selected to y.

Linus Walleij (4):
      mfd: Fix ab8500 error path bug
      mfd: Add ab8500 version detection and enforcing
      mfd: Parametrize ab8500 IRQ masks and registers
      mfd: Support AB9540 ab8500 variant

Mark Brown (10):
      mfd: twl-core: Don't specify regulator consumers by struct device
      mfd: wm8994: Mark MICBIAS register as readable
      mfd: wm8994: We don't need to runtime resume by default
      mfd: Test for jack detection when deciding if wm8994 should suspend
      mfd: wm8994: Add __devinit and __devexit annotations for probe and remove
      mfd: Correct readability of WM8994 DC servo 4E register
      mfd: wm8994: Remove defaults for volatile registers
      mfd: wm8994: Fix register default for WM1811 AntiPOP2
      mfd: Remove unused LDO supply field from WM8994 pdata
      ARM: S3C64XX: Hook up supply for WM8994 LDOs on Littlemill

Mattias Nilsson (8):
      mfd: Function for obtaining the db8500 prcmu firmware version
      mfd: Update abstract dbx500 interface
      mfd: db8500 clock handling update
      mfd: db8500 OPP and sleep handling update
      mfd: Add initial db8500 prcmu register access api
      mfd: Add a prcmu_abb_write_masked routine to db8500-prcmu
      mfd: Make use of the ab8500 firmware read-modify-write service
      mfd: Remove obsolete hwacc implementation for db8500-prmcu

Michael Thalmeier (1):
      mfd: Add pdata to set mc13783-ts conversion delay

Nishanth Menon (2):
      mfd: Clear twl6030 IRQ status register only once
      mfd: Make twl6030_irq_set_wake static

Paul Parsons (1):
      mfd: Add to_irq() member to asic3 gpio_chip structure

Peter Ujfalusi (1):
      mfd: Detach twl6040 from the pmic mfd driver

Rabin Vincent (1):
      mfd: Don't use mutex_lock_interruptible in ab8500-core

Samuel Ortiz (2):
      mfd: Fix pm8606 build failure
      Revert "mfd: Add platform data for MAX8997 haptic driver"

Sangbeom Kim (2):
      mfd: Convert s5m core driver to use devm_kzalloc()
      mfd: Add support for multiple s5m devices

Venu Byravarasu (2):
      mfd: Fix compilation error in tps65910.h
      mfd: Add support for TPS65090

Ying-Chun Liu (PaulLiu) (1):
      mfd: Add anatop mfd driver

 .../devicetree/bindings/gpio/gpio-twl4030.txt      |   23 +
 arch/arm/mach-omap2/board-4430sdp.c                |   13 +-
 arch/arm/mach-omap2/board-omap4panda.c             |   15 +-
 arch/arm/mach-s3c64xx/mach-crag6410-module.c       |   14 +-
 .../mach-ux500/include/mach/irqs-board-mop500.h    |    2 +-
 drivers/cpufreq/db8500-cpufreq.c                   |   13 +-
 drivers/gpio/gpio-stmpe.c                          |   41 +-
 drivers/gpio/gpio-twl4030.c                        |  111 ++-
 drivers/hwmon/mc13783-adc.c                        |    2 +-
 drivers/input/misc/88pm860x_onkey.c                |   26 +
 drivers/input/touchscreen/mc13783_ts.c             |   11 +-
 drivers/leds/leds-88pm860x.c                       |   23 +
 drivers/mfd/88pm860x-core.c                        |  110 ++-
 drivers/mfd/88pm860x-i2c.c                         |   25 +
 drivers/mfd/Kconfig                                |   54 +-
 drivers/mfd/Makefile                               |    4 +
 drivers/mfd/ab5500-core.c                          |    1 -
 drivers/mfd/ab8500-core.c                          |  380 +++++--
 drivers/mfd/ab8500-i2c.c                           |   30 +-
 drivers/mfd/anatop-mfd.c                           |  137 +++
 drivers/mfd/asic3.c                                |    6 +
 drivers/mfd/da9052-core.c                          |    3 -
 drivers/mfd/da9052-i2c.c                           |   11 +-
 drivers/mfd/da9052-spi.c                           |    9 +-
 drivers/mfd/db8500-prcmu.c                         | 1220 ++++++++++++++------
 drivers/mfd/dbx500-prcmu-regs.h                    |  130 ++-
 drivers/mfd/mc13xxx-core.c                         |   11 +-
 drivers/mfd/mfd-core.c                             |    4 +-
 drivers/mfd/omap-usb-host.c                        |    7 +-
 drivers/mfd/pcf50633-core.c                        |    8 +-
 drivers/mfd/pcf50633-gpio.c                        |   27 +-
 drivers/mfd/pcf50633-irq.c                         |    7 +-
 drivers/mfd/rc5t583-irq.c                          |  408 +++++++
 drivers/mfd/rc5t583.c                              |  386 +++++++
 drivers/mfd/s5m-core.c                             |   60 +-
 drivers/mfd/s5m-irq.c                              |   14 +-
 drivers/mfd/sm501.c                                |   10 +-
 drivers/mfd/stmpe.c                                |  134 ++-
 drivers/mfd/tps65090.c                             |  387 +++++++
 drivers/mfd/tps65217.c                             |  242 ++++
 drivers/mfd/tps65910-irq.c                         |   11 +
 drivers/mfd/tps65910.c                             |  125 +--
 drivers/mfd/tps65912-core.c                        |    2 +-
 drivers/mfd/twl-core.c                             |  173 ++--
 drivers/mfd/twl-core.h                             |    4 +-
 drivers/mfd/twl4030-irq.c                          |  107 +-
 drivers/mfd/twl6030-irq.c                          |   86 +-
 drivers/mfd/wm831x-spi.c                           |    2 +-
 drivers/mfd/wm8350-irq.c                           |    1 -
 drivers/mfd/wm8400-core.c                          |    3 +-
 drivers/mfd/wm8994-core.c                          |   24 +-
 drivers/mfd/wm8994-regmap.c                        |   21 +-
 drivers/rtc/rtc-88pm860x.c                         |   27 +
 drivers/video/backlight/88pm860x_bl.c              |   49 +-
 include/linux/i2c/twl.h                            |    2 +-
 include/linux/mfd/88pm860x.h                       |   23 +
 include/linux/mfd/abx500.h                         |    7 -
 include/linux/mfd/abx500/ab8500-gpio.h             |    4 +-
 include/linux/mfd/abx500/ab8500-sysctrl.h          |   43 +
 include/linux/mfd/abx500/ab8500.h                  |  207 +++-
 include/linux/mfd/anatop.h                         |   40 +
 include/linux/mfd/da9052/da9052.h                  |    2 -
 include/linux/mfd/db8500-prcmu.h                   |  183 ++--
 include/linux/mfd/dbx500-prcmu.h                   |  414 +++++++-
 include/linux/mfd/mc13xxx.h                        |   16 +-
 include/linux/mfd/rc5t583.h                        |  295 +++++
 include/linux/mfd/stmpe.h                          |    1 +
 include/linux/mfd/tps65090.h                       |   46 +
 include/linux/mfd/tps65217.h                       |  283 +++++
 include/linux/mfd/tps65910.h                       |    3 +
 include/linux/mfd/wm8994/pdata.h                   |    1 -
 include/linux/regulator/ab8500.h                   |   70 ++-
 72 files changed, 5243 insertions(+), 1151 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-twl4030.txt
 create mode 100644 drivers/mfd/anatop-mfd.c
 create mode 100644 drivers/mfd/rc5t583-irq.c
 create mode 100644 drivers/mfd/rc5t583.c
 create mode 100644 drivers/mfd/tps65090.c
 create mode 100644 drivers/mfd/tps65217.c
 create mode 100644 include/linux/mfd/anatop.h
 create mode 100644 include/linux/mfd/rc5t583.h
 create mode 100644 include/linux/mfd/tps65090.h
 create mode 100644 include/linux/mfd/tps65217.h
-- 
Intel Open Source Technology Centre
http://oss.intel.com/

