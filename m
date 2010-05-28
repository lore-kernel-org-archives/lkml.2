Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab0E1Aq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:46:29 -0400
Received: from mga05.intel.com ([192.55.52.89]:14873 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754530Ab0E1Aq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:46:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,314,1272870000"; 
   d="scan'208";a="571237258"
Date: Fri, 28 May 2010 02:46:14 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT] [2.6.35] MFD pull request
Message-ID: <20100528004611.GA24790@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the MFD pull request for the 2.6.35 merge window.

We have a bunch of new drivers: RDC R-321x southbridge, Janz MODULbus,
ST-E AB3550 and AB8500, Toshiba TC35892 and TI TPS6507. We also have a
pcf50633 cleanup, an ABx500 redesign, our usual Wolfson fixes and more
Timberdale subdevices.

Thanks in advance for pulling:

The following changes since commit c5617b200ac52e35f7e8cf05a17b0a2d50f6b3e9:
  Linus Torvalds (1):
        Merge branch 'perf-core-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next

Dan Carpenter (2):
      mfd: Off by one calculating size for timberdale
      mfd: Proper pcf50633 irq check

Florian Fainelli (6):
      mfd: Add support for the RDC321x southbridge
      gpio: Add support for RDC321x GPIO controller
      watchdog: Convert rdc321x_wdt to use southbridge pci device
      x86: remove rdc321x_defs.h
      mfd: Change rdc321x resources flags to IORESOURCE_IO
      gpio: Fix inverted rdc321x gpio data out registers

Haojian Zhuang (1):
      mfd: Delay to mask tsc irq in max8925

Henrik Kretzschmar (1):
      mfd: Section cleanup of 88pm860x driver

Ilkka Koskinen (1):
      mfd: Rename twl5031 sih modules

Ira W. Snyder (3):
      mfd: Janz CMOD-IO PCI MODULbus Carrier Board support
      can: Add support for Janz VMOD-ICAN3 Intelligent CAN module
      gpio: Add support for Janz VMOD-TTL Digital IO module

Lars-Peter Clausen (4):
      mfd: Fix pcf50633 bitfield logic in interrupt handler
      mfd: pcf50633-adc: Fix potential race in pcf50633_adc_sync_read
      mfd: Use threaded irq for pcf50633
      mfd: Move pcf50633 irq related functions to its own file.

Linus Walleij (1):
      mfd: Renamed ab3100.h to abx500.h

Mark Brown (4):
      mfd: Remove unused wm831x IRQ handler data
      mfd: Improve WM831x AUXADC completion handling
      mfd: Initialise WM831x IRQ masks on chip even if interrupts not in use
      mfd: Ensure WM831x charger interrupts are acknowledged when suspending

Mattias Wallin (3):
      mfd: AB3100 register access change to abx500 API
      mfd: AB3550 core driver
      ARM: AB3550 board configuration and irq for U300

Phil Carmody (1):
      mfd: Fix error in wm8400 reg cache access check

Rabin Vincent (4):
      mfd: Remove incorrect wm8350 kfree
      mfd: Add Toshiba's TC35892 MFD core
      gpio: Add TC35892 GPIO driver
      mfd: New AB8500 driver

Randy Dunlap (2):
      mfd: Use menuconfig for quicker config editing
      gpio: rdc321x needs to select MFD_CORE

Richard Röjfors (2):
      mfd: Add in XIIC to some configurations of timberdale
      mfd: Add timb-dma to all configurations of timberdale

Samuel Ortiz (2):
      mfd: Check t7l66 platform_data pointer
      mfd: Check for mem_base when building IORESOURCE_MEM resources

Tejun Heo (1):
      gpio: Update gfp/slab.h includes for rdc321x

Tobias Klauser (1):
      mfd: Storage class for timberdale should be before const qualifier

Todd Fischer (6):
      mfd: Move TPS6507x register definition to header file.
      mfd: Add tps6507x board data structure
      regulator: tps6057x namespace cleanup
      mfd: Add TPS6507x support
      input: Touchscreen driver for TPS6507x
      davinci: da850 TPS6507x touch screen driver board data

Wolfram Sang (2):
      mfd: Fix dangling pointers
      mfd: Remove unneeded and dangerous clearing of clientdata

 arch/arm/mach-davinci/board-da850-evm.c |   19 +-
 arch/arm/mach-u300/i2c.c                |   57 +-
 arch/arm/mach-u300/include/mach/irqs.h  |    7 +
 arch/arm/mach-ux500/board-mop500.c      |    2 +-
 arch/x86/include/asm/rdc321x_defs.h     |   12 -
 drivers/gpio/Kconfig                    |   26 +
 drivers/gpio/Makefile                   |    5 +-
 drivers/gpio/janz-ttl.c                 |  258 +++++
 drivers/gpio/rdc321x-gpio.c             |  246 +++++
 drivers/gpio/tc35892-gpio.c             |  381 +++++++
 drivers/input/touchscreen/Kconfig       |   13 +
 drivers/input/touchscreen/Makefile      |    1 +
 drivers/input/touchscreen/tps6507x-ts.c |  400 +++++++
 drivers/mfd/88pm860x-core.c             |    6 +-
 drivers/mfd/88pm860x-i2c.c              |    2 +-
 drivers/mfd/Kconfig                     |   87 ++-
 drivers/mfd/Makefile                    |   13 +-
 drivers/mfd/ab3100-core.c               |   99 ++-
 drivers/mfd/ab3100-otp.c                |   13 +-
 drivers/mfd/ab3550-core.c               | 1401 +++++++++++++++++++++++
 drivers/mfd/ab4500-core.c               |  209 ----
 drivers/mfd/ab8500-core.c               |  444 ++++++++
 drivers/mfd/ab8500-spi.c                |  133 +++
 drivers/mfd/abx500-core.c               |  157 +++
 drivers/mfd/da903x.c                    |    1 +
 drivers/mfd/janz-cmodio.c               |  304 +++++
 drivers/mfd/max8925-core.c              |    7 +-
 drivers/mfd/max8925-i2c.c               |    2 -
 drivers/mfd/menelaus.c                  |    3 +-
 drivers/mfd/mfd-core.c                  |    2 +-
 drivers/mfd/pcf50633-adc.c              |   39 +-
 drivers/mfd/pcf50633-core.c             |  345 +------
 drivers/mfd/pcf50633-irq.c              |  318 ++++++
 drivers/mfd/rdc321x-southbridge.c       |  123 +++
 drivers/mfd/t7l66xb.c                   |    3 +
 drivers/mfd/tc35892.c                   |  347 ++++++
 drivers/mfd/timberdale.c                |  156 +++-
 drivers/mfd/timberdale.h                |   16 +-
 drivers/mfd/tps65010.c                  |    2 +-
 drivers/mfd/tps6507x.c                  |  159 +++
 drivers/mfd/twl4030-irq.c               |   11 +-
 drivers/mfd/wm831x-core.c               |  112 ++-
 drivers/mfd/wm831x-irq.c                |   18 +-
 drivers/mfd/wm8350-i2c.c                |    6 +-
 drivers/mfd/wm8400-core.c               |    4 +-
 drivers/net/can/Kconfig                 |   10 +
 drivers/net/can/Makefile                |    1 +
 drivers/net/can/janz-ican3.c            | 1830 +++++++++++++++++++++++++++++++
 drivers/regulator/ab3100.c              |   35 +-
 drivers/regulator/tps6507x-regulator.c  |  373 +++----
 drivers/rtc/rtc-ab3100.c                |   41 +-
 drivers/watchdog/rdc321x_wdt.c          |   53 +-
 include/linux/input/tps6507x-ts.h       |   24 +
 include/linux/mfd/88pm860x.h            |    4 +-
 include/linux/mfd/ab3100.h              |  129 ---
 include/linux/mfd/ab4500.h              |  262 -----
 include/linux/mfd/ab8500.h              |  128 +++
 include/linux/mfd/abx500.h              |  233 ++++
 include/linux/mfd/janz.h                |   54 +
 include/linux/mfd/rdc321x.h             |   26 +
 include/linux/mfd/tc35892.h             |  132 +++
 include/linux/mfd/tps6507x.h            |  169 +++
 include/linux/mfd/wm831x/core.h         |    5 +-
 63 files changed, 8113 insertions(+), 1365 deletions(-)
 delete mode 100644 arch/x86/include/asm/rdc321x_defs.h
 create mode 100644 drivers/gpio/janz-ttl.c
 create mode 100644 drivers/gpio/rdc321x-gpio.c
 create mode 100644 drivers/gpio/tc35892-gpio.c
 create mode 100644 drivers/input/touchscreen/tps6507x-ts.c
 create mode 100644 drivers/mfd/ab3550-core.c
 delete mode 100644 drivers/mfd/ab4500-core.c
 create mode 100644 drivers/mfd/ab8500-core.c
 create mode 100644 drivers/mfd/ab8500-spi.c
 create mode 100644 drivers/mfd/abx500-core.c
 create mode 100644 drivers/mfd/janz-cmodio.c
 create mode 100644 drivers/mfd/pcf50633-irq.c
 create mode 100644 drivers/mfd/rdc321x-southbridge.c
 create mode 100644 drivers/mfd/tc35892.c
 create mode 100644 drivers/mfd/tps6507x.c
 create mode 100644 drivers/net/can/janz-ican3.c
 create mode 100644 include/linux/input/tps6507x-ts.h
 delete mode 100644 include/linux/mfd/ab3100.h
 delete mode 100644 include/linux/mfd/ab4500.h
 create mode 100644 include/linux/mfd/ab8500.h
 create mode 100644 include/linux/mfd/abx500.h
 create mode 100644 include/linux/mfd/janz.h
 create mode 100644 include/linux/mfd/rdc321x.h
 create mode 100644 include/linux/mfd/tc35892.h
 create mode 100644 include/linux/mfd/tps6507x.h

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
