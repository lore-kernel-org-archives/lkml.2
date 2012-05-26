Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab2EZHYy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 03:24:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52354 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab2EZHXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 03:23:04 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: =?UTF-8?q?=5BGIT=20PULL=202/8=5D=20arm-soc=3A=20driver=20specific=20updates?=
Date: Sat, 26 May 2012 00:22:32 -0700
Message-Id: <1338016958-7887-3-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1338016958-7887-1-git-send-email-olof@lixom.net>
References: <1338016958-7887-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes are specific to some driver that may be used by multiple
boards or socs. The most significant change in here is the move of the
samsung iommu code from a platform specific in-kernel interface to the
generic iommu subsystem.

----------------------------------------------------------------

The following changes since commit cfda982fa8b2affe2b42ab5bb7d5737736fa8caf:

  Merge tag 'defconfig' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/drivers

for you to fetch changes up to 046fae440d32cc6dec8148c7e06a8b4b987f8a2f:

  Merge branch 'next/devel-samsung-iommu' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into next/drivers

----------------------------------------------------------------

Allen Martin (1):
      ARM: tegra: Add pllc clock init table

Arnd Bergmann (7):
      Merge branch 'keyboard' of git://github.com/hzhuang1/linux into next/drivers
      Merge branch 'next/cleanup-samsung-iommu' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge branch 'omap/dt-missed-3.4' into drivers/mmc
      mmc: dt: Consolidate DT bindings
      Merge branch 'for-3.5/ahb' of git://git.kernel.org/.../swarren/linux-tegra into next/drivers
      Merge branch 'drivers/mmc' into next/drivers
      Merge branch 'next/devel-samsung-iommu' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers

Chao Xie (4):
      Input: pxa27x_keypad keep clock on as wakeup source
      Input: pxa27x_keypad bug fix for direct_key_mask
      Input: pxa27x_keypad direct key may be low active
      Input: pxa27x_keypad add choice to set direct_key_mask

Hiroshi DOYU (2):
      ARM: tegra: Add Tegra AHB driver
      ARM: tegra: Add SMMU enabler in AHB

KyongHo Cho (3):
      S5P: SYSMMU: Remove System MMU device driver
      ARM: EXYNOS: Change System MMU platform device definitions
      iommu/exynos: Add iommu driver for EXYNOS Platforms

Olof Johansson (5):
      Merge branch 'for-3.5/usb-ulpi' of git://git.kernel.org/.../swarren/linux-tegra into next/drivers
      Merge branch 'for-3.5/tegra30-audio' of git://git.kernel.org/.../swarren/linux-tegra into next/drivers
      Merge branch 'for-3.5/debug' of git://git.kernel.org/.../swarren/linux-tegra into next/drivers
      Merge tag 'v3.5-soc' of git://gitorious.org/linux-davinci/linux-davinci into next/drivers
      Merge tag 'ep93xx-fixes-for-3.5' of git://github.com/RyanMallon/linux-ep93xx into next/drivers

Peter De Schrijver (1):
      ARM: tegra: Initialize pll_p_out1

Rafal Prylowski (2):
      arm: ep93xx: Don't try to release not acquired GPIO lines
      dmaengine/ep93xx_dma: Implement double buffering for M2M DMA channels

Sebastian Andrzej Siewior (1):
      ARM: davinci: optimize the DMA ISR

Stephen Warren (12):
      ARM: tegra: uncompress.h: Implement TEGRA_DEBUG_UART_AUTO_ODMDATA
      ARM: tegra: provide clock aliases for AHUB configlink
      ARM: tegra: set up audio clocks for tegra30 dt
      ARM: tegra: add AUXDATA required for audio
      ARM: dt: tegra30.dtsi: Add audio-related nodes
      ARM: dt: tegra cardhu: basic audio support
      ARM: tegra: reparent sclk to pll_c_out1
      ARM: tegra: fix pclk rate
      ARM: tegra: change pll_p_out4's rate to 24MHz
      ARM: tegra: don't hard-code USB ULPI PHY reset_gpio
      ARM: tegra: add USB ULPI PHY reset GPIO to device tree
      ARM: dt: tegra: pinmux changes for USB ULPI

Uwe Kleine-König (1):
      ARM: davinci: implement DEBUG_LL port choice


 .../bindings/arm/tegra/nvidia,tegra20-ahb.txt   |   11 +
 .../devicetree/bindings/mmc/fsl-esdhc.txt       |    6 +-
 .../devicetree/bindings/mmc/fsl-imx-esdhc.txt   |    2 +-
 .../devicetree/bindings/mmc/mmc-spi-slot.txt    |    3 +-
 Documentation/devicetree/bindings/mmc/mmc.txt   |   27 +
 .../devicetree/bindings/mmc/nvidia-sdhci.txt    |    4 +-
 .../devicetree/bindings/mmc/ti-omap-hsmmc.txt   |    4 +-
 .../devicetree/bindings/usb/tegra-usb.txt       |    3 +
 arch/arm/Kconfig.debug                          |   29 +
 arch/arm/boot/dts/imx53-smd.dts                 |    4 +-
 arch/arm/boot/dts/imx6q-arm2.dts                |    2 +-
 arch/arm/boot/dts/omap3-beagle.dts              |    2 +-
 arch/arm/boot/dts/omap4-panda.dts               |    4 +-
 arch/arm/boot/dts/omap4-sdp.dts                 |    6 +-
 arch/arm/boot/dts/tegra-cardhu.dts              |   65 ++
 arch/arm/boot/dts/tegra-harmony.dts             |   26 +-
 arch/arm/boot/dts/tegra-paz00.dts               |   20 +-
 arch/arm/boot/dts/tegra-seaboard.dts            |    6 +
 arch/arm/boot/dts/tegra-trimslice.dts           |   22 +-
 arch/arm/boot/dts/tegra-ventana.dts             |    6 +
 arch/arm/boot/dts/tegra30.dtsi                  |   41 +
 arch/arm/mach-davinci/dma.c                     |   69 +-
 .../arm/mach-davinci/include/mach/debug-macro.S |   58 +-
 arch/arm/mach-davinci/include/mach/hardware.h   |    2 +-
 arch/arm/mach-davinci/include/mach/serial.h     |   10 -
 arch/arm/mach-davinci/include/mach/uncompress.h |   30 +-
 arch/arm/mach-ep93xx/core.c                     |    2 +-
 arch/arm/mach-exynos/Kconfig                    |   10 +-
 arch/arm/mach-exynos/Makefile                   |    2 +-
 arch/arm/mach-exynos/clock-exynos4.c            |   79 +-
 arch/arm/mach-exynos/clock-exynos4.h            |    2 +
 arch/arm/mach-exynos/clock-exynos4210.c         |   11 +
 arch/arm/mach-exynos/clock-exynos4212.c         |   28 +-
 arch/arm/mach-exynos/clock-exynos5.c            |   90 ++
 arch/arm/mach-exynos/dev-sysmmu.c               |  457 ++++----
 arch/arm/mach-exynos/include/mach/irqs.h        |   25 +-
 arch/arm/mach-exynos/include/mach/map.h         |   38 +
 arch/arm/mach-exynos/include/mach/regs-clock.h  |    5 +
 arch/arm/mach-exynos/include/mach/regs-sysmmu.h |   28 -
 arch/arm/mach-exynos/include/mach/sysmmu.h      |   88 +-
 arch/arm/mach-exynos/mach-armlex4210.c          |    1 -
 arch/arm/mach-exynos/mach-smdkv310.c            |    1 -
 arch/arm/mach-tegra/Kconfig                     |   37 +-
 arch/arm/mach-tegra/board-dt-tegra30.c          |   10 +
 arch/arm/mach-tegra/board-paz00.c               |    3 +-
 arch/arm/mach-tegra/board-trimslice.c           |    2 +
 arch/arm/mach-tegra/common.c                    |   22 +-
 arch/arm/mach-tegra/devices.c                   |    5 +-
 arch/arm/mach-tegra/devices.h                   |    4 +
 arch/arm/mach-tegra/include/mach/tegra-ahb.h    |   19 +
 arch/arm/mach-tegra/include/mach/uncompress.h   |  176 ++-
 arch/arm/mach-tegra/include/mach/usb_phy.h      |    4 +-
 arch/arm/mach-tegra/tegra2_clocks.c             |    4 +
 arch/arm/mach-tegra/tegra30_clocks.c            |    9 +
 arch/arm/mach-tegra/usb_phy.c                   |   15 +-
 arch/arm/plat-pxa/include/plat/pxa27x_keypad.h  |    4 +
 arch/arm/plat-s5p/Kconfig                       |    8 -
 arch/arm/plat-s5p/Makefile                      |    1 -
 arch/arm/plat-s5p/sysmmu.c                      |  313 -----
 arch/arm/plat-samsung/include/plat/devs.h       |    1 -
 arch/arm/plat-samsung/include/plat/sysmmu.h     |   95 --
 arch/powerpc/boot/dts/mpc8569mds.dts            |    1 +
 drivers/Makefile                                |    2 +-
 drivers/amba/Makefile                           |    4 +-
 drivers/amba/tegra-ahb.c                        |  293 +++++
 drivers/dma/ep93xx_dma.c                        |  117 +-
 drivers/input/keyboard/pxa27x_keypad.c          |   52 +-
 drivers/iommu/Kconfig                           |   21 +
 drivers/iommu/Makefile                          |    1 +
 drivers/iommu/exynos-iommu.c                    | 1076 ++++++++++++++++++
 drivers/mmc/host/omap_hsmmc.c                   |    2 +-
 drivers/mmc/host/sdhci-esdhc-imx.c              |    2 +-
 drivers/mmc/host/sdhci-pltfm.c                  |    8 +-
 drivers/usb/host/ehci-tegra.c                   |    5 +-
 74 files changed, 2630 insertions(+), 1015 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-ahb.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/mmc.txt
 delete mode 100644 arch/arm/mach-exynos/include/mach/regs-sysmmu.h
 create mode 100644 arch/arm/mach-tegra/include/mach/tegra-ahb.h
 delete mode 100644 arch/arm/plat-s5p/sysmmu.c
 delete mode 100644 arch/arm/plat-samsung/include/plat/sysmmu.h
 create mode 100644 drivers/amba/tegra-ahb.c
 create mode 100644 drivers/iommu/exynos-iommu.c
