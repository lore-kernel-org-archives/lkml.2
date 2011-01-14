Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672Ab1ANN56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 08:57:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:23785 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757430Ab1ANN5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 08:57:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,322,1291622400"; 
   d="scan'208";a="696860934"
Date: Fri, 14 Jan 2011 14:57:47 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Andres Salomon <dilinger@queued.net>,
        Sundar Iyer <sundar.iyer@stericsson.com>,
        Axel Lin <axel.lin@gmail.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Joe Perches <joe@perches.com>, Stephen Warren <swarren@nvidia.com>,
        Bryan Wu <bryan.wu@canonical.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [GIT] [2.6.38] MFD pull request
Message-ID: <20110114135747.GB20263@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the MFD pull request for the 2.6.38 merge window.

The biggest part of the update comes from the new irq API conversion and from
various fixes all over the place. We also got support for the AMD cs5535
companion device, and for Wolfson Microelectronics WM8326 (besides the WM8958
one that got merged already).

Thanks in advance for pulling it:

The following changes since commit 52cfd503ad7176d23a5dd7af3981744feb60622f:

  Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6 (2011-01-13 20:15:35 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next

Andres Salomon (7):
      mfd: Add cs5535-mfd driver for AMD Geode's CS5535/CS5536 support
      mfd: Fix cs5535 warning on x86-64
      gpio: Convert cs5535 from pci device to platform device
      misc: Convert cs5535-mfgpt from pci device to platform device
      gpio/misc: Add MODULE_ALIAS entries for CS5535 functions
      x86: OLPC: convert olpc-xo1 driver from pci device to platform device
      i2c: Convert SCx200 driver from using raw PCI to platform device

Axel Lin (3):
      mfd: Include <linux/io.h> instead of <asm/io.h>
      mfd: Include <linux/gpio.h> instead of <asm/gpio.h>
      mfd: Add __devexit annotation for vx855_remove

Bryan Wu (1):
      mfd: Fix twl_probe section mismatch warning in mfd/twl-core.c

Joe Perches (4):
      mfd: Update WARN uses
      mfd: Use printf extension %pR for struct resource
      misc: Fix cs5535 printk warnings
      gpio: Fix cs5535 printk warnings

Lennert Buytenhek (2):
      mfd: Convert ezx-pcap to new irq_ methods
      mfd: twl6030 irq_data conversion.

Mark Brown (30):
      mfd: Simplify WM832x subdevice instantiation
      mfd: Add WM8326 support
      mfd: Convert WM831x to new irq_ interrupt methods
      mfd: Convert WM835x to new irq_ interrupt methods
      mfd: Convert WM8994 to new irq_ interrupt methods
      mfd: Provide pm_runtime_no_callbacks flag in cell data
      mfd: Implement runtime PM for WM8994 core driver
      mfd: Staticise unexported symbols in ASIC3
      mfd: Correct ASIC3 IRQ_OWM resource setup
      mfd: Use NULL to initialise NULL pointers in ab8500-debugfs
      mfd: Staticise internal functions in HTC I2CCPLD driver
      mfd: Convert 88PM860x driver to new irq_ APIs
      mfd: Convert ASIC3 to new irq_ APIs
      mfd: Convert AB3500 to new irq_ APIs
      mfd: Convert AB8500 to new irq_ methods
      mfd: Convert HTC EGPIO driver to irq_ API
      mfd: Convert HTC I2C CPLD driver to irq_ API
      mfd: Convert jz4740-adc to new irq_ methods
      mfd: Convert max8925 to new irq_ API
      mfd: Convert MAX8998 driver to irq_ API
      mfd: Convert SMTPE driver to new irq_ APIs
      mfd: Convert t7166xb driver to new irq_ API
      mfd: Convert tc6393xb driver to new irq_ APIs
      mfd: Convert tps6586x driver to new irq_ API
      mfd: Convert TWL4030 to new irq_ APIs
      mfd: Convert Wolfson MFD drivers to use irq_data accessor function
      misc: Make AB8500_PWM driver depend on U8500 due to PWM breakage
      mfd: Remove ARCH_U8500 dependency from AB8500
      mfd: Convert WM831x away from legacy I2C PM operations
      mfd: Flag WM831x /IRQ as a wake source

Mattias Wallin (6):
      mfd: Fix ab8500-debug indentation errors
      mfd: ab8500-core improved error handling in get_chip_id
      mfd: Export ab8500 chip id to sysfs
      mfd: ab8500-core wake up from suspend
      mfd: ab8500-core ioresources irq for subdrivers added
      mfd: ab8500-core chip version cut 2.0 support

MyungJoo Ham (3):
      mfd: MAX8998/LP3974 hibernation support
      mfd: Support LP3974 RTC
      regulator: Support MAX8998/LP3974 DVS-GPIO

Stephen Warren (1):
      mfd: Remove tps6586x device ID check

Sundar Iyer (1):
      mfd/ab8500: remove spi support

Uwe Kleine-König (1):
      mfd: Don't open-code mc13xxx_unlock

 arch/x86/Kconfig                    |    2 +-
 arch/x86/platform/olpc/olpc-xo1.c   |  101 ++--
 drivers/gpio/cs5535-gpio.c          |   93 ++---
 drivers/i2c/busses/scx200_acb.c     |  200 +++----
 drivers/mfd/88pm860x-core.c         |   36 +-
 drivers/mfd/Kconfig                 |   16 +-
 drivers/mfd/Makefile                |    3 +-
 drivers/mfd/ab3550-core.c           |   28 +-
 drivers/mfd/ab8500-core.c           |  306 ++++++++++--
 drivers/mfd/ab8500-debugfs.c        | 1016 +++++++++++++++++-----------------
 drivers/mfd/ab8500-spi.c            |  143 -----
 drivers/mfd/asic3.c                 |   62 ++--
 drivers/mfd/cs5535-mfd.c            |  151 ++++++
 drivers/mfd/ezx-pcap.c              |   25 +-
 drivers/mfd/htc-egpio.c             |   27 +-
 drivers/mfd/htc-i2cpld.c            |   40 +-
 drivers/mfd/jz4740-adc.c            |   25 +-
 drivers/mfd/max8925-core.c          |   30 +-
 drivers/mfd/max8998-irq.c           |   37 +-
 drivers/mfd/max8998.c               |  134 +++++-
 drivers/mfd/mc13xxx-core.c          |    2 +-
 drivers/mfd/mfd-core.c              |    4 +
 drivers/mfd/sm501.c                 |    9 +-
 drivers/mfd/stmpe.c                 |   28 +-
 drivers/mfd/t7l66xb.c               |   20 +-
 drivers/mfd/tc6393xb.c              |   22 +-
 drivers/mfd/tps65010.c              |    2 +-
 drivers/mfd/tps6586x.c              |   36 +-
 drivers/mfd/twl-core.c              |    2 +-
 drivers/mfd/twl4030-irq.c           |   28 +-
 drivers/mfd/twl6030-irq.c           |    2 +-
 drivers/mfd/vx855.c                 |    2 +-
 drivers/mfd/wm831x-core.c           |   17 +-
 drivers/mfd/wm831x-i2c.c            |   14 +-
 drivers/mfd/wm831x-irq.c            |   53 ++-
 drivers/mfd/wm831x-spi.c            |   18 +
 drivers/mfd/wm8350-irq.c            |   32 +-
 drivers/mfd/wm8994-core.c           |   46 +-
 drivers/mfd/wm8994-irq.c            |   32 +-
 drivers/misc/Kconfig                |    2 +-
 drivers/misc/cs5535-mfgpt.c         |   73 +--
 drivers/regulator/max8998.c         |   94 +++-
 drivers/rtc/rtc-max8998.c           |   54 ++-
 include/linux/mfd/ab8500.h          |   53 +-
 include/linux/mfd/core.h            |    6 +
 include/linux/mfd/max8998-private.h |    2 +
 include/linux/mfd/max8998.h         |   31 +-
 include/linux/mfd/wm831x/core.h     |    1 +
 48 files changed, 1806 insertions(+), 1354 deletions(-)
 delete mode 100644 drivers/mfd/ab8500-spi.c
 create mode 100644 drivers/mfd/cs5535-mfd.c

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
