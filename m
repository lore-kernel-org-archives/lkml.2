Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960Ab2JAX7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:59:53 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55016 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab2JAX5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:57:33 -0400
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 2/12] ARM: soc: general cleanups
Date: Mon,  1 Oct 2012 16:56:57 -0700
Message-Id: <1349135827-24790-3-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1349135827-24790-1-git-send-email-olof@lixom.net>
References: <1349135827-24790-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a large branch that contains a handful of different cleanups:

- Fixing up the I/O space remapping on PCI on ARM. This is a series
from Rob Herring that restructures how all pci devices allocate I/O
space, and it's part of the work to allow multiplatform kernels.
- A number of cleanup series for OMAP, moving and removing some
headers, sparse irq rework and in general preparation for
multiplatform.
- Final removal of all non-DT boards for Tegra, it is now
device-tree-only!
- Removal of a stale platform, nxp4008. It's an old mobile chipset
that is no longer in use, and was very likely never really used with
a mainline kernel. We have not been able to find anyone interested
in keeping it around in the kernel.
- Removal of the legacy dmaengine driver on tegra

+ A handful of other things that I haven't described above.


Conflicts:
* drivers/staging/tidspbridge/core/wdt.c has an add/change conflict
* drivers/usb/host/Kconfig has a change/remove conflict due to nxp4008 removal
* drivers/w1/masters/omap_hdq.c has had similar cleanups merged through
  Greg K-H, go with what's already in the tree on those conflicts.


----------------------------------------------------------------

The following changes since commit 17a505edb09495510ac8998450980472c412455b:

  Merge branch 'next/fixes-non-critical' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup

for you to fetch changes up to 9cf1c871526cf6bfec2a653e1e068ee72592542c:

  Merge tag 'omap-devel-board-late-v3-for-v3.7' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into next/cleanup

----------------------------------------------------------------

Afzal Mohammed (10):
      ARM: OMAP2+: gpmc: update nand register helper
      ARM: OMAP2+: gpmc-nand: update gpmc-nand regs
      mtd: nand: omap2: handle nand on gpmc
      ARM: OMAP2+: gpmc-nand: update resource with memory
      ARM: OMAP2+: gpmc-onenand: provide memory as resource
      mtd: nand: omap2: obtain memory from resource
      mtd: onenand: omap2: obtain memory from resource
      ARM: OMAP2+: gpmc: Modify interrupt handling
      ARM: OMAP2+: gpmc-nand: Modify Interrupt handling
      mtd: nand: omap2: use gpmc provided irqs

AnilKumar Ch (1):
      ARM: OMAP2+: serial: Change MAX_HSUART_PORTS to 6

Arnd Bergmann (31):
      ARM: bcmring: move cfg_global header to mach/
      ARM: bcmring: remove include/csp/ subdir
      ARM: bcmring: use proper MMIO accessors
      iop13xx: use more regular PCI I/O space handling
      Merge branch 'cleanup/io-pci' into next/cleanups
      Merge branch 'testing/bcmring' into next/cleanups
      Merge branch 'u300-cleanup' of git://git.kernel.org/.../linusw/linux-stericsson into next/cleanup
      Merge commit 'a849088aa1' from rmk/fixes into cleanup/io-pci
      Merge branch 'cleanup/io-pci' into next/cleanup
      ARM: shmobile: use __iomem pointers for MMIO
      ARM: at91: use __iomem pointers for MMIO
      ARM: ebsa110: use __iomem pointers for MMIO
      ARM: imx: use __iomem pointers for MMIO
      ARM: integrator: use __iomem pointers for MMIO
      ARM: iop13xx: use __iomem pointers for MMIO
      ARM: iop32x: use __iomem pointers for MMIO
      ARM: ixp4xx: use __iomem pointers for MMIO
      ARM: ks8695: use __iomem pointers for MMIO
      ARM: lpc32xx: use __iomem pointers for MMIO
      ARM: msm: use __iomem pointers for MMIO
      ARM: nomadik: use __iomem pointers for MMIO
      ARM: prima2: use __iomem pointers for MMIO
      ARM: sa1100: use __iomem pointers for MMIO
      ARM: spear13xx: use __iomem pointers for MMIO
      ARM: samsung: use __iomem pointers for MMIO
      input: rpcmouse: use __iomem pointers for MMIO
      serial: ks8695: use __iomem pointers for MMIO
      scsi: eesox: use __iomem pointers for MMIO
      video: da8xx-fb: use __iomem pointers for MMIO
      net: seeq: use __iomem pointers for MMIO
      ARM: omap: move platform_data definitions

Barry Song (3):
      ARM: PRIMA2: use DT_MACHINE_START and convert to generic board
      ARM: PRIMA2: adjust Kconfig to support select SoC features
      ARM: SIRF: make sirf irqchip driver optional since new SoCs will have GIC

Chao Xie (5):
      arm: mmp: make private clock definition exclude from common clock
      arm: mmp: move pxa168 clock definition to separated file
      arm: mmp: move pxa910 clock definition to separated file
      ARM: mmp: move mmp2 clock definition to separated file
      ARM: mmp: remove unused definition in APBC and APMU

Fabio Estevam (2):
      ARM: plat-mxc: Remove unused imx_ioremap
      ARM: imx27-phytec-phycore: Fix I2C EEPROM address

Igor Grinberg (9):
      ARM: OMAP: cleanup struct omap_board_config_kernel
      ARM: OMAP: omap3evm: cleanup revision bits
      ARM: OMAP: remove the sti console workaround
      ARM: OMAP1: remove the crystal type tag parsing
      ARM: OMAP: remove the omap custom tags
      ARM: OMAP1: move omap1_bl pdata out of arch/arm/*
      ARM: OMAP1: move lcd pdata out of arch/arm/*
      ARM: OMAP: move debug_card_init() function
      ARM: OMAP: remove plat/board.h file

Javier Martin (1):
      ARM i.MX mx2_camera: Remove MX2_CAMERA_SWAP16 and MX2_CAMERA_PACK_DIR_MSB flags.

Jon Hunter (1):
      ARM: PMU: Add runtime PM Support

Jonghwan Choi (1):
      ARM: EXYNOS: cleanup unused code related to GPS

Laxman Dewangan (7):
      ARM: tegra: use IO_ADDRESS for getting virtual address
      ARM: dt: tegra: harmony: add regulators
      ARM: tegra: config: enable dmaengine based APB DMA driver
      ARM: tegra: dma: remove legacy APB DMA driver
      ARM: tegra: apbio: remove support of legacy DMA driver based access
      spi: tegra: remove support of legacy DMA driver based access
      ASoC: tegra: remove support of legacy DMA driver based access

Linus Walleij (12):
      ARM: u300: retire ancient platforms
      pinctrl/coh901: retire ancient GPIO block versions
      pinctrl/coh901: move header to platform data dir
      ARM: u300: merge u300.c into core.c and rid headers
      ARM: u300: delete remnant clkdev.h file
      ARM: u300: move DMA channel header into mach-u300
      ARM: u300: convert to sparse IRQs
      ARM: ks8695: merge the timer header into the timer driver
      ARM: ks8695: use [readl|writel]_relaxed()
      ARM: ks8695: delete resume hook from timer
      ARM: ks8695: convert to generic time and clocksource
      watchdog: ks8695: sink registers into driver

Matt Porter (1):
      ARM: OMAP2+: Enable pinctrl dummy states

Olof Johansson (24):
      Merge branch 'marco-prepare' of git://gitorious.org/sirfprima2-kernel/sirfprima2-kernel into next/cleanup
      Merge tag 'arm-perf-3.7' of git://git.kernel.org/.../will/linux into next/cleanup
      Merge tag 'ks8695-time-for-arm-soc' of http://git.kernel.org/.../linusw/linux-stericsson into next/cleanup
      Merge branch 'ag5evm' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge branch 'pnx4008-removal' of git://git.antcom.de/linux-2.6 into next/cleanup
      Merge branch 'ks8695/timer' into next/cleanup
      Merge branch 'clk' of git://github.com/hzhuang1/linux into next/cleanup
      Merge tag 'imx-cleanup' of git://git.pengutronix.de/git/imx/linux-2.6 into next/cleanup
      Merge tag 'msm-cleanup-for-3.7' of git://git.kernel.org/.../davidb/linux-msm into next/cleanup
      Merge tag 'tegra-for-3.7-cleanup' of git://git.kernel.org/.../swarren/linux-tegra into next/cleanup
      Merge branch 'depends/tps6589x-dt' into next/cleanup
      Merge tag 'tegra-for-3.7-board-removal' of git://git.kernel.org/.../swarren/linux-tegra into next/cleanup
      Merge tag 'omap-devel-gpmc-fixed-for-v3.7' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge tag 'cleanup-omap-tags-for-v3.7' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge branch 'depends/tty-omap-serial' into next/cleanup
      Merge tag 'omap-cleanup-sparseirq-for-v3.7' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge tag 'omap-cleanup-makefile-sparse-for-v3.7' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge tag 'cleanup-fixes-for-v3.7' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge branch 'samsung/cleanup' into next/cleanup
      Merge tag 'tegra-for-3.7-dmaengine' of git://git.kernel.org/.../swarren/linux-tegra into next/cleanup
      Merge tag 'omap-cleanup-local-headers-for-v3.7' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge branch 'board' of git://github.com/hzhuang1/linux into next/cleanup
      Merge branch 'cleanup/__iomem' into next/cleanup
      Merge tag 'omap-devel-board-late-v3-for-v3.7' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup

Oskar Schirmer (1):
      serial/imx: fix IMX UART macro usage to reflect correct processor

Paul Walmsley (8):
      ARM: OMAP2+: clean up whitespace in Makefile
      ARM: OMAP2+: clean up omap_hwmod.o build directives in Makefile
      ARM: OMAP2+: move MPU INTCPS, secure monitor, SDRC build directives in Makefile
      ARM: OMAP2+: clean up OMAP4 PRM & sleep build directives in Makefile
      ARM: OMAP2+: clean up OMAP clock Makefile sections
      ARM: OMAP2+: clean up PRCM sections of the Makefile
      ARM: OMAP: clean up some smatch warnings, fix some printk(KERN_ERR ...
      ARM: OMAP: unwrap strings

Peter Ujfalusi (1):
      ARM: OMAP4: twl-common: Support for additional devices on i2c1 bus

Rob Herring (16):
      i2c: iop3xx: clean-up trailing whitespace
      i2c: iop3xx: use standard gpiolib functions
      ARM: Add fixed PCI i/o mapping
      ARM: move PCI i/o resource setup into common code
      ARM: versatile: use fixed PCI i/o mapping
      ARM: tegra: use fixed PCI i/o mapping
      ARM: integrator: use fixed PCI i/o mapping
      ARM: integrator: remove trailing whitespace on pci_v3.c
      ARM: shark: use fixed PCI i/o mapping
      ARM: footbridge: use fixed PCI i/o mapping
      ARM: dove: use fixed PCI i/o mapping
      ARM: kirkwood: use fixed PCI i/o mapping
      ARM: orion5x: use fixed PCI i/o mapping
      ARM: iop13xx: use fixed PCI i/o mapping
      ARM: mv78xx0: use fixed pci i/o mapping
      ARM: iop3xx: use fixed PCI i/o mapping

Roland Stigge (1):
      ARM: mach-pnx4008: Remove architecture

Sachin Kamat (2):
      ARM: S3C24XX: Use module_platform_driver macro in h1940-bluetooth.c
      ARM: S3C24XX: Use module_platform_driver macro in mach-osiris-dvs.c

Sascha Hauer (3):
      ARM: i.MX clk pllv1: move mxc_decode_pll code to its user
      ARM: i.MX remove last leftovers from legacy clock support
      ARM i.MX53 clk: Fix ldb parent clocks

Stephen Boyd (6):
      ARM: msm: Remove msm_hw_reset_hook
      ARM: msm: clock-pcom: Mark functions static
      ARM: msm: Remove unused idle.c
      ARM: msm: Fix sparse warnings due to incorrect type
      ARM: msm: Remove unused acpuclock-arm11
      ARM: msm: Remove uncompiled board-msm7x27

Stephen Warren (9):
      ARM: tegra: remove duplicate select USE_OF
      gpio: tegra: remove useless includes of <mach/*.h>
      mmc: tegra: remove useless include of <mach/*.h>
      Merge commit 'tps6589x-dt' into for-3.7/board-removal
      ARM: tegra: remove board (but not DT) support for TrimSlice
      ARM: tegra: remove board (but not DT) support for Paz00
      ARM: tegra: remove board (but not DT) support for Harmony
      ARM: dt: tegra: harmony: configure power off
      ARM: tegra: harmony: fix ldo7 regulator-name

Sudeep KarkadaNagesha (2):
      ARM: pmu: remove arm_pmu_type enumeration
      ARM: perf: move irq registration into pmu implementation

Sylwester Nawrocki (4):
      ARM: S3C24XX: Convert users of s3c2410_gpio_setpin to gpiolib API
      ARM: S3C24XX: Remove obsolete GPIO API declarations
      gpio-samsung: Remove now unused s3c2410_gpio* API
      gpio: samsung: Update documentation

Tony Lindgren (46):
      Merge tags 'omap-devel-gpmc-fixed-for-v3.7' and 'cleanup-omap-tags-for-v3.7' into cleanup-sparseirq
      ARM: OMAP1: Move define of OMAP_LCD_DMA to dma.h
      ARM: OMAP1: Define OMAP1_INT_I2C locally
      ARM: OMAP2+: Make INTCPS_NR_IRQS local for mach-omap2/irq.c
      ARM: OMAP2+: Remove unused nand_irq for GPMC
      ARM: OMAP2+: Remove hardcoded twl4030 gpio_base, irq_base and irq_end
      ARM: OMAP: Move gpio.h to include/linux/platform_data
      Input: omap-keypad: Remove dependencies to mach includes
      W1: OMAP HDQ1W: Remove dependencies to mach/hardware.h
      ARM: OMAP2+: Prepare for irqs.h removal
      ARM: OMAP2+: Remove hardcoded IRQs and enable SPARSE_IRQ
      ARM: OMAP1: Move plat/irqs.h to mach/irqs.h
      ARM: OMAP: Remove unused old gpio-switch.h
      ARM: OMAP: Split plat/hardware.h, use local soc.h for omap2+
      ARM: OMAP2+ Move SoC specific headers to be local to mach-omap2
      ARM: OMAP1: Move SoC specific headers from plat to mach for omap1
      Merge tag 'omap-cleanup-a-for-3.7' of git://git.kernel.org/.../pjw/omap-pending into cleanup-makefile-sparse
      Merge tag 'omap-cleanup-b-for-3.7' of git://git.kernel.org/.../pjw/omap-pending into cleanup-makefile-sparse
      mfd: Fix compile for twl-core.c by removing cpu_is_omap usage
      ARM: OMAP1: Include gpio-omap.h for board-h2 and board-h3
      ARM: OMAP: Remove unused param.h
      ARM: OMAP: Remove smp.h
      ARM: OMAP1: Make plat/mux.h omap1 only
      ARM: OMAP1: Move board-ams-delta.h from plat to mach
      ARM: OMAP2+: Make id.h local
      ARM: OMAP2+: Make am35xx.h local
      ARM: OMAP2+: Make board-rx51.h local
      ARM: OMAP2+: Make ctrl_module_core_44xx.h local
      ARM: OMAP2+: Make ctrl_module_pad_core_44xx.h local
      ARM: OMAP2+: Make ctrl_module_pad_wkup_44xx.h local
      ARM: OMAP2+: Make ctrl_module_wkup_44xx.h local
      ARM: OMAP2+: Make omap-secure.h local
      ARM: OMAP2+: Make omap-wakeupgen.h local
      ARM: OMAP1: Move board-sx1.h from plat to mach
      ARM: OMAP1: Move board-voiceblue.h from plat to mach
      ARM: OMAP2+: Make debug-devices.h local
      ARM: OMAP1: Move flash.h from plat to mach
      ARM: OMAP2+: Make gpmc-smc91x.h local
      ARM: OMAP2+: Make gpmc-smsc911x.h local
      ARM: OMAP2+: Make hdq1w.h local
      ARM: OMAP1: Move irda.h from plat to mach
      ARM: OMAP2+: Make l3_2xxx.h local
      ARM: OMAP2+: Make l3_3xxx.h local
      ARM: OMAP2+: Make l4_2xxx.h local
      ARM: OMAP2+: Make l4_3xxx.h local
      ARM: OMAP2+: Make omap4-keypad.h local

Wei Yongjun (4):
      ARM i.MX: remove duplicated include from clk-imx21.c
      ARM: mach-shmobile: remove duplicated include from board-ag5evm.c
      ARM: msm: dma: use list_move_tail instead of list_del/list_add_tail
      ARM: mmp: using for_each_set_bit to simplify the code

Will Deacon (6):
      ARM: perf: add devicetree bindings for 11MPcore, A5, A7 and A15 PMUs
      ARM: pmu: remove unused reservation mechanism
      ARM: perf: remove mysterious compiler barrier
      ARM: perf: probe devicetree in preference to current CPU
      ARM: perf: prepare for moving CPU PMU code into separate file
      ARM: perf: move CPU-specific PMU handling code into separate file


 Documentation/arm/Samsung-S3C24XX/GPIO.txt      |   82 +-
 Documentation/arm/Samsung/GPIO.txt              |    8 +-
 Documentation/arm/memory.txt                    |    3 +
 Documentation/devicetree/bindings/arm/pmu.txt   |    4 +
 MAINTAINERS                                     |    1 -
 arch/arm/Kconfig                                |   43 +-
 arch/arm/Makefile                               |    1 -
 arch/arm/boot/dts/imx27-phytec-phycore.dts      |    2 +-
 arch/arm/boot/dts/tegra20-harmony.dts           |  220 ++++
 arch/arm/configs/pnx4008_defconfig              |  472 --------
 arch/arm/configs/prima2_defconfig               |    7 +-
 arch/arm/configs/tegra_defconfig                |    2 +
 arch/arm/include/asm/hardware/iop3xx.h          |   12 +-
 arch/arm/include/asm/io.h                       |    8 +
 arch/arm/include/asm/mach/map.h                 |    8 +
 arch/arm/include/asm/mach/pci.h                 |   13 +
 arch/arm/include/asm/perf_event.h               |    9 +-
 arch/arm/include/asm/pmu.h                      |   77 +-
 arch/arm/kernel/Makefile                        |    3 +-
 arch/arm/kernel/bios32.c                        |   54 +-
 arch/arm/kernel/perf_event.c                    |  347 +-----
 arch/arm/kernel/perf_event_cpu.c                |  295 +++++
 arch/arm/kernel/perf_event_v6.c                 |   12 +-
 arch/arm/kernel/perf_event_v7.c                 |   32 +-
 arch/arm/kernel/perf_event_xscale.c             |   10 +-
 arch/arm/kernel/pmu.c                           |   36 -
 arch/arm/mach-at91/at91x40.c                    |    2 +-
 arch/arm/mach-at91/at91x40_time.c               |    4 +-
 arch/arm/mach-at91/include/mach/hardware.h      |    4 +-
 arch/arm/mach-at91/include/mach/uncompress.h    |    6 +-
 arch/arm/mach-at91/setup.c                      |    4 +-
 arch/arm/mach-bcmring/arch.c                    |    5 +-
 arch/arm/mach-bcmring/core.c                    |    3 +-
 arch/arm/mach-bcmring/csp/chipc/chipcHw.c       |  137 +--
 arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c  |   90 +-
 arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c |   19 +-
 arch/arm/mach-bcmring/csp/dmac/dmacHw.c         |   27 +-
 arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c   |    6 +-
 arch/arm/mach-bcmring/csp/tmr/tmrHw.c           |    6 +-
 arch/arm/mach-bcmring/include/cfg_global.h      |   13 -
 arch/arm/mach-bcmring/include/csp/cache.h       |   35 -
 arch/arm/mach-bcmring/include/csp/delay.h       |   36 -
 arch/arm/mach-bcmring/include/csp/errno.h       |   32 -
 arch/arm/mach-bcmring/include/csp/intcHw.h      |   40 -
 arch/arm/mach-bcmring/include/csp/module.h      |   32 -
 arch/arm/mach-bcmring/include/csp/secHw.h       |   65 --
 arch/arm/mach-bcmring/include/csp/stdint.h      |   30 -
 arch/arm/mach-bcmring/include/csp/string.h      |   34 -
 .../{cfg_global_defines.h => mach/cfg_global.h} |   11 +
 .../mach-bcmring/include/mach/csp/cap_inline.h  |    2 +-
 .../mach-bcmring/include/mach/csp/chipcHw_def.h |    6 +-
 .../include/mach/csp/chipcHw_inline.h           |  119 +-
 .../mach-bcmring/include/mach/csp/chipcHw_reg.h |    6 +-
 .../arm/mach-bcmring/include/mach/csp/ddrcReg.h |    6 +-
 .../include/{ => mach}/csp/dmacHw.h             |    4 +-
 .../mach-bcmring/include/mach/csp/dmacHw_priv.h |    2 +-
 .../mach-bcmring/include/mach/csp/dmacHw_reg.h  |  106 +-
 arch/arm/mach-bcmring/include/mach/csp/hw_cfg.h |    2 +-
 .../mach-bcmring/include/mach/csp/intcHw_reg.h  |   18 +-
 .../arm/mach-bcmring/include/mach/csp/mm_addr.h |    2 +-
 arch/arm/mach-bcmring/include/mach/csp/mm_io.h  |    8 +-
 .../mach-bcmring/include/{ => mach}/csp/reg.h   |   25 +-
 .../include/mach/csp/secHw_inline.h             |   10 +-
 .../mach-bcmring/include/{ => mach}/csp/tmrHw.h |    2 +-
 arch/arm/mach-bcmring/include/mach/dma.h        |    2 +-
 arch/arm/mach-bcmring/include/mach/hardware.h   |    2 +-
 arch/arm/mach-bcmring/include/mach/reg_nand.h   |    2 +-
 arch/arm/mach-bcmring/include/mach/reg_umi.h    |    4 +-
 arch/arm/mach-bcmring/mm.c                      |    4 +-
 arch/arm/mach-bcmring/timer.c                   |    2 +-
 arch/arm/mach-dove/common.c                     |   10 -
 arch/arm/mach-dove/include/mach/dove.h          |    8 +-
 arch/arm/mach-dove/include/mach/io.h            |   19 -
 arch/arm/mach-dove/pcie.c                       |   43 +-
 arch/arm/mach-ebsa110/core.c                    |    8 +-
 arch/arm/mach-ebsa110/core.h                    |   12 +-
 arch/arm/mach-exynos/clock-exynos5.c            |    9 -
 arch/arm/mach-exynos/include/mach/map.h         |    1 -
 arch/arm/mach-footbridge/common.c               |   12 +-
 arch/arm/mach-footbridge/dc21285.c              |   16 +-
 .../mach-footbridge/include/mach/debug-macro.S  |    3 +-
 arch/arm/mach-footbridge/include/mach/io.h      |   12 +-
 arch/arm/mach-imx/Makefile                      |    2 +-
 arch/arm/mach-imx/clk-imx21.c                   |    1 -
 arch/arm/mach-imx/clk-imx51-imx53.c             |    4 +-
 arch/arm/mach-imx/clk-pllv1.c                   |   49 +-
 arch/arm/mach-imx/clk.c                         |    3 +
 arch/arm/mach-imx/clk.h                         |    3 +-
 arch/arm/mach-imx/mach-kzm_arm11_01.c           |    5 +-
 arch/arm/mach-imx/mach-mx31ads.c                |    2 +-
 arch/arm/mach-imx/mach-mx31lite.c               |    2 +-
 arch/arm/mach-integrator/core.c                 |    4 +-
 arch/arm/mach-integrator/cpu.c                  |    8 +-
 arch/arm/mach-integrator/include/mach/io.h      |   33 -
 .../arm/mach-integrator/include/mach/platform.h |    4 +
 arch/arm/mach-integrator/integrator_ap.c        |   21 +-
 arch/arm/mach-integrator/integrator_cp.c        |    6 +-
 arch/arm/mach-integrator/pci_v3.c               |   62 +-
 arch/arm/mach-iop13xx/include/mach/io.h         |   28 -
 arch/arm/mach-iop13xx/include/mach/iop13xx.h    |   48 +-
 arch/arm/mach-iop13xx/include/mach/memory.h     |   14 +-
 arch/arm/mach-iop13xx/io.c                      |   35 +-
 arch/arm/mach-iop13xx/pci.c                     |   53 +-
 arch/arm/mach-iop13xx/pci.h                     |    4 +-
 arch/arm/mach-iop13xx/setup.c                   |   20 +-
 arch/arm/mach-iop32x/glantank.c                 |    2 +-
 arch/arm/mach-iop32x/include/mach/io.h          |   19 -
 arch/arm/mach-iop33x/include/mach/io.h          |   19 -
 arch/arm/mach-ixp4xx/common.c                   |    8 +-
 arch/arm/mach-ixp4xx/include/mach/cpu.h         |    5 +-
 arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h |   10 +-
 arch/arm/mach-kirkwood/common.c                 |   10 -
 arch/arm/mach-kirkwood/include/mach/io.h        |   24 -
 arch/arm/mach-kirkwood/include/mach/kirkwood.h  |    8 +-
 arch/arm/mach-kirkwood/pcie.c                   |   44 +-
 arch/arm/mach-ks8695/cpu.c                      |    2 +-
 arch/arm/mach-ks8695/include/mach/hardware.h    |    2 +-
 arch/arm/mach-ks8695/include/mach/regs-timer.h  |   40 -
 arch/arm/mach-ks8695/include/mach/uncompress.h  |    6 +-
 arch/arm/mach-ks8695/time.c                     |  133 ++-
 arch/arm/mach-lpc32xx/common.c                  |    8 +-
 arch/arm/mach-lpc32xx/include/mach/hardware.h   |    2 +-
 arch/arm/mach-mmp/Makefile                      |    8 +-
 arch/arm/mach-mmp/clock-mmp2.c                  |  111 ++
 arch/arm/mach-mmp/clock-pxa168.c                |   91 ++
 arch/arm/mach-mmp/clock-pxa910.c                |   67 ++
 arch/arm/mach-mmp/common.h                      |    3 +
 arch/arm/mach-mmp/include/mach/regs-apbc.h      |   95 --
 arch/arm/mach-mmp/include/mach/regs-apmu.h      |   15 -
 arch/arm/mach-mmp/irq.c                         |    4 +-
 arch/arm/mach-mmp/mmp2.c                        |   71 +-
 arch/arm/mach-mmp/pxa168.c                      |   58 +-
 arch/arm/mach-mmp/pxa910.c                      |   40 +-
 arch/arm/mach-msm/Makefile                      |    4 +-
 arch/arm/mach-msm/acpuclock-arm11.c             |  525 ---------
 arch/arm/mach-msm/acpuclock.h                   |   32 -
 arch/arm/mach-msm/board-mahimahi.c              |    1 -
 arch/arm/mach-msm/board-msm7x27.c               |  170 ---
 arch/arm/mach-msm/board-sapphire.c              |    1 -
 arch/arm/mach-msm/clock-pcom.c                  |   18 +-
 arch/arm/mach-msm/dma.c                         |    3 +-
 arch/arm/mach-msm/idle.c                        |   49 -
 arch/arm/mach-msm/include/mach/board.h          |   10 -
 arch/arm/mach-msm/include/mach/system.h         |   19 -
 arch/arm/mach-msm/io.c                          |    3 +-
 arch/arm/mach-msm/proc_comm.c                   |    1 -
 arch/arm/mach-msm/smd.c                         |   26 +-
 arch/arm/mach-msm/timer.c                       |    2 +-
 arch/arm/mach-mv78xx0/addr-map.c                |    3 +-
 arch/arm/mach-mv78xx0/common.c                  |    5 -
 arch/arm/mach-mv78xx0/include/mach/io.h         |   24 -
 arch/arm/mach-mv78xx0/include/mach/mv78xx0.h    |   21 +-
 arch/arm/mach-mv78xx0/pcie.c                    |  110 +-
 arch/arm/mach-nomadik/include/mach/hardware.h   |    2 +-
 arch/arm/mach-nomadik/include/mach/uncompress.h |    8 +-
 arch/arm/mach-omap1/ams-delta-fiq-handler.S     |    3 +-
 arch/arm/mach-omap1/ams-delta-fiq.c             |    2 +-
 arch/arm/mach-omap1/board-ams-delta.c           |    8 +-
 arch/arm/mach-omap1/board-fsample.c             |    7 +-
 arch/arm/mach-omap1/board-generic.c             |    8 +-
 arch/arm/mach-omap1/board-h2.c                  |    9 +-
 arch/arm/mach-omap1/board-h3.c                  |    7 +-
 arch/arm/mach-omap1/board-htcherald.c           |    8 +-
 arch/arm/mach-omap1/board-innovator.c           |    6 +-
 arch/arm/mach-omap1/board-nokia770.c            |    8 +-
 arch/arm/mach-omap1/board-osk.c                 |    8 +-
 arch/arm/mach-omap1/board-palmte.c              |   10 +-
 arch/arm/mach-omap1/board-palmtt.c              |   10 +-
 arch/arm/mach-omap1/board-palmz71.c             |   10 +-
 arch/arm/mach-omap1/board-perseus2.c            |    7 +-
 arch/arm/mach-omap1/board-sx1-mmc.c             |    2 +-
 arch/arm/mach-omap1/board-sx1.c                 |   11 +-
 arch/arm/mach-omap1/board-voiceblue.c           |   12 +-
 arch/arm/mach-omap1/clock.c                     |    4 +-
 arch/arm/mach-omap1/clock_data.c                |   21 +-
 arch/arm/mach-omap1/devices.c                   |    5 +-
 arch/arm/mach-omap1/dma.c                       |    8 +-
 arch/arm/mach-omap1/flash.c                     |    2 +-
 arch/arm/mach-omap1/gpio15xx.c                  |    1 +
 arch/arm/mach-omap1/gpio16xx.c                  |    1 +
 arch/arm/mach-omap1/gpio7xx.c                   |    1 +
 arch/arm/mach-omap1/i2c.c                       |    2 +-
 .../arm/mach-omap1/include/mach/ams-delta-fiq.h |    2 -
 .../include/mach}/board-ams-delta.h             |    0
 .../include/mach}/board-sx1.h                   |    0
 .../include/mach}/board-voiceblue.h             |    0
 .../plat => mach-omap1/include/mach}/flash.h    |    0
 arch/arm/mach-omap1/include/mach/gpio.h         |    2 -
 arch/arm/mach-omap1/include/mach/hardware.h     |  285 ++++-
 .../plat => mach-omap1/include/mach}/irda.h     |    0
 arch/arm/mach-omap1/include/mach/irqs.h         |  267 ++++-
 .../plat => mach-omap1/include/mach}/mux.h      |    0
 .../plat => mach-omap1/include/mach}/omap1510.h |    3 +-
 .../plat => mach-omap1/include/mach}/omap16xx.h |    3 +-
 .../plat => mach-omap1/include/mach}/omap7xx.h  |    3 +-
 arch/arm/mach-omap1/include/mach/smp.h          |    5 -
 arch/arm/mach-omap1/io.c                        |    2 +-
 arch/arm/mach-omap1/lcd_dma.c                   |    6 +-
 arch/arm/mach-omap1/leds-h2p2-debug.c           |   13 +-
 arch/arm/mach-omap1/leds.c                      |    3 +-
 arch/arm/mach-omap1/mcbsp.c                     |    4 +-
 arch/arm/mach-omap1/mux.c                       |   58 +-
 arch/arm/mach-omap1/pm.c                        |    2 +-
 arch/arm/mach-omap1/serial.c                    |    3 +-
 arch/arm/mach-omap1/usb.c                       |    2 +-
 arch/arm/mach-omap2/Makefile                    |  108 +-
 .../include/plat => mach-omap2}/am33xx.h        |    0
 arch/arm/mach-omap2/am35xx-emac.c               |    2 +-
 arch/arm/mach-omap2/{include/mach => }/am35xx.h |    0
 arch/arm/mach-omap2/board-2430sdp.c             |    8 +-
 arch/arm/mach-omap2/board-3430sdp.c             |   14 +-
 arch/arm/mach-omap2/board-3630sdp.c             |    8 +-
 arch/arm/mach-omap2/board-4430sdp.c             |   18 +-
 arch/arm/mach-omap2/board-am3517crane.c         |   10 -
 arch/arm/mach-omap2/board-am3517evm.c           |   13 +-
 arch/arm/mach-omap2/board-apollon.c             |    2 -
 arch/arm/mach-omap2/board-cm-t35.c              |   16 +-
 arch/arm/mach-omap2/board-cm-t3517.c            |   13 +-
 arch/arm/mach-omap2/board-devkit8000.c          |   13 +-
 arch/arm/mach-omap2/board-flash.c               |    8 +-
 arch/arm/mach-omap2/board-generic.c             |    2 -
 arch/arm/mach-omap2/board-h4.c                  |    5 +-
 arch/arm/mach-omap2/board-igep0020.c            |    9 +-
 arch/arm/mach-omap2/board-ldp.c                 |   11 +-
 arch/arm/mach-omap2/board-n8x0.c                |   16 +-
 arch/arm/mach-omap2/board-omap3beagle.c         |    7 +-
 arch/arm/mach-omap2/board-omap3evm.c            |   29 +-
 arch/arm/mach-omap2/board-omap3logic.c          |   18 +-
 arch/arm/mach-omap2/board-omap3pandora.c        |    9 +-
 arch/arm/mach-omap2/board-omap3stalker.c        |   21 +-
 arch/arm/mach-omap2/board-omap3touchbook.c      |    9 +-
 arch/arm/mach-omap2/board-omap4panda.c          |   16 +-
 arch/arm/mach-omap2/board-overo.c               |   19 +-
 arch/arm/mach-omap2/board-rm680.c               |    8 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c    |   15 +-
 arch/arm/mach-omap2/board-rx51-video.c          |    4 +-
 arch/arm/mach-omap2/board-rx51.c                |    4 +-
 .../mach-omap2/{include/mach => }/board-rx51.h  |    0
 arch/arm/mach-omap2/board-ti8168evm.c           |    8 -
 arch/arm/mach-omap2/board-zoom-debugboard.c     |   12 +-
 arch/arm/mach-omap2/board-zoom-display.c        |    4 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c    |    6 +-
 arch/arm/mach-omap2/board-zoom.c                |    1 -
 arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c    |    2 +-
 arch/arm/mach-omap2/clkt34xx_dpll3m2.c          |   10 +-
 arch/arm/mach-omap2/clkt_clksel.c               |   28 +-
 arch/arm/mach-omap2/clkt_dpll.c                 |   10 +-
 arch/arm/mach-omap2/clock.c                     |   28 +-
 arch/arm/mach-omap2/clock2420_data.c            |    2 +-
 arch/arm/mach-omap2/clock2430.c                 |    2 +-
 arch/arm/mach-omap2/clock2430_data.c            |    3 +-
 arch/arm/mach-omap2/clock2xxx.c                 |    2 +-
 arch/arm/mach-omap2/clock33xx_data.c            |    2 +-
 arch/arm/mach-omap2/clock3xxx.c                 |    5 +-
 arch/arm/mach-omap2/clock3xxx_data.c            |    3 +-
 arch/arm/mach-omap2/clock44xx_data.c            |    2 +-
 arch/arm/mach-omap2/clockdomain.c               |   74 +-
 arch/arm/mach-omap2/cm2xxx_3xxx.c               |    3 +-
 arch/arm/mach-omap2/common-board-devices.c      |    8 +-
 arch/arm/mach-omap2/common.c                    |    4 +-
 arch/arm/mach-omap2/common.h                    |    9 +-
 arch/arm/mach-omap2/control.c                   |    2 +-
 arch/arm/mach-omap2/control.h                   |   10 +-
 arch/arm/mach-omap2/cpuidle34xx.c               |    1 -
 .../{include/mach => }/ctrl_module_core_44xx.h  |    0
 .../mach => }/ctrl_module_pad_core_44xx.h       |    0
 .../mach => }/ctrl_module_pad_wkup_44xx.h       |    0
 .../{include/mach => }/ctrl_module_wkup_44xx.h  |    0
 arch/arm/mach-omap2/debug-devices.h             |    9 +
 arch/arm/mach-omap2/devices.c                   |   31 +-
 arch/arm/mach-omap2/dpll3xxx.c                  |    9 +-
 arch/arm/mach-omap2/dpll44xx.c                  |    2 +-
 arch/arm/mach-omap2/dsp.c                       |    2 +-
 arch/arm/mach-omap2/emu.c                       |    3 +-
 arch/arm/mach-omap2/gpio.c                      |    1 +
 arch/arm/mach-omap2/gpmc-nand.c                 |   34 +-
 arch/arm/mach-omap2/gpmc-onenand.c              |   29 +-
 arch/arm/mach-omap2/gpmc-smc91x.c               |    5 +-
 .../include/plat => mach-omap2}/gpmc-smc91x.h   |    0
 arch/arm/mach-omap2/gpmc-smsc911x.c             |    3 +-
 .../include/plat => mach-omap2}/gpmc-smsc911x.h |    0
 arch/arm/mach-omap2/gpmc.c                      |  169 ++-
 arch/arm/mach-omap2/hdq1w.c                     |    2 +-
 .../include/plat => mach-omap2}/hdq1w.h         |    0
 arch/arm/mach-omap2/hsmmc.c                     |    3 +-
 arch/arm/mach-omap2/i2c.c                       |    1 -
 arch/arm/mach-omap2/id.c                        |    9 +-
 arch/arm/mach-omap2/{include/mach => }/id.h     |    0
 arch/arm/mach-omap2/include/mach/gpio.h         |    2 -
 arch/arm/mach-omap2/include/mach/hardware.h     |    2 -
 arch/arm/mach-omap2/include/mach/irqs.h         |    2 -
 arch/arm/mach-omap2/include/mach/smp.h          |    5 -
 arch/arm/mach-omap2/io.c                        |    1 +
 arch/arm/mach-omap2/irq.c                       |   10 +-
 .../include/plat => mach-omap2}/l3_2xxx.h       |    0
 .../include/plat => mach-omap2}/l3_3xxx.h       |    0
 .../include/plat => mach-omap2}/l4_2xxx.h       |    0
 .../include/plat => mach-omap2}/l4_3xxx.h       |    0
 arch/arm/mach-omap2/mailbox.c                   |    4 +-
 arch/arm/mach-omap2/mcbsp.c                     |    4 +-
 arch/arm/mach-omap2/msdi.c                      |    1 +
 arch/arm/mach-omap2/omap-hotplug.c              |    2 +-
 arch/arm/mach-omap2/omap-iommu.c                |   12 +-
 arch/arm/mach-omap2/omap-mpuss-lowpower.c       |    3 +-
 arch/arm/mach-omap2/omap-secure.c               |    2 +-
 .../mach-omap2/{include/mach => }/omap-secure.h |    0
 arch/arm/mach-omap2/omap-smp.c                  |    6 +-
 arch/arm/mach-omap2/omap-wakeupgen.c            |    5 +-
 .../{include/mach => }/omap-wakeupgen.h         |    0
 .../include/plat => mach-omap2}/omap24xx.h      |    2 -
 .../include/plat => mach-omap2}/omap34xx.h      |    2 -
 arch/arm/mach-omap2/omap4-common.c              |   11 +-
 .../include/plat => mach-omap2}/omap4-keypad.h  |    2 +
 .../include/plat => mach-omap2}/omap44xx.h      |    2 +-
 .../include/plat => mach-omap2}/omap54xx.h      |    0
 arch/arm/mach-omap2/omap_hwmod.c                |   24 +-
 arch/arm/mach-omap2/omap_hwmod_2420_data.c      |   32 +-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c      |   80 +-
 .../omap_hwmod_2xxx_3xxx_ipblock_data.c         |  110 +-
 .../omap_hwmod_2xxx_interconnect_data.c         |    4 +-
 .../mach-omap2/omap_hwmod_2xxx_ipblock_data.c   |   10 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c      |  160 +--
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c      |    7 +-
 arch/arm/mach-omap2/omap_hwmod_common_data.h    |    1 +
 arch/arm/mach-omap2/omap_l3_noc.c               |    5 +-
 arch/arm/mach-omap2/omap_phy_internal.c         |    2 +
 arch/arm/mach-omap2/opp.c                       |   15 +-
 arch/arm/mach-omap2/opp2420_data.c              |    2 +-
 arch/arm/mach-omap2/opp2430_data.c              |    2 +-
 arch/arm/mach-omap2/opp3xxx_data.c              |    2 -
 arch/arm/mach-omap2/opp4xxx_data.c              |    3 +-
 arch/arm/mach-omap2/pm-debug.c                  |    1 -
 arch/arm/mach-omap2/pm.c                        |    4 +-
 arch/arm/mach-omap2/pm24xx.c                    |   14 +-
 arch/arm/mach-omap2/pm34xx.c                    |   10 +-
 arch/arm/mach-omap2/pm44xx.c                    |    8 +-
 arch/arm/mach-omap2/powerdomain.c               |   42 +-
 arch/arm/mach-omap2/powerdomain2xxx_3xxx.c      |    4 +-
 arch/arm/mach-omap2/powerdomain44xx.c           |    4 +-
 arch/arm/mach-omap2/powerdomains3xxx_data.c     |    4 +-
 arch/arm/mach-omap2/prcm.c                      |    9 +-
 arch/arm/mach-omap2/prm2xxx_3xxx.c              |    7 +-
 arch/arm/mach-omap2/prm44xx.c                   |    5 +-
 arch/arm/mach-omap2/prm_common.c                |    1 -
 arch/arm/mach-omap2/sdrc2xxx.c                  |    2 +-
 arch/arm/mach-omap2/serial.c                    |   14 +-
 arch/arm/mach-omap2/sleep24xx.S                 |    3 +-
 arch/arm/mach-omap2/sleep34xx.S                 |    2 +-
 arch/arm/mach-omap2/sleep44xx.S                 |    4 +-
 arch/arm/mach-omap2/soc.h                       |    7 +
 arch/arm/mach-omap2/sr_device.c                 |   13 +-
 arch/arm/mach-omap2/sram242x.S                  |    3 +-
 arch/arm/mach-omap2/sram243x.S                  |    3 +-
 arch/arm/mach-omap2/sram34xx.S                  |    3 +-
 .../include/plat => mach-omap2}/ti81xx.h        |    0
 arch/arm/mach-omap2/timer.c                     |   11 +-
 arch/arm/mach-omap2/twl-common.c                |   38 +-
 arch/arm/mach-omap2/twl-common.h                |    9 +-
 arch/arm/mach-omap2/usb-host.c                  |    2 -
 arch/arm/mach-omap2/usb-musb.c                  |    7 +-
 arch/arm/mach-omap2/vc.c                        |    8 +-
 arch/arm/mach-omap2/voltage.c                   |   12 +-
 arch/arm/mach-omap2/voltage.h                   |    2 +-
 arch/arm/mach-omap2/voltagedomains3xxx_data.c   |    3 +-
 arch/arm/mach-omap2/vp.c                        |   16 +-
 arch/arm/mach-orion5x/common.c                  |   10 -
 arch/arm/mach-orion5x/include/mach/io.h         |   22 -
 arch/arm/mach-orion5x/include/mach/orion5x.h    |   20 +-
 arch/arm/mach-orion5x/pci.c                     |   56 +-
 arch/arm/mach-pnx4008/Makefile                  |   12 -
 arch/arm/mach-pnx4008/Makefile.boot             |    4 -
 arch/arm/mach-pnx4008/clock.c                   | 1001 ----------------
 arch/arm/mach-pnx4008/clock.h                   |   43 -
 arch/arm/mach-pnx4008/core.c                    |  290 -----
 arch/arm/mach-pnx4008/dma.c                     | 1105 ------------------
 arch/arm/mach-pnx4008/gpio.c                    |  328 ------
 arch/arm/mach-pnx4008/i2c.c                     |   86 --
 arch/arm/mach-pnx4008/include/mach/clock.h      |   62 -
 .../arm/mach-pnx4008/include/mach/debug-macro.S |   21 -
 arch/arm/mach-pnx4008/include/mach/dma.h        |  160 ---
 .../arm/mach-pnx4008/include/mach/entry-macro.S |  116 --
 .../mach-pnx4008/include/mach/gpio-pnx4008.h    |  241 ----
 arch/arm/mach-pnx4008/include/mach/hardware.h   |   32 -
 arch/arm/mach-pnx4008/include/mach/irq.h        |   42 -
 arch/arm/mach-pnx4008/include/mach/irqs.h       |  215 ----
 arch/arm/mach-pnx4008/include/mach/param.h      |   21 -
 arch/arm/mach-pnx4008/include/mach/platform.h   |   69 --
 arch/arm/mach-pnx4008/include/mach/pm.h         |   33 -
 arch/arm/mach-pnx4008/include/mach/timex.h      |   19 -
 arch/arm/mach-pnx4008/include/mach/uncompress.h |   46 -
 arch/arm/mach-pnx4008/irq.c                     |  121 --
 arch/arm/mach-pnx4008/pm.c                      |  153 ---
 arch/arm/mach-pnx4008/serial.c                  |   67 --
 arch/arm/mach-pnx4008/sleep.S                   |  195 ----
 arch/arm/mach-pnx4008/time.c                    |  134 ---
 arch/arm/mach-pnx4008/time.h                    |   70 --
 arch/arm/mach-prima2/Kconfig                    |   19 +
 arch/arm/mach-prima2/Makefile                   |    4 +-
 arch/arm/mach-prima2/{prima2.c => common.c}     |   11 +-
 arch/arm/mach-prima2/include/mach/uncompress.h  |    4 +-
 arch/arm/mach-prima2/irq.c                      |    2 +-
 arch/arm/mach-pxa/devices.c                     |    3 +-
 arch/arm/mach-realview/realview_eb.c            |    3 +-
 arch/arm/mach-realview/realview_pb1176.c        |    3 +-
 arch/arm/mach-realview/realview_pb11mp.c        |    3 +-
 arch/arm/mach-realview/realview_pba8.c          |    3 +-
 arch/arm/mach-realview/realview_pbx.c           |    3 +-
 arch/arm/mach-s3c24xx/h1940-bluetooth.c         |   14 +-
 arch/arm/mach-s3c24xx/mach-anubis.c             |    3 +-
 arch/arm/mach-s3c24xx/mach-jive.c               |   12 +-
 arch/arm/mach-s3c24xx/mach-mini2440.c           |    4 +-
 arch/arm/mach-s3c24xx/mach-nexcoder.c           |   22 +-
 arch/arm/mach-s3c24xx/mach-osiris-dvs.c         |   13 +-
 arch/arm/mach-s3c24xx/mach-osiris.c             |    7 +-
 arch/arm/mach-sa1100/include/mach/simpad.h      |    2 +-
 arch/arm/mach-sa1100/simpad.c                   |    2 +-
 arch/arm/mach-shark/core.c                      |   18 -
 arch/arm/mach-shark/include/mach/debug-macro.S  |    7 +-
 arch/arm/mach-shark/include/mach/entry-macro.S  |    3 +-
 arch/arm/mach-shark/include/mach/io.h           |   18 -
 arch/arm/mach-shark/pci.c                       |    5 +
 arch/arm/mach-shmobile/board-ag5evm.c           |    1 -
 arch/arm/mach-shmobile/board-ap4evb.c           |   12 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c  |    6 +-
 arch/arm/mach-shmobile/board-bonito.c           |    8 +-
 arch/arm/mach-shmobile/board-g3evm.c            |   12 +-
 arch/arm/mach-shmobile/board-g4evm.c            |   30 +-
 arch/arm/mach-shmobile/board-kzm9g.c            |    8 +-
 arch/arm/mach-shmobile/board-mackerel.c         |   22 +-
 arch/arm/mach-shmobile/clock-r8a7740.c          |   46 +-
 arch/arm/mach-shmobile/clock-sh7367.c           |   44 +-
 arch/arm/mach-shmobile/clock-sh7372.c           |   60 +-
 arch/arm/mach-shmobile/clock-sh7377.c           |   50 +-
 arch/arm/mach-shmobile/clock-sh73a0.c           |   70 +-
 arch/arm/mach-shmobile/include/mach/gpio.h      |    6 +-
 arch/arm/mach-shmobile/intc-r8a7779.c           |   14 +-
 arch/arm/mach-shmobile/intc-sh7372.c            |   27 +-
 arch/arm/mach-shmobile/intc-sh73a0.c            |   20 +-
 arch/arm/mach-shmobile/pm-rmobile.c             |    6 +-
 arch/arm/mach-shmobile/pm-sh7372.c              |   57 +-
 arch/arm/mach-shmobile/setup-sh7367.c           |    2 +-
 arch/arm/mach-shmobile/setup-sh7377.c           |    2 +-
 arch/arm/mach-shmobile/setup-sh73a0.c           |    2 +-
 arch/arm/mach-spear13xx/include/mach/spear.h    |   14 +-
 arch/arm/mach-spear13xx/spear13xx.c             |    6 +-
 arch/arm/mach-tegra/Kconfig                     |   27 -
 arch/arm/mach-tegra/Makefile                    |   12 +-
 arch/arm/mach-tegra/apbio.c                     |  122 +-
 arch/arm/mach-tegra/board-dt-tegra20.c          |   23 +-
 arch/arm/mach-tegra/board-harmony-pcie.c        |   49 +-
 arch/arm/mach-tegra/board-harmony-pinmux.c      |  156 ---
 arch/arm/mach-tegra/board-harmony-power.c       |  156 ---
 arch/arm/mach-tegra/board-harmony.c             |  197 ----
 arch/arm/mach-tegra/board-harmony.h             |   41 -
 arch/arm/mach-tegra/board-paz00-pinmux.c        |  156 ---
 arch/arm/mach-tegra/board-paz00.c               |  192 ---
 arch/arm/mach-tegra/board-paz00.h               |   17 +-
 arch/arm/mach-tegra/board-trimslice-pinmux.c    |  155 ---
 arch/arm/mach-tegra/board-trimslice.c           |  183 ---
 arch/arm/mach-tegra/board-trimslice.h           |   30 -
 arch/arm/mach-tegra/devices.c                   |    3 +-
 arch/arm/mach-tegra/dma.c                       |  823 -------------
 arch/arm/mach-tegra/fuse.c                      |    4 +-
 arch/arm/mach-tegra/include/mach/dma.h          |   97 --
 arch/arm/mach-tegra/include/mach/io.h           |   46 -
 arch/arm/mach-tegra/include/mach/iomap.h        |    3 +
 arch/arm/mach-tegra/pcie.c                      |   95 +-
 arch/arm/mach-u300/Kconfig                      |   43 +-
 arch/arm/mach-u300/Makefile                     |    1 -
 arch/arm/mach-u300/core.c                       |  100 +-
 .../mach-u300/{include/mach => }/dma_channels.h |   11 +-
 arch/arm/mach-u300/i2c.c                        |    6 +-
 arch/arm/mach-u300/include/mach/clkdev.h        |    7 -
 arch/arm/mach-u300/include/mach/irqs.h          |   36 +-
 arch/arm/mach-u300/include/mach/platform.h      |   20 -
 arch/arm/mach-u300/include/mach/syscon.h        |   32 +-
 arch/arm/mach-u300/include/mach/u300-regs.h     |   19 +-
 arch/arm/mach-u300/spi.c                        |    2 +-
 arch/arm/mach-u300/timer.c                      |    5 +-
 arch/arm/mach-u300/timer.h                      |    1 +
 arch/arm/mach-u300/u300-gpio.h                  |   46 +-
 arch/arm/mach-u300/u300.c                       |   57 -
 arch/arm/mach-ux500/cpu-db8500.c                |    3 +-
 arch/arm/mach-versatile/core.c                  |    5 -
 arch/arm/mach-versatile/include/mach/hardware.h |    1 -
 arch/arm/mach-versatile/include/mach/io.h       |   27 -
 arch/arm/mach-versatile/pci.c                   |   22 +-
 arch/arm/mach-vexpress/ct-ca9x4.c               |    3 +-
 arch/arm/mm/ioremap.c                           |   14 +
 arch/arm/mm/mmu.c                               |   54 +-
 arch/arm/plat-iop/pci.c                         |   25 +-
 arch/arm/plat-iop/pmu.c                         |    3 +-
 arch/arm/plat-iop/setup.c                       |    5 -
 arch/arm/plat-mxc/Makefile                      |    2 +-
 arch/arm/plat-mxc/clock.c                       |  257 ----
 arch/arm/plat-mxc/cpufreq.c                     |    1 -
 arch/arm/plat-mxc/devices/platform-imx-uart.c   |    2 +-
 arch/arm/plat-mxc/include/mach/clock.h          |   70 --
 arch/arm/plat-mxc/include/mach/mx2_cam.h        |    2 -
 arch/arm/plat-mxc/include/mach/mx31.h           |    6 +-
 arch/arm/plat-mxc/system.c                      |    4 -
 arch/arm/plat-omap/Kconfig                      |    1 +
 arch/arm/plat-omap/Makefile                     |    3 +-
 arch/arm/plat-omap/common.c                     |   42 +-
 arch/arm/plat-omap/counter_32k.c                |    3 -
 arch/arm/plat-omap/debug-devices.c              |    3 -
 arch/arm/plat-omap/debug-leds.c                 |    1 +
 arch/arm/plat-omap/devices.c                    |   92 --
 arch/arm/plat-omap/dma.c                        |   54 +-
 arch/arm/plat-omap/fb.c                         |    2 -
 arch/arm/plat-omap/i2c.c                        |    4 +-
 arch/arm/plat-omap/include/plat/board.h         |  138 ---
 arch/arm/plat-omap/include/plat/cpu.h           |    3 +
 arch/arm/plat-omap/include/plat/dma.h           |    2 +
 arch/arm/plat-omap/include/plat/gpio-switch.h   |   54 -
 arch/arm/plat-omap/include/plat/gpmc.h          |   19 +
 arch/arm/plat-omap/include/plat/hardware.h      |  293 -----
 arch/arm/plat-omap/include/plat/irqs-44xx.h     |  144 ---
 arch/arm/plat-omap/include/plat/irqs.h          |  453 -------
 arch/arm/plat-omap/include/plat/mmc.h           |    1 -
 arch/arm/plat-omap/include/plat/omap-serial.h   |    4 +-
 arch/arm/plat-omap/include/plat/param.h         |    8 -
 arch/arm/plat-omap/include/plat/usb.h           |    1 -
 arch/arm/plat-omap/mux.c                        |   90 --
 arch/arm/plat-omap/omap-pm-noop.c               |   39 +-
 arch/arm/plat-omap/omap_device.c                |   25 +-
 arch/arm/plat-omap/sram.c                       |    1 -
 arch/arm/plat-samsung/devs.c                    |    3 +-
 arch/arm/plat-samsung/include/plat/gpio-fns.h   |   97 --
 arch/arm/plat-samsung/s5p-irq-gpioint.c         |    4 +-
 arch/arm/tools/mach-types                       |    1 -
 drivers/dma/omap-dma.c                          |    2 +
 drivers/gpio/gpio-omap.c                        |   15 +-
 drivers/gpio/gpio-samsung.c                     |   40 -
 drivers/gpio/gpio-tegra.c                       |    3 -
 drivers/gpio/gpio-twl4030.c                     |   15 +-
 drivers/i2c/busses/Kconfig                      |    2 +-
 drivers/i2c/busses/i2c-iop3xx.c                 |  121 +-
 drivers/input/keyboard/Kconfig                  |    2 +-
 drivers/input/keyboard/omap-keypad.c            |  156 +--
 drivers/input/mouse/rpcmouse.c                  |    2 +-
 drivers/input/serio/ams_delta_serio.c           |    2 +-
 drivers/media/video/omap/omap_vout.c            |    1 +
 drivers/media/video/omap3isp/isp.c              |    2 +
 drivers/mfd/twl-core.c                          |   54 +-
 drivers/mmc/host/omap.c                         |    2 -
 drivers/mmc/host/omap_hsmmc.c                   |    1 -
 drivers/mmc/host/sdhci-tegra.c                  |    1 -
 drivers/mtd/nand/ams-delta.c                    |   10 +-
 drivers/mtd/nand/bcm_umi_nand.c                 |   12 +-
 drivers/mtd/nand/nand_bcm_umi.h                 |   73 +-
 drivers/mtd/nand/omap2.c                        |  303 +++--
 drivers/mtd/onenand/omap2.c                     |   34 +-
 drivers/net/ethernet/seeq/ether3.c              |    4 +-
 drivers/pcmcia/omap_cf.c                        |    2 +-
 drivers/pinctrl/pinctrl-coh901.c                |  220 +---
 drivers/power/avs/smartreflex.c                 |    2 +
 drivers/remoteproc/omap_remoteproc.c            |    2 +-
 drivers/scsi/arm/eesox.c                        |    2 +-
 drivers/spi/Kconfig                             |    2 +-
 drivers/spi/spi-omap-uwire.c                    |    5 +-
 drivers/spi/spi-omap2-mcspi.c                   |    2 +-
 drivers/spi/spi-tegra.c                         |   55 +-
 drivers/staging/tidspbridge/core/dsp-clock.c    |    2 +-
 drivers/staging/tidspbridge/core/tiomap3430.c   |    2 +-
 .../staging/tidspbridge/core/tiomap3430_pwr.c   |    2 +-
 drivers/staging/tidspbridge/core/tiomap_io.c    |    2 +-
 drivers/staging/tidspbridge/core/wdt.c          |    2 +-
 .../staging/tidspbridge/rmgr/drv_interface.c    |    2 +-
 drivers/tty/serial/serial_ks8695.c              |    4 +-
 drivers/usb/Kconfig                             |    1 -
 drivers/usb/host/Kconfig                        |    2 +-
 drivers/usb/host/ohci-hcd.c                     |    2 +-
 drivers/usb/host/ohci-nxp.c                     |   84 +-
 drivers/usb/host/ohci-omap.c                    |    2 +-
 drivers/usb/musb/tusb6010_omap.c                |    1 -
 drivers/usb/otg/isp1301_omap.c                  |    2 +-
 drivers/video/backlight/omap1_bl.c              |    4 +-
 drivers/video/da8xx-fb.c                        |    8 +-
 drivers/video/omap/lcd_ams_delta.c              |    3 +-
 drivers/video/omap/lcd_mipid.c                  |    2 +-
 drivers/video/omap/lcd_osk.c                    |    2 +-
 drivers/video/omap2/dss/dispc.c                 |    1 +
 drivers/video/omap2/omapfb/omapfb-main.c        |    1 +
 drivers/watchdog/Kconfig                        |    6 +-
 drivers/watchdog/ks8695_wdt.c                   |   14 +-
 drivers/watchdog/omap_wdt.c                     |    5 +
 include/linux/i2c/twl.h                         |    3 -
 include/linux/mfd/twl6040.h                     |    1 -
 include/linux/omapfb.h                          |    7 +-
 .../linux/platform_data/asoc-ti-mcbsp.h         |    0
 .../linux/platform_data/dsp-omap.h              |    0
 .../linux/platform_data/gpio-omap.h             |   15 +-
 .../linux/platform_data/keypad-omap.h           |    0
 .../linux/platform_data/lcd-mipid.h             |    0
 .../linux/platform_data/mtd-nand-omap2.h        |    3 +-
 .../linux/platform_data/mtd-onenand-omap2.h     |    0
 include/linux/platform_data/omap1_bl.h          |   11 +
 .../linux/platform_data/pinctrl-coh901.h        |   13 +-
 .../linux/platform_data/remoteproc-omap.h       |    0
 .../linux/platform_data/spi-omap2-mcspi.h       |    0
 .../linux/platform_data/voltage-omap.h          |    0
 include/linux/power/smartreflex.h               |    2 +-
 sound/soc/omap/am3517evm.c                      |    2 +-
 sound/soc/omap/ams-delta.c                      |    4 +-
 sound/soc/omap/igep0020.c                       |    2 +-
 sound/soc/omap/mcbsp.c                          |    4 +-
 sound/soc/omap/n810.c                           |    2 +-
 sound/soc/omap/omap-abe-twl6040.c               |    4 -
 sound/soc/omap/omap-mcbsp.c                     |    3 +-
 sound/soc/omap/omap-mcpdm.c                     |    2 +
 sound/soc/omap/omap-pcm.c                       |    1 +
 sound/soc/omap/omap3beagle.c                    |    2 +-
 sound/soc/omap/omap3evm.c                       |    2 +-
 sound/soc/omap/omap3pandora.c                   |    2 +-
 sound/soc/omap/osk5912.c                        |    2 +-
 sound/soc/omap/overo.c                          |    2 +-
 sound/soc/omap/rx51.c                           |    2 +-
 sound/soc/omap/sdp3430.c                        |    3 +-
 sound/soc/omap/zoom2.c                          |    2 +-
 sound/soc/tegra/Kconfig                         |    2 +-
 sound/soc/tegra/tegra_pcm.c                     |  232 ----
 sound/soc/tegra/tegra_pcm.h                     |   14 -
 623 files changed, 4618 insertions(+), 15490 deletions(-)
 delete mode 100644 arch/arm/configs/pnx4008_defconfig
 create mode 100644 arch/arm/kernel/perf_event_cpu.c
 delete mode 100644 arch/arm/kernel/pmu.c
 delete mode 100644 arch/arm/mach-bcmring/include/cfg_global.h
 delete mode 100644 arch/arm/mach-bcmring/include/csp/cache.h
 delete mode 100644 arch/arm/mach-bcmring/include/csp/delay.h
 delete mode 100644 arch/arm/mach-bcmring/include/csp/errno.h
 delete mode 100644 arch/arm/mach-bcmring/include/csp/intcHw.h
 delete mode 100644 arch/arm/mach-bcmring/include/csp/module.h
 delete mode 100644 arch/arm/mach-bcmring/include/csp/secHw.h
 delete mode 100644 arch/arm/mach-bcmring/include/csp/stdint.h
 delete mode 100644 arch/arm/mach-bcmring/include/csp/string.h
 rename arch/arm/mach-bcmring/include/{cfg_global_defines.h => mach/cfg_global.h} (74%)
 rename arch/arm/mach-bcmring/include/{ => mach}/csp/dmacHw.h (99%)
 rename arch/arm/mach-bcmring/include/{ => mach}/csp/reg.h (81%)
 rename arch/arm/mach-bcmring/include/{ => mach}/csp/tmrHw.h (99%)
 delete mode 100644 arch/arm/mach-dove/include/mach/io.h
 create mode 100644 arch/arm/mach-imx/clk.c
 delete mode 100644 arch/arm/mach-integrator/include/mach/io.h
 delete mode 100644 arch/arm/mach-iop13xx/include/mach/io.h
 delete mode 100644 arch/arm/mach-iop32x/include/mach/io.h
 delete mode 100644 arch/arm/mach-iop33x/include/mach/io.h
 delete mode 100644 arch/arm/mach-kirkwood/include/mach/io.h
 delete mode 100644 arch/arm/mach-ks8695/include/mach/regs-timer.h
 create mode 100644 arch/arm/mach-mmp/clock-mmp2.c
 create mode 100644 arch/arm/mach-mmp/clock-pxa168.c
 create mode 100644 arch/arm/mach-mmp/clock-pxa910.c
 delete mode 100644 arch/arm/mach-msm/acpuclock-arm11.c
 delete mode 100644 arch/arm/mach-msm/acpuclock.h
 delete mode 100644 arch/arm/mach-msm/board-msm7x27.c
 delete mode 100644 arch/arm/mach-msm/idle.c
 delete mode 100644 arch/arm/mach-msm/include/mach/system.h
 delete mode 100644 arch/arm/mach-mv78xx0/include/mach/io.h
 rename arch/arm/{plat-omap/include/plat => mach-omap1/include/mach}/board-ams-delta.h (100%)
 rename arch/arm/{plat-omap/include/plat => mach-omap1/include/mach}/board-sx1.h (100%)
 rename arch/arm/{plat-omap/include/plat => mach-omap1/include/mach}/board-voiceblue.h (100%)
 rename arch/arm/{plat-omap/include/plat => mach-omap1/include/mach}/flash.h (100%)
 rename arch/arm/{plat-omap/include/plat => mach-omap1/include/mach}/irda.h (100%)
 rename arch/arm/{plat-omap/include/plat => mach-omap1/include/mach}/mux.h (100%)
 rename arch/arm/{plat-omap/include/plat => mach-omap1/include/mach}/omap1510.h (97%)
 rename arch/arm/{plat-omap/include/plat => mach-omap1/include/mach}/omap16xx.h (99%)
 rename arch/arm/{plat-omap/include/plat => mach-omap1/include/mach}/omap7xx.h (98%)
 delete mode 100644 arch/arm/mach-omap1/include/mach/smp.h
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/am33xx.h (100%)
 rename arch/arm/mach-omap2/{include/mach => }/am35xx.h (100%)
 rename arch/arm/mach-omap2/{include/mach => }/board-rx51.h (100%)
 rename arch/arm/mach-omap2/{include/mach => }/ctrl_module_core_44xx.h (100%)
 rename arch/arm/mach-omap2/{include/mach => }/ctrl_module_pad_core_44xx.h (100%)
 rename arch/arm/mach-omap2/{include/mach => }/ctrl_module_pad_wkup_44xx.h (100%)
 rename arch/arm/mach-omap2/{include/mach => }/ctrl_module_wkup_44xx.h (100%)
 create mode 100644 arch/arm/mach-omap2/debug-devices.h
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/gpmc-smc91x.h (100%)
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/gpmc-smsc911x.h (100%)
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/hdq1w.h (100%)
 rename arch/arm/mach-omap2/{include/mach => }/id.h (100%)
 delete mode 100644 arch/arm/mach-omap2/include/mach/smp.h
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/l3_2xxx.h (100%)
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/l3_3xxx.h (100%)
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/l4_2xxx.h (100%)
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/l4_3xxx.h (100%)
 rename arch/arm/mach-omap2/{include/mach => }/omap-secure.h (100%)
 rename arch/arm/mach-omap2/{include/mach => }/omap-wakeupgen.h (100%)
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/omap24xx.h (98%)
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/omap34xx.h (98%)
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/omap4-keypad.h (87%)
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/omap44xx.h (97%)
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/omap54xx.h (100%)
 create mode 100644 arch/arm/mach-omap2/soc.h
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/ti81xx.h (100%)
 delete mode 100644 arch/arm/mach-orion5x/include/mach/io.h
 delete mode 100644 arch/arm/mach-pnx4008/Makefile
 delete mode 100644 arch/arm/mach-pnx4008/Makefile.boot
 delete mode 100644 arch/arm/mach-pnx4008/clock.c
 delete mode 100644 arch/arm/mach-pnx4008/clock.h
 delete mode 100644 arch/arm/mach-pnx4008/core.c
 delete mode 100644 arch/arm/mach-pnx4008/dma.c
 delete mode 100644 arch/arm/mach-pnx4008/gpio.c
 delete mode 100644 arch/arm/mach-pnx4008/i2c.c
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/clock.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/dma.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/gpio-pnx4008.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/irq.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/param.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/platform.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/pm.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/timex.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-pnx4008/irq.c
 delete mode 100644 arch/arm/mach-pnx4008/pm.c
 delete mode 100644 arch/arm/mach-pnx4008/serial.c
 delete mode 100644 arch/arm/mach-pnx4008/sleep.S
 delete mode 100644 arch/arm/mach-pnx4008/time.c
 delete mode 100644 arch/arm/mach-pnx4008/time.h
 create mode 100644 arch/arm/mach-prima2/Kconfig
 rename arch/arm/mach-prima2/{prima2.c => common.c} (81%)
 delete mode 100644 arch/arm/mach-shark/include/mach/io.h
 delete mode 100644 arch/arm/mach-tegra/board-harmony-pinmux.c
 delete mode 100644 arch/arm/mach-tegra/board-harmony-power.c
 delete mode 100644 arch/arm/mach-tegra/board-harmony.c
 delete mode 100644 arch/arm/mach-tegra/board-harmony.h
 delete mode 100644 arch/arm/mach-tegra/board-paz00-pinmux.c
 delete mode 100644 arch/arm/mach-tegra/board-trimslice-pinmux.c
 delete mode 100644 arch/arm/mach-tegra/board-trimslice.c
 delete mode 100644 arch/arm/mach-tegra/board-trimslice.h
 delete mode 100644 arch/arm/mach-tegra/dma.c
 delete mode 100644 arch/arm/mach-tegra/include/mach/io.h
 rename arch/arm/mach-u300/{include/mach => }/dma_channels.h (88%)
 delete mode 100644 arch/arm/mach-u300/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-u300/include/mach/platform.h
 create mode 100644 arch/arm/mach-u300/timer.h
 delete mode 100644 arch/arm/mach-u300/u300.c
 delete mode 100644 arch/arm/mach-versatile/include/mach/io.h
 delete mode 100644 arch/arm/plat-mxc/clock.c
 delete mode 100644 arch/arm/plat-mxc/include/mach/clock.h
 delete mode 100644 arch/arm/plat-omap/devices.c
 delete mode 100644 arch/arm/plat-omap/include/plat/board.h
 delete mode 100644 arch/arm/plat-omap/include/plat/gpio-switch.h
 delete mode 100644 arch/arm/plat-omap/include/plat/hardware.h
 delete mode 100644 arch/arm/plat-omap/include/plat/irqs-44xx.h
 delete mode 100644 arch/arm/plat-omap/include/plat/irqs.h
 delete mode 100644 arch/arm/plat-omap/include/plat/param.h
 delete mode 100644 arch/arm/plat-omap/mux.c
 rename arch/arm/plat-omap/include/plat/mcbsp.h => include/linux/platform_data/asoc-ti-mcbsp.h (100%)
 rename arch/arm/plat-omap/include/plat/dsp.h => include/linux/platform_data/dsp-omap.h (100%)
 rename arch/arm/plat-omap/include/plat/gpio.h => include/linux/platform_data/gpio-omap.h (94%)
 rename arch/arm/plat-omap/include/plat/keypad.h => include/linux/platform_data/keypad-omap.h (100%)
 rename arch/arm/plat-omap/include/plat/lcd_mipid.h => include/linux/platform_data/lcd-mipid.h (100%)
 rename arch/arm/plat-omap/include/plat/nand.h => include/linux/platform_data/mtd-nand-omap2.h (96%)
 rename arch/arm/plat-omap/include/plat/onenand.h => include/linux/platform_data/mtd-onenand-omap2.h (100%)
 create mode 100644 include/linux/platform_data/omap1_bl.h
 rename arch/arm/mach-u300/include/mach/gpio-u300.h => include/linux/platform_data/pinctrl-coh901.h (72%)
 rename arch/arm/plat-omap/include/plat/remoteproc.h => include/linux/platform_data/remoteproc-omap.h (100%)
 rename arch/arm/plat-omap/include/plat/mcspi.h => include/linux/platform_data/spi-omap2-mcspi.h (100%)
 rename arch/arm/plat-omap/include/plat/voltage.h => include/linux/platform_data/voltage-omap.h (100%)
