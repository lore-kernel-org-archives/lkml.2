Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab2C1HOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:14:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52214 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab2C1HOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:14:42 -0400
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 3/5] ARM: More SoC support updates
Date: Wed, 28 Mar 2012 00:14:00 -0700
Message-Id: <1332918842-13521-4-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.9.2.359.gebfc2
In-Reply-To: <1332918842-13521-1-git-send-email-olof@lixom.net>
References: <1332918842-13521-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This branch contains a handful of updates of SoC base code that had
dependencies on other external trees that have now been merged:

* Support for the new EXYNOS5250 SoC from Samsung
* SMP and power domain support for Tegra3 from NVIDIA
* ux500 updates for exporting SoC information through sysfs


A few context merge conflicts:

arch/arm/mach-tegra/Makefile: localtimer.o was split off to a separate
config option, and later removed.

arch/arm/mach-ux500/Kconfig: Rename of the first machine model conflicts 
with addition of select SOC_BUS. Keep MACH_MOP500 and move up the select
SOC_BUS to be included in it.


-Olof


----------------------------------------------------------------

The following changes since commit b806d29eefb520f087e03b58131e686ea320985f:

  Merge tag 'drivers2' into for-next

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc2

for you to fetch changes up to 83fe628e16d84efc8df2731bc403eae4e4f53801:

  Merge branch 'renesas/soc' into next/soc2

----------------------------------------------------------------

Arnd Bergmann (9):
      Merge branch 'depends/driver-core' into next/soc2
      Merge branch 'ux500/soc' into next/soc2
      Merge tag 'tegra-soc2' of git://git.kernel.org/.../olof/tegra into tegra/soc2
      Merge branch 'next/soc-exynos5250-arch' of git://git.kernel.org/.../kgene/linux-samsung into samsung/exynos5
      Merge branch 'for-armsoc' of http://ftp.arm.linux.org.uk/pub/linux/arm/kernel/git-cur/linux-2.6-arm into next/soc2
      Merge branch 'samsung/exynos5' into next/soc2
      Merge branch 'samsung/soc' into next/soc2
      Merge branch 'rmobile-fixes-for-linus' of git://github.com/pmundt/linux-sh into renesas/soc
      Merge branch 'renesas/soc' into next/soc2

Eunki Kim (1):
      ARM: EXYNOS: support EINT for EXYNOS4 and EXYNOS5

Kukjin Kim (11):
      ARM: EXYNOS: to declare static for mach-exynos/common.c
      ARM: EXYNOS: use exynos_init_uarts() instead of exynos4_init_uarts()
      ARM: EXYNOS: add clock part for EXYNOS5250 SoC
      ARM: EXYNOS: add initial setup-i2c0 for EXYNOS5
      ARM: EXYNOS: add support uart for EXYNOS4 and EXYNOS5
      ARM: EXYNOS: add support for EXYNOS5250 SoC
      ARM: EXYNOS: add interrupt definitions for EXYNOS5250
      ARM: EXYNOS: add support get_core_count() for EXYNOS5250
      ARM: EXYNOS: add support ARCH_EXYNOS5 for EXYNOS5 SoCs
      ARM: EXYNOS: add support device tree enabled board file for EXYNOS5
      ARM: dts: add initial dts file for EXYNOS5250, SMDK5250

Kuninori Morimoto (1):
      ARM: mach-shmobile: ap4evb: Reserve DMA memory for the frame buffer

Lee Jones (4):
      ARM: ux500: pass parent pointer to each platform device
      ARM: ux500: export System-on-Chip information ux500 via sysfs
      ARM: ux500: move top level platform devices in sysfs to /sys/devices/socX
      ARM: ux500: remove intermediary add_platform_device* functions

Olof Johansson (2):
      Merge branch 'for-3.4/soc' into for-3.4/t30-smp
      Merge branch 'for-3.4/soc-drivers' into for-3.4/t30-smp

Peter De Schrijver (10):
      ARM: tegra: cleanup use of chipid register
      ARM: tegra: export Tegra chipid
      ARM: tegra: initialize Tegra chipid early
      ARM: tegra: functions to access the flowcontroller
      ARM: tegra: rework Tegra secondary CPU core bringup
      ARM: tegra: prepare powergate.c for multiple variants
      ARM: tegra: export tegra_powergate_is_powered()
      ARM: tegra: add support for Tegra30 powerdomains
      ARM: tegra: support for Tegra30 CPU powerdomains
      ARM: tegra: support for secondary cores on Tegra30

Stephen Warren (1):
      ARM: dt: Explicitly configure all serial ports on Tegra Cardhu

Tushar Behera (2):
      ARM: EXYNOS: Add clkdev lookup entry for lcd clock
      ARM: EXYNOS: Fix compilation error with mach-exynos4-dt board


 arch/arm/Makefile                               |    1 +
 arch/arm/boot/dts/exynos5250-smdk5250.dts       |   26 +
 arch/arm/boot/dts/exynos5250.dtsi               |  413 ++++++
 arch/arm/boot/dts/tegra-cardhu.dts              |   16 +
 arch/arm/mach-exynos/Kconfig                    |   29 +-
 arch/arm/mach-exynos/Makefile                   |    5 +-
 arch/arm/mach-exynos/clock-exynos4.c            |   14 +-
 arch/arm/mach-exynos/clock-exynos5.c            | 1247 ++++++++++++++++++
 arch/arm/mach-exynos/common.c                   |  449 +++++--
 arch/arm/mach-exynos/common.h                   |   37 +-
 arch/arm/mach-exynos/dev-ahci.c                 |    4 +-
 arch/arm/mach-exynos/dev-audio.c                |    4 +-
 arch/arm/mach-exynos/dev-uart.c                 |   78 ++
 arch/arm/mach-exynos/dma.c                      |    6 +-
 arch/arm/mach-exynos/include/mach/debug-macro.S |    9 +-
 arch/arm/mach-exynos/include/mach/irqs.h        |  597 ++++++---
 arch/arm/mach-exynos/include/mach/map.h         |   41 +-
 arch/arm/mach-exynos/include/mach/regs-clock.h  |   62 +
 arch/arm/mach-exynos/include/mach/regs-gpio.h   |   20 +-
 arch/arm/mach-exynos/include/mach/regs-pmu.h    |    1 +
 arch/arm/mach-exynos/include/mach/uncompress.h  |   17 +-
 arch/arm/mach-exynos/mach-exynos4-dt.c          |    8 +-
 arch/arm/mach-exynos/mach-exynos5-dt.c          |   78 ++
 arch/arm/mach-exynos/mct.c                      |   23 +-
 arch/arm/mach-exynos/platsmp.c                  |    9 +-
 arch/arm/mach-exynos/setup-i2c0.c               |    9 +-
 arch/arm/mach-shmobile/board-ap4evb.c           |    1 +
 arch/arm/mach-shmobile/board-mackerel.c         |   11 +-
 arch/arm/mach-shmobile/setup-sh7372.c           |    7 +
 arch/arm/mach-tegra/Makefile                    |    2 +
 arch/arm/mach-tegra/board-dt-tegra30.c          |    2 +-
 arch/arm/mach-tegra/common.c                    |    4 +
 arch/arm/mach-tegra/flowctrl.c                  |   62 +
 arch/arm/mach-tegra/flowctrl.h                  |    5 +
 arch/arm/mach-tegra/fuse.c                      |   18 +-
 arch/arm/mach-tegra/fuse.h                      |    4 +
 arch/arm/mach-tegra/headsmp.S                   |  167 ++-
 arch/arm/mach-tegra/include/mach/iomap.h        |    3 +
 arch/arm/mach-tegra/include/mach/powergate.h    |   15 +-
 arch/arm/mach-tegra/platsmp.c                   |  137 +-
 arch/arm/mach-tegra/powergate.c                 |   53 +-
 arch/arm/mach-tegra/reset.c                     |   84 ++
 arch/arm/mach-tegra/reset.h                     |   50 +
 arch/arm/mach-ux500/Kconfig                     |    1 +
 arch/arm/mach-ux500/board-mop500-sdi.c          |   31 +-
 arch/arm/mach-ux500/board-mop500.c              |   74 +-
 arch/arm/mach-ux500/board-mop500.h              |    8 +-
 arch/arm/mach-ux500/board-u5500-sdi.c           |    4 +-
 arch/arm/mach-ux500/board-u5500.c               |   27 +-
 arch/arm/mach-ux500/cpu-db5500.c                |   36 +-
 arch/arm/mach-ux500/cpu-db8500.c                |   44 +-
 arch/arm/mach-ux500/cpu.c                       |   75 ++
 arch/arm/mach-ux500/devices-common.c            |   79 +-
 arch/arm/mach-ux500/devices-common.h            |   83 +-
 arch/arm/mach-ux500/devices-db5500.h            |  116 +-
 arch/arm/mach-ux500/devices-db8500.h            |  176 +--
 arch/arm/mach-ux500/dma-db5500.c                |    3 +-
 arch/arm/mach-ux500/include/mach/db8500-regs.h  |    3 +
 arch/arm/mach-ux500/include/mach/setup.h        |   10 +-
 arch/arm/mach-ux500/include/mach/usb.h          |    4 +-
 arch/arm/mach-ux500/usb.c                       |    7 +-
 arch/arm/plat-s5p/Kconfig                       |    8 +-
 arch/arm/plat-s5p/Makefile                      |    3 +-
 arch/arm/plat-s5p/clock.c                       |   36 +
 arch/arm/plat-s5p/irq-pm.c                      |   25 +-
 arch/arm/plat-samsung/include/plat/cpu.h        |   10 +
 arch/arm/plat-samsung/include/plat/devs.h       |    2 +
 arch/arm/plat-samsung/include/plat/s5p-clock.h  |    6 +
 arch/arm/plat-samsung/include/plat/uncompress.h |    2 +
 arch/arm/plat-samsung/irq-vic-timer.c           |   16 +
 70 files changed, 3998 insertions(+), 719 deletions(-)
 create mode 100644 arch/arm/boot/dts/exynos5250-smdk5250.dts
 create mode 100644 arch/arm/boot/dts/exynos5250.dtsi
 create mode 100644 arch/arm/mach-exynos/clock-exynos5.c
 create mode 100644 arch/arm/mach-exynos/dev-uart.c
 create mode 100644 arch/arm/mach-exynos/mach-exynos5-dt.c
 create mode 100644 arch/arm/mach-tegra/flowctrl.c
 create mode 100644 arch/arm/mach-tegra/reset.c
 create mode 100644 arch/arm/mach-tegra/reset.h
