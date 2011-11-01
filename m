Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab1KBCW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:22:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51857 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab1KBCW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:22:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 1/13] arm-soc bug fixes
Date: Tue, 1 Nov 2011 04:01:17 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201111010348.13214.arnd@arndb.de>
In-Reply-To: <201111010348.13214.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111010401.17220.arnd@arndb.de>
X-Provags-ID: V02:K0:y2dC7tEFHQ+GI7mxNeea0TQ8rIwtpbiY84SW0g5OfVC
 jBtUr4P1/6c5ZlV+W8b6xIdrCa2LS3Zk/WavxQOher49c9d74m
 BmNEduXT9vaHf6BIm3MttZ3vZTkkyjdn3Xm+ufRUJrAd9DdqjE
 P7OiqsK3N3p8Tc7i3gc0kBEXI1Q0fqgcywyUp40WQn4R5LGt8P
 xdbQaatMX874lU4ty3zviZlOOhm64N3YLI+aagUKOta83/o2lU
 eyrhcK3kdfuJAkfEDyydLvEeaGnT5q09yTpHs7pTCJTur2jQqc
 ogN9tqnHMPd789+VVqcVs+FWnuI8wx+OtmatpOybJDdz/JZBhq
 vkyXsQvzMMAb9Nzu7bw4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bug fixes all over the places. These were mostly too minor to have
in the late 3.1 cycle, so I'm submitting them here. A part of this is
the initial set of 'randconfig' fixes, many more of these will come
in the future since I have over 100 trivial patches queued up in this
area. I'm planning to pick the important ones, plus any build regressions
and submit them after 3.2-rc1, but sorting through the large series will
take more time.

	Arnd

The following changes since commit 839d8810747bbf39e0a5a7f223b67bffa7945f8d:

  Merge branch 'i2c-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging (2011-10-30 15:54:59 -0700)

are available in the git repository at:

  git://git.linaro.org/people/arnd/arm-soc.git next/fixes
Arnaud Patard (2):
      MX5: fix clock usage
      ARM: mx5: fix clock usage for suspend

Arnd Bergmann (17):
      Merge branch 'tegra/fixes' into next/fixes
      Merge branch 'omap/fixes' into fixes
      ARM: pxa: make zylonite_pxa*_init declaration match code
      ARM: pxa: export symbols from pxa3xx-ulpi
      ARM: pxa: allow selecting just one of TREO680/CENTRO
      ARM: pxa: CPU_FREQ_TABLE is needed for CPU_FREQ
      ARM: pxa: pxa95x is incompatible with earlier pxa
      ARM: pxa: select POWER_SUPPLY on raumfeld
      ARM: pxa: centro and treo680 need palm27x
      ARM: pxa: sharpsl pm needs SPI
      ARM: pxa: use correct __iomem annotations
      Merge branch 'imx/fixes' into next/fixes
      Merge branch 'fixes' into next/fixes
      Merge branch 'imx/fixes' into next/fixes
      Merge branch 'pxa/fixes' into next/fixes
      Merge branch 'depends/rmk/gpio' into next/fixes
      Merge branch 'depends/rmk/memory_h' into next/fixes

Axel Lin (1):
      ARM: pxa/cm-x300: properly set bt_reset pin

Bjarne Steinsbo (1):
      ARM: OMAP4: Keyboard: Fix section mismatch in the board file

Eric Miao (5):
      ARM: pxa: fix building error by palm27x_lcd_init() when FB_PXA not defined
      ARM: pxa/z2: fix building error of pxa27x_cpu_suspend() no longer available
      ARM: pxa: pxa95x/saarb depends on pxa3xx code
      ARM: pxa: make pxafb_smart_*() empty when not enabled
      ARM: mmp: rename SHEEVAD to GPLUGD

Fabio Estevam (1):
      ARM: mx31pdk: Fix build by passing IMX_HAVE_PLATFORM_MXC_MMC

Linus Walleij (1):
      ARM: mach-ux500: unlock I&D l2x0 caches before init

Matt Burtch (1):
      ARM: i.MX28: shift frac value in _CLK_SET_RATE

Nicolas Ferre (2):
      ARM: at91: remove dependency for Atmel PWM driver selector in Kconfig
      ARM: at91: add defconfig for at91sam9g45 family

Paul Bolle (1):
      ARM: imx: Fix typo 'MACH_MX31_3DS_MXC_NAND_USE_BBT'

Paul Fertser (1):
      plat-mxc: iomux-v3.h: implicitly enable pull-up/down when that's desired

Stephen Warren (1):
      arm/dt: Tegra: Add support-8bit to SDHCI nodes

Tapani Utriainen (1):
      ARM: OMAP: irq: loop counter fix in omap_init_irq()

srinidhi kasagar (1):
      ARM: mach-ux500: enable fix for ARM errata 754322


 arch/arm/Kconfig                          |    3 +-
 arch/arm/boot/dts/tegra-harmony.dts       |    1 +
 arch/arm/boot/dts/tegra-seaboard.dts      |    4 +
 arch/arm/configs/at91sam9g45_defconfig    |  214 +++++++++++++++++++++++++++++
 arch/arm/include/asm/hardware/it8152.h    |    2 +-
 arch/arm/mach-imx/Kconfig                 |    1 +
 arch/arm/mach-imx/mach-mx31_3ds.c         |    2 +-
 arch/arm/mach-mmp/Kconfig                 |    2 +-
 arch/arm/mach-mmp/Makefile                |    2 +-
 arch/arm/mach-mmp/clock.h                 |    8 +-
 arch/arm/mach-mmp/common.c                |    4 +-
 arch/arm/mach-mmp/gplugd.c                |    2 +-
 arch/arm/mach-mmp/include/mach/addr-map.h |   10 +-
 arch/arm/mach-mmp/include/mach/gpio-pxa.h |    2 +-
 arch/arm/mach-mmp/mmp2.c                  |    3 +-
 arch/arm/mach-mx5/pm-imx5.c               |   15 ++-
 arch/arm/mach-mxs/clock-mx28.c            |    2 +-
 arch/arm/mach-omap2/board-4430sdp.c       |    2 +-
 arch/arm/mach-omap2/irq.c                 |    4 +-
 arch/arm/mach-pxa/Kconfig                 |   38 ++++--
 arch/arm/mach-pxa/Makefile                |    2 +-
 arch/arm/mach-pxa/balloon3.c              |   10 +-
 arch/arm/mach-pxa/cm-x2xx-pci.c           |    2 +-
 arch/arm/mach-pxa/cm-x2xx.c               |    4 +-
 arch/arm/mach-pxa/cm-x300.c               |    8 +-
 arch/arm/mach-pxa/include/mach/addr-map.h |    8 +-
 arch/arm/mach-pxa/include/mach/balloon3.h |    2 +-
 arch/arm/mach-pxa/include/mach/gpio-pxa.h |    2 +-
 arch/arm/mach-pxa/include/mach/hardware.h |    9 +-
 arch/arm/mach-pxa/include/mach/lpd270.h   |    4 +-
 arch/arm/mach-pxa/include/mach/mtd-xip.h  |    1 -
 arch/arm/mach-pxa/include/mach/palm27x.h  |    2 +-
 arch/arm/mach-pxa/include/mach/palmtx.h   |    6 +-
 arch/arm/mach-pxa/include/mach/pxa27x.h   |    2 +
 arch/arm/mach-pxa/include/mach/pxa95x.h   |    7 +
 arch/arm/mach-pxa/include/mach/pxafb.h    |   13 ++
 arch/arm/mach-pxa/include/mach/smemc.h    |    2 +-
 arch/arm/mach-pxa/include/mach/zeus.h     |    4 +-
 arch/arm/mach-pxa/include/mach/zylonite.h |    4 +-
 arch/arm/mach-pxa/irq.c                   |    4 +-
 arch/arm/mach-pxa/lpd270.c                |    2 +-
 arch/arm/mach-pxa/palmtreo.c              |    8 +
 arch/arm/mach-pxa/palmtx.c                |    8 +-
 arch/arm/mach-pxa/pxa25x.c                |    2 +-
 arch/arm/mach-pxa/pxa27x.c                |    2 +-
 arch/arm/mach-pxa/pxa3xx-ulpi.c           |    2 +
 arch/arm/mach-pxa/pxa3xx.c                |    2 +-
 arch/arm/mach-pxa/saarb.c                 |    1 +
 arch/arm/mach-pxa/z2.c                    |    3 +-
 arch/arm/mach-pxa/zeus.c                  |    8 +-
 arch/arm/mach-ux500/cpu.c                 |   25 ++++-
 arch/arm/plat-mxc/include/mach/iomux-v3.h |   10 +-
 arch/arm/plat-pxa/include/plat/mfp.h      |    2 +-
 arch/arm/plat-pxa/mfp.c                   |    4 +-
 drivers/gpio/gpio-pxa.c                   |    2 +-
 drivers/misc/Kconfig                      |    2 +-
 drivers/pcmcia/pxa2xx_balloon3.c          |    2 +-
 drivers/video/mbx/mbxfb.c                 |    6 +-
 drivers/video/pxafb.c                     |   10 --
 59 files changed, 410 insertions(+), 108 deletions(-)

