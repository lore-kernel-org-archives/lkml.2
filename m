Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab2LMB5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 20:57:14 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55771 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab2LMB5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 20:57:10 -0500
Date: Wed, 12 Dec 2012 17:57:09 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: [GIT PULL 3/5] ARM: arm-soc: power management and clock changes
Message-ID: <20121213015709.GC28281@quad.lixom.net>
References: <20121213015543.GA18953@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213015543.GA18953@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This branch contains a largeish set of updates of power management and
clock setup. The bulk of it is for OMAP/AM33xx platforms, but also a
few around hotplug/suspend/resume on Exynos.

It includes a split-up of some of the OMAP clock data into separate
files which adds to the diffstat, but gross delta is fairly reasonable.

Conflicts seen with this merge:

None

----------------------------------------------------------------

The following changes since commit 348064b46c96ab3012427a080340e81f617a94f5:

  Merge branch 'next/multiplatform' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/pm-merge

for you to fetch changes up to 9c7466b217af784280d9fc841bbd559ef3bf33e9:

  ARM: arm-soc: Merge branch 'next/pm2' into next/pm

----------------------------------------------------------------

Abhilash Kesavan (3):
      ARM: EXYNOS: fix the hotplug for Cortex-A15
      ARM: EXYNOS: Remove scu_enable from cpuidle
      ARM: EXYNOS: Add flush_cache_all in suspend finisher

Arnd Bergmann (3):
      Merge tag 'omap-for-v3.8/pm-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/pm
      Merge tag 'omap-for-v3.8/clock-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/clk
      Merge tag 'omap-for-v3.8/pm-part2-v3-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/pm

Inderpal Singh (2):
      ARM: EXYNOS: Add support for rtc wakeup
      ARM: EXYNOS: Fix soft reboot hang after suspend/resume

Jean Pihet (2):
      ARM: OMAP: hwmod: align the SmartReflex fck names
      ARM: OMAP: SmartReflex: pass device dependent data via platform data

Kevin Hilman (1):
      ARM: OMAP2+: voltage: fixup oscillator handling when CONFIG_PM=n

Mike Turquette (3):
      ARM: OMAP4: clock: Convert to common clk
      ARM: OMAP2+: clockdomain: bypass clockdomain handling when disabling unused clks
      ARM: OMAP2+: clock: Cleanup !CONFIG_COMMON_CLK parts

Nishanth Menon (2):
      ARM: OMAP2+: PM: VP: minor pr_warn updates
      ARM: OMAP3+: PM: VP: use uV for max and min voltage limits

Olof Johansson (7):
      Merge branch 'next/cleanup' into next/pm2
      Merge branch 'next/dt' into next/pm2
      Merge tag 'omap-for-v3.8/devel-prcm-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/pm2
      Merge branch 'next/pm-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/pm
      Merge tag 'tags/omap-for-v3.8/cleanup-multiplatform-no-clock-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/pm2
      ARM: arm-soc: Merge branch 'next/clk' into next/pm
      ARM: arm-soc: Merge branch 'next/pm2' into next/pm

Paul Walmsley (8):
      ARM: OMAP2xxx: clock: add APLL rate recalculation functions
      ARM: OMAP2+: clock: add OMAP CCF convenience macros to mach-omap2/clock.h
      ARM: OMAP44xx: clock: drop obsolete clock data
      ARM: OMAP3xxx: clk: drop obsolete clock data
      ARM: AM33xx: clock: drop obsolete clock data
      ARM: OMAP3+: DPLL: drop !CONFIG_COMMON_CLK sections
      ARM: OMAP2xxx: clock: drop obsolete clock data
      ARM: OMAP2+: PRM: initialize some PRM functions early

Peter Ujfalusi (2):
      ARM: OMAP2+: hwmod: Add possibility to count hwmod resources based on type
      ARM: OMAP2+: omap_device: Correct resource handling for DT boot

Rajendra Nayak (17):
      ARM: OMAP4: suspend: Program all domains to retention
      ARM: OMAP: clock: Nuke plat/clock.c & reuse struct clk as clk_hw_omap
      ARM: OMAP: hwmod: Fix up hwmod based clkdm accesses
      ARM: OMAP3: clock: Convert to common clk
      ARM: OMAP2: clock: Convert to common clk
      ARM: OMAP: clock: list all clk_hw_omap clks to enable/disable autoidle
      ARM: OMAP: clock: Define a function to enable clocks at init
      ARM: OMAP: clock: Get rid of some clkdm assocations within clks
      ARM: OMAP4: clock: Add 44xx data using common struct clk
      ARM: OMAP3: clock: Add 3xxx data using common struct clk
      ARM: OMAP2: clock: Add 24xx data using common struct clk
      ARM: OMAP: clock: Switch to COMMON clk
      ARM: OMAP: hwmod: Cleanup !CONFIG_COMMON_CLK parts
      ARM: OMAP4: clock: Cleanup !CONFIG_COMMON_CLK parts
      ARM: OMAP3: clock: Cleanup !CONFIG_COMMON_CLK parts
      ARM: OMAP2: clock: Cleanup !CONFIG_COMMON_CLK parts
      ARM: OMAP2+: hwmod: Add support for per hwmod/module context lost count

Tero Kristo (14):
      ARM: OMAP: voltage: renamed vp_vddmin and vp_vddmax fields
      ARM: OMAP3+: voltage: introduce omap vc / vp params for voltagedomains
      ARM: OMAP3: VC: calculate ramp times
      ARM: OMAP4: voltage: add support for VOLTSETUP_x_OFF register
      ARM: OMAP4: VC: calculate ramp times
      ARM: OMAP: add support for oscillator setup
      ARM: OMAP3+: vp: use new vp_params for calculating vddmin and vddmax
      ARM: OMAP3+: voltage: use oscillator data to calculate setup times
      ARM: OMAP: TWL: change the vddmin / vddmax voltages to spec
      ARM: OMAP3+: voltage: remove unused volt_setup_time parameter
      ARM: OMAP4: vc: fix channel configuration
      ARM: OMAP4: VC: setup I2C parameters based on board data
      ARM: OMAP4: TWL: enable high speed mode for PMIC communication
      ARM: OMAP4: USB: power down MUSB PHY during boot

Tony Lindgren (12):
      Merge tag 'for_3.8-cleanup-pm' of git://git.kernel.org/.../khilman/linux-omap-pm into omap-for-v3.8/pm
      Merge tag 'for_3.8-pm-sr' of git://git.kernel.org/.../khilman/linux-omap-pm into omap-for-v3.8/pm
      Merge tag 'for_3.8-pm-voltage' of git://git.kernel.org/.../khilman/linux-omap-pm into omap-for-v3.8/pm
      Merge branch 'omap-for-v3.8/pm' into omap-for-v3.8/clock
      Merge tag 'omap-cleanup-c-for-3.8' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.8/clock
      Merge tag 'for_3.8-pm-omap4-core-ret' of git://git.kernel.org/.../khilman/linux-omap-pm into omap-for-v3.8/pm-part2
      Merge branch 'omap-for-v3.8/pm' into omap-for-v3.8/pm-part2
      Merge tag 'omap-devel-a-for-3.8' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.8/devel-pcrm
      Merge tag 'tags/omap-for-v3.8/devel-prcm-signed' into omap-for-v3.8/cleanup-headers-prepare-multiplatform-v3
      watchdog: OMAP: fixup for ARM multiplatform support
      ASoC: OMAP: mcbsp fixes for enabling ARM multiplatform support
      ARM: OMAP: Move plat-omap/dma-omap.h to include/linux/omap-dma.h

Vaibhav Hiremath (2):
      ARM: OMAP2+: hwmod: Invoke init_clkdm before other init functions
      ARM: AM33XX: clock: add clock data in common clock format

Vishwanath Sripathy (1):
      ARM: OMAP4: OPP: add OMAP4460 definitions


 arch/arm/mach-exynos/common.c                   |    2 +
 arch/arm/mach-exynos/cpuidle.c                  |    3 +-
 arch/arm/mach-exynos/hotplug.c                  |   45 +-
 arch/arm/mach-exynos/pm.c                       |    7 +
 arch/arm/mach-omap1/board-h2.c                  |    2 +-
 arch/arm/mach-omap1/board-h3.c                  |    2 +-
 arch/arm/mach-omap1/board-palmte.c              |    2 +-
 arch/arm/mach-omap1/board-palmtt.c              |    2 +-
 arch/arm/mach-omap1/board-palmz71.c             |    2 +-
 arch/arm/mach-omap1/board-sx1.c                 |    2 +-
 arch/arm/mach-omap1/dma.c                       |    2 +-
 arch/arm/mach-omap1/io.c                        |    2 +-
 arch/arm/mach-omap1/lcd_dma.c                   |    2 +-
 arch/arm/mach-omap1/mcbsp.c                     |    2 +-
 arch/arm/mach-omap1/pm.c                        |    2 +-
 arch/arm/mach-omap2/Kconfig                     |    5 +
 arch/arm/mach-omap2/Makefile                    |   10 +-
 arch/arm/mach-omap2/board-3430sdp.c             |    2 +-
 arch/arm/mach-omap2/board-h4.c                  |    2 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c    |    2 +-
 arch/arm/mach-omap2/board-rx51.c                |    2 +-
 arch/arm/mach-omap2/cclock2420_data.c           | 1950 ++++++++++
 arch/arm/mach-omap2/cclock2430_data.c           | 2065 ++++++++++
 arch/arm/mach-omap2/cclock33xx_data.c           |  961 +++++
 arch/arm/mach-omap2/cclock3xxx_data.c           | 3595 +++++++++++++++++
 arch/arm/mach-omap2/cclock44xx_data.c           | 1987 ++++++++++
 arch/arm/mach-omap2/clkt2xxx_apll.c             |   62 +-
 arch/arm/mach-omap2/clkt2xxx_dpll.c             |    8 +-
 arch/arm/mach-omap2/clkt2xxx_dpllcore.c         |   13 +-
 arch/arm/mach-omap2/clkt2xxx_osc.c              |   13 +-
 arch/arm/mach-omap2/clkt2xxx_sys.c              |    7 +-
 arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c    |    9 +-
 arch/arm/mach-omap2/clkt34xx_dpll3m2.c          |    8 +-
 arch/arm/mach-omap2/clkt_clksel.c               |  194 +-
 arch/arm/mach-omap2/clkt_dpll.c                 |   28 +-
 arch/arm/mach-omap2/clkt_iclk.c                 |   30 +-
 arch/arm/mach-omap2/clock.c                     |  910 ++---
 arch/arm/mach-omap2/clock.h                     |  329 +-
 arch/arm/mach-omap2/clock2420_data.c            | 1972 ----------
 arch/arm/mach-omap2/clock2430.c                 |    8 +-
 arch/arm/mach-omap2/clock2430_data.c            | 2071 ----------
 arch/arm/mach-omap2/clock2xxx.c                 |    1 +
 arch/arm/mach-omap2/clock2xxx.h                 |   41 +-
 arch/arm/mach-omap2/clock33xx_data.c            | 1109 ------
 arch/arm/mach-omap2/clock34xx.c                 |   51 +-
 arch/arm/mach-omap2/clock3517.c                 |   24 +-
 arch/arm/mach-omap2/clock36xx.c                 |   22 +-
 arch/arm/mach-omap2/clock36xx.h                 |    2 +-
 arch/arm/mach-omap2/clock3xxx.c                 |    6 +-
 arch/arm/mach-omap2/clock3xxx.h                 |    6 +-
 arch/arm/mach-omap2/clock3xxx_data.c            | 3613 ------------------
 arch/arm/mach-omap2/clock44xx_data.c            | 3398 ----------------
 arch/arm/mach-omap2/clock_common_data.c         |   22 +-
 arch/arm/mach-omap2/clockdomain.c               |   89 +-
 arch/arm/mach-omap2/cm-regbits-24xx.h           |    5 +
 arch/arm/mach-omap2/cm-regbits-34xx.h           |   31 +
 arch/arm/mach-omap2/cm2xxx_3xxx.h               |    1 +
 arch/arm/mach-omap2/control.h                   |    1 +
 arch/arm/mach-omap2/devices.c                   |    2 +-
 arch/arm/mach-omap2/dma.c                       |    2 +-
 arch/arm/mach-omap2/dpll3xxx.c                  |  183 +-
 arch/arm/mach-omap2/dpll44xx.c                  |   21 +-
 arch/arm/mach-omap2/io.c                        |   18 +-
 arch/arm/mach-omap2/mcbsp.c                     |    2 +-
 arch/arm/mach-omap2/omap_device.c               |   87 +-
 arch/arm/mach-omap2/omap_hwmod.c                |  145 +-
 arch/arm/mach-omap2/omap_hwmod.h                |   12 +-
 arch/arm/mach-omap2/omap_hwmod_2420_data.c      |    4 +-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c      |    4 +-
 .../omap_hwmod_2xxx_3xxx_ipblock_data.c         |    3 +-
 .../mach-omap2/omap_hwmod_2xxx_ipblock_data.c   |    2 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c      |    2 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c      |    3 +-
 arch/arm/mach-omap2/omap_opp_data.h             |    9 +-
 arch/arm/mach-omap2/omap_phy_internal.c         |   32 +
 arch/arm/mach-omap2/omap_twl.c                  |   73 +-
 arch/arm/mach-omap2/opp4xxx_data.c              |   98 +-
 arch/arm/mach-omap2/pm.c                        |   32 +
 arch/arm/mach-omap2/pm.h                        |   10 +
 arch/arm/mach-omap2/pm24xx.c                    |    6 +-
 arch/arm/mach-omap2/pm34xx.c                    |    3 +-
 arch/arm/mach-omap2/pm44xx.c                    |    7 -
 arch/arm/mach-omap2/prm-regbits-24xx.h          |    2 +
 arch/arm/mach-omap2/prm-regbits-34xx.h          |    1 +
 arch/arm/mach-omap2/prm.h                       |   11 +-
 arch/arm/mach-omap2/prm2xxx.c                   |    3 +-
 arch/arm/mach-omap2/prm2xxx.h                   |    3 +-
 arch/arm/mach-omap2/prm2xxx_3xxx.h              |    1 +
 arch/arm/mach-omap2/prm3xxx.c                   |   17 +-
 arch/arm/mach-omap2/prm3xxx.h                   |    1 +
 arch/arm/mach-omap2/prm44xx.c                   |   49 +-
 arch/arm/mach-omap2/prm44xx.h                   |    1 +
 arch/arm/mach-omap2/prm_common.c                |   45 +
 arch/arm/mach-omap2/scrm44xx.h                  |    2 +
 arch/arm/mach-omap2/serial.c                    |    2 +-
 arch/arm/mach-omap2/sr_device.c                 |   13 +
 arch/arm/mach-omap2/vc.c                        |  453 ++-
 arch/arm/mach-omap2/vc.h                        |    8 +-
 arch/arm/mach-omap2/vc3xxx_data.c               |   22 +
 arch/arm/mach-omap2/vc44xx_data.c               |   28 +
 arch/arm/mach-omap2/voltage.h                   |   44 +-
 arch/arm/mach-omap2/voltagedomains3xxx_data.c   |    5 +
 arch/arm/mach-omap2/voltagedomains44xx_data.c   |   25 +-
 arch/arm/mach-omap2/vp.c                        |   19 +-
 arch/arm/mach-omap2/vp.h                        |    7 +
 arch/arm/mach-omap2/vp3xxx_data.c               |   10 +
 arch/arm/mach-omap2/vp44xx_data.c               |   15 +
 arch/arm/plat-omap/dma.c                        |    2 +-
 arch/arm/plat-omap/include/plat-omap/dma-omap.h |  377 --
 arch/arm/plat-samsung/include/plat/pm.h         |    2 +
 drivers/crypto/omap-aes.c                       |    2 +-
 drivers/crypto/omap-sham.c                      |    2 +-
 drivers/dma/omap-dma.c                          |    2 -
 drivers/media/platform/omap/omap_vout.c         |    2 +-
 drivers/media/platform/omap/omap_vout_vrfb.c    |    2 +-
 drivers/media/platform/omap3isp/ispstat.h       |    2 +-
 .../media/platform/soc_camera/omap1_camera.c    |    2 +-
 drivers/mtd/nand/omap2.c                        |    1 -
 drivers/mtd/onenand/omap2.c                     |    2 +-
 drivers/power/avs/smartreflex.c                 |   54 +-
 drivers/usb/gadget/omap_udc.c                   |    2 +-
 drivers/usb/musb/tusb6010_omap.c                |    2 +-
 drivers/video/omap/lcdc.c                       |    2 +-
 drivers/video/omap/omapfb_main.c                |    2 +-
 drivers/video/omap/sossi.c                      |    2 +-
 drivers/watchdog/omap_wdt.c                     |    2 -
 include/linux/omap-dma.h                        |  366 ++
 include/linux/power/smartreflex.h               |   14 +-
 sound/soc/omap/mcbsp.c                          |    4 +-
 sound/soc/omap/mcbsp.h                          |    6 +
 sound/soc/omap/omap-mcbsp.c                     |    5 +-
 131 files changed, 13015 insertions(+), 14135 deletions(-)
 create mode 100644 arch/arm/mach-omap2/cclock2420_data.c
 create mode 100644 arch/arm/mach-omap2/cclock2430_data.c
 create mode 100644 arch/arm/mach-omap2/cclock33xx_data.c
 create mode 100644 arch/arm/mach-omap2/cclock3xxx_data.c
 create mode 100644 arch/arm/mach-omap2/cclock44xx_data.c
 delete mode 100644 arch/arm/mach-omap2/clock2420_data.c
 delete mode 100644 arch/arm/mach-omap2/clock2430_data.c
 delete mode 100644 arch/arm/mach-omap2/clock33xx_data.c
 delete mode 100644 arch/arm/mach-omap2/clock3xxx_data.c
 delete mode 100644 arch/arm/mach-omap2/clock44xx_data.c
 delete mode 100644 arch/arm/plat-omap/include/plat-omap/dma-omap.h
