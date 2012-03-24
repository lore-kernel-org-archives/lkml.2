Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab2CXWDz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 18:03:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58864 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab2CXWDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 18:03:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 02/09] ARM: global cleanups
Date: Sat, 24 Mar 2012 22:02:39 +0000
Message-Id: <1332626568-17812-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332626568-17812-1-git-send-email-arnd@arndb.de>
References: <1332626568-17812-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:alVV5kenyGZJxCRr1mqKG7bdemERADzwHBqlfqnC6iw
 0a0zIPBRx6IA7V8k4okHj8BO6sKVhoNXP5tx5JkmzIqJ71ghGc
 cdnTAUsextbJzhvWSjVZ40BejO3gyxii16LVY3sdVWUMAPksyi
 gQ3+z7LaTGojdhZNH3Ejxqbc2DnWMv1RVB1YWE2KAzuety8QWq
 ke+kEDKf+7fIasLuz0bsvb5V2hzJUoj080+ECNFkFOzvLiIn8v
 bKyoCdlU5qim4hCu/J3/V7cpTMBKe5ySPrAmGalMmxU4bDOUDs
 T9t8e+sklg6GMPUTJQqA5Y1UoWVGH1bzvHv5FMAFtbnmASy25I
 xvirO/F5fIYvIM18SLGP6rNP9ryJnqp4MuFoARE2k1ab8F0QSV
 mCNUOm4ykr4UA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quite a bit of code gets removed, and some stuff moved around, mostly
the old samsung s3c24xx stuff. There should be no functional changes in
this series otherwise. Some cleanups have dependencies on other arm-soc
branches and will be sent in the second round.

The at91cap9 platform is removed and no longer listed in
Documentation/feature-removal-schedule.txt, which conflicts with two
new entries in that file.

arch/arm/plat-mxc/audmux-v1.c was removed, so the changes to its comments
are meaningless now.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

The following changes since commit "b4dfcf6 Merge branch 'next/cleanup'
into for-next", leading up to commit " 4fbd069 Merge branch
'omap/fixes-non-critical-part2' into ne", are available in

git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup

Arnd Bergmann (14):
      Merge branch 'imx-cleanup' of git://git.pengutronix.de/git/imx/linux-2.6 into next/cleanup
      ARM: davinci: add back dummy header files
      Merge branch 'davinci/cleanups' into next/cleanup
      Merge branch 'cleanup-3.4' of git://github.com/hzhuang1/linux into next/cleanup
      Merge branch 'cleanup' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge branch 'depends/omap/gpio/runtime-pm-cleanup' into next/cleanup
      ARM: tegra: select CPU_FREQ_TABLE
      ARM: tegra: build localtimer support only when needed
      ARM: tegra: export usb phy symbols
      Merge tag 'tegra-cleanups' of git://git.kernel.org/.../olof/tegra into tegra/cleanups
      Merge branch 'ep93xx-for-arm-soc' of git://github.com/RyanMallon/linux-2.6 into next/cleanup
      Merge branch 'for-3.4' of git://gitorious.org/linux-omap-dss2/linux into next/cleanup
      Merge branch 'omap/fixes-non-critical-part2' into next/cleanup
      Merge branch 'next/cleanup' into for-next

Daniel Lezcano (4):
      ARM: at91: coding style fixes
      ARM: at91: declare header name
      ARM: at91: remove wait_for_interrupt definition
      ARM: at91: implement the standby function for pm/cpuidle

Fabio Estevam (2):
      ARM: plat-mxc: audmux-v1: Remove unneeded ifdef's
      ARM: mx3: Let mx31 and mx35 share the same CCM header file

H Hartley Sweeten (1):
      ep93xx: Convert the watchdog driver into a platform device.

Haojian Zhuang (2):
      rtc: sa1100: remove periodic code
      rtc: sa1100: remove verification code of alarm

Heiko Stuebner (17):
      ARM: S3C24XX: remove unused spi gpio setup functions
      ARM: S3C24XX: move spi-s3c24xx platdata out of mach
      ARM: S3C24XX: Remove extern declaration of clk_msysclk
      ARM: S3C24XX: move common S3C2443 clock definitions to clock.h
      ARM: S3C2410: move s3c2410_baseclk_add to clock.h
      ARM: S3C24XX: Move s3c2443-clock.c to mach-s3c24xx
      ARM: S3C24XX: Move common-smdk code to mach directory
      ARM: S3C24XX: move simtec-specific code to mach directory
      ARM: S3C24XX: Consolidate Simtec extensions
      ARM: S3C24XX: Move device setup files to mach directory
      ARM: S3C24XX: Fix indentation of dma-s3c2443
      ARM: S3C24XX: Reuse S3C2443 dma for S3C2416
      ARM: S3C24XX: remove obsolete S3C2416_DMA option
      ARM: S3C24XX: remove XXX_setup_clocks method from S3C2443
      ARM: S3C24XX: add get_rate for clk_h on S3C2416/2443
      ARM: S3C24XX: add get_rate for clk_p on S3C2416/2443
      ARM: S3C24XX: remove call to s3c24xx_setup_clocks

Jaecheol Lee (1):
      ARM: EXYNOS: add clock registers for exynos4x12-cpufreq

Jarkko Nikula (1):
      ARM: OMAP: McSPI: Remove unused flag from struct omap2_mcspi_device_config

Jean Pihet (1):
      ARM: OMAP2+: PM debug: fix the use of debugfs_create_* API

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: code removal of CAP9 SoC

Jesper Juhl (1):
      ARM: Remove redundant ';' from avic_irq_set_priority()

Kevin Hilman (2):
      Merge remote-tracking branch 'omap/hsmmc' into for_3.4/cleanup/pm-base
      ARM: OMAP: omap_device: remove omap_device_parent

Kukjin Kim (21):
      ARM: EXYNOS: use static declaration when it is not used in other files
      ARM: S3C24XX: use static declaration when it is not used in other files
      ARM: S3C64XX: use static declaration when it is not used in other files
      ARM: S5P64X0: use static declaration when it is not used in other files
      ARM: S5PC100: use static declaration when it is not used in other files
      ARM: S5PV210: use static declaration when it is not used in other files
      ARM: SAMSUNG: use static declaration when it is not used in other files
      ARM: S3C24XX: change the ARCH_S3C2410 to ARCH_S3C24XX
      ARM: S3C2410: move mach-s3c2410/* into mach-s3c24xx/
      ARM: S3C2412: move mach-s3c2412/* into mach-s3c24xx/
      ARM: S3C2416: move mach-s3c2416/* into mach-s3c24xx/
      ARM: S3C2440: move mach-s3c2440/* into mach-s3c24xx/
      ARM: S3C2443: move mach-s3c2443/* into mach-s3c24xx/
      ARM: s3c2410_defconfig: update s3c2410_defconfig
      Merge branch 'topic/cleanup-s3c24xx' into next/cleanup-s3c24xx
      Merge branch 'topic/cleanup-use-static' into next/cleanup-use-static
      Merge branch 'next/cleanup-use-static' into next/cleanup-exynos-clock
      ARM: EXYNOS: replace clock.c for other new EXYNOS SoCs
      ARM: EXYNOS: use static declaration on regarding clock
      ARM: EXYNOS: change the prefix S5P_ to EXYNOS4_ for clock
      PM / devfreq: update the name of EXYNOS clock register

Manjunath Hadli (8):
      ARM: davinci: dm644x: move private definitions to C file
      ARM: davinci: dm365: move private definitions to C file
      ARM: davinci: dm646x: move private definitions to C file
      ARM: davinci: create new common platform header for davinci
      ARM: davinci: streamline sysmod access
      ARM: davinci: dm644x: improve readability using macro
      ARM: davinci: dm644x: fix inconsistent variable naming
      ARM: davinci: dm644x: don't force vpfe registeration on all boards

Marc Dietrich (2):
      ARM: tegra: paz00: fix wrong SD1 power gpio
      ARM: tegra: paz00: fix wrong UART port on mini-pcie plug

MyungJoo Ham (2):
      PM / devfreq: update the name of EXYNOS clock registers that were omitted
      ARM: EXYNOS: Add clock register addresses for EXYNOS4X12 bus devfreq driver

NeilBrown (2):
      ARM: OMAP2+: UART: remove unused fields in omap_uart_state.
      ARM: OMAP2+: remove some orphan function declarations.

Nicolas Ferre (1):
      Merge remote-tracking branch 'armsoc/depends/rmk/for-armsoc' into at91-3.4-base

Olof Johansson (9):
      Merge branch 'at91-3.4-base' of git://github.com/at91linux/linux-at91 into next/cleanup
      Merge branch 'at91-3.4-base+pm_cleanup' of git://github.com/at91linux/linux-at91 into next/cleanup
      Merge branch 'depends/rmk/for-armsoc' into for-3.4/cleanup-and-fixes
      Merge branch 'cleanup' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge branch 'next/cleanup-use-static' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge branch 'next/cleanup-s3c24xx' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge branch 'cleanup-pm' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge branch 'uart' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge branch 'next/cleanup-exynos-clock' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup

Paul Walmsley (6):
      ARM: OMAP2xxx: PM: remove obsolete timer disable code in the suspend path
      ARM: OMAP3: PM: remove superfluous calls to pwrdm_clear_all_prev_pwrst()
      ARM: OMAP2+: PM: clean up omap_set_pwrdm_state()
      ARM: OMAP2+: PM: share clkdms_setup() across OMAP2, 3, 4
      ARM: OMAP2+: omap_device: call all suspend, resume callbacks when OMAP_DEVICE_NO_IDLE_ON_SUSPEND is set
      ARM: OMAP2+: PM: share some suspend-related functions across OMAP2, 3, 4

Peter De Schrijver (1):
      ARM: tegra: Enable CPUIdle on Tegra20

Ryan Mallon (10):
      ep93xx: Move PHYS_BASE defines to local SoC header file
      ep93xx: Don't use system controller defines in audio drivers
      ep93xx: Move GPIO defines to gpio-ep93xx.h
      ep93xx: Use ioremap for backlight driver
      ep93xx: Move peripheral defines to local SoC header
      ep93xx: Configure GPIO ports in core code
      ep93xx: Make syscon access functions private to SoC
      ep93xx: Move crunch code to mach-ep93xx directory
      ep93xx: Move EP93XX_SYSCON defines to SoC private header
      ep93xx: Remove unnecessary includes of ep93xx-regs.h

Stephen Warren (1):
      ARM: tegra: select required CPU and L2 errata options

Tony Lindgren (13):
      ARM: OMAP2+: Drop DISPC L3 firewall code
      ARM: OMAP2+: Move SDRC related functions from io.h into local common.h
      ARM: OMAP: Move omap_init_consistent_dma_size() to local common.h
      ARM: OMAP1: Move 16xx GPIO system clock to platform init code
      ARM: OMAP1: Move most of plat/io.h into local iomap.h
      ARM: OMAP2+: Move most of plat/io.h into local iomap.h
      ARM: OMAP: Remove plat/io.h by splitting it into mach/io.h and mach/hardware.h
      ARM: OMAP2+: Limit omap_read/write usage to legacy USB drivers
      Merge branch 'iomap' into cleanup
      ARM: OMAP2+: Fix L4_EMU_34XX_BASE error after iomap changes
      Merge branch 'for_3.4/cleanup/pm' of git://git.kernel.org/.../khilman/linux-omap-pm into cleanup-pm
      Merge branch 'for_3.4/cleanup/uart' of git://git.kernel.org/.../khilman/linux-omap-pm into uart
      ARM: OMAP2+: Fix build error after merge


 Documentation/feature-removal-schedule.txt         |   14 -
 arch/arm/Kconfig                                   |   29 +-
 arch/arm/Kconfig.debug                             |    2 +-
 arch/arm/Makefile                                  |    2 +-
 arch/arm/boot/compressed/head.S                    |    2 +-
 arch/arm/configs/at91cap9_defconfig                |  108 --
 arch/arm/configs/mini2440_defconfig                |    2 +-
 arch/arm/configs/s3c2410_defconfig                 |   57 +-
 arch/arm/configs/tct_hammer_defconfig              |    2 +-
 arch/arm/kernel/Makefile                           |    3 -
 arch/arm/mach-at91/Kconfig                         |   26 +-
 arch/arm/mach-at91/Makefile                        |    4 -
 arch/arm/mach-at91/Makefile.boot                   |    6 +-
 arch/arm/mach-at91/at91cap9.c                      |  404 -----
 arch/arm/mach-at91/at91cap9_devices.c              | 1273 ----------------
 arch/arm/mach-at91/board-cap9adk.c                 |  396 -----
 arch/arm/mach-at91/clock.c                         |    5 +-
 arch/arm/mach-at91/cpuidle.c                       |   11 +-
 arch/arm/mach-at91/generic.h                       |    1 -
 arch/arm/mach-at91/include/mach/at91_pmc.h         |   14 +-
 arch/arm/mach-at91/include/mach/at91cap9.h         |  122 --
 arch/arm/mach-at91/include/mach/at91cap9_matrix.h  |  137 --
 arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h  |   10 -
 arch/arm/mach-at91/include/mach/cpu.h              |   21 -
 arch/arm/mach-at91/include/mach/hardware.h         |    4 +-
 arch/arm/mach-at91/pm.c                            |   17 +-
 arch/arm/mach-at91/pm.h                            |   91 +-
 arch/arm/mach-at91/pm_slowclock.S                  |   12 +-
 arch/arm/mach-at91/setup.c                         |   17 -
 arch/arm/mach-at91/soc.h                           |    5 -
 arch/arm/mach-davinci/board-dm355-evm.c            |    3 +-
 arch/arm/mach-davinci/board-dm355-leopard.c        |    3 +-
 arch/arm/mach-davinci/board-dm365-evm.c            |    3 +-
 arch/arm/mach-davinci/board-dm644x-evm.c           |   28 +-
 arch/arm/mach-davinci/board-dm646x-evm.c           |   32 +-
 arch/arm/mach-davinci/board-neuros-osd2.c          |    3 +-
 arch/arm/mach-davinci/board-sffsdr.c               |    3 +-
 arch/arm/mach-davinci/davinci.h                    |   96 ++
 arch/arm/mach-davinci/devices.c                    |   32 +-
 arch/arm/mach-davinci/dm355.c                      |    3 +-
 arch/arm/mach-davinci/dm365.c                      |   19 +-
 arch/arm/mach-davinci/dm644x.c                     |   53 +-
 arch/arm/mach-davinci/dm646x.c                     |   21 +-
 arch/arm/mach-davinci/include/mach/dm355.h         |   32 -
 arch/arm/mach-davinci/include/mach/dm365.h         |   53 +-
 arch/arm/mach-davinci/include/mach/dm644x.h        |   47 -
 arch/arm/mach-davinci/include/mach/dm646x.h        |   42 +-
 arch/arm/mach-davinci/include/mach/hardware.h      |    2 -
 arch/arm/mach-ep93xx/Makefile                      |    3 +
 arch/arm/mach-ep93xx/adssphere.c                   |    1 +
 arch/arm/mach-ep93xx/clock.c                       |    1 +
 arch/arm/mach-ep93xx/core.c                        |   35 +-
 arch/arm/{kernel => mach-ep93xx}/crunch-bits.S     |    0
 arch/arm/{kernel => mach-ep93xx}/crunch.c          |    4 +-
 arch/arm/mach-ep93xx/dma.c                         |    2 +
 arch/arm/mach-ep93xx/edb93xx.c                     |    1 +
 arch/arm/mach-ep93xx/gesbc9312.c                   |    1 +
 arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h    |  191 +---
 arch/arm/mach-ep93xx/include/mach/gpio-ep93xx.h    |   10 +
 arch/arm/mach-ep93xx/include/mach/hardware.h       |    1 -
 arch/arm/mach-ep93xx/include/mach/platform.h       |   14 -
 arch/arm/mach-ep93xx/micro9.c                      |    1 +
 arch/arm/mach-ep93xx/simone.c                      |    2 +
 arch/arm/mach-ep93xx/snappercl15.c                 |    2 +
 arch/arm/mach-ep93xx/soc.h                         |  213 +++
 arch/arm/mach-ep93xx/ts72xx.c                      |    1 +
 arch/arm/mach-ep93xx/vision_ep9307.c               |    2 +
 arch/arm/mach-exynos/Makefile                      |    3 +-
 arch/arm/mach-exynos/clock-exynos4.c               | 1563 +++++++++++++++++++
 arch/arm/mach-exynos/clock-exynos4.h               |   30 +
 arch/arm/mach-exynos/clock-exynos4210.c            |   48 +-
 arch/arm/mach-exynos/clock-exynos4212.c            |   32 +-
 arch/arm/mach-exynos/clock.c                       | 1564 --------------------
 arch/arm/mach-exynos/common.c                      |    2 +-
 arch/arm/mach-exynos/common.h                      |    9 +
 arch/arm/mach-exynos/dma.c                         |   16 +-
 arch/arm/mach-exynos/include/mach/exynos4-clock.h  |   43 -
 arch/arm/mach-exynos/include/mach/regs-clock.h     |  416 +++---
 arch/arm/mach-exynos/mach-origen.c                 |    2 +-
 arch/arm/mach-exynos/mach-universal_c210.c         |    2 +-
 arch/arm/mach-exynos/pm.c                          |   40 +-
 arch/arm/mach-imx/clock-imx31.c                    |    2 +-
 arch/arm/mach-imx/clock-imx35.c                    |  166 +--
 .../mach-imx/{crmregs-imx31.h => crmregs-imx3.h}   |   15 +-
 arch/arm/mach-imx/mach-armadillo5x0.c              |    2 +-
 arch/arm/mach-omap1/ams-delta-fiq-handler.S        |    3 +-
 arch/arm/mach-omap1/ams-delta-fiq.c                |    1 +
 arch/arm/mach-omap1/board-ams-delta.c              |   10 +-
 arch/arm/mach-omap1/board-fsample.c                |    7 +-
 arch/arm/mach-omap1/board-h2.c                     |    6 +-
 arch/arm/mach-omap1/board-h3.c                     |    8 +-
 arch/arm/mach-omap1/board-htcherald.c              |    5 +-
 arch/arm/mach-omap1/board-innovator.c              |    7 +-
 arch/arm/mach-omap1/board-nokia770.c               |    6 +-
 arch/arm/mach-omap1/board-osk.c                    |    6 +-
 arch/arm/mach-omap1/board-palmte.c                 |    4 +-
 arch/arm/mach-omap1/board-palmtt.c                 |   10 +-
 arch/arm/mach-omap1/board-palmz71.c                |    9 +-
 arch/arm/mach-omap1/board-perseus2.c               |    7 +-
 arch/arm/mach-omap1/board-sx1.c                    |    6 +-
 arch/arm/mach-omap1/board-voiceblue.c              |    6 +-
 arch/arm/mach-omap1/clock.c                        |    5 +-
 arch/arm/mach-omap1/clock_data.c                   |    5 +-
 arch/arm/mach-omap1/common.h                       |    1 +
 arch/arm/mach-omap1/devices.c                      |    8 +-
 arch/arm/mach-omap1/dma.c                          |    2 +-
 arch/arm/mach-omap1/flash.c                        |    4 +-
 arch/arm/mach-omap1/fpga.c                         |    5 +-
 arch/arm/mach-omap1/gpio16xx.c                     |   14 +-
 arch/arm/mach-omap1/id.c                           |    3 +
 arch/arm/mach-omap1/include/mach/entry-macro.S     |    4 +-
 arch/arm/mach-omap1/include/mach/hardware.h        |   36 +
 arch/arm/mach-omap1/include/mach/io.h              |   43 +-
 arch/arm/mach-omap1/include/mach/memory.h          |    3 +-
 arch/arm/mach-omap1/io.c                           |    3 +
 arch/arm/mach-omap1/iomap.h                        |   42 +
 arch/arm/mach-omap1/irq.c                          |    4 +-
 arch/arm/mach-omap1/lcd_dma.c                      |    3 +-
 arch/arm/mach-omap1/mcbsp.c                        |    5 +-
 arch/arm/mach-omap1/pm.c                           |    4 +-
 arch/arm/mach-omap1/reset.c                        |    3 +-
 arch/arm/mach-omap1/sleep.S                        |    4 +
 arch/arm/mach-omap1/sram.S                         |    4 +
 arch/arm/mach-omap1/time.c                         |    3 +-
 arch/arm/mach-omap1/timer32k.c                     |    7 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |    1 -
 arch/arm/mach-omap2/board-n8x0.c                   |    1 -
 arch/arm/mach-omap2/board-rx51-peripherals.c       |    3 -
 arch/arm/mach-omap2/board-zoom-display.c           |    1 -
 arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c       |    1 +
 arch/arm/mach-omap2/clkt_dpll.c                    |    1 +
 arch/arm/mach-omap2/clock2420_data.c               |    3 +
 arch/arm/mach-omap2/clock2430.c                    |    2 +
 arch/arm/mach-omap2/clock2430_data.c               |    2 +
 arch/arm/mach-omap2/clock2xxx.c                    |    1 +
 arch/arm/mach-omap2/clock3xxx.c                    |    1 +
 arch/arm/mach-omap2/clock3xxx_data.c               |    3 +-
 arch/arm/mach-omap2/clock44xx_data.c               |    3 +
 arch/arm/mach-omap2/cm2xxx_3xxx.c                  |    4 +-
 arch/arm/mach-omap2/cm44xx.c                       |    2 +-
 arch/arm/mach-omap2/cminst44xx.c                   |    2 +-
 arch/arm/mach-omap2/common-board-devices.c         |    1 -
 arch/arm/mach-omap2/common.c                       |    5 +-
 arch/arm/mach-omap2/common.h                       |    7 +
 arch/arm/mach-omap2/control.c                      |    4 +-
 arch/arm/mach-omap2/control.h                      |    1 -
 arch/arm/mach-omap2/devices.c                      |    2 +-
 arch/arm/mach-omap2/display.c                      |    1 +
 arch/arm/mach-omap2/emu.c                          |    4 +
 arch/arm/mach-omap2/gpmc-nand.c                    |    1 +
 arch/arm/mach-omap2/gpmc-onenand.c                 |    1 +
 arch/arm/mach-omap2/include/mach/io.h              |   46 +-
 arch/arm/mach-omap2/io.c                           |   58 +-
 .../include/plat/io.h => mach-omap2/iomap.h}       |   80 +-
 arch/arm/mach-omap2/irq.c                          |    5 +-
 arch/arm/mach-omap2/omap-mpuss-lowpower.c          |    2 -
 arch/arm/mach-omap2/omap-smp.c                     |    3 +-
 arch/arm/mach-omap2/opp2420_data.c                 |    2 +
 arch/arm/mach-omap2/opp2430_data.c                 |    2 +
 arch/arm/mach-omap2/pm-debug.c                     |    6 +-
 arch/arm/mach-omap2/pm.c                           |  113 ++-
 arch/arm/mach-omap2/pm.h                           |    3 +-
 arch/arm/mach-omap2/pm24xx.c                       |  100 +--
 arch/arm/mach-omap2/pm34xx.c                       |   74 +-
 arch/arm/mach-omap2/pm44xx.c                       |   57 +-
 arch/arm/mach-omap2/prcm_mpu44xx.c                 |    2 +-
 arch/arm/mach-omap2/prm44xx.c                      |    3 +-
 arch/arm/mach-omap2/prminst44xx.c                  |    2 +-
 arch/arm/mach-omap2/sdram-nokia.c                  |    1 -
 arch/arm/mach-omap2/sdrc2xxx.c                     |    6 +-
 arch/arm/mach-omap2/serial.c                       |    4 -
 arch/arm/mach-omap2/sleep24xx.S                    |    1 -
 arch/arm/mach-omap2/sleep34xx.S                    |    5 +-
 arch/arm/mach-omap2/sram242x.S                     |    4 +-
 arch/arm/mach-omap2/sram243x.S                     |    4 +-
 arch/arm/mach-omap2/sram34xx.S                     |    5 +-
 arch/arm/mach-s3c2410/Kconfig                      |  154 --
 arch/arm/mach-s3c2410/Makefile                     |   26 -
 arch/arm/mach-s3c2410/common.h                     |   17 -
 arch/arm/mach-s3c2410/usb-simtec.h                 |   16 -
 arch/arm/mach-s3c2412/Kconfig                      |   85 --
 arch/arm/mach-s3c2412/Makefile                     |   12 -
 arch/arm/mach-s3c2416/Kconfig                      |   60 -
 arch/arm/mach-s3c2416/Makefile                     |   22 -
 arch/arm/mach-s3c2440/Kconfig                      |  165 --
 arch/arm/mach-s3c2440/Makefile                     |   26 +-
 arch/arm/mach-s3c2440/common.h                     |   17 -
 arch/arm/mach-s3c2443/Kconfig                      |   32 -
 arch/arm/mach-s3c2443/Makefile                     |   20 -
 arch/arm/mach-s3c24xx/Kconfig                      |  538 +++++++
 arch/arm/mach-s3c24xx/Makefile                     |   95 ++
 .../{mach-s3c2410 => mach-s3c24xx}/Makefile.boot   |    0
 arch/arm/{mach-s3c2410 => mach-s3c24xx}/bast-ide.c |    0
 arch/arm/{mach-s3c2410 => mach-s3c24xx}/bast-irq.c |    0
 .../clock.c => mach-s3c24xx/clock-s3c2412.c}       |    0
 .../clock.c => mach-s3c24xx/clock-s3c2416.c}       |    7 -
 .../clock.c => mach-s3c24xx/clock-s3c2440.c}       |    0
 .../clock.c => mach-s3c24xx/clock-s3c2443.c}       |    7 -
 .../clock-s3c244x.c}                               |    0
 .../common-s3c2443.c}                              |   90 +-
 .../{plat-s3c24xx => mach-s3c24xx}/common-smdk.c   |    0
 .../dma.c => mach-s3c24xx/dma-s3c2410.c}           |    0
 .../dma.c => mach-s3c24xx/dma-s3c2412.c}           |    0
 .../dma.c => mach-s3c24xx/dma-s3c2440.c}           |    0
 .../dma.c => mach-s3c24xx/dma-s3c2443.c}           |   30 +-
 .../h1940-bluetooth.c                              |    0
 .../include/mach/anubis-cpld.h                     |    0
 .../include/mach/anubis-irq.h                      |    0
 .../include/mach/anubis-map.h                      |    0
 .../include/mach/bast-cpld.h                       |    0
 .../include/mach/bast-irq.h                        |    0
 .../include/mach/bast-map.h                        |    0
 .../include/mach/bast-pmu.h                        |    0
 .../include/mach/debug-macro.S                     |    0
 .../include/mach/dma.h                             |    0
 .../include/mach/entry-macro.S                     |    0
 .../include/mach/fb.h                              |    0
 .../include/mach/gpio-fns.h                        |    0
 .../include/mach/gpio-nrs.h                        |    0
 .../include/mach/gpio-track.h                      |    0
 .../include/mach/gpio.h                            |    0
 .../include/mach/gta02.h                           |    0
 .../include/mach/h1940-latch.h                     |    0
 .../include/mach/h1940.h                           |    0
 .../include/mach/hardware.h                        |    0
 .../include/mach/idle.h                            |    0
 .../include/mach/io.h                              |    0
 .../include/mach/irqs.h                            |    0
 .../include/mach/leds-gpio.h                       |    0
 .../include/mach/map.h                             |    0
 .../include/mach/osiris-cpld.h                     |    0
 .../include/mach/osiris-map.h                      |    0
 .../include/mach/otom-map.h                        |    0
 .../include/mach/pm-core.h                         |    0
 .../include/mach/regs-clock.h                      |    0
 .../include/mach/regs-dsc.h                        |    0
 .../include/mach/regs-gpio.h                       |    0
 .../include/mach/regs-gpioj.h                      |    0
 .../include/mach/regs-irq.h                        |    0
 .../include/mach/regs-lcd.h                        |    0
 .../include/mach/regs-mem.h                        |    0
 .../include/mach/regs-power.h                      |    0
 .../include/mach/regs-s3c2412-mem.h                |    0
 .../include/mach/regs-s3c2412.h                    |    0
 .../include/mach/regs-s3c2416-mem.h                |    0
 .../include/mach/regs-s3c2416.h                    |    0
 .../include/mach/regs-s3c2443-clock.h              |    0
 .../include/mach/regs-sdi.h                        |    0
 .../include/mach/tick.h                            |    0
 .../include/mach/timex.h                           |    0
 .../include/mach/uncompress.h                      |    0
 .../include/mach/vr1000-cpld.h                     |    0
 .../include/mach/vr1000-irq.h                      |    0
 .../include/mach/vr1000-map.h                      |    0
 .../irq.c => mach-s3c24xx/irq-s3c2412.c}           |    0
 .../irq.c => mach-s3c24xx/irq-s3c2416.c}           |    0
 .../irq.c => mach-s3c24xx/irq-s3c2440.c}           |    0
 .../irq.c => mach-s3c24xx/irq-s3c2443.c}           |    0
 .../s3c244x-irq.c => mach-s3c24xx/irq-s3c244x.c}   |    0
 .../{mach-s3c2410 => mach-s3c24xx}/mach-amlm5900.c |    0
 .../{mach-s3c2440 => mach-s3c24xx}/mach-anubis.c   |    1 +
 .../mach-at2440evb.c                               |    0
 .../arm/{mach-s3c2410 => mach-s3c24xx}/mach-bast.c |    3 +-
 .../{mach-s3c2440 => mach-s3c24xx}/mach-gta02.c    |    6 +-
 .../{mach-s3c2410 => mach-s3c24xx}/mach-h1940.c    |   12 +-
 .../arm/{mach-s3c2412 => mach-s3c24xx}/mach-jive.c |    0
 .../{mach-s3c2440 => mach-s3c24xx}/mach-mini2440.c |    0
 arch/arm/{mach-s3c2410 => mach-s3c24xx}/mach-n30.c |    0
 .../{mach-s3c2440 => mach-s3c24xx}/mach-nexcoder.c |    0
 .../mach-osiris-dvs.c                              |    0
 .../{mach-s3c2440 => mach-s3c24xx}/mach-osiris.c   |    0
 .../arm/{mach-s3c2410 => mach-s3c24xx}/mach-otom.c |    0
 .../{mach-s3c2410 => mach-s3c24xx}/mach-qt2410.c   |    0
 .../{mach-s3c2440 => mach-s3c24xx}/mach-rx1950.c   |   12 +-
 .../{mach-s3c2440 => mach-s3c24xx}/mach-rx3715.c   |    0
 .../{mach-s3c2410 => mach-s3c24xx}/mach-smdk2410.c |    0
 .../{mach-s3c2412 => mach-s3c24xx}/mach-smdk2413.c |    0
 .../{mach-s3c2416 => mach-s3c24xx}/mach-smdk2416.c |    8 +-
 .../{mach-s3c2440 => mach-s3c24xx}/mach-smdk2440.c |    0
 .../{mach-s3c2443 => mach-s3c24xx}/mach-smdk2443.c |    0
 .../mach-tct_hammer.c                              |    0
 .../{mach-s3c2410 => mach-s3c24xx}/mach-vr1000.c   |    3 +-
 .../{mach-s3c2412 => mach-s3c24xx}/mach-vstms.c    |    0
 arch/arm/{mach-s3c2410 => mach-s3c24xx}/pm-h1940.S |    0
 .../pm.c => mach-s3c24xx/pm-s3c2410.c}             |    0
 .../pm.c => mach-s3c24xx/pm-s3c2412.c}             |    0
 .../pm.c => mach-s3c24xx/pm-s3c2416.c}             |    0
 arch/arm/{mach-s3c2410 => mach-s3c24xx}/s3c2410.c  |    0
 arch/arm/{mach-s3c2412 => mach-s3c24xx}/s3c2412.c  |    0
 arch/arm/{mach-s3c2416 => mach-s3c24xx}/s3c2416.c  |    0
 arch/arm/{mach-s3c2440 => mach-s3c24xx}/s3c2440.c  |    0
 arch/arm/{mach-s3c2440 => mach-s3c24xx}/s3c2442.c  |    0
 arch/arm/{mach-s3c2443 => mach-s3c24xx}/s3c2443.c  |    0
 arch/arm/{mach-s3c2440 => mach-s3c24xx}/s3c244x.c  |    0
 .../arm/{plat-s3c24xx => mach-s3c24xx}/setup-i2c.c |    0
 .../setup-sdhci-gpio.c                             |    0
 arch/arm/{plat-s3c24xx => mach-s3c24xx}/setup-ts.c |    0
 .../{plat-s3c24xx => mach-s3c24xx}/simtec-audio.c  |    2 +
 .../nor-simtec.c => mach-s3c24xx/simtec-nor.c}     |    2 +-
 .../pm-simtec.c => mach-s3c24xx/simtec-pm.c}       |    0
 .../usb-simtec.c => mach-s3c24xx/simtec-usb.c}     |    2 +-
 .../nor-simtec.h => mach-s3c24xx/simtec.h}         |    9 +-
 .../sleep.S => mach-s3c24xx/sleep-s3c2410.S}       |    0
 .../sleep.S => mach-s3c24xx/sleep-s3c2412.S}       |    0
 arch/arm/mach-s3c64xx/common.h                     |    2 -
 arch/arm/mach-s3c64xx/irq-pm.c                     |    2 +-
 arch/arm/mach-s5p64x0/clock.c                      |   11 +-
 arch/arm/mach-s5p64x0/dma.c                        |   12 +-
 arch/arm/mach-s5p64x0/include/mach/s5p64x0-clock.h |    7 -
 arch/arm/mach-s5pc100/clock.c                      |   28 +-
 arch/arm/mach-s5pc100/dma.c                        |   16 +-
 arch/arm/mach-s5pv210/dma.c                        |   16 +-
 arch/arm/mach-s5pv210/mach-goni.c                  |    2 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c              |    2 +-
 arch/arm/mach-tegra/Kconfig                        |   14 +
 arch/arm/mach-tegra/Makefile                       |    3 +-
 arch/arm/mach-tegra/common.c                       |    2 -
 arch/arm/mach-tegra/usb_phy.c                      |   11 +
 arch/arm/plat-mxc/avic.c                           |    2 +-
 arch/arm/plat-omap/counter_32k.c                   |    1 +
 arch/arm/plat-omap/dma.c                           |    2 +
 arch/arm/plat-omap/dmtimer.c                       |    2 +
 arch/arm/plat-omap/include/plat/hardware.h         |    6 +
 arch/arm/plat-omap/include/plat/keypad.h           |    2 +
 arch/arm/plat-omap/include/plat/mcspi.h            |    3 -
 arch/arm/plat-omap/include/plat/omap_device.h      |    2 +-
 arch/arm/plat-omap/include/plat/serial.h           |    1 -
 arch/arm/plat-omap/include/plat/tc.h               |   17 -
 arch/arm/plat-omap/include/plat/usb.h              |   41 +
 arch/arm/plat-omap/mux.c                           |    5 +-
 arch/arm/plat-omap/omap-pm-noop.c                  |    2 +-
 arch/arm/plat-omap/omap_device.c                   |   24 +-
 arch/arm/plat-omap/sram.c                          |    9 +-
 arch/arm/plat-omap/usb.c                           |    4 +
 arch/arm/plat-s3c24xx/Kconfig                      |   57 +-
 arch/arm/plat-s3c24xx/Makefile                     |   19 +-
 arch/arm/plat-s3c24xx/spi-bus0-gpe11_12_13.c       |   36 -
 arch/arm/plat-s3c24xx/spi-bus1-gpd8_9_10.c         |   38 -
 arch/arm/plat-s3c24xx/spi-bus1-gpg5_6_7.c          |   36 -
 arch/arm/plat-s5p/irq-eint.c                       |    2 +-
 arch/arm/plat-s5p/irq-gpioint.c                    |    2 +-
 arch/arm/plat-samsung/Kconfig                      |    4 +-
 arch/arm/plat-samsung/devs.c                       |   13 +-
 arch/arm/plat-samsung/dma-ops.c                    |    2 +-
 arch/arm/plat-samsung/include/plat/audio-simtec.h  |    3 -
 arch/arm/plat-samsung/include/plat/clock.h         |   22 +-
 arch/arm/plat-samsung/include/plat/regs-dma.h      |    2 +-
 arch/arm/plat-samsung/include/plat/s3c2410.h       |    2 -
 arch/arm/plat-samsung/include/plat/s3c2443.h       |   20 -
 arch/avr32/mach-at32ap/include/mach/cpu.h          |    3 -
 drivers/char/hw_random/omap-rng.c                  |    2 +
 drivers/devfreq/exynos4_bus.c                      |  230 ++--
 drivers/gpio/gpio-ep93xx.c                         |    7 -
 drivers/input/touchscreen/Kconfig                  |    2 +-
 drivers/leds/Kconfig                               |    2 +-
 drivers/mmc/host/Kconfig                           |    2 +-
 drivers/mmc/host/at91_mci.c                        |    1 -
 drivers/mtd/nand/Kconfig                           |    2 +-
 drivers/rtc/Kconfig                                |    2 +-
 drivers/rtc/rtc-sa1100.c                           |   81 +-
 drivers/spi/Kconfig                                |    2 +-
 drivers/spi/spi-s3c24xx.c                          |    2 +-
 drivers/usb/Kconfig                                |    2 +-
 drivers/usb/gadget/Kconfig                         |    8 +-
 drivers/usb/host/ohci-hcd.c                        |    2 +-
 drivers/video/Kconfig                              |    2 +-
 drivers/video/backlight/ep93xx_bl.c                |   25 +-
 drivers/video/ep93xx-fb.c                          |   18 +-
 drivers/video/omap2/dss/dispc.c                    |    5 -
 drivers/video/omap2/dss/dss.c                      |    3 +
 drivers/watchdog/Kconfig                           |    2 +-
 drivers/watchdog/ep93xx_wdt.c                      |   51 +-
 .../mach/spi.h => include/linux/spi/s3c24xx.h      |   20 +-
 sound/soc/samsung/Kconfig                          |   12 +-
 374 files changed, 4236 insertions(+), 6914 deletions(-)
