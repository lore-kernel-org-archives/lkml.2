Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab2C1HOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:14:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52214 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab2C1HOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:14:39 -0400
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 1/5] ARM: cleanups of io includes
Date: Wed, 28 Mar 2012 00:13:58 -0700
Message-Id: <1332918842-13521-2-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.9.2.359.gebfc2
In-Reply-To: <1332918842-13521-1-git-send-email-olof@lixom.net>
References: <1332918842-13521-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Herring has done a sweeping change cleaning up all of the mach/io.h includes,
moving some of the oft-repeated macros to a common location and removing a bunch of
boiler plate. This is another step closer to a common zImage for multiple platforms.


This branch has some context conflicts with current upstream contents:

arch/arm/Kconfig: New selects added for ARCH_S3C24X. Include both sides
of the merge.

arch/arm/mach-shmobile/smp-sh73a0.c: A readl vs readw fix collided with
the io accessor cleanup. Ditch the __io() use but keep readl.

arch/arm/mach-tegra/include/mach/debug-macro.S: include of mach/io.h is
going away, iomap.h is kept.


-Olof

----------------------------------------------------------------

The following changes since commit 6658a6991cef75719a21441aa0b7f8d6821534ee:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup2

for you to fetch changes up to 88b48684fe2d4f6207223423227c80d5408bccaf:

  Merge branch 'for-3.4/fixes-for-io-cleanup' of git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra into next/cleanup2

----------------------------------------------------------------

Arnd Bergmann (3):
      Merge branch 'cleanup' of git://git.kernel.org/.../tmlind/linux-omap into omap/cleanup
      Merge tag 'tegra-soc' of git://git.kernel.org/.../olof/tegra into tegra/soc
      Merge branch 'tegra/cleanups' into next/cleanup2

Olof Johansson (7):
      Merge branch 'io-cleanup-for-3.4' of git://sources.calxeda.com/kernel/linux into devel/io-cleanup
      Merge branch 'io-cleanup-for-3.4' of git://sources.calxeda.com/kernel/linux into next/cleanup2
      Merge branch 'io-cleanup-for-3.4' of git://sources.calxeda.com/kernel/linux into devel/io-cleanup
      Merge branch 'io-cleanup-for-3.4' of git://sources.calxeda.com/kernel/linux into next/cleanup2
      Merge branch 'io-cleanup-for-3.4' of git://sources.calxeda.com/kernel/linux into next/cleanup2
      Merge branch 'tegra/soc' into next/cleanup2
      Merge branch 'for-3.4/fixes-for-io-cleanup' of git://git.kernel.org/.../swarren/linux-tegra into next/cleanup2

Rob Herring (28):
      Merge remote-tracking branch 'arm-soc/at91/base2+cleanup' into cleanup-base
      usb: ohci-pxa27x: add explicit include of hardware.h
      ARM: provide runtime hook for ioremap/iounmap
      ARM: imx: convert to common runtime ioremap hook
      ARM: msm: use runtime ioremap hook
      ARM: iop13xx: use runtime ioremap hook
      ARM: ixp4xx: use runtime ioremap hook
      ARM: ebsa110: use runtime ioremap hook
      ARM: remove compile time __arch_ioremap/__arch_iounmap
      ARM: iop13xx: move io.h externs to pci.h
      ARM: msm: clean-up mach/io.h
      [media] davinci: remove includes of mach/io.h
      ARM: davinci: remove unneeded mach/io.h include
      ARM: orion5x: clean-up mach/io.h
      ARM: tegra: clean-up mach/io.h
      ARM: ep93xx: clean-up mach/io.h
      ARM: at91: add explicit include of hardware.h to uncompressor
      ARM: dove: add explicit include of dove.h to addr-map.c
      ARM: clps711x: remove unneeded include of mach/io.h
      ARM: make mach/io.h include optional
      ARM: remove bunch of now unused mach/io.h files
      ARM: kill off __mem_pci
      ARM: fix ioremap/iounmap for !CONFIG_MMU
      ARM: iop13xx: fix missing declaration of iop13xx_init_early
      ARM: create a common IOMEM definition
      ARM: __io abuse cleanup
      ARM: dma-mapping: convert ARCH_HAS_DMA_SET_COHERENT_MASK to kconfig symbol
      ARM: pxa: use common IOMEM definition

Stephen Warren (2):
      Merge remote branch 'remotes/korg_olof_tegra/for-3.4/soc' into for-3.4/fixes-for-io-cleanup
      ARM: tegra: Include assembler.h in sleep.S to fix build break

Tony Lindgren (1):
      ARM: OMAP: Remove remaining includes for mach/io.h


 arch/arm/Kconfig                                 |   27 +++++++
 arch/arm/include/asm/assembler.h                 |    2 +
 arch/arm/include/asm/io.h                        |   71 ++++++++---------
 arch/arm/kernel/debug.S                          |    1 +
 arch/arm/kernel/entry-armv.S                     |    1 +
 arch/arm/mach-at91/include/mach/io.h             |   31 -------
 arch/arm/mach-at91/include/mach/uncompress.h     |    1 +
 arch/arm/mach-bcmring/include/mach/io.h          |   33 --------
 arch/arm/mach-clps711x/include/mach/io.h         |   36 ---------
 arch/arm/mach-clps711x/include/mach/uncompress.h |    1 -
 arch/arm/mach-cns3xxx/core.c                     |    8 +-
 arch/arm/mach-cns3xxx/devices.c                  |    2 +-
 arch/arm/mach-cns3xxx/include/mach/io.h          |   17 ----
 arch/arm/mach-davinci/include/mach/entry-macro.S |    1 -
 arch/arm/mach-davinci/include/mach/hardware.h    |    6 --
 arch/arm/mach-davinci/include/mach/io.h          |   24 ------
 arch/arm/mach-davinci/include/mach/uncompress.h  |    2 +
 arch/arm/mach-dove/addr-map.c                    |    1 +
 arch/arm/mach-dove/include/mach/io.h             |    1 -
 arch/arm/mach-ebsa110/core.c                     |   15 ++++
 arch/arm/mach-ebsa110/include/mach/io.h          |    9 ---
 arch/arm/mach-ep93xx/include/mach/io.h           |   22 -----
 arch/arm/mach-exynos/include/mach/io.h           |   26 ------
 arch/arm/mach-footbridge/include/mach/io.h       |   13 ---
 arch/arm/mach-gemini/include/mach/io.h           |   18 -----
 arch/arm/mach-h720x/include/mach/io.h            |   22 -----
 arch/arm/mach-highbank/include/mach/io.h         |    7 --
 arch/arm/mach-imx/mm-imx3.c                      |   10 +--
 arch/arm/mach-integrator/include/mach/io.h       |    1 -
 arch/arm/mach-iop13xx/include/mach/io.h          |   13 ---
 arch/arm/mach-iop13xx/include/mach/iop13xx.h     |    1 +
 arch/arm/mach-iop13xx/io.c                       |   20 +++--
 arch/arm/mach-iop13xx/iq81340mc.c                |    1 +
 arch/arm/mach-iop13xx/iq81340sc.c                |    1 +
 arch/arm/mach-iop13xx/pci.h                      |    6 ++
 arch/arm/mach-iop32x/include/mach/io.h           |    1 -
 arch/arm/mach-iop33x/include/mach/io.h           |    1 -
 arch/arm/mach-ixp2000/include/mach/io.h          |    1 -
 arch/arm/mach-ixp23xx/include/mach/io.h          |    1 -
 arch/arm/mach-ixp4xx/avila-setup.c               |    2 +
 arch/arm/mach-ixp4xx/common.c                    |   33 ++++++++
 arch/arm/mach-ixp4xx/coyote-setup.c              |    2 +
 arch/arm/mach-ixp4xx/dsmg600-setup.c             |    1 +
 arch/arm/mach-ixp4xx/fsg-setup.c                 |    1 +
 arch/arm/mach-ixp4xx/gateway7001-setup.c         |    1 +
 arch/arm/mach-ixp4xx/goramo_mlr.c                |    1 +
 arch/arm/mach-ixp4xx/gtwx5715-setup.c            |    1 +
 arch/arm/mach-ixp4xx/include/mach/hardware.h     |    2 -
 arch/arm/mach-ixp4xx/include/mach/io.h           |   24 +-----
 arch/arm/mach-ixp4xx/include/mach/platform.h     |    1 +
 arch/arm/mach-ixp4xx/ixdp425-setup.c             |    4 +
 arch/arm/mach-ixp4xx/nas100d-setup.c             |    1 +
 arch/arm/mach-ixp4xx/nslu2-setup.c               |    1 +
 arch/arm/mach-ixp4xx/omixp-setup.c               |    3 +
 arch/arm/mach-ixp4xx/vulcan-setup.c              |    1 +
 arch/arm/mach-ixp4xx/wg302v2-setup.c             |    1 +
 arch/arm/mach-kirkwood/include/mach/io.h         |    2 -
 arch/arm/mach-ks8695/include/mach/io.h           |   19 -----
 arch/arm/mach-lpc32xx/include/mach/io.h          |   27 -------
 arch/arm/mach-mmp/include/mach/addr-map.h        |    6 --
 arch/arm/mach-mmp/include/mach/io.h              |   21 -----
 arch/arm/mach-msm/board-halibut.c                |    6 ++
 arch/arm/mach-msm/board-trout.c                  |    6 ++
 arch/arm/mach-msm/include/mach/io.h              |   36 ---------
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h  |   12 +--
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h  |    4 +
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h  |    4 +
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h  |    4 +
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h  |    4 +
 arch/arm/mach-msm/include/mach/msm_iomap.h       |    6 --
 arch/arm/mach-msm/io.c                           |    8 +-
 arch/arm/mach-mv78xx0/include/mach/io.h          |    2 -
 arch/arm/mach-mxs/include/mach/hardware.h        |    6 --
 arch/arm/mach-mxs/include/mach/io.h              |   22 -----
 arch/arm/mach-netx/generic.c                     |    2 +-
 arch/arm/mach-netx/include/mach/hardware.h       |    2 +-
 arch/arm/mach-netx/include/mach/io.h             |   28 -------
 arch/arm/mach-netx/include/mach/netx-regs.h      |   16 ++--
 arch/arm/mach-nomadik/include/mach/io.h          |   22 -----
 arch/arm/mach-omap1/ams-delta-fiq-handler.S      |    1 +
 arch/arm/mach-omap1/include/mach/entry-macro.S   |    1 -
 arch/arm/mach-omap1/include/mach/io.h            |   46 -----------
 arch/arm/mach-omap1/iomap.h                      |    6 --
 arch/arm/mach-omap1/sleep.S                      |    2 -
 arch/arm/mach-omap1/sram.S                       |    1 -
 arch/arm/mach-omap2/clock3xxx_data.c             |    1 +
 arch/arm/mach-omap2/clock44xx_data.c             |    1 +
 arch/arm/mach-omap2/include/mach/io.h            |   49 ------------
 arch/arm/mach-omap2/iomap.h                      |    6 --
 arch/arm/mach-orion5x/common.h                   |    9 +++
 arch/arm/mach-orion5x/include/mach/io.h          |   33 --------
 arch/arm/mach-orion5x/pci.c                      |    1 +
 arch/arm/mach-orion5x/tsx09-common.c             |    1 +
 arch/arm/mach-picoxcell/include/mach/io.h        |   22 -----
 arch/arm/mach-pnx4008/include/mach/io.h          |   21 -----
 arch/arm/mach-prima2/include/mach/io.h           |   16 ----
 arch/arm/mach-pxa/Kconfig                        |    1 +
 arch/arm/mach-pxa/clock-pxa2xx.c                 |    1 +
 arch/arm/mach-pxa/corgi_pm.c                     |    1 +
 arch/arm/mach-pxa/cpufreq-pxa3xx.c               |    1 +
 arch/arm/mach-pxa/include/mach/hardware.h        |    6 --
 arch/arm/mach-pxa/include/mach/io.h              |   20 -----
 arch/arm/mach-pxa/mfp-pxa2xx.c                   |    1 +
 arch/arm/mach-pxa/pxa2xx.c                       |    1 +
 arch/arm/mach-pxa/pxa300.c                       |    1 +
 arch/arm/mach-pxa/pxa320.c                       |    1 +
 arch/arm/mach-pxa/sharpsl_pm.c                   |    1 +
 arch/arm/mach-realview/include/mach/hardware.h   |    2 +-
 arch/arm/mach-realview/include/mach/io.h         |   28 -------
 arch/arm/mach-rpc/include/mach/hardware.h        |    6 --
 arch/arm/mach-rpc/include/mach/io.h              |    5 --
 arch/arm/mach-s3c24xx/include/mach/io.h          |    5 --
 arch/arm/mach-s3c64xx/include/mach/io.h          |   18 -----
 arch/arm/mach-s5p64x0/include/mach/io.h          |   25 ------
 arch/arm/mach-s5pc100/include/mach/io.h          |   18 -----
 arch/arm/mach-s5pv210/include/mach/io.h          |   26 ------
 arch/arm/mach-sa1100/include/mach/io.h           |   20 -----
 arch/arm/mach-shark/include/mach/io.h            |    2 -
 arch/arm/mach-shmobile/board-ag5evm.c            |    2 +-
 arch/arm/mach-shmobile/board-bonito.c            |    2 +-
 arch/arm/mach-shmobile/board-kota2.c             |    2 +-
 arch/arm/mach-shmobile/include/mach/io.h         |    9 ---
 arch/arm/mach-shmobile/intc-r8a7779.c            |    4 +-
 arch/arm/mach-shmobile/intc-sh73a0.c             |    4 +-
 arch/arm/mach-shmobile/smp-r8a7779.c             |    4 +-
 arch/arm/mach-shmobile/smp-sh73a0.c              |   20 ++---
 arch/arm/mach-spear3xx/clock.c                   |    1 +
 arch/arm/mach-spear3xx/include/mach/io.h         |   19 -----
 arch/arm/mach-spear6xx/clock.c                   |    1 +
 arch/arm/mach-spear6xx/include/mach/io.h         |   20 -----
 arch/arm/mach-tegra/Makefile                     |    1 +
 arch/arm/mach-tegra/include/mach/debug-macro.S   |    2 -
 arch/arm/mach-tegra/include/mach/io.h            |   49 ------------
 arch/arm/mach-tegra/include/mach/iomap.h         |   42 ++++++++++
 arch/arm/mach-tegra/io.c                         |    1 +
 arch/arm/mach-tegra/sleep.S                      |    4 +-
 arch/arm/mach-u300/include/mach/io.h             |   20 -----
 arch/arm/mach-u300/include/mach/u300-regs.h      |    6 --
 arch/arm/mach-ux500/include/mach/hardware.h      |    2 +-
 arch/arm/mach-ux500/include/mach/io.h            |   22 -----
 arch/arm/mach-versatile/include/mach/io.h        |   28 -------
 arch/arm/mach-vexpress/include/mach/io.h         |   26 ------
 arch/arm/mach-vt8500/include/mach/io.h           |   26 ------
 arch/arm/mach-w90x900/include/mach/io.h          |   30 -------
 arch/arm/mach-zynq/include/mach/io.h             |   33 --------
 arch/arm/mm/ioremap.c                            |   17 +++-
 arch/arm/mm/nommu.c                              |    8 +-
 arch/arm/plat-mxc/include/mach/hardware.h        |    7 +-
 arch/arm/plat-mxc/include/mach/io.h              |   39 ---------
 arch/arm/plat-omap/include/plat/hardware.h       |    6 --
 arch/arm/plat-omap/include/plat/sdrc.h           |    1 -
 arch/arm/plat-omap/include/plat/usb.h            |    1 -
 arch/arm/plat-spear/include/plat/hardware.h      |    6 --
 arch/arm/plat-spear/include/plat/io.h            |   22 -----
 drivers/media/video/davinci/vpbe_osd.c           |    1 -
 drivers/media/video/davinci/vpbe_venc.c          |    1 -
 drivers/rtc/rtc-sa1100.c                         |    1 +
 drivers/video/omap2/vrfb.c                       |    1 -
 drivers/watchdog/sa1100_wdt.c                    |    1 +
 include/linux/dma-mapping.h                      |    2 +-
 sound/arm/pxa2xx-ac97-lib.c                      |    1 +
 sound/arm/pxa2xx-ac97.c                          |    1 +
 sound/soc/pxa/pxa2xx-ac97.c                      |    1 +
 163 files changed, 337 insertions(+), 1367 deletions(-)
 delete mode 100644 arch/arm/mach-at91/include/mach/io.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/io.h
 delete mode 100644 arch/arm/mach-clps711x/include/mach/io.h
 delete mode 100644 arch/arm/mach-cns3xxx/include/mach/io.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/io.h
 delete mode 100644 arch/arm/mach-ep93xx/include/mach/io.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/io.h
 delete mode 100644 arch/arm/mach-gemini/include/mach/io.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/io.h
 delete mode 100644 arch/arm/mach-highbank/include/mach/io.h
 create mode 100644 arch/arm/mach-iop13xx/pci.h
 delete mode 100644 arch/arm/mach-ks8695/include/mach/io.h
 delete mode 100644 arch/arm/mach-lpc32xx/include/mach/io.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/io.h
 delete mode 100644 arch/arm/mach-msm/include/mach/io.h
 delete mode 100644 arch/arm/mach-mxs/include/mach/io.h
 delete mode 100644 arch/arm/mach-netx/include/mach/io.h
 delete mode 100644 arch/arm/mach-nomadik/include/mach/io.h
 delete mode 100644 arch/arm/mach-omap1/include/mach/io.h
 delete mode 100644 arch/arm/mach-omap2/include/mach/io.h
 delete mode 100644 arch/arm/mach-orion5x/include/mach/io.h
 delete mode 100644 arch/arm/mach-picoxcell/include/mach/io.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/io.h
 delete mode 100644 arch/arm/mach-prima2/include/mach/io.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/io.h
 delete mode 100644 arch/arm/mach-realview/include/mach/io.h
 delete mode 100644 arch/arm/mach-s3c64xx/include/mach/io.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/io.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/io.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/io.h
 delete mode 100644 arch/arm/mach-sa1100/include/mach/io.h
 delete mode 100644 arch/arm/mach-shmobile/include/mach/io.h
 delete mode 100644 arch/arm/mach-spear3xx/include/mach/io.h
 delete mode 100644 arch/arm/mach-spear6xx/include/mach/io.h
 delete mode 100644 arch/arm/mach-u300/include/mach/io.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/io.h
 delete mode 100644 arch/arm/mach-versatile/include/mach/io.h
 delete mode 100644 arch/arm/mach-vexpress/include/mach/io.h
 delete mode 100644 arch/arm/mach-vt8500/include/mach/io.h
 delete mode 100644 arch/arm/mach-w90x900/include/mach/io.h
 delete mode 100644 arch/arm/mach-zynq/include/mach/io.h
 delete mode 100644 arch/arm/plat-mxc/include/mach/io.h
 delete mode 100644 arch/arm/plat-spear/include/plat/io.h
