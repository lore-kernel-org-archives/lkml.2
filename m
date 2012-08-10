Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936Ab2HJTGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 15:06:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62482 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab2HJTGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 15:06:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 1/3] arm-soc: bug fixes for v3.6-rc2
Date: Fri, 10 Aug 2012 21:06:13 +0200
Message-Id: <1344625575-27560-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344625575-27560-1-git-send-email-arnd@arndb.de>
References: <1344625575-27560-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:u4TBp8D35kVH2lT2QGSY6yk1U7psRvo52+lHwUQ+IuY
 VQvlpZbAjSgw7Jo8c8UM8IWMPCdHytYRKKi0MU3Hg/2SxC/Hhw
 DfWGDoLP62hcz4ySW6cxcatclSPHG50Lj9NlfyGy4inp43RFa4
 WeDortJgZciilT/57w7NAb0BuJkRYts4Jf5rrEFObBq9ES1U1r
 aRAISYb+aZ/IwMSOCJanDBlzMxt7iFnyO7ZyyYuMs3e2pPctRy
 eGEXOe8lgl9EKjMqr4ivXgQL8C/YMVLgs2YhBoGAY8YewKNDkl
 CAy2DMBRUBI8dJ1t9Z+lgCXAkXq/x5d9CKVLOPq0gGHf7tJLNh
 p/l8zxsqBGvyDyNj+V7N7kxM7RM4CJlXOfTcc/4rc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to de9234306bb28fe6c8c3bb908e3f9956f5276a02:

  ARM: davinci: remove broken ntosd2_init_i2c (2012-08-10 13:14:36 +0200)

----------------------------------------------------------------
arm-soc: bug fixes for v3.6-rc2

These are a bunch of bug fixes that came in after the merge window and
one update for the MAINTAINERS file. The largest part of the fixes
are patches that address bugs found by building all the ARM defconfig
files. There are a lot more warnings that we have patches for, but
the others are either still under discussion or are harmless and
do not cause actual problems besides making the build slightly noisy.

----------------------------------------------------------------
Arnd Bergmann (19):
      Merge branch 'imx/fixes-for-3.6' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge branch 'mxs/fixes-for-3.6' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'imx-fixes' of git://git.pengutronix.de/git/imx/linux-2.6 into fixes
      mfd/asic3: fix asic3_mfd_probe return value
      usb/ohci-omap: remove unused variable
      ARM: pxa: remove irq_to_gpio from ezx-pcap driver
      Input: eeti_ts: pass gpio value instead of IRQ
      ARM: sa1100: include linux/io.h in hackkit leds code
      ARM: s3c24xx: use new PWM driver
      ARM: integrator: include <linux/export.h>
      ARM: imx: gpmi-nand depends on mxs-dma
      ARM: exynos: exynos_pm_add_dev_to_genpd may be unused
      gpio: em: do not discard em_gio_irq_domain_cleanup
      mtd/omap2: fix dmaengine_slave_config error handling
      spi/s3c64xx: improve error handling
      omap-rng: fix use of SIMPLE_DEV_PM_OPS
      Merge branch 'testing/new-warnings' into fixes
      ARM: s3c24xx: enable CONFIG_BUG for tct_hammer
      ARM: davinci: remove broken ntosd2_init_i2c

Fabio Estevam (5):
      ARM: dts: imx27-3ds.dts: Fix serial console node
      ARM: imx6q-sabrelite: Setup CLKO IOMUX
      ARM: mx23: Fix registers range
      ARM: mx28: Fix registers range
      ARM: clk-imx31: Fix the keypad clock name

Javier Martin (1):
      i.MX27: Fix emma-prp and csi clocks.

Linus Walleij (2):
      MAINTAINERS: update entry for Linus Walleij
      ARM: integrator: use clk_prepare_enable() for timer

Marc Kleine-Budde (1):
      ARM: mxs: always build ocotp

Marek Vasut (1):
      ARM: mxs: Remove MMAP_MIN_ADDR setting from mxs_defconfig

Sebastian Hesselbarth (1):
      ARM: kirkwood: fix typo in Makefile.boot

Shawn Guo (3):
      ARM: imx: enable emi_slow_gate clock for imx5
      ARM: dts: imx53-ard: add regulators for lan9220
      ARM: dts: imx: fix gpio interrupts property

Stephen Warren (1):
      ARM: tegra: more regulator fixes for Harmony

 MAINTAINERS                               |   17 ++++---
 arch/arm/boot/dts/imx23.dtsi              |   52 ++++++++++----------
 arch/arm/boot/dts/imx27-3ds.dts           |    2 +-
 arch/arm/boot/dts/imx28.dtsi              |   74 ++++++++++++++---------------
 arch/arm/boot/dts/imx51-babbage.dts       |    2 +-
 arch/arm/boot/dts/imx53-ard.dts           |   22 ++++++++-
 arch/arm/boot/dts/imx6q-sabrelite.dts     |    1 +
 arch/arm/configs/imx_v6_v7_defconfig      |    1 +
 arch/arm/configs/mxs_defconfig            |    1 -
 arch/arm/configs/tct_hammer_defconfig     |    2 +-
 arch/arm/mach-davinci/board-neuros-osd2.c |   39 ---------------
 arch/arm/mach-exynos/pm_domains.c         |    2 +-
 arch/arm/mach-imx/clk-imx27.c             |    8 ++--
 arch/arm/mach-imx/clk-imx31.c             |    2 +-
 arch/arm/mach-imx/clk-imx51-imx53.c       |    1 +
 arch/arm/mach-integrator/core.c           |    1 +
 arch/arm/mach-integrator/integrator_ap.c  |    2 +-
 arch/arm/mach-kirkwood/Makefile.boot      |    4 +-
 arch/arm/mach-mxs/Kconfig                 |    6 ---
 arch/arm/mach-mxs/Makefile                |    3 +-
 arch/arm/mach-pxa/raumfeld.c              |    2 +-
 arch/arm/mach-s3c24xx/Kconfig             |    4 +-
 arch/arm/mach-sa1100/leds-hackkit.c       |    1 +
 arch/arm/mach-tegra/board-harmony-power.c |   32 +++++++------
 arch/arm/plat-samsung/Kconfig             |    3 +-
 drivers/char/hw_random/omap-rng.c         |    2 +-
 drivers/gpio/gpio-em.c                    |    2 +-
 drivers/input/touchscreen/eeti_ts.c       |   21 ++++----
 drivers/mfd/asic3.c                       |    1 +
 drivers/mfd/ezx-pcap.c                    |    2 +-
 drivers/mtd/nand/Kconfig                  |    2 +-
 drivers/mtd/nand/omap2.c                  |    7 ++-
 drivers/spi/spi-s3c64xx.c                 |    2 +-
 drivers/usb/host/ohci-omap.c              |    2 -
 include/linux/input/eeti_ts.h             |    1 +
 include/linux/mfd/ezx-pcap.h              |    1 +
 36 files changed, 160 insertions(+), 167 deletions(-)
