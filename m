Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab2AIWOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:14:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54888 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235Ab2AIWOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:14:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 04/11] Cleanups for the Samsung platforms
Date: Mon,  9 Jan 2012 22:12:44 +0000
Message-Id: <1326147171-13752-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326147171-13752-1-git-send-email-arnd@arndb.de>
References: <1326147171-13752-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:SgbJp+YxL6PsRqkJQJgrQJTfENqUS+rn8KnCJu04quo
 dYvGyTbHDhK6al9Ivjx+ZWP39m1Gd+9FBbBKGsdFIpVwfnrkdu
 RV/fc4S35iEAigx30CwXI337wEWuwsteBlAYVmFUk62KAb/N9L
 V5ukyHkHdEuZtvpsK6EyH8oAfKi/ENVjg61NOAubkXG7hIEkVz
 yPoTsl0tsJtALGEX1HLGLLTVtGMLm35zxld4pzxk2vCAygGKkB
 NhTMHkswRxEr1HDA/+Br1HA14/88/4Arro2XpBFC17ggQM8bHb
 jgnKgdx2i7x1MfsYCrm0LrPC2gLgYIhmG7X3McTcQYLnGeEWXk
 fOJFCDRCynePfREZpBFowRoUZ+xbjSWASTurqXAbq5HIcMkftX
 MFXC5S5Id1Vig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various cleanup changes that the device driver changes are built upon.
Since the samsung cleanups depend on the device tree series, which
depends on the first set of cleanups for tegra.

The following changes since commit b65d96b917d83121088fc7d314f919efb8f232ce:

  Merge branch 'next/dt' into for-next3 (2012-01-09 16:47:40 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git next/cleanup2

Arnd Bergmann (6):
      Merge branch 'next-samsung-cleanup-mmc2' of git://git.kernel.org/.../kgene/linux-samsung into samsung/cleanup
      Merge branch 'next-samsung-devel-spi3' of git://git.kernel.org/.../kgene/linux-samsung into samsung/cleanup
      Merge branch 'next-samsung-cleanup-spi4' of git://git.kernel.org/.../kgene/linux-samsung into samsung/cleanup
      Merge branch 'samsung/cleanup' into next/cleanup2
      Merge branch 'samsung/dt' into samsung/cleanup
      Merge branch 'samsung/cleanup' into next/cleanup2

Jingoo Han (2):
      ARM: S5PV210: Use gpio_request_one
      ARM: EXYNOS: Use gpio_request_one

Olof Johansson (2):
      Merge branch 'next-samsung-cleanup-samsung' of git://git.kernel.org/.../kgene/linux-samsung into samsung/cleanup
      Merge branch 'samsung/cleanup' into next/cleanup2

Padmavathi Venna (12):
      spi/s3c64xx: Use bus clocks created using clkdev
      ARM: S3C64XX: Add SPI clkdev support
      ARM: S5PC100: Add SPI clkdev support
      ARM: S5P64X0: Add SPI clkdev support
      ARM: S5PV210: Add SPI clkdev support
      ARM: SAMSUNG: Remove SPI bus clocks from platform data
      ARM: SAMSUNG: Consolidation of SPI platform devices to plat-samsung
      ARM: S3C64XX: Modified files for SPI consolidation work
      ARM: S5PC100: Modified files for SPI consolidation work
      ARM: S5P64X0: Modified files for SPI consolidation work
      ARM: S5PV210: Modified files for SPI consolidation work
      ARM: S3C64XX: Modified according to SPI consolidation work

Rajeshwari Shinde (3):
      ARM: SAMSUNG: Remove SDHCI bus clocks from platform data
      ARM: SAMSUNG: Add lookup of sdhci-s3c clocks using generic names
      mmc: sdhci-s3c: Use generic clock names for sdhci bus clock options

Shawn Guo (1):
      ARM: EXYNOS: remove exynos4_scu_enable()

Thomas Meyer (1):
      ARM: SAMSUNG: Use kmemdup rather than duplicating its implementation

 arch/arm/mach-exynos/Makefile                    |    1 -
 arch/arm/mach-exynos/clock.c                     |   88 +++++---
 arch/arm/mach-exynos/mach-nuri.c                 |    9 +-
 arch/arm/mach-exynos/mach-smdkv310.c             |    4 +-
 arch/arm/mach-exynos/mach-universal_c210.c       |   10 +-
 arch/arm/mach-exynos/pm.c                        |   24 +--
 arch/arm/mach-exynos/setup-sdhci.c               |   22 --
 arch/arm/mach-s3c2416/Makefile                   |    1 -
 arch/arm/mach-s3c2416/clock.c                    |   68 +++---
 arch/arm/mach-s3c2416/setup-sdhci.c              |   24 --
 arch/arm/mach-s3c64xx/Kconfig                    |    8 +-
 arch/arm/mach-s3c64xx/Makefile                   |    2 +-
 arch/arm/mach-s3c64xx/clock.c                    |  206 +++++++++++-------
 arch/arm/mach-s3c64xx/dev-spi.c                  |  180 ---------------
 arch/arm/mach-s3c64xx/include/mach/map.h         |    2 +
 arch/arm/mach-s3c64xx/setup-sdhci.c              |   24 --
 arch/arm/mach-s3c64xx/setup-spi.c                |   45 ++++
 arch/arm/mach-s5p64x0/Kconfig                    |    7 +-
 arch/arm/mach-s5p64x0/Makefile                   |    2 +-
 arch/arm/mach-s5p64x0/clock-s5p6440.c            |   61 +++---
 arch/arm/mach-s5p64x0/clock-s5p6450.c            |   49 +++--
 arch/arm/mach-s5p64x0/dev-spi.c                  |  224 -------------------
 arch/arm/mach-s5p64x0/include/mach/map.h         |    2 +
 arch/arm/mach-s5p64x0/setup-spi.c                |   55 +++++
 arch/arm/mach-s5pc100/Kconfig                    |    5 +
 arch/arm/mach-s5pc100/Makefile                   |    3 +-
 arch/arm/mach-s5pc100/clock.c                    |  254 +++++++++++++---------
 arch/arm/mach-s5pc100/dev-spi.c                  |  227 -------------------
 arch/arm/mach-s5pc100/include/mach/map.h         |    3 +
 arch/arm/mach-s5pc100/setup-sdhci.c              |   23 --
 arch/arm/mach-s5pc100/setup-spi.c                |   65 ++++++
 arch/arm/mach-s5pv210/Kconfig                    |    5 +
 arch/arm/mach-s5pv210/Makefile                   |    3 +-
 arch/arm/mach-s5pv210/clock.c                    |  217 +++++++++++-------
 arch/arm/mach-s5pv210/dev-spi.c                  |  175 ---------------
 arch/arm/mach-s5pv210/include/mach/map.h         |    2 +
 arch/arm/mach-s5pv210/mach-aquila.c              |    3 +-
 arch/arm/mach-s5pv210/mach-goni.c                |    6 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c            |   10 +-
 arch/arm/mach-s5pv210/setup-sdhci.c              |   22 --
 arch/arm/mach-s5pv210/setup-spi.c                |   51 +++++
 arch/arm/plat-s3c24xx/dma.c                      |    3 +-
 arch/arm/plat-s3c24xx/s3c2443-clock.c            |   16 +-
 arch/arm/plat-samsung/Kconfig                    |   16 ++-
 arch/arm/plat-samsung/devs.c                     |  127 +++++++++++
 arch/arm/plat-samsung/include/plat/devs.h        |    8 +-
 arch/arm/plat-samsung/include/plat/s3c64xx-spi.h |   24 ++-
 arch/arm/plat-samsung/include/plat/sdhci.h       |   31 ---
 drivers/mmc/host/sdhci-s3c.c                     |    7 +-
 drivers/spi/spi-s3c64xx.c                        |   14 +-
 50 files changed, 1000 insertions(+), 1438 deletions(-)
