Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab2DFEqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 00:46:52 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55706 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab2DFEqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 00:46:51 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
Date: Thu, 5 Apr 2012 21:46:50 -0700
Message-ID: <CAOesGMhiSpKEPkmJuXqFZBnx7mNpCLEcTQ2ALeCcq3Cy-0d3xQ@mail.gmail.com>
Subject: [GIT PULL] ARM: SoC fixes
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,


The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
tags/fixes-for-linus

for you to fetch changes up to a8f5b6e5ef0faf64997bfa87698aaabc989e64c4:

  Merge tag 'omap-fixes-a2-for-3.4rc' of
git://git.kernel.org/pub/scm/linux/kernel/git/pjw/omap-pending into
fixes (2012-04-05 17:09:45 -0700)

----------------------------------------------------------------

ARM: SoC fixes for 3.4-rc2

A bunch of fixes for regressions (and a few other problems) in 3.4-rc1:

* Fix for regression of mach/io.h cleanup on platforms with PCI or PCMCIA
  (adding back the include file on those for now)
* AT91 fixes for usb and spi
* smsc911x ethernet fixes for i.MX
* smsc911x fixes for OMAP
* gpio fixes for Tegra
* A handful of build error and warning fixes for various platforms
* cpufreq kconfig dependencies, build and lowlevel debug fixes for
  Samsung platforms

In other words, more or less the regular collection of -rc1/2 type
material. A few of them, in particular the smsc911x for OMAP series, aren't
technically regressions for 3.4, but they're valid fixes and we're still
relatively early in the rc cycle so it seems appropriate to include them.

----------------------------------------------------------------
Ameya Palande (1):
      ARM: OMAP4: clock data: fix mult and div mask for USB_DPLL

Colin Cross (1):
      ARM: EXYNOS: fix CONFIG_DEBUG_LL

Dima Zavin (1):
      ARM: EXYNOS: use chip_id reg in uncompress to select uart base phys

Fabio Estevam (8):
      ARM: mach-mx35_3ds: Fix build warning due to the lack of 'const'
annotation
      ARM: 3ds_debugboard: Fix smsc911x driver probe
      ARM: mx35: Fix registration of camera clock
      ARM: mx53ard: Fix smsc911x driver probe
      ARM: mx31lite: Fix smsc911x driver probe
      ARM: mx31lilly: Fix smsc911x driver probe
      ARM: kzm_arm11_01: Fix smsc911x driver probe
      ARM: armadillo5x0: Fix smsc911x driver probe

Govindraj.R (1):
      ARM: OMAP2+: omap_hwmod: Allow io_ring wakeup configuration for
all modules

Grazvydas Ignotas (2):
      ARM: OMAP3xxx: HSMMC: avoid erratum workaround when transceiver
is attached
      ARM: OMAP3xxx: clock data: fix DPLL4 CLKSEL masks

Igor Grinberg (1):
      ARM: OMAP: fix section mismatches in usb-host.c

Il Han (1):
      ARM: EXYNOS: fix ISO C90 warning

Ilya Yanok (1):
      ARM: OMAP AM3517/3505: clock data: change EMAC clocks aliases

Javier Martin (1):
      MX2: Fix mx2_camera clock regression.

Kukjin Kim (2):
      ARM: S3C24XX: fix missing common.h in mach-s3c24xx/
      EXYNOS: fix dependency for EXYNOS_CPUFREQ

Ludovic Desroches (1):
      ARM: at91: dt: remove unit-address part for memory nodes

Mark A. Greer (2):
      arm: omap3: pm34xx.c: Fix omap3_pm_init() error out paths
      arm: omap3: pm34xx.c: Replace printk() with appropriate pr_*()

Ming Lei (1):
      ARM: OMAP3+: fix oops triggered in omap_prcm_register_chain_handler(v1)

Nicolas Ferre (11):
      ARM: at91/at91sam9x5: add clkdev entries for DMA controllers
      USB: ohci-at91: fix vbus_pin_active_low handling
      ARM: at91/USB host: specify and handle properly vbus_pin_active_low
      ARM: at91/dts: USB host vbus is active low
      USB: ohci-at91: rework and fix initialization
      USB: ohci-at91: change maximum number of ports
      USB: ohci-at91: trivial return code name change
      ARM: at91/at91sam9x5.dtsi: fix NAND ale/cle in DT file
      ARM: at91/NAND DT bindings: add comments
      USB: ehci-atmel: add needed of.h header file
      ARM: at91: fix check of valid GPIO for SPI and USB

Nishanth Menon (2):
      ARM: OMAP2+: OPP: allow OPP enumeration to continue if device is
not present
      ARM: OMAP: clock: fix race in disable all clocks

Olof Johansson (7):
      Merge tag 'v3.4-rc1-imx-fixes' of
git://git.pengutronix.de/git/imx/linux-2.6 into fixes
      Merge branch 'for-3.4/fixes-for-rc2' of
git://git.kernel.org/.../swarren/linux-tegra into fixes
      Merge branch 'at91-fixes' of
git://github.com/at91linux/linux-at91 into fixes
      Merge branch 'fixes' of
git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge branch 'v3.4-cpufreq-exynos-fixes' of
git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge branch 'v3.4-samsung-fixes-1' of
git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge tag 'omap-fixes-a2-for-3.4rc' of
git://git.kernel.org/.../pjw/omap-pending into fixes

Paul Gortmaker (2):
      ARM: versatile: fix build failure in pci.c
      ARM: fix lcd power build failure in collie_defconfig

Paul Walmsley (4):
      ARM: OMAP44xx: clockdomain data: correct the emu_sys_clkdm CLKTRCTRL data
      ARM: OMAP4: hwmod data: Add aliases for McBSP fclk clocks
      ARM: OMAP3: clock data: fill in some missing clockdomains
      Merge branches 'clock_fixes_3.4rc', 'clockdomain_fixes_3.4rc',
'hsmmc_erratum_2_1_1_128_refine_3.4rc1', 'hwmod_data_fixes_a_3.4rc',
'hwmod_fixes_a2_3.4rc' and 'powerdomain_fixes_a_3.4rc' into
omap-fixes-a2-for-3.4rc-branch

R Sricharan (1):
      ARM: OMAP2+: Fix omap2+ build error

Rajendra Nayak (4):
      ARM: OMAP: hwmod: Use sysc_fields->srst_shift and get rid of
hardcoded SYSC_TYPE2_SOFTRESET_MASK
      ARM: OMAP4: clock data: Force a DPLL clkdm/pwrdm ON before a relock
      ARM: OMAP2+: hwmod: Restore sysc after a reset
      ARM: OMAP2+: hwmod: Make omap_hwmod_softreset wait for reset status

Rob Herring (1):
      ARM: fix __io macro for PCMCIA

Russ Dill (5):
      ARM: OMAP2+: smsc911x: Remove odd gpmc_cfg/board_data redirection
      ARM: OMAP2+ smsc911x: Fix possible stale smsc911x flags
      ARM: OMAP2+: smsc911x: Remove unused rate calculation
      ARM: OMAP2+: smsc911x: Remove regulator support from gmpc-smsc911x
      ARM: OMAP2+: smsc911x: Add fixed board regulators

Sachin Kamat (1):
      ARM: EXYNOS: Fix compiler warning in dma.c file

Santosh Shilimkar (2):
      ARM: OMAP4: Workaround the OCP synchronisation issue with 32K synctimer.
      ARM: OMAP2+: powerdomain: Wait for powerdomain transition in
pwrdm_state_switch()

Stephen Warren (2):
      gpio: tegra: fix register address calculations for Tegra30
      gpio: tegra: Iterate over the correct number of banks

Tero Kristo (1):
      ARM: OMAP4: prm: fix interrupt register offsets

Tony Lindgren (3):
      Merge branch 'misc_devel_3.4' of git://git.pwsan.com/linux-2.6 into fixes
      Merge branch 'fixes-smsc911x' into fixes
      Merge branch 'for_3.4/fixes/pm' of
git://git.kernel.org/.../khilman/linux-omap-pm into fixes

Vaibhav Hiremath (1):
      ARM: OMAP2+: hwmod: Fix wrong SYSC_TYPE1_XXX_MASK bit definitions

 .../devicetree/bindings/mtd/atmel-nand.txt         |   10 +-
 arch/arm/Kconfig                                   |    1 +
 arch/arm/boot/dts/at91sam9g20.dtsi                 |    2 +-
 arch/arm/boot/dts/at91sam9g25ek.dts                |    4 +-
 arch/arm/boot/dts/at91sam9g45.dtsi                 |    2 +-
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |    6 +-
 arch/arm/boot/dts/at91sam9x5.dtsi                  |    6 +-
 arch/arm/boot/dts/at91sam9x5cm.dtsi                |    2 +-
 arch/arm/boot/dts/usb_a9g20.dts                    |    2 +-
 arch/arm/include/asm/barrier.h                     |    2 +-
 arch/arm/include/asm/io.h                          |    2 +-
 arch/arm/mach-at91/at91sam9260_devices.c           |    3 +
 arch/arm/mach-at91/at91sam9261_devices.c           |    3 +
 arch/arm/mach-at91/at91sam9263_devices.c           |    6 +-
 arch/arm/mach-at91/at91sam9g45_devices.c           |   11 +-
 arch/arm/mach-at91/at91sam9rl_devices.c            |    3 +
 arch/arm/mach-at91/at91sam9x5.c                    |    2 +
 arch/arm/mach-at91/board-sam9263ek.c               |    1 +
 arch/arm/mach-at91/board-sam9m10g45ek.c            |    1 +
 arch/arm/mach-at91/include/mach/board.h            |   13 +-
 arch/arm/mach-at91/include/mach/io.h               |   27 ++++
 arch/arm/mach-exynos/common.c                      |    3 +-
 arch/arm/mach-exynos/dma.c                         |    2 -
 arch/arm/mach-exynos/include/mach/debug-macro.S    |    7 +-
 arch/arm/mach-exynos/include/mach/uncompress.h     |   17 +-
 arch/arm/mach-imx/clock-imx27.c                    |    1 +
 arch/arm/mach-imx/clock-imx35.c                    |    2 +-
 arch/arm/mach-imx/mach-armadillo5x0.c              |    9 ++
 arch/arm/mach-imx/mach-kzm_arm11_01.c              |    9 ++
 arch/arm/mach-imx/mach-mx31lilly.c                 |    9 ++
 arch/arm/mach-imx/mach-mx31lite.c                  |    9 ++
 arch/arm/mach-imx/mach-mx35_3ds.c                  |    2 +-
 arch/arm/mach-imx/mach-mx53_ard.c                  |    8 +
 arch/arm/mach-omap1/include/mach/io.h              |   45 ++++++
 arch/arm/mach-omap2/board-cm-t35.c                 |   16 ++
 arch/arm/mach-omap2/board-igep0020.c               |    6 +
 arch/arm/mach-omap2/board-ldp.c                    |    7 +
 arch/arm/mach-omap2/board-omap3evm.c               |   15 +-
 arch/arm/mach-omap2/board-omap3logic.c             |    7 +
 arch/arm/mach-omap2/board-omap3stalker.c           |   16 +-
 arch/arm/mach-omap2/board-overo.c                  |    8 +
 arch/arm/mach-omap2/board-zoom-debugboard.c        |    9 ++
 arch/arm/mach-omap2/clock3xxx_data.c               |   18 ++-
 arch/arm/mach-omap2/clock44xx_data.c               |    5 +-
 arch/arm/mach-omap2/clockdomains44xx_data.c        |    2 +-
 arch/arm/mach-omap2/gpmc-smsc911x.c                |   65 +-------
 arch/arm/mach-omap2/hsmmc.c                        |    7 +
 arch/arm/mach-omap2/omap_hwmod.c                   |   96 ++++++------
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   28 ++++
 arch/arm/mach-omap2/opp.c                          |    4 +-
 arch/arm/mach-omap2/pm34xx.c                       |   38 ++---
 arch/arm/mach-omap2/pm44xx.c                       |   10 +-
 arch/arm/mach-omap2/powerdomain.c                  |    8 +-
 arch/arm/mach-omap2/prm44xx.c                      |   21 +--
 arch/arm/mach-omap2/prm_common.c                   |    2 +-
 arch/arm/mach-omap2/usb-host.c                     |   10 +-
 arch/arm/mach-pxa/Kconfig                          |    1 +
 arch/arm/mach-pxa/include/mach/io.h                |   17 ++
 arch/arm/mach-s3c24xx/common.h                     |   18 +++
 arch/arm/mach-sa1100/collie.c                      |    4 +
 arch/arm/mach-sa1100/include/mach/collie.h         |    3 +-
 arch/arm/mach-versatile/pci.c                      |   10 +-
 arch/arm/plat-mxc/3ds_debugboard.c                 |    2 +-
 arch/arm/plat-omap/Kconfig                         |    1 +
 arch/arm/plat-omap/clock.c                         |    5 +-
 arch/arm/plat-omap/include/plat/omap_hwmod.h       |   12 +-
 drivers/cpufreq/Kconfig.arm                        |   10 +-
 drivers/gpio/gpio-tegra.c                          |   59 +++++--
 drivers/usb/host/ehci-atmel.c                      |    1 +
 drivers/usb/host/ohci-at91.c                       |  163 +++++++++++---------
 drivers/video/backlight/locomolcd.c                |    9 +-
 71 files changed, 603 insertions(+), 342 deletions(-)
 create mode 100644 arch/arm/mach-at91/include/mach/io.h
 create mode 100644 arch/arm/mach-omap1/include/mach/io.h
 create mode 100644 arch/arm/mach-pxa/include/mach/io.h
 create mode 100644 arch/arm/mach-s3c24xx/common.h
