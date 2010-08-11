Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859Ab0HKKJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 06:09:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:49957 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932827Ab0HKKJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 06:09:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,352,1278313200"; 
   d="scan'208";a="310667978"
Date: Wed, 11 Aug 2010 12:09:15 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Axel Lin <axel.lin@gmail.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Jarkko Nikula <jhnikula@gmail.com>, David Miller <davem@davemloft.net>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sundar R Iyer <sundar.iyer@stericsson.com>,
        Kulikov Vasiliy <segooon@gmail.com>, Hemanth V <hemanthv@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Luotao Fu <l.fu@pengutronix.de>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Julia Lawall <julia@diku.dk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Dan Carpenter <error27@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: [GIT] [2.6.36] MFD pull request
Message-ID: <20100811100914.GA2506@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the MFD pull request for the 2.6.36 merge window.

We have a few new drivers with this round, mostly the ST-E stmpe, TI
TPS6586x and Ingenic jz4740. But the bulk of it is around fixes and cleanups.

Thanks in advance for pulling:

The following changes since commit 3d30701b58970425e1d45994d6cb82f828924fdd:

  Merge branch 'for-linus' of git://neil.brown.name/md (2010-08-10 15:38:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next

Axel Lin (14):
      mfd: Fix memory leak in ab3100_otp_probe
      mfd: properly handle platform_device_add_resources fail in mfd_add_device
      mfd: Properly free t7l66xb clk32k clock source
      mfd: Fix jz4740-adc resource reclaim in probe error path
      mfd: Check jz4740-adc kmalloc() result
      mfd: Fix wrong goto labels for tc6393xb error handling
      mfd: Fix tc6387xb resource reclaim
      mfd: Annotate tc6387xb probe/remove routines with __devinit/__devexit
      mfd: Avoid calling platform_device_put() twice in ucb1400 probe error path
      mfd: Fix wm8994_device_init() return value
      mfd: Fix wrong wm8350-core kfree in error path
      mfd: Fix incorrect kfree(i2c) in tps6507x i2c_driver probe
      mfd: Fix incorrect kfree(i2c) in wm831x-core i2c_driver probe
      mfd: Fix incorrect kfree(i2c) in wm8994-core i2c_driver probe

Dan Carpenter (1):
      mfd: Fix 88pm860x uninitialized variable and clean up

David Miller (1):
      mfd: Missing slab.h includes

Haojian Zhuang (2):
      mfd: Enable onkey on max8925
      mfd: Fix led resource in 88pm860x

Hemanth V (1):
      mfd: Add support for TWL6030 PWM

Jarkko Nikula (2):
      mfd: Fix menelaus mmc slot 2 misconfiguration
      mfd: Use macros instead of some constant magic numbers for menelaus

Julia Lawall (2):
      mfd: kzalloc doesn't return ERR_PTR
      mfd: Fix davinci memory leak

Kulikov Vasiliy (1):
      touchscreen: Fix sign bug

Lars-Peter Clausen (1):
      mfd: Add JZ4740 ADC driver

Linus Walleij (1):
      mfd: AB8500 mask off irrelevant bits from the SPI message

Luotao Fu (1):
      input: STMPE touch controller support

Mark Brown (4):
      mfd: Staticise ab3550 register access functions
      gpiolib: Implement set_debounce for WM831x GPIOs
      mfd: Add additional WM8994 GPIO functions
      mfd: Add WM8321 support

Mike Rapoport (1):
      mfd: Add TPS6586x driver

Rabin Vincent (3):
      mfd: Add STMPE I/O Expander support
      gpio: Add STMPE GPIO driver
      input: Add STMPE keypad driver

Samuel Ortiz (1):
      mfd: More verbose MFD Kconfig entry

Sundar R Iyer (1):
      mfd: Add stmpe auto sleep feature

Uwe Kleine-König (3):
      mfd: New mc13783 function exposing flags
      hwmon: Don't access struct mc13783 directly from mc13783-adc
      mfd: Get rid of now unused mc13783 private header

 drivers/gpio/Kconfig                  |    7 +
 drivers/gpio/Makefile                 |    1 +
 drivers/gpio/stmpe-gpio.c             |  399 +++++++++++++
 drivers/gpio/wm831x-gpio.c            |   32 ++
 drivers/hwmon/mc13783-adc.c           |   17 +-
 drivers/input/keyboard/Kconfig        |   10 +
 drivers/input/keyboard/Makefile       |    1 +
 drivers/input/keyboard/stmpe-keypad.c |  386 +++++++++++++
 drivers/input/touchscreen/Kconfig     |   10 +
 drivers/input/touchscreen/Makefile    |    1 +
 drivers/input/touchscreen/stmpe-ts.c  |  397 +++++++++++++
 drivers/mfd/88pm860x-core.c           |   86 ++--
 drivers/mfd/Kconfig                   |   65 +++-
 drivers/mfd/Makefile                  |    4 +
 drivers/mfd/ab3100-otp.c              |   16 +-
 drivers/mfd/ab3550-core.c             |   23 +-
 drivers/mfd/ab8500-spi.c              |    7 +-
 drivers/mfd/abx500-core.c             |    2 +-
 drivers/mfd/davinci_voicecodec.c      |    6 +-
 drivers/mfd/janz-cmodio.c             |    1 +
 drivers/mfd/jz4740-adc.c              |  394 +++++++++++++
 drivers/mfd/max8925-core.c            |   27 +
 drivers/mfd/mc13783-core.c            |   30 +-
 drivers/mfd/menelaus.c                |   75 ++-
 drivers/mfd/mfd-core.c                |    4 +-
 drivers/mfd/stmpe.c                   |  985 +++++++++++++++++++++++++++++++++
 drivers/mfd/stmpe.h                   |  183 ++++++
 drivers/mfd/t7l66xb.c                 |    3 +-
 drivers/mfd/tc6387xb.c                |   16 +-
 drivers/mfd/tc6393xb.c                |    4 +-
 drivers/mfd/tps6507x.c                |    4 +-
 drivers/mfd/tps6586x.c                |  375 +++++++++++++
 drivers/mfd/twl6030-pwm.c             |  163 ++++++
 drivers/mfd/ucb1400_core.c            |    2 +-
 drivers/mfd/wm831x-core.c             |   18 +-
 drivers/mfd/wm8350-core.c             |    6 +-
 drivers/mfd/wm8994-core.c             |    8 +-
 include/linux/jz4740-adc.h            |   32 ++
 include/linux/mfd/mc13783-private.h   |  220 --------
 include/linux/mfd/mc13783.h           |    2 +
 include/linux/mfd/stmpe.h             |  201 +++++++
 include/linux/mfd/tps6586x.h          |   47 ++
 include/linux/mfd/wm8994/gpio.h       |    4 +
 43 files changed, 3934 insertions(+), 340 deletions(-)
 create mode 100644 drivers/gpio/stmpe-gpio.c
 create mode 100644 drivers/input/keyboard/stmpe-keypad.c
 create mode 100644 drivers/input/touchscreen/stmpe-ts.c
 create mode 100644 drivers/mfd/jz4740-adc.c
 create mode 100644 drivers/mfd/stmpe.c
 create mode 100644 drivers/mfd/stmpe.h
 create mode 100644 drivers/mfd/tps6586x.c
 create mode 100644 drivers/mfd/twl6030-pwm.c
 create mode 100644 include/linux/jz4740-adc.h
 delete mode 100644 include/linux/mfd/mc13783-private.h
 create mode 100644 include/linux/mfd/stmpe.h
 create mode 100644 include/linux/mfd/tps6586x.h
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
