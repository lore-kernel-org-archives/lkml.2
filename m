Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab2EZHX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 03:23:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63447 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab2EZHXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 03:23:13 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 7/8] arm-soc: soc specific changes, part 2
Date: Sat, 26 May 2012 00:22:37 -0700
Message-Id: <1338016958-7887-8-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1338016958-7887-1-git-send-email-olof@lixom.net>
References: <1338016958-7887-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the spear13xx platform, which has first been under
review a long time ago and finally been completed after generic spear
work has gone into the clock, dt and pinctrl branches.

Also a number of updates for the samsung socs are part of this branch.

----------------------------------------------------------------

The following changes since commit 56e16c5e06b624d0ec7e958b212c368864a78504:

  Merge tag 'dt2' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc2

for you to fetch changes up to 820f3dd7964f1889baaaaa0c2ba45d05bb619f66:

  ARM: exynos: fix building with CONFIG_OF disabled

----------------------------------------------------------------

Arnd Bergmann (6):
      Merge branch 'spear/13xx' into next/soc2
      Merge branch 'exynos/iommu' into next/soc2
      Merge branch 'next/devel-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/soc2
      Merge branch 'samsung/cleanup-plat-s5p' into next/soc2
      Merge branch 'next/devel-exynos5250-1' of git://git.kernel.org/.../kgene/linux-samsung into next/soc2
      ARM: exynos: fix building with CONFIG_OF disabled

Boojin Kim (1):
      ARM: EXYNOS: Support DMA for EXYNOS5250 SoC

Changhwan Youn (2):
      ARM: EXYNOS: Modify the GIC physical address for static io-mapping
      ARM: EXYNOS: Redefine IRQ_MCT_L0,1 definition

Heiko Stuebner (6):
      ARM: S3C24XX: Add forgotten clock lookup table to S3C2443
      ARM: S3C24XX: claim spi channels for hsspi in dma-s3c2443
      ARM: S3C24XX: Add map entries needed by the s3c64xx-spi devices
      ARM: S3C24XX: Add clock-lookup entries required by s3c64xx-spi
      ARM: S3C24XX: Add HSSPI setup callback for s3c64xx-spi driver
      spi/s3c64xx: Allow usage for ARCH_S3C24XX

Inderpal Singh (1):
      ARM: EXYNOS: Support Suspend/Resume for EXYNOS4412

Kisoo Yu (1):
      ARM: EXYNOS: Add pre-divider and fout mux clocks for bpll and mpll

Kukjin Kim (4):
      Merge branch 'next/devel-samsung-iommu' into next/devel-samsung
      Merge branch 'next/devel-s3c24xx-hsspi' into next/devel-samsung
      Merge branch 'next/cleanup-plat-s5p' into next/devel-exynos5250-1
      ARM: EXYNOS: update irqs for EXYNOS5250 SoC

Kyoungil Kim (1):
      ARM: EXYNOS: To use common config for EXYNOS4 and EXYNOS5 SPI

Marek Szyprowski (1):
      ARM: EXYNOS: add platform device for core DRM subsystem

Olof Johansson (1):
      ARM: EXYNOS: add dts files to dtbs target

Sangsu Park (1):
      ARM: EXYNOS: add GPC4 bank instance

Sylwester Nawrocki (1):
      ARM: EXYNOS: Add platform resource definitions for FIMC-LITE

Thomas Abraham (6):
      ARM: EXYNOS: Add watchdog timer clock instance
      ARM: EXYNOS: Remove a new bus_type instance for EXYNOS5
      ARM: EXYNOS: Add irq_domain support for interrupt combiner
      ARM: EXYNOS: Add device tree support for interrupt combiner
      ARM: dts: Update device tree source files for EXYNOS5250
      ARM: EXYNOS: Add AUXDATA for i2c controllers

Viresh Kumar (10):
      SPEAr13xx: Add header files
      SPEAr13xx: Add source files
      SPEAr13xx: Add common clock framework support
      pinctrl: SPEAr: Create macro for declaring GPIO PINS
      pinctrl: Add SPEAr13xx pinctrl drivers
      SPEAr13xx: Add dts and dtsi files
      SPEAr13xx: Add compilation support
      SPEAr13xx: Add defconfig
      SPEAr: Update MAINTAINERS and Documentation
      pinctrl: SPEAr1310: Fix pin numbers for clcd_high_res


 Documentation/arm/SPEAr/overview.txt            |   32 +-
 .../bindings/arm/samsung/interrupt-combiner.txt |   52 +
 Documentation/devicetree/bindings/arm/spear.txt |   14 +-
 .../bindings/pinctrl/pinctrl_spear.txt          |   47 +
 MAINTAINERS                                     |   13 +
 arch/arm/Makefile                               |    2 +
 arch/arm/boot/dts/exynos5250-smdk5250.dts       |   48 +
 arch/arm/boot/dts/exynos5250.dtsi               |   60 +-
 arch/arm/boot/dts/spear1310-evb.dts             |  292 +++
 arch/arm/boot/dts/spear1310.dtsi                |  184 ++
 arch/arm/boot/dts/spear1340-evb.dts             |  308 +++
 arch/arm/boot/dts/spear1340.dtsi                |   56 +
 arch/arm/boot/dts/spear13xx.dtsi                |  262 +++
 arch/arm/configs/spear13xx_defconfig            |   95 +
 arch/arm/mach-exynos/Kconfig                    |   14 +-
 arch/arm/mach-exynos/Makefile                   |    7 +-
 arch/arm/mach-exynos/Makefile.boot              |    3 +
 arch/arm/mach-exynos/clock-exynos4212.c         |   10 +
 arch/arm/mach-exynos/clock-exynos5.c            |   51 +-
 arch/arm/mach-exynos/common.c                   |  182 +-
 arch/arm/mach-exynos/dev-drm.c                  |   29 +
 arch/arm/mach-exynos/dma.c                      |  141 +-
 arch/arm/mach-exynos/include/mach/gpio.h        |    9 +-
 arch/arm/mach-exynos/include/mach/irqs.h        |   40 +-
 arch/arm/mach-exynos/include/mach/map.h         |    7 +-
 arch/arm/mach-exynos/include/mach/regs-clock.h  |    2 +
 arch/arm/mach-exynos/include/mach/regs-pmu.h    |   10 +-
 arch/arm/mach-exynos/include/mach/spi-clocks.h  |    2 +-
 arch/arm/mach-exynos/mach-exynos5-dt.c          |    4 +
 arch/arm/mach-exynos/mct.c                      |   17 +-
 arch/arm/mach-exynos/pm.c                       |    4 +-
 arch/arm/mach-exynos/pmu.c                      |   24 +-
 arch/arm/mach-s3c24xx/Kconfig                   |    5 +
 arch/arm/mach-s3c24xx/Makefile                  |    1 +
 arch/arm/mach-s3c24xx/clock-s3c2416.c           |    1 +
 arch/arm/mach-s3c24xx/clock-s3c2443.c           |    6 +
 arch/arm/mach-s3c24xx/common-s3c2443.c          |   15 +-
 arch/arm/mach-s3c24xx/dma-s3c2443.c             |   16 +-
 arch/arm/mach-s3c24xx/include/mach/dma.h        |    4 +
 arch/arm/mach-s3c24xx/include/mach/map.h        |    5 +
 arch/arm/mach-s3c24xx/setup-spi.c               |   39 +
 arch/arm/mach-spear13xx/Kconfig                 |   20 +
 arch/arm/mach-spear13xx/Makefile                |   10 +
 arch/arm/mach-spear13xx/Makefile.boot           |    6 +
 arch/arm/mach-spear13xx/headsmp.S               |   47 +
 arch/arm/mach-spear13xx/hotplug.c               |  119 +
 .../mach-spear13xx/include/mach/debug-macro.S   |   14 +
 arch/arm/mach-spear13xx/include/mach/dma.h      |  128 +
 arch/arm/mach-spear13xx/include/mach/generic.h  |   49 +
 arch/arm/mach-spear13xx/include/mach/gpio.h     |   19 +
 arch/arm/mach-spear13xx/include/mach/hardware.h |    1 +
 arch/arm/mach-spear13xx/include/mach/irqs.h     |   20 +
 arch/arm/mach-spear13xx/include/mach/spear.h    |   62 +
 arch/arm/mach-spear13xx/include/mach/timex.h    |   19 +
 .../mach-spear13xx/include/mach/uncompress.h    |   19 +
 arch/arm/mach-spear13xx/platsmp.c               |  127 +
 arch/arm/mach-spear13xx/spear1310.c             |   88 +
 arch/arm/mach-spear13xx/spear1340.c             |  192 ++
 arch/arm/mach-spear13xx/spear13xx.c             |  197 ++
 arch/arm/plat-samsung/Kconfig                   |    2 +-
 arch/arm/plat-samsung/include/plat/cpu.h        |    2 +-
 arch/arm/plat-samsung/include/plat/devs.h       |    2 +
 arch/arm/plat-samsung/include/plat/dma-pl330.h  |    1 +
 arch/arm/plat-samsung/include/plat/s5p-clock.h  |    4 +
 arch/arm/plat-samsung/s5p-clock.c               |   30 +
 arch/arm/plat-spear/Kconfig                     |   12 +
 arch/arm/plat-spear/Makefile                    |    5 +-
 arch/arm/plat-spear/restart.c                   |    5 +
 drivers/clk/spear/Makefile                      |    2 +
 drivers/clk/spear/spear1310_clock.c             | 1106 +++++++++
 drivers/clk/spear/spear1340_clock.c             |  964 ++++++++
 drivers/gpio/gpio-samsung.c                     |   11 +-
 drivers/pinctrl/spear/Kconfig                   |   10 +
 drivers/pinctrl/spear/Makefile                  |    2 +
 drivers/pinctrl/spear/pinctrl-spear.h           |  251 ++
 drivers/pinctrl/spear/pinctrl-spear1310.c       | 2198 ++++++++++++++++++
 drivers/pinctrl/spear/pinctrl-spear1340.c       | 1989 ++++++++++++++++
 drivers/pinctrl/spear/pinctrl-spear3xx.c        |  103 +-
 drivers/spi/Kconfig                             |    2 +-
 79 files changed, 9648 insertions(+), 303 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/samsung/interrupt-combiner.txt
 create mode 100644 arch/arm/boot/dts/spear1310-evb.dts
 create mode 100644 arch/arm/boot/dts/spear1310.dtsi
 create mode 100644 arch/arm/boot/dts/spear1340-evb.dts
 create mode 100644 arch/arm/boot/dts/spear1340.dtsi
 create mode 100644 arch/arm/boot/dts/spear13xx.dtsi
 create mode 100644 arch/arm/configs/spear13xx_defconfig
 create mode 100644 arch/arm/mach-exynos/dev-drm.c
 create mode 100644 arch/arm/mach-s3c24xx/setup-spi.c
 create mode 100644 arch/arm/mach-spear13xx/Kconfig
 create mode 100644 arch/arm/mach-spear13xx/Makefile
 create mode 100644 arch/arm/mach-spear13xx/Makefile.boot
 create mode 100644 arch/arm/mach-spear13xx/headsmp.S
 create mode 100644 arch/arm/mach-spear13xx/hotplug.c
 create mode 100644 arch/arm/mach-spear13xx/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-spear13xx/include/mach/dma.h
 create mode 100644 arch/arm/mach-spear13xx/include/mach/generic.h
 create mode 100644 arch/arm/mach-spear13xx/include/mach/gpio.h
 create mode 100644 arch/arm/mach-spear13xx/include/mach/hardware.h
 create mode 100644 arch/arm/mach-spear13xx/include/mach/irqs.h
 create mode 100644 arch/arm/mach-spear13xx/include/mach/spear.h
 create mode 100644 arch/arm/mach-spear13xx/include/mach/spear1310_misc_regs.h
 create mode 100644 arch/arm/mach-spear13xx/include/mach/spear1340_misc_regs.h
 create mode 100644 arch/arm/mach-spear13xx/include/mach/timex.h
 create mode 100644 arch/arm/mach-spear13xx/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-spear13xx/platsmp.c
 create mode 100644 arch/arm/mach-spear13xx/spear1310.c
 create mode 100644 arch/arm/mach-spear13xx/spear1340.c
 create mode 100644 arch/arm/mach-spear13xx/spear13xx.c
 create mode 100644 drivers/clk/spear/spear1310_clock.c
 create mode 100644 drivers/clk/spear/spear1340_clock.c
 create mode 100644 drivers/pinctrl/spear/pinctrl-spear1310.c
 create mode 100644 drivers/pinctrl/spear/pinctrl-spear1340.c
