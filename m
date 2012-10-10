Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab2JJVsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 17:48:43 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34423 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2JJVsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 17:48:41 -0400
Date: Wed, 10 Oct 2012 14:48:59 -0700
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org
Subject: [GIT PULL] ARM: SoC fixes
Message-ID: <20121010214859.GA27542@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,


The following changes since commit 0e51793e162ca432fc5f04178cf82b80a92c2659:

  Merge branch 'for-linus' of git://git.linaro.org/people/rmk/linux-arm (2012-10-07 21:20:57 +0900)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes

for you to fetch changes up to 6bd5dbda2adeabba69c969886511e501a65b6e3c:

  Merge tag 'omap-for-v3.7-rc1/fixes-asoc-regression-signed' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into fixes (2012-10-09 15:00:58 -0700)

----------------------------------------------------------------

ARM: SoC fixes

A series of fixes (and in some cases, some cleanups):

Via Tony Lindgren:
- A collection of OMAP regression fixes, in particular because firmware
  no longer sets up all pin states before starting the kernel.
- cpufreq fixes for OMAP (Rafael is on vacation and this was pre-agreed).
- A longer series of misc regression fixes and cleanups, warning removals,
  etc for OMAP

>From Arnd Bergmann:
- A series of warning fixes for various platforms (defconfig builds)

Misc:
- A couple of tegra fixes, one for i.MX, some vt8500 fixes, etc.

----------------------------------------------------------------
Afzal Mohammed (1):
      ARM: OMAP2+: gpmc: annotate exit sections properly

Arnd Bergmann (22):
      ARM: shark: fix shark_pci_init return code
      ARM: pxa: Wunused-result warning in viper board file
      ARM: pxa: define palmte2_pxa_keys conditionally
      ARM: pxa: remove sharpsl_fatal_check function
      ARM: pxa: work around duplicate definition of GPIO24_SSP1_SFRM
      ARM: at91: skip at91_io_desc definition for NOMMU
      ARM: at91: unused variable in at91_pm_verify_clocks
      ARM: s3c24xx: fix multiple section mismatch warnings
      ARM: mv78xx0: mark mv78xx0_timer_init as __init_refok
      ARM: iop13xx: mark iop13xx_scan_bus as __devinit
      ARM: iop13xx: fix iq81340sc_atux_map_irq prototype
      ARM: davinci: don't mark da850_register_cpufreq as __init
      ARM: rpc: check device_register return code in ecard_probe
      ARM: ks8695: __arch_virt_to_dma type handling
      ARM: soc: dependency warnings for errata
      ARM: footbridge: remove RTC_IRQ definition
      ARM: mv78xx0: correct addr_map_cfg __initdata annotation
      ARM: footbridge: nw_gpio_lock is raw_spin_lock
      ARM: shmobile: mark shmobile_init_late as __init
      ARM: assabet: fix bogus warning in get_assabet_scr (again)
      ARM: integrator: use __iomem pointers for MMIO, part 2
      ARM: pxa: armcore: fix PCI PIO warnings

Axel Lin (1):
      ARM: OMAP: OMAP_DEBUG_LEDS needs to select LEDS_CLASS

Colin Cross (1):
      ARM: OMAP: counter: add locking to read_persistent_clock

Jean Pihet (2):
      ARM: OMAP: SmartReflex: select CONFIG_POWER_SUPPLY in Kconfig
      ARM: OMAP: SmartReflex: fix error path in init function

Jon Hunter (2):
      ARM: OMAP2+: hwmod data: Fix PMU interrupt definitions
      ARM: OMAP3: fix workaround for EMU clockdomain

Kevin Hilman (4):
      cpufreq: OMAP: ensure valid clock rate before scaling
      cpufreq: OMAP: remove unused <plat/omap-pm.h>
      cpufreq: OMAP: use get_cpu_device() instead of omap_device API
      ARM: OMAP2+: PM: MPU DVFS: use generic CPU device for MPU-SS

Olof Johansson (10):
      ARM: iop: fix mismerge of Kconfig
      ARM: tegra: fix mismerges of header file inclusions
      Merge branch 'late/fixes' into fixes
      ARM: integrator_cp: fix build failure
      Merge branch 'fixes2' into fixes
      Merge tag 'omap-for-v3.7-rc1/fixes-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'omap-for-v3.7-rc1/fixes-hwmod-clock-signed-v3' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'omap-for-v3.7-rc1/fixes-pm-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'omap-for-v3.7-rc1/fixes-cpufreq-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'omap-for-v3.7-rc1/fixes-asoc-regression-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes

Paul Walmsley (3):
      ARM: OMAP: omap3evm: fix new sparse warning
      cpufreq: OMAP: fix clock usage to be SoC independent, remove plat/ includes
      ARM: OMAP4/AM335x: hwmod: fix disable_module regression in hardreset handling

Peter Senna Tschudin (3):
      arch/arm/mach-omap1/devices.c: Remove unecessary semicolon
      arch/arm/mach-omap2: Remove unecessary semicolon
      arch/arm/plat-omap/omap-pm-noop.c: Remove unecessary semicolon

Peter Ujfalusi (9):
      ARM: OMAP: board-4430-sdp: Pin mux configuration for audio needs
      ARM: OMAP: board-omap4panda: Pin mux configuration for audio needs
      ARM/dts: omap4-panda: Disable unused audio IPs
      ARM/dts: omap4-sdp: Disable unused McBSP3
      ARM/dts: omap5-evm: Disable unused McBSP3
      ARM/dts: omap4-sdp: pinmux configuration for audio
      ARM/dts: omap4-panda: pinmux configuration for audio
      ARM/dts: Add pinctrl driver entries for omap5
      ARM/dts: omap5-evm: pinmux configuration for audio

R Sricharan (1):
      ARM: OMAP2+: Round of the carve out memory requested to section_size

Raphael Assenat (1):
      AM35xx: Add missing hwmod entry for the HDQ/1-Wire present in AM3505/3517 CPUs.

Shawn Guo (1):
      ARM: dts: remove redundant imx dtb targets from Makefile

Shubhrajyoti D (1):
      ARM: OMAP: rx51: Fix a section mismatch warn

Stephen Warren (3):
      ARM: tegra: fix invalid unit-address in tegra*.dtsi
      ARM: tegra: remove "Tegra board type" comment from Kconfig
      ARM: bcm2835: fix typos in DT binding documentation

Tony Lindgren (3):
      Merge tag 'for_3.7-fixes-cpufreq' of git://git.kernel.org/.../khilman/linux-omap-pm into omap-for-v3.7-rc1/fixes-cpufreq
      Merge tag 'for_3.7-fixes-pm' of git://git.kernel.org/.../khilman/linux-omap-pm into omap-for-v3.7-rc1/fixes-pm
      Merge tag 'omap-fixes-a-for-pre3.7' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.7-rc1/fixes-hwmod-clock

Tony Prisk (3):
      dtb: Add arch-vt8500 board files to arch/arm/boot/dts/Makefile
      vt8500: Fix build warning when no framebuffer selected
      arm: vt8500: Fix build warning in uncompress.h

Vaibhav Hiremath (2):
      ARM: am33xx: clk: Update clkdev table to add mcasp alias
      ARM: OMAP2+: Add am335x evm and bone targets to common Makefile

Vikram Narayanan (1):
      arm/omap: Replace board_ref_clock with enum values

Wei Yongjun (8):
      ARM: OMAP: fix return value check in beagle_opp_init()
      ARM: OMAP: omap_device: fix return value check in omap_device_build_ss()
      ARM: OMAP2+: SmartReflex: fix return value check in sr_dev_init()
      ARM: OMAP2+: PM: fix return value check in omap2_set_init_voltage()
      OMAPDSS: fix return value check in create_dss_pdev()
      ARM: OMAP: hsmmc: fix return value check in omap_hsmmc_init_one()
      ARM: OMAP: fix return value check in realtime_counter_init()
      ARM: OMAP2+: remove duplicated include from board-omap3stalker.c

Yegor Yefremov (1):
      arm: increase FORCE_MAX_ZONEORDER for TI AM33XX

 .../brcm,bcm2835-armctrl-ic.txt                    |  2 +-
 .../bindings/timer/brcm,bcm2835-system-timer.txt   |  2 +-
 arch/arm/Kconfig                                   |  3 +-
 arch/arm/boot/dts/Makefile                         | 15 +++---
 arch/arm/boot/dts/omap4-panda.dts                  | 47 ++++++++++++++++++
 arch/arm/boot/dts/omap4-sdp.dts                    | 57 +++++++++++++++++++++
 arch/arm/boot/dts/omap5-evm.dts                    | 58 ++++++++++++++++++++++
 arch/arm/boot/dts/omap5.dtsi                       | 17 +++++++
 arch/arm/boot/dts/tegra20-seaboard.dts             |  2 +-
 arch/arm/boot/dts/tegra20.dtsi                     |  4 +-
 arch/arm/common/it8152.c                           | 12 +++--
 arch/arm/mach-at91/pm.c                            |  5 +-
 arch/arm/mach-at91/setup.c                         |  2 +-
 arch/arm/mach-davinci/da850.c                      |  2 +-
 arch/arm/mach-footbridge/include/mach/irqs.h       |  2 -
 arch/arm/mach-integrator/include/mach/cm.h         |  2 +-
 arch/arm/mach-integrator/include/mach/platform.h   |  6 +--
 arch/arm/mach-integrator/integrator_ap.c           |  2 +-
 arch/arm/mach-integrator/integrator_cp.c           |  4 +-
 arch/arm/mach-iop13xx/iq81340sc.c                  |  2 +-
 arch/arm/mach-iop13xx/pci.c                        |  2 +-
 arch/arm/mach-ks8695/include/mach/memory.h         |  3 +-
 arch/arm/mach-mv78xx0/addr-map.c                   |  2 +-
 arch/arm/mach-mv78xx0/common.c                     |  2 +-
 arch/arm/mach-omap1/devices.c                      |  2 +-
 arch/arm/mach-omap2/board-4430sdp.c                | 26 ++++++++++
 arch/arm/mach-omap2/board-flash.c                  |  2 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |  2 +-
 arch/arm/mach-omap2/board-omap3evm.c               |  3 +-
 arch/arm/mach-omap2/board-omap3stalker.c           |  5 --
 arch/arm/mach-omap2/board-omap4panda.c             | 18 ++++++-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |  2 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c       |  3 +-
 arch/arm/mach-omap2/clkt_clksel.c                  |  2 +-
 arch/arm/mach-omap2/clock33xx_data.c               |  2 +
 arch/arm/mach-omap2/clockdomain2xxx_3xxx.c         | 44 ++++++++--------
 arch/arm/mach-omap2/display.c                      |  2 +-
 arch/arm/mach-omap2/gpmc.c                         |  4 +-
 arch/arm/mach-omap2/hsmmc.c                        |  2 +-
 arch/arm/mach-omap2/mux.c                          |  2 +-
 arch/arm/mach-omap2/omap-secure.c                  |  4 +-
 arch/arm/mach-omap2/omap_hwmod.c                   | 31 ++++++++++--
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c |  2 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  9 ++--
 arch/arm/mach-omap2/opp.c                          | 23 ++++++---
 arch/arm/mach-omap2/pm-debug.c                     |  2 +-
 arch/arm/mach-omap2/pm.c                           | 13 ++++-
 arch/arm/mach-omap2/sr_device.c                    |  2 +-
 arch/arm/mach-omap2/timer.c                        |  2 +-
 arch/arm/mach-omap2/twl-common.c                   |  2 +-
 arch/arm/mach-pxa/cm-x2xx.c                        |  1 +
 arch/arm/mach-pxa/palmte2.c                        |  2 +
 arch/arm/mach-pxa/sharpsl_pm.c                     | 48 ------------------
 arch/arm/mach-pxa/viper.c                          |  3 +-
 arch/arm/mach-rpc/ecard.c                          |  4 +-
 arch/arm/mach-s3c24xx/irq-s3c2416.c                |  6 +--
 arch/arm/mach-s3c24xx/irq-s3c2443.c                |  4 +-
 arch/arm/mach-s3c24xx/simtec-usb.c                 |  2 +-
 arch/arm/mach-sa1100/assabet.c                     |  2 +-
 arch/arm/mach-shark/pci.c                          |  2 +-
 arch/arm/mach-shmobile/include/mach/common.h       |  2 +-
 arch/arm/mach-tegra/Kconfig                        |  6 +--
 arch/arm/mach-ux500/Kconfig                        |  4 +-
 arch/arm/mach-vt8500/include/mach/uncompress.h     |  8 +--
 arch/arm/mach-vt8500/vt8500.c                      |  5 +-
 arch/arm/plat-omap/Kconfig                         |  2 +
 arch/arm/plat-omap/counter_32k.c                   | 21 +++++---
 arch/arm/plat-omap/omap-pm-noop.c                  |  8 +--
 arch/arm/plat-omap/omap_device.c                   |  2 +-
 drivers/char/ds1620.c                              |  8 +--
 drivers/char/nwflash.c                             |  4 +-
 drivers/cpufreq/omap-cpufreq.c                     | 36 +++++---------
 drivers/mmc/host/sdhci-tegra.c                     |  1 -
 drivers/power/avs/smartreflex.c                    |  8 +--
 sound/oss/waveartist.c                             |  4 +-
 75 files changed, 436 insertions(+), 223 deletions(-)
