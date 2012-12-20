Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab2LTQpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 11:45:22 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44491 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2LTQpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 11:45:17 -0500
Date: Thu, 20 Dec 2012 08:38:14 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tony@atomide.com,
        maxime.ripard@free-electrons.com
Subject: [GIT PULL v2] ARM: arm-soc fixes for 3.8
Message-ID: <20121220163814.GA29557@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

One of the sunxi patches from the last pull request was misapplied (I
realized what happened -- git am -s didn't apply cleanly so I had done it
through regular patch, thus not catching the renames properly). Here's
a fresh version of the pull request with a couple more OMAP and Samsung
patches included.

There's a chance that a couple of the OMAP patches will also go in through
Russell, since my connectivity has been crap so far this trip and it
causes build breaks for the platform. It's a branch pull from Tony,
it should be a no-op either way.


-Olof

The following changes since commit f01af9f85855e38fbd601e033a8eac204cc4cc1c:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc (2012-12-19 20:31:02 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes

for you to fetch changes up to ae66ba6f15c4f20b5b613d9c494c56f67ddb70a8:

  Merge branch 'v3.8-samsung-fixes-audio' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into fixes (2012-12-20 08:07:52 -0800)

----------------------------------------------------------------

ARM: arm-soc fixes for 3.8

This is a batch of fixes for arm-soc platforms. Most of it is for OMAP
but there are others too (Samsung, i.MX, Tegra, ep93xx). Fixes warnings,
some broken platforms and drivers, etc.

So, a bit all over the map really.

----------------------------------------------------------------
Axel Lin (1):
      pinctrl: exynos5440/samsung: Staticize pcfgs

Dongjin Kim (1):
      ARM: EXYNOS: Fix MSHC clocks instance names

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

Kukjin Kim (3):
      ARM: EXYNOS: fix build error when MFC is not selected
      ARM: EXYNOS: fix GIC using for EXYNOS5440
      ARM: EXYNOS: fix skip scu_enable() for EXYNOS5440

Linus Walleij (2):
      ARM: u300: delete custom pin hog code
      ARM: ux500: fix missing include

Maxime Ripard (1):
      ARM: sunxi: Change device tree naming scheme for sunxi

Michael Spang (1):
      ARM: SAMSUNG: Add missing include guard to gpio-core.h

Oleg Matcovschi (1):
      OMAP2+: mux: Fixed gpio mux mode analysis

Olof Johansson (10):
      ARM: exynos: Fix warning due to missing 'inline' in stub
      ARM: davinci: fix build break due to missing include
      Merge tag 'tegra-for-3.8-fixes-for-rc1' of git://git.kernel.org/.../swarren/linux-tegra into fixes
      Merge tag 'omap-fixes-a-for-v3.8-window' of git://git.kernel.org/.../pjw/omap-pending into fixes
      Merge tag 'omap-for-v3.8/fixes-for-merge-window-v4-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'imx-fixes-rc' of git://git.pengutronix.de/git/imx/linux-2.6 into fixes
      Merge tag 'ep93xx-fixes-for-3.8' of git://github.com/RyanMallon/linux-ep93xx into fixes
      Merge tag 'omap-for-v3.8/fixes-for-merge-window-part2-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge branch 'v3.8-samsung-fixes-1' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge branch 'v3.8-samsung-fixes-audio' of git://git.kernel.org/.../kgene/linux-samsung into fixes

Padmavathi Venna (5):
      ARM: S3C64XX: Add I2S clkdev support
      ARM: S5PC100: Add I2S clkdev support
      ARM: S5P64X0: Add I2S clkdev support
      ARM: S5PV210: Avoid passing the clks through platform data
      ARM: EXYNOS: Avoid passing the clks through platform data

Paul Walmsley (3):
      ARM: OMAP4: clock data: div_iva_hs_clk is a power-of-two divider
      ARM: OMAP4: clock data: DPLLs are missing bypass clocks in their parent lists
      ARM: OMAP3/4: cpuidle: fix sparse and checkpatch warnings

Peter Ujfalusi (1):
      ARM: OMAP2+: Fix compillation error in mach-omap2/timer.c

Roger Quadros (1):
      mfd: omap-usb-host: get rid of cpu_is_omap..() macros

Sachin Kamat (4):
      pinctrl: samsung: Fix a typo in pinctrl-samsung.h
      ARM: EXYNOS: Fix NULL pointer dereference bug in Origen
      ARM: EXYNOS: Fix NULL pointer dereference bug in SMDK4X12
      ARM: EXYNOS: Fix NULL pointer dereference bug in SMDKV310

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

Vaibhav Bedia (1):
      ARM: OMAP: Fix build breakage due to missing include in i2c.c

Vaibhav Hiremath (1):
      ARM: OMAP2+: Fix sparse warnings in timer.c

 arch/arm/boot/dts/Makefile                         |   5 +-
 arch/arm/boot/dts/imx27-3ds.dts                    |   8 +-
 arch/arm/boot/dts/imx27-phytec-phycore.dts         |  13 ++-
 arch/arm/boot/dts/imx27.dtsi                       |  11 +-
 arch/arm/boot/dts/omap2420-h4.dts                  |   2 +-
 ...n4i-cubieboard.dts => sun4i-a10-cubieboard.dts} |   4 +-
 arch/arm/boot/dts/{sun4i.dtsi => sun4i-a10.dtsi}   |   0
 ...sun5i-olinuxino.dts => sun5i-a13-olinuxino.dts} |   4 +-
 arch/arm/boot/dts/{sun5i.dtsi => sun5i-a13.dtsi}   |   0
 arch/arm/mach-davinci/board-da850-evm.c            |   1 +
 arch/arm/mach-ep93xx/include/mach/uncompress.h     |  10 +-
 arch/arm/mach-exynos/clock-exynos4.c               |   4 +-
 arch/arm/mach-exynos/common.c                      |   3 +-
 arch/arm/mach-exynos/common.h                      |   2 +-
 arch/arm/mach-exynos/dev-audio.c                   |  12 --
 arch/arm/mach-exynos/mach-exynos5-dt.c             |   2 +
 arch/arm/mach-exynos/mach-origen.c                 |   4 +-
 arch/arm/mach-exynos/mach-smdk4x12.c               |   4 +-
 arch/arm/mach-exynos/mach-smdkv310.c               |   4 +-
 arch/arm/mach-exynos/platsmp.c                     |   2 +-
 arch/arm/mach-imx/clk-imx51-imx53.c                |  16 +++
 .../devices/platform-mx2-emma.c                    |   4 +-
 arch/arm/mach-omap2/Kconfig                        |   3 +-
 arch/arm/mach-omap2/board-3430sdp.c                |   1 +
 arch/arm/mach-omap2/board-am3517evm.c              |   1 +
 arch/arm/mach-omap2/board-cm-t35.c                 |   1 +
 arch/arm/mach-omap2/board-devkit8000.c             |   1 +
 arch/arm/mach-omap2/board-h4.c                     |  83 ++++----------
 arch/arm/mach-omap2/board-omap3evm.c               |   1 +
 arch/arm/mach-omap2/board-omap3stalker.c           |   1 +
 arch/arm/mach-omap2/cclock44xx_data.c              |  78 ++++++++++---
 arch/arm/mach-omap2/clock.h                        |  10 ++
 arch/arm/mach-omap2/clockdomain.c                  |   3 +-
 arch/arm/mach-omap2/common.c                       |   3 -
 arch/arm/mach-omap2/cpuidle34xx.c                  |  14 ++-
 arch/arm/mach-omap2/cpuidle44xx.c                  |  28 +++--
 arch/arm/mach-omap2/dpll3xxx.c                     |  46 +++++---
 arch/arm/mach-omap2/dpll44xx.c                     |  64 +++++++++--
 arch/arm/mach-omap2/i2c.c                          |   1 +
 arch/arm/mach-omap2/mux.c                          |  10 +-
 arch/arm/mach-omap2/mux.h                          |  20 +++-
 arch/arm/mach-omap2/mux34xx.c                      |   2 +-
 arch/arm/mach-omap2/serial.c                       |   3 +-
 arch/arm/mach-omap2/timer.c                        |   8 +-
 arch/arm/mach-omap2/usb-host.c                     |   4 +
 arch/arm/mach-s3c64xx/clock.c                      | 126 +++++++++++++--------
 arch/arm/mach-s3c64xx/dev-audio.c                  |  11 --
 arch/arm/mach-s5p64x0/clock-s5p6440.c              |  49 +++++---
 arch/arm/mach-s5p64x0/clock-s5p6450.c              |  61 ++++++----
 arch/arm/mach-s5p64x0/dev-audio.c                  |  12 --
 arch/arm/mach-s5pc100/clock.c                      |  48 +++++---
 arch/arm/mach-s5pc100/dev-audio.c                  |  16 ---
 arch/arm/mach-s5pv210/dev-audio.c                  |  16 ---
 arch/arm/mach-tegra/common.c                       |   2 +-
 arch/arm/mach-tegra/tegra30_clocks.c               |   4 +-
 arch/arm/mach-u300/core.c                          |  34 ------
 arch/arm/mach-ux500/devices-db8500.h               |   1 +
 arch/arm/plat-omap/Makefile                        |   1 -
 arch/arm/plat-omap/debug-devices.c                 |  92 ---------------
 arch/arm/plat-omap/include/plat/debug-devices.h    |   2 -
 arch/arm/plat-samsung/include/plat/gpio-core.h     |   5 +
 drivers/amba/tegra-ahb.c                           |   2 +
 drivers/mfd/omap-usb-host.c                        |   3 +-
 drivers/pinctrl/pinctrl-exynos5440.c               |   2 +-
 drivers/pinctrl/pinctrl-samsung.c                  |   2 +-
 drivers/pinctrl/pinctrl-samsung.h                  |   2 +-
 drivers/tty/serial/omap-serial.c                   |   3 +-
 .../linux/platform_data/serial-omap.h              |   0
 include/linux/platform_data/usb-omap.h             |   3 +
 include/video/omap-panel-tfp410.h                  |   2 +-
 70 files changed, 513 insertions(+), 487 deletions(-)
 rename arch/arm/boot/dts/{sun4i-cubieboard.dts => sun4i-a10-cubieboard.dts} (87%)
 rename arch/arm/boot/dts/{sun4i.dtsi => sun4i-a10.dtsi} (100%)
 rename arch/arm/boot/dts/{sun5i-olinuxino.dts => sun5i-a13-olinuxino.dts} (86%)
 rename arch/arm/boot/dts/{sun5i.dtsi => sun5i-a13.dtsi} (100%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-mx2-emma.c (94%)
 delete mode 100644 arch/arm/plat-omap/debug-devices.c
 delete mode 100644 arch/arm/plat-omap/include/plat/debug-devices.h
 rename arch/arm/plat-omap/include/plat/omap-serial.h => include/linux/platform_data/serial-omap.h (100%)
