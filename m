Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2LMB5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 20:57:39 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:62482 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab2LMB5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 20:57:38 -0500
Date: Wed, 12 Dec 2012 17:57:36 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: [GIT PULL 4/5] ARM: arm-soc: driver specific changes
Message-ID: <20121213015736.GD28281@quad.lixom.net>
References: <20121213015543.GA18953@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213015543.GA18953@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A collection of mostly SoC-specific driver updates:
- a handful of pincontrol and setup changes
- new drivers for hwmon and reset controller for vexpress
- timing support updates for OMAP (gpmc and other interfaces)
- + a collection of smaller cleanups


Conflicts seen with this merge:

None

----------------------------------------------------------------

The following changes since commit 93dd6e875a23bb2b41b527d869dbbd0d9595760d:

  Merge branch 'next/pm-merge' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/drivers

for you to fetch changes up to 4aa7cf79b1f760b5751d1686329351c2e060791b:

  Merge branch 'next/gpio-samsung' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into next/drivers

----------------------------------------------------------------

Afzal Mohammed (6):
      ARM: OMAP2+: nand: remove redundant rounding
      ARM: OMAP2+: gpmc: handle additional timings
      ARM: OMAP2+: gpmc: generic timing calculation
      ARM: OMAP2+: onenand: generic timing calculation
      ARM: OMAP2+: smc91x: generic timing calculation
      ARM: OMAP2+: tusb6010: generic timing calculation

Arnd Bergmann (6):
      Merge branch 'vexpress-drivers' of git://git.linaro.org/people/pawelmoll/linux into next/drivers
      Merge tag 'ux500-pins-for-arm-soc' of http://git.kernel.org/.../linusw/linux-stericsson into next/drivers
      Merge branch 'omap/headers4' into next/drivers
      Merge tag 'omap-for-v3.8/gpmc-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers
      Merge branch 'omap/dt' into next/drivers
      Merge tag 'omap-for-v3.8/timer-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers

Eunki Kim (2):
      ARM: SAMSUNG: Insert bitmap_gpio_int member in samsung_gpio_chip
      gpio: samsung: Fix input mode setting function for GPIO int

Jean-Nicolas Graux (1):
      ARM: ux500: add STM pin configuration

Jingoo Han (1):
      gpio: samsung: use pr_* instead of printk

Jorgen Jonsson (1):
      ARM: ux500: fixup magnetometer pins

Linus Walleij (2):
      ARM: ux500: delete duplicate macro
      ARM: ux500: fix pin warning

Olof Johansson (1):
      Merge branch 'next/gpio-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers

Patrice Chotard (6):
      ARM: ux500: 8500: register LCD VSI pinctrl table
      ARM: ux500: 8500: add IDLE pin configuration for SPI
      ARM: ux500: 8500: update SKE keypad pinctrl table
      ARM: ux500: 8500: define SDI sleep states
      ARM: ux500: cosmetic fixups for uart0
      ARM: ux500: 8500: add pinctrl support for uart1 and uart2

Pawel Moll (2):
      hwmon: Versatile Express hwmon driver
      ARM: vexpress: Reset driver

Tony Lindgren (1):
      Merge tag 'gpmc-generic-timing' of git://gitorious.org/x0148406-public/linux-kernel into omap-for-v3.8/gpmc


 Documentation/bus-devices/ti-gpmc.txt           | 122 ++++++
 .../devicetree/bindings/hwmon/vexpress.txt      |  23 +
 Documentation/hwmon/vexpress                    |  34 ++
 arch/arm/mach-omap2/gpmc-nand.c                 |  26 +-
 arch/arm/mach-omap2/gpmc-onenand.c              | 143 ++-----
 arch/arm/mach-omap2/gpmc-smc91x.c               |  43 +-
 arch/arm/mach-omap2/gpmc.c                      | 373 ++++++++++++++++
 arch/arm/mach-omap2/gpmc.h                      | 113 ++++-
 arch/arm/mach-omap2/usb-tusb6010.c              | 181 ++------
 arch/arm/mach-ux500/board-mop500-pins.c         | 425 ++++++++++++++++---
 arch/arm/mach-vexpress/reset.c                  | 141 ++++++
 arch/arm/plat-samsung/include/plat/gpio-core.h  |   2 +
 arch/arm/plat-samsung/s5p-irq-gpioint.c         |   8 +-
 drivers/gpio/gpio-samsung.c                     |  25 +-
 drivers/hwmon/Kconfig                           |   8 +
 drivers/hwmon/Makefile                          |   1 +
 drivers/hwmon/vexpress.c                        | 229 ++++++++++
 17 files changed, 1525 insertions(+), 372 deletions(-)
 create mode 100644 Documentation/bus-devices/ti-gpmc.txt
 create mode 100644 Documentation/devicetree/bindings/hwmon/vexpress.txt
 create mode 100644 Documentation/hwmon/vexpress
 create mode 100644 arch/arm/mach-vexpress/reset.c
 create mode 100644 drivers/hwmon/vexpress.c
