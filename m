Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2LRGzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 01:55:05 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:58147 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab2LRGzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 01:55:03 -0500
Date: Mon, 17 Dec 2012 22:55:02 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org
Subject: [GIT PULL] ARM: arm-soc fixes for 3.8
Message-ID: <20121218065502.GA12865@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,


The following changes since commit fa4c95bfdb85d568ae327d57aa33a4f55bab79c4:

  Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs (2012-12-17 08:27:59 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes

for you to fetch changes up to 4d1839138220e7e35bf9e31c854e4e0196dea7a1:

  Merge tag 'ep93xx-fixes-for-3.8' of git://github.com/RyanMallon/linux-ep93xx into fixes (2012-12-17 18:42:30 -0800)

----------------------------------------------------------------

ARM: arm-soc fixes for 3.8

This is a batch of fixes for arm-soc platforms, most of it is for OMAP
but there are others too (i.MX, Tegra, ep93xx). Fixes warnings, some
broken platforms and drivers, etc. A bit all over the map really.

----------------------------------------------------------------
Fabio Estevam (2):
      ARM: dts: mx27: Fix the AIPI bus for FEC
      ARM: imx: Move platform-mx2-emma to arch/arm/mach-imx/devices

Florian Fainelli (1):
      ARM: ep93xx: properly wait for UART FIFO to be empty

Hiroshi Doyu (1):
      amba: tegra-ahb: Fix warning w/o PM_SLEEP

Javier Martinez Canillas (1):
      ARM: OMAP2+: common: remove use of vram

Jon Hunter (11):
      ARM: OMAP2+: Fix realtime_counter_init warning in timer.c
      ARM: AM335x: Fix warning in timer.c
      ARM: OMAP2420: Fix ethernet support for OMAP2420 H4
      ARM: OMAP: Remove debug-devices.c
      ARM: dts: OMAP2420: Correct H4 board memory size
      ARM: dts: Add build target for omap4-panda-a4
      ARM: OMAP4: Update timer clock aliases
      ARM: OMAP4: Add function table for non-M4X dplls
      ARM: OMAP4: Enhance support for DPLLs with 4X multiplier
      ARM: OMAP4460: Workaround ABE DPLL failing to turn-on
      ARM: OMAP4: Fix EMU clock domain always on

Linus Walleij (2):
      ARM: u300: delete custom pin hog code
      ARM: ux500: fix missing include

Maxime Ripard (1):
      ARM: sunxi: Change device tree naming scheme for sunxi

Oleg Matcovschi (1):
      OMAP2+: mux: Fixed gpio mux mode analysis

Olof Johansson (7):
      ARM: exynos: Fix warning due to missing 'inline' in stub
      ARM: davinci: fix build break due to missing include
      Merge tag 'tegra-for-3.8-fixes-for-rc1' of git://git.kernel.org/.../swarren/linux-tegra into fixes
      Merge tag 'omap-fixes-a-for-v3.8-window' of git://git.kernel.org/.../pjw/omap-pending into fixes
      Merge tag 'omap-for-v3.8/fixes-for-merge-window-v4-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'imx-fixes-rc' of git://git.pengutronix.de/git/imx/linux-2.6 into fixes
      Merge tag 'ep93xx-fixes-for-3.8' of git://github.com/RyanMallon/linux-ep93xx into fixes

Paul Walmsley (3):
      ARM: OMAP4: clock data: div_iva_hs_clk is a power-of-two divider
      ARM: OMAP4: clock data: DPLLs are missing bypass clocks in their parent lists
      ARM: OMAP3/4: cpuidle: fix sparse and checkpatch warnings

Roger Quadros (1):
      mfd: omap-usb-host: get rid of cpu_is_omap..() macros

Sascha Hauer (1):
      ARM i.MX51 clock: Fix regression since enabling MIPI/HSP clocks

Sivaram Nair (2):
      ARM: tegra: select correct parent clk for pll_p
      ARM: tegra: fix comment in dsib clk set_parent

Tomi Valkeinen (1):
      OMAP: board-files: fix i2c_bus for tfp410

Tony Lindgren (3):
      Merge branch 'fixes-timer-build' of git://github.com/jonhunter/linux into omap-for-v3.8/fixes-for-merge-window
      ARM: OMAP: Move plat/omap-serial.h to include/linux/platform_data/serial-omap.h
      Merge branch 'omap-for-v3.8/fixes-for-merge-window' into omap-for-v3.8/fixes-for-merge-window-v2

Vaibhav Hiremath (1):
      ARM: OMAP2+: Fix sparse warnings in timer.c

 arch/arm/boot/dts/Makefile                         |  5 +-
 arch/arm/boot/dts/imx27-3ds.dts                    |  8 +-
 arch/arm/boot/dts/imx27-phytec-phycore.dts         | 13 +--
 arch/arm/boot/dts/imx27.dtsi                       | 11 ++-
 arch/arm/boot/dts/omap2420-h4.dts                  |  2 +-
 arch/arm/boot/dts/sun4i-cubieboard.dts             |  4 +-
 arch/arm/boot/dts/sun5i-olinuxino.dts              |  4 +-
 arch/arm/mach-davinci/board-da850-evm.c            |  1 +
 arch/arm/mach-ep93xx/include/mach/uncompress.h     | 10 +--
 arch/arm/mach-exynos/common.h                      |  2 +-
 arch/arm/mach-imx/clk-imx51-imx53.c                | 16 ++++
 .../devices/platform-mx2-emma.c                    |  4 +-
 arch/arm/mach-omap2/Kconfig                        |  3 +-
 arch/arm/mach-omap2/board-3430sdp.c                |  1 +
 arch/arm/mach-omap2/board-am3517evm.c              |  1 +
 arch/arm/mach-omap2/board-cm-t35.c                 |  1 +
 arch/arm/mach-omap2/board-devkit8000.c             |  1 +
 arch/arm/mach-omap2/board-h4.c                     | 83 +++++--------------
 arch/arm/mach-omap2/board-omap3evm.c               |  1 +
 arch/arm/mach-omap2/board-omap3stalker.c           |  1 +
 arch/arm/mach-omap2/cclock44xx_data.c              | 78 +++++++++++++++---
 arch/arm/mach-omap2/clock.h                        | 10 +++
 arch/arm/mach-omap2/clockdomain.c                  |  3 +-
 arch/arm/mach-omap2/common.c                       |  3 -
 arch/arm/mach-omap2/cpuidle34xx.c                  | 14 ++--
 arch/arm/mach-omap2/cpuidle44xx.c                  | 28 ++++---
 arch/arm/mach-omap2/dpll3xxx.c                     | 46 +++++++----
 arch/arm/mach-omap2/dpll44xx.c                     | 64 ++++++++++++---
 arch/arm/mach-omap2/mux.c                          | 10 +--
 arch/arm/mach-omap2/mux.h                          | 20 +++--
 arch/arm/mach-omap2/mux34xx.c                      |  2 +-
 arch/arm/mach-omap2/serial.c                       |  3 +-
 arch/arm/mach-omap2/timer.c                        |  6 +-
 arch/arm/mach-omap2/usb-host.c                     |  4 +
 arch/arm/mach-tegra/common.c                       |  2 +-
 arch/arm/mach-tegra/tegra30_clocks.c               |  4 +-
 arch/arm/mach-u300/core.c                          | 34 --------
 arch/arm/mach-ux500/devices-db8500.h               |  1 +
 arch/arm/plat-omap/Makefile                        |  1 -
 arch/arm/plat-omap/debug-devices.c                 | 92 ----------------------
 arch/arm/plat-omap/include/plat/debug-devices.h    |  2 -
 drivers/amba/tegra-ahb.c                           |  2 +
 drivers/mfd/omap-usb-host.c                        |  3 +-
 drivers/tty/serial/omap-serial.c                   |  3 +-
 .../linux/platform_data/serial-omap.h              |  0
 include/linux/platform_data/usb-omap.h             |  3 +
 include/video/omap-panel-tfp410.h                  |  2 +-
 47 files changed, 308 insertions(+), 304 deletions(-)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-mx2-emma.c (94%)
 delete mode 100644 arch/arm/plat-omap/debug-devices.c
 delete mode 100644 arch/arm/plat-omap/include/plat/debug-devices.h
 rename arch/arm/plat-omap/include/plat/omap-serial.h => include/linux/platform_data/serial-omap.h (100%)
