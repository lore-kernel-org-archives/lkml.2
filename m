Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189Ab1CWPhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:37:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:18717 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932712Ab1CWPh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:37:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,231,1299484800"; 
   d="scan'208";a="723474132"
Date: Wed, 23 Mar 2011 16:37:25 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT] [2.6.39] MFD pull request
Message-ID: <20110323153724.GI2351@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the MFD pull request for the 2.6.39 merge window.

This one is slightly bigger than usual. A big chunk of the changes comes
from Andres Salomon and allows for MFD cells to be shared. We also have a few
new drivers (TI's TPS6105x, Maxim MAX8997, STE AB8500 GPADC and Intel's Tunnel
Creek support), and our regular WM8xxx fixes from Mark.

Thanks in advance for pulling those changes:

The following changes since commit 6447f55da90b77faec1697d499ed7986bb4f6de6:

  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx (2011-03-22 17:53:13 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next

Andres Salomon (33):
      mfd-core: Fix up typos/vagueness in comment
      mfd-core: Unconditionally add mfd_cell to every platform_device
      mfd: mfd_cell is now implicitly available to jz4740 drivers
      mfd: mfd_cell is now implicitly available to ab3550 driver
      mfd: mfd_cell is now implicitly available to ab3100 drivers
      mfd: mfd_cell is now implicitly available to asic3 drivers
      mfd: mfd_cell is now implicitly available to htc-pasic3 drivers
      mfd: mfd_cell is now implicitly available to timberdale drivers
      mfd: mfd_cell is now implicitly available to t7166xb drivers
      mfd: mfd_cell is now implicitly available to wl1273 drivers
      mfd: mfd_cell is now implicitly available to sh_mobile_sdhi drivers
      mfd: mfd_cell is now implicitly available to tc6393xb drivers
      mfd: mfd_cell is now implicitly available to twl4030 drivers
      mfd: mfd_cell is now implicitly available to tc6387xb drivers
      mfd: mfd_cell is now implicitly available to janz drivers
      mfd: mfd_cell is now implicitly available to mc13xxx drivers
      mfd: Drop data_size from mfd_cell struct
      mfd: Rename platform_data field of mfd_cell to mfd_data
      asoc: davinci_voicecodec: use mfd_data instead of driver_data
      asoc: wm8400-codec: Use mfd_data instead of driver_data
      w1: Use mfd_data instead of driver_data for dsw1wm.c
      mmc: Use mfd_data instead of driver_data for tmio-mmc
      mtd: Use mfd_data instead of driver_data for tmio_nand
      fb: Use mfd_data instead of driver_data for tmio-fb
      rdc321x-southbridge: Use mfd_data instead of driver_data
      mfd: Remove driver_data field from mfd_cell
      mfd: Add refcounting support to mfd_cells
      mfd: add platform_device sharing support for mfd
      mfd: Add sharing for cs5535 acpi/pms cells
      tmio: Silence warnings introduced by mfd changes
      jz4740: silence warnings related to mfd_get_cell changes
      w1: Silence ds1wm warnings related to mfd_get_cell changes
      mfd: Rename mfd_shared_cell_{en,dis}able to drop the "shared" part

Arun Murthy (1):
      mfd: Add new ab8500 GPADC driver

Axel Lin (4):
      mfd: Add MODULE_DEVICE_TABLE to mc13xxx-core
      mfd: Add MODULE_DEVICE_TABLE to pcf50633-core
      mfd: Add MODULE_DEVICE_TABLE to vx855
      mfd: Add "platform:" prefix for twl4030-madc platform modalias

Balaji T K (2):
      regulator: twl: add clk32kg to twl-regulator
      OMAP4: add clk32kg data to omap4panda and blaze board file

Daniel Willerud (3):
      mfd: Move ab8500 gpadc header to subdir
      mfd: Reentrance and revamp ab8500 gpadc fetching interface
      mfd: Free dangling irq in ab8500 gpadc probe error path

Denis Turischev (3):
      pci_ids: Add Intel Tunnel Creek LPC Bridge device ID.
      mfd: Add Tunnel Creek support to lpc_sch
      gpio: Add Tunnel Creek support to sch_gpio

Haojian Zhuang (5):
      mfd: Adopt mfd_data in 88pm860x backlight
      mfd: Adopt mfd_data in 88pm860x led
      mfd: Adopt mfd_data in 88pm860x regulator
      mfd: Adopt mfd_data in 88pm860x input driver
      mfd: Append additional read write on 88pm860x

Jochen Friedrich (1):
      mfd: Add BTN_TOUCH event to ucb1x00-ts

Johan Palsson (1):
      mfd: Calibrate ab8500 gpadc using OTP values

Karl Komierowski (1):
      mfd: Fix ab8500-gpadc to measure charger current

Keerthy (3):
      mfd: Enabling twl4030_wdt and pwrbutton only for Triton
      mfd: Add twl4030 madc driver
      hwmon: twl4030: Hwmon Driver for TWL4030 MADC

Linus Walleij (3):
      mfd: Add a core driver for TI TPS61050/TPS61052 chips v2
      regulator: Add a subdriver for TI TPS6105x regulator portions v2
      mfd: Rename ab8500 gpadc header

Mark Brown (19):
      mfd: Leave acknowledgement of WM831x touchscreen IRQs to the driver
      mfd: Convert adp5520 to dev_pm_ops
      mfd: Staticise non-exported symbols in MAX8998 driver
      mfd: Convert pcf50633 to dev_pm_ops
      mfd: Support configuration of WM831x /IRQ output in CMOS mode
      mfd: Convert WM831x SPI to use dev_pm_ops
      mfd: Add fast path for WM831x touchscreen interrupts
      mfd: Remove bitrotted genirq comment from wm831x IRQ code
      mfd: Put WM8994 into reset when suspending
      mfd: Convert WM831x interrupt masking to enable/disable operations
      mfd: Convert WM8994/58 interrupt masking to enable/disable operations
      mfd: Add platform data to support multiple WM831x devices per board
      mfd: Add WM8994 bulk register write operation
      mfd: Staticise WM8994 PM ops
      mfd: Remove copy from WM831x I2C write function
      mfd: Avoid copying data in WM8994 I2C write
      mfd: Push byte swap out of WM8994 bulk I/O
      mfd: Constify WM8994 write path
      mfd: Push byte swaps out of wm8994 bulk read path

Mattias Nilsson (1):
      mfd: AB8500 system control driver

Mattias Wallin (2):
      mfd: ab8500 chip revision 3.0 support
      mfd: ab8500-core switch off status added

MyungJoo Ham (2):
      mfd: MAX8997/8966 support
      regulator: MAX8997/8966 support

Randy Dunlap (1):
      mfd: Fix MAX8997 Kconfig entry typos

Vasiliy Kulikov (3):
      mfd: ab3100: world-writable debugfs *_priv files
      mfd: ab3500: world-writable debugfs register-* files
      mfd: ab8500: world-writable debugfs register-* files

Vincent Palatin (1):
      mfd: Invert tps6586x GPIO and subdevices initialization

Wolfram Sang (1):
      mfd: Remove obsolete cleanup for wl1273 clientdata

 Documentation/hwmon/twl4030-madc-hwmon |   45 ++
 arch/arm/mach-imx/mach-mx27_3ds.c      |   11 +-
 arch/arm/mach-imx/mach-pcm038.c        |   10 +-
 arch/arm/mach-mx3/mach-mx31_3ds.c      |   10 +-
 arch/arm/mach-mx3/mach-mx31moboard.c   |    6 +-
 arch/arm/mach-omap2/board-4430sdp.c    |    7 +
 arch/arm/mach-omap2/board-omap4panda.c |    7 +
 arch/x86/platform/olpc/olpc-xo1.c      |   42 +-
 drivers/dma/timb_dma.c                 |    3 +-
 drivers/gpio/Kconfig                   |    7 +-
 drivers/gpio/janz-ttl.c                |    3 +-
 drivers/gpio/rdc321x-gpio.c            |    3 +-
 drivers/gpio/sch_gpio.c                |   57 +-
 drivers/gpio/timbgpio.c                |    6 +-
 drivers/hwmon/Kconfig                  |   10 +
 drivers/hwmon/Makefile                 |    1 +
 drivers/hwmon/jz4740-hwmon.c           |    4 +-
 drivers/hwmon/twl4030-madc-hwmon.c     |  157 ++++
 drivers/i2c/busses/i2c-ocores.c        |    3 +-
 drivers/i2c/busses/i2c-xiic.c          |    3 +-
 drivers/input/misc/88pm860x_onkey.c    |    2 +-
 drivers/input/misc/twl4030-vibra.c     |    3 +-
 drivers/leds/leds-88pm860x.c           |   60 +-
 drivers/leds/leds-mc13783.c            |    7 +-
 drivers/media/radio/radio-timb.c       |    3 +-
 drivers/media/radio/radio-wl1273.c     |    2 +-
 drivers/media/video/timblogiw.c        |    3 +-
 drivers/mfd/88pm860x-core.c            |  567 ++++++++-------
 drivers/mfd/88pm860x-i2c.c             |  103 +++
 drivers/mfd/Kconfig                    |   40 +
 drivers/mfd/Makefile                   |    6 +-
 drivers/mfd/ab3100-core.c              |   10 +-
 drivers/mfd/ab3550-core.c              |   12 +-
 drivers/mfd/ab8500-core.c              |   56 ++-
 drivers/mfd/ab8500-debugfs.c           |    6 +-
 drivers/mfd/ab8500-gpadc.c             |  614 ++++++++++++++++
 drivers/mfd/ab8500-sysctrl.c           |   80 +++
 drivers/mfd/adp5520.c                  |   15 +-
 drivers/mfd/asic3.c                    |   10 +-
 drivers/mfd/cs5535-mfd.c               |   37 +
 drivers/mfd/davinci_voicecodec.c       |    4 +-
 drivers/mfd/htc-pasic3.c               |    7 +-
 drivers/mfd/janz-cmodio.c              |    3 +-
 drivers/mfd/jz4740-adc.c               |    4 -
 drivers/mfd/lpc_sch.c                  |    7 +-
 drivers/mfd/max8997.c                  |  427 +++++++++++
 drivers/mfd/max8998.c                  |    4 +-
 drivers/mfd/mc13xxx-core.c             |   21 +-
 drivers/mfd/mfd-core.c                 |  135 ++++-
 drivers/mfd/pcf50633-core.c            |   24 +-
 drivers/mfd/rdc321x-southbridge.c      |    4 +-
 drivers/mfd/sh_mobile_sdhi.c           |    4 +-
 drivers/mfd/t7l66xb.c                  |   13 +-
 drivers/mfd/tc6387xb.c                 |    7 +-
 drivers/mfd/tc6393xb.c                 |   25 +-
 drivers/mfd/timberdale.c               |   81 +--
 drivers/mfd/tps6105x.c                 |  246 +++++++
 drivers/mfd/tps6586x.c                 |   26 +-
 drivers/mfd/twl-core.c                 |    8 +-
 drivers/mfd/twl4030-codec.c            |    6 +-
 drivers/mfd/twl4030-madc.c             |  802 +++++++++++++++++++++
 drivers/mfd/ucb1x00-ts.c               |    5 +-
 drivers/mfd/vx855.c                    |    1 +
 drivers/mfd/wl1273-core.c              |    8 +-
 drivers/mfd/wm831x-i2c.c               |   18 +-
 drivers/mfd/wm831x-irq.c               |   44 +-
 drivers/mfd/wm831x-spi.c               |   24 +-
 drivers/mfd/wm8400-core.c              |    2 +-
 drivers/mfd/wm8994-core.c              |   77 ++-
 drivers/mfd/wm8994-irq.c               |   14 +-
 drivers/mmc/host/tmio_mmc.c            |   34 +-
 drivers/mtd/nand/tmio_nand.c           |   11 +-
 drivers/net/can/janz-ican3.c           |    3 +-
 drivers/net/ks8842.c                   |    3 +-
 drivers/power/jz4740-battery.c         |    4 +-
 drivers/regulator/88pm8607.c           |   46 +-
 drivers/regulator/Kconfig              |   18 +
 drivers/regulator/Makefile             |    3 +-
 drivers/regulator/ab3100.c             |    3 +-
 drivers/regulator/max8997.c            | 1213 ++++++++++++++++++++++++++++++++
 drivers/regulator/mc13783-regulator.c  |    7 +-
 drivers/regulator/mc13892-regulator.c  |    7 +-
 drivers/regulator/tps6105x-regulator.c |  196 +++++
 drivers/regulator/twl-regulator.c      |   24 +-
 drivers/spi/xilinx_spi.c               |    3 +-
 drivers/usb/host/ohci-tmio.c           |    8 +-
 drivers/video/backlight/88pm860x_bl.c  |   34 +-
 drivers/video/tmiofb.c                 |   28 +-
 drivers/w1/masters/ds1wm.c             |   13 +-
 drivers/watchdog/rdc321x_wdt.c         |    3 +-
 include/linux/i2c/twl.h                |    2 +
 include/linux/i2c/twl4030-madc.h       |  141 ++++
 include/linux/mfd/88pm860x.h           |   20 +-
 include/linux/mfd/ab8500.h             |    4 +-
 include/linux/mfd/ab8500/gpadc.h       |   32 +
 include/linux/mfd/ab8500/sysctrl.h     |  254 +++++++
 include/linux/mfd/abx500.h             |    1 -
 include/linux/mfd/core.h               |   54 ++-
 include/linux/mfd/max8997-private.h    |  347 +++++++++
 include/linux/mfd/max8997.h            |  114 +++
 include/linux/mfd/mc13xxx.h            |    3 +-
 include/linux/mfd/tps6105x.h           |  101 +++
 include/linux/mfd/wm831x/pdata.h       |    6 +
 include/linux/mfd/wm8994/core.h        |    4 +-
 include/linux/pci_ids.h                |    1 +
 sound/soc/codecs/cq93vc.c              |    3 +-
 sound/soc/codecs/twl4030.c             |    6 +-
 sound/soc/codecs/wl1273.c              |    3 +-
 sound/soc/codecs/wm8400.c              |    3 +-
 sound/soc/davinci/davinci-vcif.c       |    2 +-
 110 files changed, 6059 insertions(+), 785 deletions(-)
 create mode 100644 Documentation/hwmon/twl4030-madc-hwmon
 create mode 100644 drivers/hwmon/twl4030-madc-hwmon.c
 create mode 100644 drivers/mfd/ab8500-gpadc.c
 create mode 100644 drivers/mfd/ab8500-sysctrl.c
 create mode 100644 drivers/mfd/max8997.c
 create mode 100644 drivers/mfd/tps6105x.c
 create mode 100644 drivers/mfd/twl4030-madc.c
 create mode 100644 drivers/regulator/max8997.c
 create mode 100644 drivers/regulator/tps6105x-regulator.c
 create mode 100644 include/linux/i2c/twl4030-madc.h
 create mode 100644 include/linux/mfd/ab8500/gpadc.h
 create mode 100644 include/linux/mfd/ab8500/sysctrl.h
 create mode 100644 include/linux/mfd/max8997-private.h
 create mode 100644 include/linux/mfd/max8997.h
 create mode 100644 include/linux/mfd/tps6105x.h

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
