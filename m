Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab2JAX6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:58:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45774 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758810Ab2JAX5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:57:54 -0400
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 12/12] ARM: soc: multiplatform enablement
Date: Mon,  1 Oct 2012 16:57:07 -0700
Message-Id: <1349135827-24790-13-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1349135827-24790-1-git-send-email-olof@lixom.net>
References: <1349135827-24790-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a pretty significant branch. It's the introduction of the
first multiplatform support on ARM, and with this (and the later
branch) merged, it is now possible to build one kernel that contains
support for highbank, vexpress, mvebu, socfpga, and picoxcell. More
platforms will be convered over in the next few releases.

Two critical last things had to be done for this to be practical and
possible:
* Today each platform has its own include directory under
mach-<mach>/include/mach/*, and traditionally that is where a lot of
driver/platform shared definitions have gone, such as platform data
structures. They now need to move out to a common location instead,
and this branch moves a large number of those out to
include/linux/platform_data.
* Each platform used to list the device trees to compile for its
boards in mach-<mach>/Makefile.boot.

Both of the above changes will mean that there are some merge
conflicts to come (and some to resolve here). It's a one-time move and
once it settles in, we should be good for quite a while. Sorry for the
overhead.


Conflicts: Plenty. :(
* arch/arm/Kconfig: ARCH_HIGHBANK was moved, just delete the version in HEAD.
* arch/arm/Makefile: Conflict due to change from := to +=
  combined with add/removes so no auto-resolve. The version from this
  branch is safe to pull in as-is.
* arch/arm/mach-exynos/Makefile.boot conflict due to add/move
  of all *dtb targets. The exynos4210-trats.dtb has to be moved to
  arch/arm/boot/dts/Makefile next to the other exynos4 targets.
* arch/arm/mach-tegra/board-dt-tegra20.c: conflicts at the top of the
  file. Keep "common.h" include and the USB data structures. "devices.h"
  has been removed, so don't keep that include.
* arch/arm/plat-samsung/devs.c has change/add conflict due to the include
  file moves. Keep the plat/hdmi.h config, we will come around and
  cleanup this added include separately if needed.
* arch/arm/mach-vt8500/devices.c: Remove file.

----------------------------------------------------------------

The following changes since commit 9192d4ca1c4a4d43e6c4f1f9fd3ae48dc3017d07:

  Merge branch 'next/docs' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/multiplatform

for you to fetch changes up to a55eb3ec0e38e2db17207b204c050fbcdf750abb:

  drivers: bus: omap_l3: fixup merge conflict resolution

----------------------------------------------------------------

Arnd Bergmann (18):
      ARM: SoC: convert spear13xx to SMP operations
      ARM: at91: move platform_data definitions
      ARM: davinci: move platform_data definitions
      ARM: ep93xx: move platform_data definitions
      ARM: imx: move platform_data definitions
      ARM: msm: move platform_data definitions
      ARM: netx: move platform_data definitions
      ARM: pxa: move platform_data definitions
      ARM: sa1100: move platform_data definitions
      ARM: tegra: move sdhci platform_data definition
      ARM: vt8500: move platform_data definitions
      ARM: w90x900: move platform_data definitions
      ARM: nomadik: move platform_data definitions
      ARM: vexpress: remove dependency on mach/* headers
      ARM: orion: move platform_data definitions
      ARM: samsung: move platform_data definitions
      ARM: spear: move platform_data definitions
      Merge branch 'bcmring/removal' into next/multiplatform

David Brown (1):
      ARM: msm: Move core.h contents into common.h

Marc Zyngier (12):
      ARM: SoC: add per-platform SMP operations
      ARM: SoC: convert VExpress/RealView to SMP operations
      ARM: SoC: convert OMAP4 to SMP operations
      ARM: SoC: convert Tegra to SMP operations
      ARM: SoC: convert Exynos4 to SMP operations
      ARM: SoC: convert MSM to SMP operations
      ARM: SoC: convert ux500 to SMP operations
      ARM: SoC: convert shmobile SMP to SMP operations
      ARM: SoC: convert highbank to SMP operations
      ARM: SoC: convert imx6q to SMP operations
      ARM: smp: Make SMP operations mandatory
      ARM: consolidate pen_release instead of having per platform definitions

Olof Johansson (8):
      Merge branch 'next/cleanup' into next/multiplatform
      Merge branch 'next/dt' into next/multiplatform
      Merge branch 'next/soc' into next/multiplatform
      Merge tag 'multi-platform-for-3.7' of git://sources.calxeda.com/kernel/linux into next/multiplatform
      ARM: dtb: move all dtb targets to common Makefile
      Merge branch 'multiplatform/smp_ops' into next/multiplatform
      Merge branch 'multiplatform/platform-data' into next/multiplatform
      drivers: bus: omap_l3: fixup merge conflict resolution

Rob Herring (20):
      staging: ste_rmi4: remove gpio.h include
      usb: pxa27x_udc: remove IRQ_USB define
      net: pxaficp_ir: add irq resources
      ARM: pxa: use gpio_to_irq for sharppm_sl
      ARM: shmobile: move custom gpio functions to sh-gpio.h
      ARM: orion: move custom gpio functions to orion-gpio.h
      ARM: make mach/gpio.h headers optional
      ARM: move debug macros to common location
      ARM: highbank: move debug macros to include/debug
      ARM: vexpress: move debug macros to include/debug
      ARM: mvebu: move debug macros to include/debug
      ARM: socfpga: move debug macros to include/debug
      ARM: picoxcell: move debug macros to include/debug
      ARM: move all dtb targets out of Makefile.boot
      ARM: picoxcell: remove dependency on mach/* headers
      ARM: mvebu: move armada-370-xp.h in mach dir
      ARM: initial multiplatform support
      ARM: vexpress: convert to multi-platform
      ARM: highbank: call highbank_pm_init from .init_machine
      ARM: add v7 multi-platform defconfig


 Documentation/spi/ep93xx_spi                    |   2 +-
 arch/arm/Kconfig                                | 165 +++++++++----------
 arch/arm/Kconfig.debug                          |  33 ++++
 arch/arm/Makefile                               | 148 ++++++++---------
 arch/arm/boot/Makefile                          |   2 +
 arch/arm/boot/compressed/misc.c                 |   6 +
 arch/arm/boot/dts/Makefile                      | 100 +++++++++++
 arch/arm/configs/multi_v7_defconfig             |  57 +++++++
 arch/arm/include/asm/gpio.h                     |   2 +
 arch/arm/include/asm/mach/arch.h                |   7 +
 arch/arm/include/asm/smp.h                      |  48 ++++--
 arch/arm/include/asm/timex.h                    |   4 +
 .../debug-macro.S => include/debug/highbank.S}  |   6 +-
 arch/arm/include/debug/icedcc.S                 |  90 ++++++++++
 .../debug-macro.S => include/debug/mvebu.S}     |   3 +-
 .../debug-macro.S => include/debug/picoxcell.S} |   4 +-
 .../debug-macro.S => include/debug/socfpga.S}   |   0
 .../debug-macro.S => include/debug/vexpress.S}  |   0
 arch/arm/kernel/debug.S                         |  87 +---------
 arch/arm/kernel/head.S                          |   4 +-
 arch/arm/kernel/setup.c                         |   4 +-
 arch/arm/kernel/smp.c                           |  72 +++++++-
 arch/arm/mach-at91/Makefile.boot                |  24 ---
 arch/arm/mach-at91/at91sam9g45_devices.c        |   2 +-
 arch/arm/mach-at91/at91sam9rl_devices.c         |   2 +-
 arch/arm/mach-at91/include/mach/atmel-mci.h     |   2 +-
 arch/arm/mach-bcm2835/Makefile.boot             |   2 -
 arch/arm/mach-davinci/aemif.c                   |   2 +-
 arch/arm/mach-davinci/board-da830-evm.c         |   8 +-
 arch/arm/mach-davinci/board-da850-evm.c         |   6 +-
 arch/arm/mach-davinci/board-dm355-evm.c         |   8 +-
 arch/arm/mach-davinci/board-dm355-leopard.c     |   8 +-
 arch/arm/mach-davinci/board-dm365-evm.c         |   8 +-
 arch/arm/mach-davinci/board-dm644x-evm.c        |  10 +-
 arch/arm/mach-davinci/board-dm646x-evm.c        |   6 +-
 arch/arm/mach-davinci/board-mityomapl138.c      |   4 +-
 arch/arm/mach-davinci/board-neuros-osd2.c       |   8 +-
 arch/arm/mach-davinci/board-sffsdr.c            |   4 +-
 arch/arm/mach-davinci/davinci.h                 |   2 +-
 arch/arm/mach-davinci/devices.c                 |   4 +-
 arch/arm/mach-davinci/dm355.c                   |   2 +-
 arch/arm/mach-davinci/dm365.c                   |   4 +-
 arch/arm/mach-davinci/include/mach/da8xx.h      |   8 +-
 arch/arm/mach-davinci/include/mach/tnetv107x.h  |   4 +-
 arch/arm/mach-davinci/usb.c                     |   2 +-
 arch/arm/mach-dove/common.c                     |   2 +-
 arch/arm/mach-dove/include/mach/gpio.h          |   9 -
 arch/arm/mach-dove/irq.c                        |   1 +
 arch/arm/mach-dove/mpp.c                        |   1 +
 arch/arm/mach-ep93xx/core.c                     |   6 +-
 arch/arm/mach-ep93xx/dma.c                      |   2 +-
 arch/arm/mach-ep93xx/edb93xx.c                  |   4 +-
 arch/arm/mach-ep93xx/include/mach/gpio.h        |   1 -
 arch/arm/mach-ep93xx/simone.c                   |   2 +-
 arch/arm/mach-ep93xx/snappercl15.c              |   2 +-
 arch/arm/mach-ep93xx/vision_ep9307.c            |   4 +-
 arch/arm/mach-exynos/Makefile.boot              |   3 -
 arch/arm/mach-exynos/common.h                   |   5 +
 arch/arm/mach-exynos/dev-audio.c                |   2 +-
 arch/arm/mach-exynos/dev-ohci.c                 |   2 +-
 arch/arm/mach-exynos/hotplug.c                  |  18 +-
 arch/arm/mach-exynos/mach-armlex4210.c          |   1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c          |   1 +
 arch/arm/mach-exynos/mach-nuri.c                |   7 +-
 arch/arm/mach-exynos/mach-origen.c              |   7 +-
 arch/arm/mach-exynos/mach-smdk4x12.c            |   4 +-
 arch/arm/mach-exynos/mach-smdkv310.c            |   8 +-
 arch/arm/mach-exynos/mach-universal_c210.c      |   5 +-
 arch/arm/mach-exynos/platsmp.c                  |  27 +--
 arch/arm/mach-exynos/setup-i2c0.c               |   2 +-
 arch/arm/mach-exynos/setup-i2c1.c               |   2 +-
 arch/arm/mach-exynos/setup-i2c2.c               |   2 +-
 arch/arm/mach-exynos/setup-i2c3.c               |   2 +-
 arch/arm/mach-exynos/setup-i2c4.c               |   2 +-
 arch/arm/mach-exynos/setup-i2c5.c               |   2 +-
 arch/arm/mach-exynos/setup-i2c6.c               |   2 +-
 arch/arm/mach-exynos/setup-i2c7.c               |   2 +-
 arch/arm/mach-highbank/Kconfig                  |  15 ++
 arch/arm/mach-highbank/Makefile.boot            |   1 -
 arch/arm/mach-highbank/core.h                   |   9 +
 arch/arm/mach-highbank/highbank.c               |   2 +
 arch/arm/mach-highbank/hotplug.c                |  16 +-
 arch/arm/mach-highbank/include/mach/gpio.h      |   1 -
 arch/arm/mach-highbank/include/mach/timex.h     |   6 -
 .../arm/mach-highbank/include/mach/uncompress.h |   9 -
 arch/arm/mach-highbank/platsmp.c                |  18 +-
 arch/arm/mach-highbank/pm.c                     |   4 +-
 arch/arm/mach-imx/Makefile.boot                 |  11 --
 arch/arm/mach-imx/ehci-imx25.c                  |   2 +-
 arch/arm/mach-imx/ehci-imx27.c                  |   2 +-
 arch/arm/mach-imx/ehci-imx31.c                  |   2 +-
 arch/arm/mach-imx/ehci-imx35.c                  |   2 +-
 arch/arm/mach-imx/ehci-imx5.c                   |   2 +-
 arch/arm/mach-imx/hotplug.c                     |  16 +-
 arch/arm/mach-imx/mach-imx6q.c                  |   1 +
 arch/arm/mach-imx/mach-mx31moboard.c            |   2 +-
 arch/arm/mach-imx/mx1-camera-fiq-ksym.c         |   2 +-
 arch/arm/mach-imx/platsmp.c                     |  18 +-
 arch/arm/mach-ixp4xx/include/mach/gpio.h        |   2 -
 arch/arm/mach-kirkwood/Makefile.boot            |  11 --
 arch/arm/mach-kirkwood/board-dreamplug.c        |   2 +-
 arch/arm/mach-kirkwood/board-goflexnet.c        |   2 +-
 arch/arm/mach-kirkwood/common.c                 |  10 +-
 arch/arm/mach-kirkwood/d2net_v2-setup.c         |   2 +-
 arch/arm/mach-kirkwood/db88f6281-bp-setup.c     |   2 +-
 arch/arm/mach-kirkwood/dockstar-setup.c         |   2 +-
 arch/arm/mach-kirkwood/guruplug-setup.c         |   2 +-
 arch/arm/mach-kirkwood/include/mach/gpio.h      |   9 -
 arch/arm/mach-kirkwood/irq.c                    |   1 +
 arch/arm/mach-kirkwood/netspace_v2-setup.c      |   2 +-
 arch/arm/mach-kirkwood/netxbig_v2-setup.c       |   2 +-
 arch/arm/mach-kirkwood/openrd-setup.c           |   2 +-
 arch/arm/mach-kirkwood/rd88f6192-nas-setup.c    |   1 +
 arch/arm/mach-kirkwood/rd88f6281-setup.c        |   2 +-
 arch/arm/mach-kirkwood/sheevaplug-setup.c       |   2 +-
 arch/arm/mach-lpc32xx/Makefile.boot             |   2 -
 arch/arm/mach-mmp/aspenite.c                    |   2 +-
 arch/arm/mach-mmp/include/mach/mmp2.h           |   2 +-
 arch/arm/mach-mmp/include/mach/pxa168.h         |   4 +-
 arch/arm/mach-mmp/include/mach/pxa910.h         |   2 +-
 arch/arm/mach-mmp/sram.c                        |   2 +-
 arch/arm/mach-mmp/teton_bga.c                   |   2 +-
 arch/arm/mach-msm/Makefile.boot                 |   3 -
 arch/arm/mach-msm/board-dt-8660.c               |   1 +
 arch/arm/mach-msm/board-dt-8960.c               |   1 +
 arch/arm/mach-msm/board-qsd8x50.c               |   2 +-
 arch/arm/mach-msm/board-trout-mmc.c             |   2 +-
 arch/arm/mach-msm/board-trout-panel.c           |   2 +-
 arch/arm/mach-msm/common.h                      |   2 +
 arch/arm/mach-msm/core.h                        |   2 +
 arch/arm/mach-msm/devices-msm7x00.c             |   2 +-
 arch/arm/mach-msm/devices-msm7x30.c             |   2 +-
 arch/arm/mach-msm/devices-qsd8x50.c             |   2 +-
 arch/arm/mach-msm/hotplug.c                     |  18 +-
 arch/arm/mach-msm/include/mach/board.h          |   2 +-
 arch/arm/mach-msm/include/mach/gpio.h           |   1 -
 arch/arm/mach-msm/platsmp.c                     |  24 ++-
 arch/arm/mach-mv78xx0/common.c                  |   4 +-
 arch/arm/mach-mv78xx0/irq.c                     |   1 +
 arch/arm/mach-mvebu/Kconfig                     |  10 ++
 arch/arm/mach-mvebu/Makefile                    |   2 +
 arch/arm/mach-mvebu/Makefile.boot               |   3 -
 arch/arm/mach-mvebu/armada-370-xp.c             |   2 +-
 .../{include/mach => }/armada-370-xp.h          |   0
 arch/arm/mach-mvebu/include/mach/timex.h        |  13 --
 arch/arm/mach-mvebu/include/mach/uncompress.h   |  43 -----
 arch/arm/mach-mxs/Makefile.boot                 |  10 --
 arch/arm/mach-mxs/include/mach/gpio.h           |   1 -
 arch/arm/mach-netx/nxdb500.c                    |   2 +-
 arch/arm/mach-netx/nxdkn.c                      |   2 +-
 arch/arm/mach-netx/nxeb500hmi.c                 |   2 +-
 arch/arm/mach-nomadik/board-nhk8815.c           |   2 +-
 arch/arm/mach-nomadik/include/mach/gpio.h       |   4 -
 arch/arm/mach-omap2/Makefile.boot               |   6 -
 arch/arm/mach-omap2/board-4430sdp.c             |   1 +
 arch/arm/mach-omap2/board-generic.c             |   2 +
 arch/arm/mach-omap2/board-omap4panda.c          |   1 +
 arch/arm/mach-omap2/common.h                    |   5 +
 arch/arm/mach-omap2/omap-hotplug.c              |  16 +-
 arch/arm/mach-omap2/omap-smp.c                  |  18 +-
 arch/arm/mach-orion5x/common.c                  |   4 +-
 arch/arm/mach-orion5x/d2net-setup.c             |   1 +
 arch/arm/mach-orion5x/db88f5281-setup.c         |   2 +-
 arch/arm/mach-orion5x/dns323-setup.c            |   1 +
 arch/arm/mach-orion5x/include/mach/gpio.h       |   9 -
 arch/arm/mach-orion5x/irq.c                     |   1 +
 arch/arm/mach-orion5x/kurobox_pro-setup.c       |   2 +-
 arch/arm/mach-orion5x/net2big-setup.c           |   1 +
 arch/arm/mach-picoxcell/Kconfig                 |  14 ++
 arch/arm/mach-picoxcell/Makefile.boot           |   1 -
 arch/arm/mach-picoxcell/common.c                |  13 +-
 arch/arm/mach-picoxcell/include/mach/gpio.h     |   1 -
 arch/arm/mach-picoxcell/include/mach/hardware.h |  21 ---
 arch/arm/mach-picoxcell/include/mach/map.h      |  25 ---
 .../mach-picoxcell/include/mach/picoxcell_soc.h |  25 ---
 arch/arm/mach-picoxcell/include/mach/timex.h    |  25 ---
 .../mach-picoxcell/include/mach/uncompress.h    |  21 ---
 arch/arm/mach-prima2/Makefile.boot              |   2 -
 arch/arm/mach-pxa/am200epd.c                    |   2 +-
 arch/arm/mach-pxa/am300epd.c                    |   2 +-
 arch/arm/mach-pxa/balloon3.c                    |   8 +-
 arch/arm/mach-pxa/cm-x270.c                     |   4 +-
 arch/arm/mach-pxa/cm-x2xx.c                     |   2 +-
 arch/arm/mach-pxa/cm-x300.c                     |  10 +-
 arch/arm/mach-pxa/colibri-evalboard.c           |   4 +-
 arch/arm/mach-pxa/colibri-pxa270-income.c       |   6 +-
 arch/arm/mach-pxa/colibri-pxa300.c              |   4 +-
 arch/arm/mach-pxa/colibri-pxa320.c              |   4 +-
 arch/arm/mach-pxa/colibri-pxa3xx.c              |   6 +-
 arch/arm/mach-pxa/corgi.c                       |   4 +-
 arch/arm/mach-pxa/csb726.c                      |   4 +-
 arch/arm/mach-pxa/devices.c                     |  31 +++-
 arch/arm/mach-pxa/em-x270.c                     |  10 +-
 arch/arm/mach-pxa/eseries.c                     |   4 +-
 arch/arm/mach-pxa/ezx.c                         |   8 +-
 arch/arm/mach-pxa/gumstix.c                     |   2 +-
 arch/arm/mach-pxa/hx4700.c                      |   2 +-
 arch/arm/mach-pxa/idp.c                         |   4 +-
 arch/arm/mach-pxa/littleton.c                   |   8 +-
 arch/arm/mach-pxa/lpd270.c                      |   8 +-
 arch/arm/mach-pxa/lubbock.c                     |   6 +-
 arch/arm/mach-pxa/magician.c                    |   8 +-
 arch/arm/mach-pxa/mainstone.c                   |  10 +-
 arch/arm/mach-pxa/mioa701.c                     |   8 +-
 arch/arm/mach-pxa/mxm8x10.c                     |   8 +-
 arch/arm/mach-pxa/palm27x.c                     |   8 +-
 arch/arm/mach-pxa/palmld.c                      |  10 +-
 arch/arm/mach-pxa/palmt5.c                      |  10 +-
 arch/arm/mach-pxa/palmtc.c                      |   6 +-
 arch/arm/mach-pxa/palmte2.c                     |   8 +-
 arch/arm/mach-pxa/palmtreo.c                    |  14 +-
 arch/arm/mach-pxa/palmtx.c                      |  10 +-
 arch/arm/mach-pxa/palmz72.c                     |  12 +-
 arch/arm/mach-pxa/pcm990-baseboard.c            |   8 +-
 arch/arm/mach-pxa/poodle.c                      |   6 +-
 arch/arm/mach-pxa/pxa27x.c                      |   2 +-
 arch/arm/mach-pxa/pxa2xx.c                      |   2 +-
 arch/arm/mach-pxa/pxa3xx-ulpi.c                 |   2 +-
 arch/arm/mach-pxa/pxa3xx.c                      |   2 +-
 arch/arm/mach-pxa/raumfeld.c                    |   8 +-
 arch/arm/mach-pxa/saar.c                        |   2 +-
 arch/arm/mach-pxa/sharpsl_pm.c                  |  30 ++--
 arch/arm/mach-pxa/spitz.c                       |   8 +-
 arch/arm/mach-pxa/stargate2.c                   |   2 +-
 arch/arm/mach-pxa/tavorevb.c                    |   4 +-
 arch/arm/mach-pxa/tosa.c                        |   4 +-
 arch/arm/mach-pxa/trizeps4.c                    |   8 +-
 arch/arm/mach-pxa/viper.c                       |   4 +-
 arch/arm/mach-pxa/vpac270.c                     |   8 +-
 arch/arm/mach-pxa/z2.c                          |   6 +-
 arch/arm/mach-pxa/zeus.c                        |   8 +-
 arch/arm/mach-pxa/zylonite.c                    |  10 +-
 arch/arm/mach-realview/core.h                   |   3 +
 arch/arm/mach-realview/hotplug.c                |  18 +-
 arch/arm/mach-realview/include/mach/gpio.h      |   1 -
 arch/arm/mach-realview/platsmp.c                |  18 +-
 arch/arm/mach-realview/realview_pb11mp.c        |   1 +
 arch/arm/mach-realview/realview_pbx.c           |   1 +
 arch/arm/mach-s3c24xx/common-smdk.c             |   4 +-
 arch/arm/mach-s3c24xx/mach-amlm5900.c           |   2 +-
 arch/arm/mach-s3c24xx/mach-anubis.c             |   6 +-
 arch/arm/mach-s3c24xx/mach-at2440evb.c          |   6 +-
 arch/arm/mach-s3c24xx/mach-bast.c               |   8 +-
 arch/arm/mach-s3c24xx/mach-gta02.c              |  10 +-
 arch/arm/mach-s3c24xx/mach-h1940.c              |   8 +-
 arch/arm/mach-s3c24xx/mach-jive.c               |   6 +-
 arch/arm/mach-s3c24xx/mach-mini2440.c           |  10 +-
 arch/arm/mach-s3c24xx/mach-n30.c                |   8 +-
 arch/arm/mach-s3c24xx/mach-nexcoder.c           |   2 +-
 arch/arm/mach-s3c24xx/mach-osiris.c             |   4 +-
 arch/arm/mach-s3c24xx/mach-otom.c               |   2 +-
 arch/arm/mach-s3c24xx/mach-qt2410.c             |   8 +-
 arch/arm/mach-s3c24xx/mach-rx1950.c             |  10 +-
 arch/arm/mach-s3c24xx/mach-rx3715.c             |   2 +-
 arch/arm/mach-s3c24xx/mach-smdk2410.c           |   2 +-
 arch/arm/mach-s3c24xx/mach-smdk2413.c           |   4 +-
 arch/arm/mach-s3c24xx/mach-smdk2416.c           |   8 +-
 arch/arm/mach-s3c24xx/mach-smdk2440.c           |   2 +-
 arch/arm/mach-s3c24xx/mach-smdk2443.c           |   2 +-
 arch/arm/mach-s3c24xx/mach-tct_hammer.c         |   2 +-
 arch/arm/mach-s3c24xx/mach-vr1000.c             |   6 +-
 arch/arm/mach-s3c24xx/mach-vstms.c              |   4 +-
 arch/arm/mach-s3c24xx/setup-i2c.c               |   2 +-
 arch/arm/mach-s3c24xx/simtec-audio.c            |   2 +-
 arch/arm/mach-s3c24xx/simtec-usb.c              |   2 +-
 arch/arm/mach-s3c64xx/dev-audio.c               |   2 +-
 arch/arm/mach-s3c64xx/mach-anw6410.c            |   2 +-
 arch/arm/mach-s3c64xx/mach-crag6410-module.c    |   2 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c           |   4 +-
 arch/arm/mach-s3c64xx/mach-hmt.c                |   4 +-
 arch/arm/mach-s3c64xx/mach-mini6410.c           |   4 +-
 arch/arm/mach-s3c64xx/mach-ncp.c                |   2 +-
 arch/arm/mach-s3c64xx/mach-real6410.c           |   4 +-
 arch/arm/mach-s3c64xx/mach-smartq.c             |   8 +-
 arch/arm/mach-s3c64xx/mach-smdk6400.c           |   2 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c           |   6 +-
 arch/arm/mach-s3c64xx/setup-i2c0.c              |   2 +-
 arch/arm/mach-s3c64xx/setup-i2c1.c              |   2 +-
 arch/arm/mach-s3c64xx/setup-ide.c               |   2 +-
 arch/arm/mach-s5p64x0/dev-audio.c               |   2 +-
 arch/arm/mach-s5p64x0/mach-smdk6440.c           |   4 +-
 arch/arm/mach-s5p64x0/mach-smdk6450.c           |   4 +-
 arch/arm/mach-s5p64x0/setup-i2c0.c              |   2 +-
 arch/arm/mach-s5p64x0/setup-i2c1.c              |   2 +-
 arch/arm/mach-s5pc100/dev-audio.c               |   2 +-
 arch/arm/mach-s5pc100/mach-smdkc100.c           |   8 +-
 arch/arm/mach-s5pc100/setup-i2c0.c              |   2 +-
 arch/arm/mach-s5pc100/setup-i2c1.c              |   2 +-
 arch/arm/mach-s5pv210/dev-audio.c               |   2 +-
 arch/arm/mach-s5pv210/mach-goni.c               |   2 +-
 arch/arm/mach-s5pv210/mach-smdkc110.c           |   4 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c           |   6 +-
 arch/arm/mach-s5pv210/mach-torbreck.c           |   2 +-
 arch/arm/mach-s5pv210/setup-i2c0.c              |   2 +-
 arch/arm/mach-s5pv210/setup-i2c1.c              |   2 +-
 arch/arm/mach-s5pv210/setup-i2c2.c              |   2 +-
 arch/arm/mach-sa1100/assabet.c                  |   2 +-
 arch/arm/mach-sa1100/cerf.c                     |   2 +-
 arch/arm/mach-sa1100/collie.c                   |   2 +-
 arch/arm/mach-sa1100/lart.c                     |   2 +-
 arch/arm/mach-sa1100/shannon.c                  |   2 +-
 arch/arm/mach-sa1100/simpad.c                   |   2 +-
 arch/arm/mach-shmobile/Makefile.boot            |   4 -
 arch/arm/mach-shmobile/board-ag5evm.c           |   1 +
 arch/arm/mach-shmobile/board-ap4evb.c           |   2 +
 arch/arm/mach-shmobile/board-armadillo800eva.c  |   2 +
 arch/arm/mach-shmobile/board-g4evm.c            |   2 +
 arch/arm/mach-shmobile/board-kota2.c            |   1 +
 arch/arm/mach-shmobile/board-kzm9d.c            |   1 +
 arch/arm/mach-shmobile/board-kzm9g.c            |   1 +
 arch/arm/mach-shmobile/board-mackerel.c         |   2 +
 arch/arm/mach-shmobile/board-marzen.c           |   1 +
 arch/arm/mach-shmobile/hotplug.c                |  31 ++--
 arch/arm/mach-shmobile/include/mach/common.h    |  24 +--
 arch/arm/mach-shmobile/include/mach/emev2.h     |   7 +-
 arch/arm/mach-shmobile/include/mach/r8a7779.h   |   2 +
 arch/arm/mach-shmobile/include/mach/sh73a0.h    |   2 +
 arch/arm/mach-shmobile/pfc-r8a7740.c            |   2 +-
 arch/arm/mach-shmobile/pfc-r8a7779.c            |   2 +-
 arch/arm/mach-shmobile/pfc-sh7367.c             |   2 +-
 arch/arm/mach-shmobile/pfc-sh7372.c             |   2 +-
 arch/arm/mach-shmobile/pfc-sh7377.c             |   2 +-
 arch/arm/mach-shmobile/pfc-sh73a0.c             |   2 +-
 arch/arm/mach-shmobile/platsmp.c                |  96 +----------
 arch/arm/mach-shmobile/setup-emev2.c            |   1 +
 .../{include/mach/gpio.h => sh-gpio.h}          |  14 --
 arch/arm/mach-shmobile/smp-emev2.c              |  47 +++++-
 arch/arm/mach-shmobile/smp-r8a7779.c            |  48 +++++-
 arch/arm/mach-shmobile/smp-sh73a0.c             |  48 +++++-
 arch/arm/mach-socfpga/Kconfig                   |  16 ++
 arch/arm/mach-socfpga/Makefile.boot             |   1 -
 arch/arm/mach-socfpga/include/mach/timex.h      |  19 ---
 arch/arm/mach-socfpga/include/mach/uncompress.h |   9 -
 arch/arm/mach-spear13xx/Makefile.boot           |   3 -
 arch/arm/mach-spear13xx/hotplug.c               |  22 +--
 arch/arm/mach-spear13xx/include/mach/generic.h  |   3 +
 arch/arm/mach-spear13xx/include/mach/gpio.h     |  19 ---
 arch/arm/mach-spear13xx/platsmp.c               |  25 +--
 arch/arm/mach-spear13xx/spear1310.c             |   1 +
 arch/arm/mach-spear13xx/spear1340.c             |   1 +
 arch/arm/mach-spear3xx/Makefile.boot            |   4 -
 arch/arm/mach-spear3xx/include/mach/gpio.h      |  19 ---
 arch/arm/mach-spear6xx/Makefile.boot            |   2 -
 arch/arm/mach-spear6xx/include/mach/gpio.h      |  19 ---
 arch/arm/mach-tegra/Makefile.boot               |  12 --
 arch/arm/mach-tegra/board-dt-tegra20.c          |   2 +
 arch/arm/mach-tegra/board-dt-tegra30.c          |   2 +
 arch/arm/mach-tegra/board-paz00.c               |   2 +-
 arch/arm/mach-tegra/common.c                    |   1 +
 arch/arm/mach-tegra/common.h                    |   4 +
 arch/arm/mach-tegra/hotplug.c                   |   9 +-
 arch/arm/mach-tegra/include/mach/gpio.h         |   1 -
 arch/arm/mach-tegra/platsmp.c                   |  21 ++-
 arch/arm/mach-u300/include/mach/gpio.h          |   1 -
 arch/arm/mach-ux500/Makefile.boot               |   2 -
 arch/arm/mach-ux500/board-mop500.c              |   6 +-
 arch/arm/mach-ux500/cpu-db8500.c                |   2 +-
 arch/arm/mach-ux500/devices-common.h            |   2 +-
 arch/arm/mach-ux500/hotplug.c                   |  36 +---
 arch/arm/mach-ux500/include/mach/gpio.h         |   5 -
 arch/arm/mach-ux500/include/mach/setup.h        |   3 +
 arch/arm/mach-ux500/platsmp.c                   |  24 +--
 arch/arm/mach-ux500/usb.c                       |   2 +-
 arch/arm/mach-versatile/include/mach/gpio.h     |   1 -
 arch/arm/mach-vexpress/Kconfig                  |  64 +++----
 arch/arm/mach-vexpress/Makefile                 |   2 +
 arch/arm/mach-vexpress/Makefile.boot            |  10 --
 arch/arm/mach-vexpress/core.h                   |   4 +
 arch/arm/mach-vexpress/ct-ca9x4.c               |   1 +
 arch/arm/mach-vexpress/hotplug.c                |  18 +-
 arch/arm/mach-vexpress/include/mach/gpio.h      |   1 -
 arch/arm/mach-vexpress/include/mach/irqs.h      |   2 +
 arch/arm/mach-vexpress/include/mach/timex.h     |  23 ---
 .../arm/mach-vexpress/include/mach/uncompress.h |  86 ----------
 arch/arm/mach-vexpress/platsmp.c                |  18 +-
 arch/arm/mach-vexpress/v2m.c                    |   8 +-
 arch/arm/mach-vt8500/include/mach/gpio.h        |   1 -
 arch/arm/mach-w90x900/dev.c                     |   6 +-
 arch/arm/mach-w90x900/mach-nuc950evb.c          |   2 +-
 .../plat-mxc/devices/platform-sdhci-esdhc-imx.c |   2 +-
 arch/arm/plat-mxc/include/mach/common.h         |   4 +
 arch/arm/plat-mxc/include/mach/devices-common.h |  32 ++--
 arch/arm/plat-mxc/include/mach/gpio.h           |   1 -
 arch/arm/plat-mxc/ssi-fiq-ksym.c                |   2 +-
 arch/arm/plat-orion/common.c                    |   4 +-
 arch/arm/plat-orion/gpio.c                      |   2 +-
 .../include/plat/{gpio.h => orion-gpio.h}       |   2 +-
 arch/arm/plat-orion/irq.c                       |   2 +-
 arch/arm/plat-orion/mpp.c                       |   1 +
 arch/arm/plat-samsung/devs.c                    |  20 +--
 arch/arm/plat-spear/include/plat/gpio.h         |   1 -
 arch/arm/plat-versatile/Makefile                |   2 +
 arch/arm/plat-versatile/include/plat/platsmp.h  |  14 ++
 arch/arm/plat-versatile/platsmp.c               |  10 +-
 drivers/ata/pata_ep93xx.c                       |   2 +-
 drivers/ata/pata_pxa.c                          |   2 +-
 drivers/ata/pata_samsung_cf.c                   |   2 +-
 drivers/bus/omap_l3_noc.c                       |   1 -
 drivers/crypto/ux500/cryp/cryp_core.c           |   2 +-
 drivers/crypto/ux500/hash/hash_core.c           |   2 +-
 drivers/dma/at_hdmac_regs.h                     |   2 +-
 drivers/dma/ep93xx_dma.c                        |   2 +-
 drivers/dma/imx-dma.c                           |   2 +-
 drivers/dma/imx-sdma.c                          |   4 +-
 drivers/dma/mmp_tdma.c                          |   2 +-
 drivers/dma/mv_xor.c                            |   2 +-
 drivers/hwmon/s3c-hwmon.c                       |   2 +-
 drivers/i2c/busses/i2c-davinci.c                |   2 +-
 drivers/i2c/busses/i2c-imx.c                    |   2 +-
 drivers/i2c/busses/i2c-nuc900.c                 |   2 +-
 drivers/i2c/busses/i2c-s3c2410.c                |   2 +-
 drivers/input/keyboard/davinci_keyscan.c        |   2 +-
 drivers/input/keyboard/ep93xx_keypad.c          |   2 +-
 drivers/input/keyboard/nomadik-ske-keypad.c     |   2 +-
 drivers/input/keyboard/pxa27x_keypad.c          |   2 +-
 drivers/input/keyboard/pxa930_rotary.c          |   2 +-
 drivers/input/keyboard/spear-keyboard.c         |   2 +-
 drivers/input/keyboard/w90p910_keypad.c         |   2 +-
 drivers/input/mouse/pxa930_trkball.c            |   2 +-
 drivers/input/touchscreen/s3c2410_ts.c          |   2 +-
 drivers/leds/leds-netxbig.c                     |   2 +-
 drivers/leds/leds-ns2.c                         |   2 +-
 drivers/leds/leds-s3c24xx.c                     |   2 +-
 drivers/media/video/davinci/vpbe_venc.c         |   2 +-
 drivers/media/video/mx1_camera.c                |   2 +-
 drivers/media/video/mx2_camera.c                |   2 +-
 drivers/media/video/mx3_camera.c                |   4 +-
 drivers/media/video/pxa_camera.c                |   2 +-
 drivers/media/video/s5p-fimc/mipi-csis.c        |   2 +-
 drivers/mfd/mcp-sa11x0.c                        |   2 +-
 drivers/mmc/host/davinci_mmc.c                  |   2 +-
 drivers/mmc/host/msm_sdcc.c                     |   2 +-
 drivers/mmc/host/mvsdio.c                       |   2 +-
 drivers/mmc/host/mxcmmc.c                       |   4 +-
 drivers/mmc/host/pxamci.c                       |   2 +-
 drivers/mmc/host/s3cmci.c                       |   2 +-
 drivers/mmc/host/sdhci-esdhc-imx.c              |   2 +-
 drivers/mmc/host/sdhci-tegra.c                  |   3 +-
 drivers/mtd/nand/davinci_nand.c                 |   4 +-
 drivers/mtd/nand/mxc_nand.c                     |   2 +-
 drivers/mtd/nand/nomadik_nand.c                 |   2 +-
 drivers/mtd/nand/orion_nand.c                   |   2 +-
 drivers/mtd/nand/pxa3xx_nand.c                  |   2 +-
 drivers/mtd/nand/s3c2410.c                      |   2 +-
 drivers/net/ethernet/netx-eth.c                 |   2 +-
 drivers/net/irda/pxaficp_ir.c                   |  30 ++--
 drivers/pcmcia/pxa2xx_viper.c                   |   2 +-
 drivers/sh/pfc/gpio.c                           |   1 +
 drivers/spi/spi-davinci.c                       |   2 +-
 drivers/spi/spi-ep93xx.c                        |   4 +-
 drivers/spi/spi-imx.c                           |   2 +-
 drivers/spi/spi-nuc900.c                        |   2 +-
 drivers/spi/spi-s3c64xx.c                       |   2 +-
 .../ste_rmi4/board-mop500-u8500uib-rmi4.c       |   1 -
 drivers/tty/serial/imx.c                        |   2 +-
 drivers/usb/gadget/imx_udc.c                    |   2 +-
 drivers/usb/gadget/pxa27x_udc.c                 |   2 +-
 drivers/usb/gadget/s3c2410_udc.c                |   2 +-
 drivers/usb/host/ehci-mxc.c                     |   2 +-
 drivers/usb/host/ehci-orion.c                   |   2 +-
 drivers/usb/host/ehci-s5p.c                     |   2 +-
 drivers/usb/host/imx21-hcd.h                    |   2 +-
 drivers/usb/host/ohci-da8xx.c                   |   2 +-
 drivers/usb/host/ohci-exynos.c                  |   2 +-
 drivers/usb/host/ohci-pxa27x.c                  |   4 +-
 drivers/usb/host/ohci-s3c2410.c                 |   2 +-
 drivers/usb/musb/da8xx.c                        |   2 +-
 drivers/usb/musb/ux500_dma.c                    |   2 +-
 drivers/video/ep93xx-fb.c                       |   2 +-
 drivers/video/imxfb.c                           |   2 +-
 drivers/video/msm/mddi.c                        |   2 +-
 drivers/video/msm/mddi_client_dummy.c           |   2 +-
 drivers/video/msm/mddi_client_nt35399.c         |   2 +-
 drivers/video/msm/mddi_client_toshiba.c         |   2 +-
 drivers/video/msm/mdp.c                         |   2 +-
 drivers/video/msm/mdp_hw.h                      |   2 +-
 drivers/video/msm/mdp_ppp.c                     |   2 +-
 drivers/video/msm/msm_fb.c                      |   2 +-
 drivers/video/mx3fb.c                           |   4 +-
 drivers/video/nuc900fb.c                        |   2 +-
 drivers/video/nuc900fb.h                        |   2 +-
 drivers/video/pxafb.c                           |   2 +-
 drivers/video/vt8500lcdfb.c                     |   2 +-
 drivers/video/wm8505fb.c                        |   2 +-
 .../linux/platform_data/asoc-imx-ssi.h          |   0
 .../linux/platform_data/asoc-kirkwood.h         |   0
 .../linux/platform_data/asoc-palm27x.h          |   0
 .../linux/platform_data/asoc-s3c.h              |   0
 .../linux/platform_data/asoc-s3c24xx_simtec.h   |   0
 .../linux/platform_data/ata-pxa.h               |   0
 .../linux/platform_data/ata-samsung_cf.h        |   0
 include/linux/platform_data/atmel-aes.h         |   2 +-
 .../linux/platform_data/camera-mx1.h            |   0
 .../linux/platform_data/camera-mx2.h            |   0
 .../linux/platform_data/camera-mx3.h            |   0
 .../linux/platform_data/camera-pxa.h            |   0
 .../linux/platform_data}/crypto-ux500.h         |   0
 .../linux/platform_data/dma-atmel.h             |   0
 .../linux/platform_data/dma-ep93xx.h            |   0
 .../linux/platform_data/dma-imx-sdma.h          |   0
 .../linux/platform_data/dma-imx.h               |   0
 .../linux/platform_data/dma-mmp_tdma.h          |   0
 .../linux/platform_data/dma-mv_xor.h            |   0
 .../linux/platform_data/eth-netx.h              |   0
 .../linux/platform_data/hwmon-s3c.h             |   0
 .../linux/platform_data/i2c-davinci.h           |   0
 .../linux/platform_data/i2c-imx.h               |   0
 .../linux/platform_data/i2c-nuc900.h            |   0
 .../linux/platform_data/i2c-s3c2410.h           |   0
 .../linux/platform_data/irda-pxaficp.h          |   0
 .../platform_data/keyboard-pxa930_rotary.h      |   0
 .../linux/platform_data/keyboard-spear.h        |   0
 .../linux/platform_data/keypad-ep93xx.h         |   0
 .../linux/platform_data/keypad-nomadik-ske.h    |   0
 .../linux/platform_data/keypad-pxa27x.h         |   0
 .../linux/platform_data/keypad-w90p910.h        |   0
 .../linux/platform_data/keyscan-davinci.h       |   0
 .../linux/platform_data/leds-kirkwood-netxbig.h |   0
 .../linux/platform_data/leds-kirkwood-ns2.h     |   0
 .../linux/platform_data/leds-s3c24xx.h          |   0
 .../linux/platform_data/mfd-mcp-sa11x0.h        |   0
 .../linux/platform_data/mipi-csis.h             |   0
 .../linux/platform_data/mmc-davinci.h           |   0
 .../linux/platform_data/mmc-esdhc-imx.h         |   0
 .../linux/platform_data/mmc-msm_sdcc.h          |   0
 .../linux/platform_data/mmc-mvsdio.h            |   0
 .../linux/platform_data/mmc-mxcmmc.h            |   0
 .../linux/platform_data/mmc-pxamci.h            |   0
 .../linux/platform_data/mmc-s3cmci.h            |   0
 .../linux/platform_data/mmc-sdhci-tegra.h       |   6 +-
 .../linux/platform_data/mouse-pxa930_trkball.h  |   0
 .../linux/platform_data/mtd-davinci-aemif.h     |   0
 .../linux/platform_data/mtd-davinci.h           |   0
 .../linux/platform_data/mtd-mxc_nand.h          |   0
 .../linux/platform_data/mtd-nand-pxa3xx.h       |   0
 .../linux/platform_data/mtd-nand-s3c2410.h      |   0
 .../linux/platform_data/mtd-nomadik-nand.h      |   0
 .../linux/platform_data/mtd-orion_nand.h        |   0
 .../linux/platform_data/pcmcia-pxa2xx_viper.h   |   0
 .../linux/platform_data/serial-imx.h            |   0
 .../linux/platform_data/spi-davinci.h           |   0
 .../linux/platform_data/spi-ep93xx.h            |   0
 .../linux/platform_data/spi-imx.h               |   0
 .../linux/platform_data/spi-nuc900.h            |   0
 .../linux/platform_data/spi-s3c64xx.h           |   0
 .../linux/platform_data/touchscreen-s3c2410.h   |   0
 .../linux/platform_data/usb-davinci.h           |   0
 .../linux/platform_data/usb-ehci-mxc.h          |   0
 .../linux/platform_data/usb-ehci-orion.h        |   0
 .../linux/platform_data/usb-ehci-s5p.h          |   0
 .../linux/platform_data/usb-exynos.h            |   0
 .../linux/platform_data/usb-imx_udc.h           |   0
 .../linux/platform_data/usb-musb-ux500.h        |   0
 .../linux/platform_data/usb-mx2.h               |   0
 .../linux/platform_data/usb-ohci-pxa27x.h       |   0
 .../linux/platform_data/usb-ohci-s3c2410.h      |   0
 .../linux/platform_data/usb-pxa3xx-ulpi.h       |   0
 .../linux/platform_data/usb-s3c2410_udc.h       |   0
 .../linux/platform_data/video-ep93xx.h          |   0
 .../linux/platform_data/video-imxfb.h           |   0
 .../linux/platform_data/video-msm_fb.h          |   0
 .../linux/platform_data/video-mx3fb.h           |   0
 .../linux/platform_data/video-nuc900fb.h        |   0
 .../linux/platform_data/video-pxafb.h           |   0
 .../linux/platform_data/video-vt8500lcdfb.h     |   0
 sound/soc/ep93xx/ep93xx-ac97.c                  |   2 +-
 sound/soc/ep93xx/ep93xx-i2s.c                   |   2 +-
 sound/soc/ep93xx/ep93xx-pcm.c                   |   2 +-
 sound/soc/fsl/imx-pcm-dma.c                     |   2 +-
 sound/soc/fsl/imx-pcm-fiq.c                     |   2 +-
 sound/soc/fsl/imx-ssi.c                         |   2 +-
 sound/soc/fsl/imx-ssi.h                         |   2 +-
 sound/soc/kirkwood/kirkwood-i2s.c               |   2 +-
 sound/soc/kirkwood/kirkwood-openrd.c            |   2 +-
 sound/soc/kirkwood/kirkwood-t5325.c             |   2 +-
 sound/soc/pxa/palm27x.c                         |   2 +-
 sound/soc/samsung/ac97.c                        |   2 +-
 sound/soc/samsung/i2s.c                         |   2 +-
 sound/soc/samsung/pcm.c                         |   2 +-
 sound/soc/samsung/s3c24xx_simtec.c              |   2 +-
 sound/soc/samsung/spdif.c                       |   2 +-
 581 files changed, 1757 insertions(+), 1871 deletions(-)
 create mode 100644 arch/arm/boot/dts/Makefile
 create mode 100644 arch/arm/configs/multi_v7_defconfig
 rename arch/arm/{mach-highbank/include/mach/debug-macro.S => include/debug/highbank.S} (83%)
 create mode 100644 arch/arm/include/debug/icedcc.S
 rename arch/arm/{mach-mvebu/include/mach/debug-macro.S => include/debug/mvebu.S} (86%)
 rename arch/arm/{mach-picoxcell/include/mach/debug-macro.S => include/debug/picoxcell.S} (89%)
 rename arch/arm/{mach-socfpga/include/mach/debug-macro.S => include/debug/socfpga.S} (100%)
 rename arch/arm/{mach-vexpress/include/mach/debug-macro.S => include/debug/vexpress.S} (100%)
 delete mode 100644 arch/arm/mach-dove/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-ep93xx/include/mach/gpio.h
 create mode 100644 arch/arm/mach-highbank/Kconfig
 delete mode 100644 arch/arm/mach-highbank/Makefile.boot
 delete mode 100644 arch/arm/mach-highbank/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-highbank/include/mach/timex.h
 delete mode 100644 arch/arm/mach-highbank/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-ixp4xx/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-kirkwood/include/mach/gpio.h
 create mode 100644 arch/arm/mach-msm/core.h
 delete mode 100644 arch/arm/mach-msm/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-mvebu/Makefile.boot
 rename arch/arm/mach-mvebu/{include/mach => }/armada-370-xp.h (100%)
 delete mode 100644 arch/arm/mach-mvebu/include/mach/timex.h
 delete mode 100644 arch/arm/mach-mvebu/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-mxs/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-nomadik/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-orion5x/include/mach/gpio.h
 create mode 100644 arch/arm/mach-picoxcell/Kconfig
 delete mode 100644 arch/arm/mach-picoxcell/Makefile.boot
 delete mode 100644 arch/arm/mach-picoxcell/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-picoxcell/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-picoxcell/include/mach/map.h
 delete mode 100644 arch/arm/mach-picoxcell/include/mach/picoxcell_soc.h
 delete mode 100644 arch/arm/mach-picoxcell/include/mach/timex.h
 delete mode 100644 arch/arm/mach-picoxcell/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-realview/include/mach/gpio.h
 rename arch/arm/mach-shmobile/{include/mach/gpio.h => sh-gpio.h} (84%)
 create mode 100644 arch/arm/mach-socfpga/Kconfig
 delete mode 100644 arch/arm/mach-socfpga/Makefile.boot
 delete mode 100644 arch/arm/mach-socfpga/include/mach/timex.h
 delete mode 100644 arch/arm/mach-socfpga/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-spear13xx/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-spear3xx/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-spear6xx/include/mach/gpio.h
 create mode 100644 arch/arm/mach-tegra/common.h
 delete mode 100644 arch/arm/mach-tegra/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-u300/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-versatile/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-vexpress/Makefile.boot
 delete mode 100644 arch/arm/mach-vexpress/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-vexpress/include/mach/timex.h
 delete mode 100644 arch/arm/mach-vexpress/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-vt8500/include/mach/gpio.h
 delete mode 100644 arch/arm/plat-mxc/include/mach/gpio.h
 rename arch/arm/plat-orion/include/plat/{gpio.h => orion-gpio.h} (95%)
 delete mode 100644 arch/arm/plat-spear/include/plat/gpio.h
 create mode 100644 arch/arm/plat-versatile/include/plat/platsmp.h
 rename arch/arm/plat-mxc/include/mach/ssi.h => include/linux/platform_data/asoc-imx-ssi.h (100%)
 rename arch/arm/plat-orion/include/plat/audio.h => include/linux/platform_data/asoc-kirkwood.h (100%)
 rename arch/arm/mach-pxa/include/mach/palmasoc.h => include/linux/platform_data/asoc-palm27x.h (100%)
 rename arch/arm/plat-samsung/include/plat/audio.h => include/linux/platform_data/asoc-s3c.h (100%)
 rename arch/arm/plat-samsung/include/plat/audio-simtec.h => include/linux/platform_data/asoc-s3c24xx_simtec.h (100%)
 rename arch/arm/mach-pxa/include/mach/pata_pxa.h => include/linux/platform_data/ata-pxa.h (100%)
 rename arch/arm/plat-samsung/include/plat/ata.h => include/linux/platform_data/ata-samsung_cf.h (100%)
 rename arch/arm/plat-mxc/include/mach/mx1_camera.h => include/linux/platform_data/camera-mx1.h (100%)
 rename arch/arm/plat-mxc/include/mach/mx2_cam.h => include/linux/platform_data/camera-mx2.h (100%)
 rename arch/arm/plat-mxc/include/mach/mx3_camera.h => include/linux/platform_data/camera-mx3.h (100%)
 rename arch/arm/mach-pxa/include/mach/camera.h => include/linux/platform_data/camera-pxa.h (100%)
 rename {arch/arm/mach-ux500/include/mach => include/linux/platform_data}/crypto-ux500.h (100%)
 rename arch/arm/mach-at91/include/mach/at_hdmac.h => include/linux/platform_data/dma-atmel.h (100%)
 rename arch/arm/mach-ep93xx/include/mach/dma.h => include/linux/platform_data/dma-ep93xx.h (100%)
 rename arch/arm/plat-mxc/include/mach/sdma.h => include/linux/platform_data/dma-imx-sdma.h (100%)
 rename arch/arm/plat-mxc/include/mach/dma.h => include/linux/platform_data/dma-imx.h (100%)
 rename arch/arm/mach-mmp/include/mach/sram.h => include/linux/platform_data/dma-mmp_tdma.h (100%)
 rename arch/arm/plat-orion/include/plat/mv_xor.h => include/linux/platform_data/dma-mv_xor.h (100%)
 rename arch/arm/mach-netx/include/mach/eth.h => include/linux/platform_data/eth-netx.h (100%)
 rename arch/arm/plat-samsung/include/plat/hwmon.h => include/linux/platform_data/hwmon-s3c.h (100%)
 rename arch/arm/mach-davinci/include/mach/i2c.h => include/linux/platform_data/i2c-davinci.h (100%)
 rename arch/arm/plat-mxc/include/mach/i2c.h => include/linux/platform_data/i2c-imx.h (100%)
 rename arch/arm/mach-w90x900/include/mach/i2c.h => include/linux/platform_data/i2c-nuc900.h (100%)
 rename arch/arm/plat-samsung/include/plat/iic.h => include/linux/platform_data/i2c-s3c2410.h (100%)
 rename arch/arm/mach-pxa/include/mach/irda.h => include/linux/platform_data/irda-pxaficp.h (100%)
 rename arch/arm/mach-pxa/include/mach/pxa930_rotary.h => include/linux/platform_data/keyboard-pxa930_rotary.h (100%)
 rename arch/arm/plat-spear/include/plat/keyboard.h => include/linux/platform_data/keyboard-spear.h (100%)
 rename arch/arm/mach-ep93xx/include/mach/ep93xx_keypad.h => include/linux/platform_data/keypad-ep93xx.h (100%)
 rename arch/arm/plat-nomadik/include/plat/ske.h => include/linux/platform_data/keypad-nomadik-ske.h (100%)
 rename arch/arm/plat-pxa/include/plat/pxa27x_keypad.h => include/linux/platform_data/keypad-pxa27x.h (100%)
 rename arch/arm/mach-w90x900/include/mach/w90p910_keypad.h => include/linux/platform_data/keypad-w90p910.h (100%)
 rename arch/arm/mach-davinci/include/mach/keyscan.h => include/linux/platform_data/keyscan-davinci.h (100%)
 rename arch/arm/mach-kirkwood/include/mach/leds-netxbig.h => include/linux/platform_data/leds-kirkwood-netxbig.h (100%)
 rename arch/arm/mach-kirkwood/include/mach/leds-ns2.h => include/linux/platform_data/leds-kirkwood-ns2.h (100%)
 rename arch/arm/mach-s3c24xx/include/mach/leds-gpio.h => include/linux/platform_data/leds-s3c24xx.h (100%)
 rename arch/arm/mach-sa1100/include/mach/mcp.h => include/linux/platform_data/mfd-mcp-sa11x0.h (100%)
 rename arch/arm/plat-samsung/include/plat/mipi_csis.h => include/linux/platform_data/mipi-csis.h (100%)
 rename arch/arm/mach-davinci/include/mach/mmc.h => include/linux/platform_data/mmc-davinci.h (100%)
 rename arch/arm/plat-mxc/include/mach/esdhc.h => include/linux/platform_data/mmc-esdhc-imx.h (100%)
 rename arch/arm/mach-msm/include/mach/mmc.h => include/linux/platform_data/mmc-msm_sdcc.h (100%)
 rename arch/arm/plat-orion/include/plat/mvsdio.h => include/linux/platform_data/mmc-mvsdio.h (100%)
 rename arch/arm/plat-mxc/include/mach/mmc.h => include/linux/platform_data/mmc-mxcmmc.h (100%)
 rename arch/arm/mach-pxa/include/mach/mmc.h => include/linux/platform_data/mmc-pxamci.h (100%)
 rename arch/arm/plat-samsung/include/plat/mci.h => include/linux/platform_data/mmc-s3cmci.h (100%)
 rename arch/arm/mach-tegra/include/mach/sdhci.h => include/linux/platform_data/mmc-sdhci-tegra.h (84%)
 rename arch/arm/mach-pxa/include/mach/pxa930_trkball.h => include/linux/platform_data/mouse-pxa930_trkball.h (100%)
 rename arch/arm/mach-davinci/include/mach/aemif.h => include/linux/platform_data/mtd-davinci-aemif.h (100%)
 rename arch/arm/mach-davinci/include/mach/nand.h => include/linux/platform_data/mtd-davinci.h (100%)
 rename arch/arm/plat-mxc/include/mach/mxc_nand.h => include/linux/platform_data/mtd-mxc_nand.h (100%)
 rename arch/arm/plat-pxa/include/plat/pxa3xx_nand.h => include/linux/platform_data/mtd-nand-pxa3xx.h (100%)
 rename arch/arm/plat-samsung/include/plat/nand.h => include/linux/platform_data/mtd-nand-s3c2410.h (100%)
 rename arch/arm/mach-nomadik/include/mach/nand.h => include/linux/platform_data/mtd-nomadik-nand.h (100%)
 rename arch/arm/plat-orion/include/plat/orion_nand.h => include/linux/platform_data/mtd-orion_nand.h (100%)
 rename arch/arm/mach-pxa/include/mach/arcom-pcmcia.h => include/linux/platform_data/pcmcia-pxa2xx_viper.h (100%)
 rename arch/arm/plat-mxc/include/mach/imx-uart.h => include/linux/platform_data/serial-imx.h (100%)
 rename arch/arm/mach-davinci/include/mach/spi.h => include/linux/platform_data/spi-davinci.h (100%)
 rename arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h => include/linux/platform_data/spi-ep93xx.h (100%)
 rename arch/arm/plat-mxc/include/mach/spi.h => include/linux/platform_data/spi-imx.h (100%)
 rename arch/arm/mach-w90x900/include/mach/nuc900_spi.h => include/linux/platform_data/spi-nuc900.h (100%)
 rename arch/arm/plat-samsung/include/plat/s3c64xx-spi.h => include/linux/platform_data/spi-s3c64xx.h (100%)
 rename arch/arm/plat-samsung/include/plat/ts.h => include/linux/platform_data/touchscreen-s3c2410.h (100%)
 rename arch/arm/mach-davinci/include/mach/usb.h => include/linux/platform_data/usb-davinci.h (100%)
 rename arch/arm/plat-mxc/include/mach/mxc_ehci.h => include/linux/platform_data/usb-ehci-mxc.h (100%)
 rename arch/arm/plat-orion/include/plat/ehci-orion.h => include/linux/platform_data/usb-ehci-orion.h (100%)
 rename arch/arm/plat-samsung/include/plat/ehci.h => include/linux/platform_data/usb-ehci-s5p.h (100%)
 rename arch/arm/mach-exynos/include/mach/ohci.h => include/linux/platform_data/usb-exynos.h (100%)
 rename arch/arm/plat-mxc/include/mach/usb.h => include/linux/platform_data/usb-imx_udc.h (100%)
 rename arch/arm/mach-ux500/include/mach/usb.h => include/linux/platform_data/usb-musb-ux500.h (100%)
 rename arch/arm/plat-mxc/include/mach/mx21-usbhost.h => include/linux/platform_data/usb-mx2.h (100%)
 rename arch/arm/mach-pxa/include/mach/ohci.h => include/linux/platform_data/usb-ohci-pxa27x.h (100%)
 rename arch/arm/plat-samsung/include/plat/usb-control.h => include/linux/platform_data/usb-ohci-s3c2410.h (100%)
 rename arch/arm/mach-pxa/include/mach/pxa3xx-u2d.h => include/linux/platform_data/usb-pxa3xx-ulpi.h (100%)
 rename arch/arm/plat-samsung/include/plat/udc.h => include/linux/platform_data/usb-s3c2410_udc.h (100%)
 rename arch/arm/mach-ep93xx/include/mach/fb.h => include/linux/platform_data/video-ep93xx.h (100%)
 rename arch/arm/plat-mxc/include/mach/imxfb.h => include/linux/platform_data/video-imxfb.h (100%)
 rename arch/arm/mach-msm/include/mach/msm_fb.h => include/linux/platform_data/video-msm_fb.h (100%)
 rename arch/arm/plat-mxc/include/mach/mx3fb.h => include/linux/platform_data/video-mx3fb.h (100%)
 rename arch/arm/mach-w90x900/include/mach/fb.h => include/linux/platform_data/video-nuc900fb.h (100%)
 rename arch/arm/mach-pxa/include/mach/pxafb.h => include/linux/platform_data/video-pxafb.h (100%)
 rename arch/arm/mach-vt8500/include/mach/vt8500fb.h => include/linux/platform_data/video-vt8500lcdfb.h (100%)
