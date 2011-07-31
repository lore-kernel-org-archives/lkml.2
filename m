Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab1GaWga (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 18:36:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:56993 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab1GaWgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 18:36:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,297,1309762800"; 
   d="scan'208";a="32593664"
Date: Mon, 1 Aug 2011 00:37:39 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Sanjeev Premi <premi@ti.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Keshava Munegowda <Keshava_mgowda@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jesper Juhl <jj@chaosbits.net>, Dan Carpenter <error27@gmail.com>,
        Jin Park <jinyoungp@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Om Prakash <omprakash.pal@stericsson.com>,
        Axel Lin <axel.lin@gmail.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Oleg Drokin <green@linuxhacker.ru>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Robert Rosengren <robert.rosengren@stericsson.com>,
        Margarita Olaya <magi@slimlogic.co.uk>,
        Peter Huewe <peterhuewe@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [GIT] [3.1] MFD pull request
Message-ID: <20110731223739.GZ26275@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the MFD pull request for the 3.1 merge window. This is a relatively
quiet one, with a few new MFD drivers: AnalogicTech's AAT2870 and TI's
tps65912 and tps65921.
The rest of the update is made of a big chunk of Wolfson's WM83xx fixes and
improvements, and a few fixes for the ST-Ericsson ABxxxx support.

Thanks in advance for pulling those in.

The following changes since commit 24c3047095fa3954f114bfff2e37b8fcbb216396:

  Merge branch 'nfs-for-3.1' of git://git.linux-nfs.org/projects/trondmy/linux-nfs (2011-07-31 06:26:50 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next

Alexander Stein (1):
      mfd: Add tunnelcreek watchdog to lpc_sch devices

Axel Lin (2):
      mfd: Remove comp{1,2}_threshold sysfs entries in tps65911_comparator_remove
      mfd: Fix off-by-one value range checking for tps65912_i2c_write

Dan Carpenter (1):
      regulator: Storing tps65912 error codes in u8

Dimitris Papastamos (1):
      mfd: Fix off by one in WM831x IRQ code

Jesper Juhl (3):
      mfd: Remove dead code from max8997-irq
      mfd: Don't leak init_data in tps65910_i2c_probe
      mfd: Avoid two assignments if failures happen in tps65910_i2c_probe

Jin Park (3):
      mfd: Add AAT2870 mfd driver
      backlight: Add AAT2870 backlight driver
      regulator: aat2870: Add AAT2870 regulator driver

Keshava Munegowda (1):
      mfd: Fix the omap-usb-host clock API usage on usbhs_disable()

Lars-Peter Clausen (1):
      mfd: Use generic irq chip for jz4740-adc

Linus Walleij (3):
      mfd: Update ab8500 subdevice list
      mfd: Clean-up ab8500 register file
      mfd: Move TPS55910 Kconfig option

Margarita Olaya (4):
      mfd: tps65912: Add new mfd device
      tps65912: irq: add interrupt controller
      tps65912: gpio: add gpio driver
      tps65912: add regulator driver

Mark Brown (18):
      mfd: Fix bus lock interaction for WM831x IRQ set_type() operation
      mfd: Implement support for multiple WM831x devices
      mfd: Allow touchscreen to be disabled on wm831x devices
      mfd: Only register wm831x RTC device if the 32.768kHz crystal is enabled
      mfd: Support dynamic allocation of IRQ range for wm831x
      mfd: Read wm831x AUXADC conversion results before acknowledging interrupt
      mfd: Refactor wm831x AUXADC handling into a separate file
      mfd: Restructure wm8994-core device revision handling
      mfd: Support multiple active WM831x AUXADC conversions
      mfd: Fix WM8994 IRQ register cache restore on resume
      mfd: Fix error handling if BUG() isn't enabled in WM8994
      mfd: Implement tps65910 IRQ cleanup
      mfd: Ensure value written by wm831x_set_bits() is within the mask
      mfd: Add WM831x clock control register definitions
      mfd: Don't ask about the TPS65912 core driver in Kconfig
      mfd: Add devices for WM831x clocking module
      mfd: Acknowlege all WM831x IRQs before we handle them
      mfd: Acknowledge WM8994 IRQs before reporting

Oleg Drokin (1):
      mfd: Add tps65921 support from twl-core

Om Prakash (1):
      mfd: Fix missing stmpe kerneldoc

Peter Huewe (2):
      mfd: Use kstrtoul_from_user in ab3550
      mfd: Use kstrtoul_from_user in ab8500

Randy Dunlap (1):
      mfd: twl6030-pwm.c needs MODULE_LICENSE

Robert Rosengren (1):
      mfd: ab8500-core MFD devices marked as initdata

Sanjeev Premi (1):
      mfd: Fix mismatch in twl4030 mutex lock-unlock

Sascha Hauer (1):
      mfd: Allocate wm835x irq descs dynamically

 drivers/gpio/Kconfig                   |    6 +
 drivers/gpio/Makefile                  |    1 +
 drivers/gpio/gpio-tps65912.c           |  156 +++++++
 drivers/mfd/Kconfig                    |   53 ++-
 drivers/mfd/Makefile                   |    8 +-
 drivers/mfd/aat2870-core.c             |  535 +++++++++++++++++++++
 drivers/mfd/ab3550-core.c              |   41 +--
 drivers/mfd/ab8500-core.c              |  231 +++++++---
 drivers/mfd/ab8500-debugfs.c           |   41 +--
 drivers/mfd/jz4740-adc.c               |   90 ++---
 drivers/mfd/lpc_sch.c                  |   49 ++-
 drivers/mfd/max8997-irq.c              |    2 -
 drivers/mfd/omap-usb-host.c            |    4 +-
 drivers/mfd/stmpe.c                    |    2 +-
 drivers/mfd/stmpe.h                    |    1 +
 drivers/mfd/tps65910.c                 |   13 +-
 drivers/mfd/tps65911-comparator.c      |    2 +
 drivers/mfd/tps65912-core.c            |  177 +++++++
 drivers/mfd/tps65912-i2c.c             |  139 ++++++
 drivers/mfd/tps65912-irq.c             |  224 +++++++++
 drivers/mfd/tps65912-spi.c             |  142 ++++++
 drivers/mfd/twl-core.c                 |    2 +
 drivers/mfd/twl4030-madc.c             |    8 +-
 drivers/mfd/twl6030-pwm.c              |    2 +
 drivers/mfd/wm831x-auxadc.c            |  299 ++++++++++++
 drivers/mfd/wm831x-core.c              |  259 +++--------
 drivers/mfd/wm831x-irq.c               |   77 ++--
 drivers/mfd/wm8350-irq.c               |   18 +-
 drivers/mfd/wm8994-core.c              |   33 +-
 drivers/mfd/wm8994-irq.c               |   12 +-
 drivers/regulator/Kconfig              |   13 +
 drivers/regulator/Makefile             |    2 +
 drivers/regulator/aat2870-regulator.c  |  232 +++++++++
 drivers/regulator/tps65912-regulator.c |  800 ++++++++++++++++++++++++++++++++
 drivers/video/backlight/Kconfig        |    7 +
 drivers/video/backlight/Makefile       |    1 +
 drivers/video/backlight/aat2870_bl.c   |  246 ++++++++++
 include/linux/mfd/aat2870.h            |  181 +++++++
 include/linux/mfd/ab8500.h             |    8 +-
 include/linux/mfd/stmpe.h              |    3 +
 include/linux/mfd/tps65910.h           |    1 +
 include/linux/mfd/tps65912.h           |  327 +++++++++++++
 include/linux/mfd/wm831x/core.h        |  119 +++++-
 include/linux/mfd/wm831x/pdata.h       |    3 +
 44 files changed, 4118 insertions(+), 452 deletions(-)
 create mode 100644 drivers/gpio/gpio-tps65912.c
 create mode 100644 drivers/mfd/aat2870-core.c
 create mode 100644 drivers/mfd/tps65912-core.c
 create mode 100644 drivers/mfd/tps65912-i2c.c
 create mode 100644 drivers/mfd/tps65912-irq.c
 create mode 100644 drivers/mfd/tps65912-spi.c
 create mode 100644 drivers/mfd/wm831x-auxadc.c
 create mode 100644 drivers/regulator/aat2870-regulator.c
 create mode 100644 drivers/regulator/tps65912-regulator.c
 create mode 100644 drivers/video/backlight/aat2870_bl.c
 create mode 100644 include/linux/mfd/aat2870.h
 create mode 100644 include/linux/mfd/tps65912.h

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
