Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab2LLQmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:42:16 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43405 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab2LLQmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:42:14 -0500
Date: Wed, 12 Dec 2012 08:42:11 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: [GIT PULL 4/5] ARM: arm-soc: SoC updates for 3.8
Message-ID: <20121212164211.GD16288@quad.lixom.net>
References: <20121212163942.GA16036@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121212163942.GA16036@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,


This contains the bulk of new SoC development for this merge window.

Two new platforms have been added, the sunxi platforms (Allwinner A1x
SoCs) by Maxime Ripard, and a generic Broadcom platform for a new
series of ARMv7 platforms from them, where the hope is that we can
keep the platform code generic enough to have them all share one mach
directory. The new Broadcom platform is contributed by Christian Daudt.

Highbank has grown support for Calxeda's next generation of hardware,
ECX-2000.

clps711x has seen a lot of cleanup from Alexander Shiyan, and he's also
taken on maintainership of the platform.

Beyond this there has been a bunch of work from a number of people on
converting more platforms to IRQ domains, pinctrl conversion, cleanup
and general feature enablement across most of the active platforms.


Conflicts seen with this merge:

arch/arm/mach-integrator/integrator_cp.c and
arch/arm/mach-integrator/integrator_ap.c:
Similar conflict due to remove/change. Keep int*map_io_atag as the map_io
call, remove nr_irqs.

arch/arm/mach-ux500/cpu-db8500.c:
Add/add conflict. Keep both includes.

arch/arm/mach-vexpress/v2m.c:
allnodes was renamed of_allnodes. Keep the non-HEAD version, but rename
the variable in the of_property_read_u32() call.

drivers/pinctrl/Kconfig:
Add/remove conflict. Keep the new exynos entry, and remove the local
entries for all the others (since they are now under mvebu). Keep the
"source" line for mvebu.


----------------------------------------------------------------

The following changes since commit 5bf5d3f630699134d78692d03f32c1198e5b9f6d:

  Merge branch 'next/cleanup' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc

for you to fetch changes up to 5faf7cbb848da827f6ea1458b5a1c26a44e7510a:

  mfd: vexpress-sysreg: Remove LEDs code

----------------------------------------------------------------

Alban Bedel (1):
      ARM: LPC32xx: Add the motor PWM clock

Alexander Shiyan (25):
      ARM: clps711x: convert to clockevents
      ARM: clps711x: p720t: remove missing #include
      ARM: clps711x: rework IRQ sybsustem initialization
      ARM: clps711x: added missing definitions
      ARM: clps711x: make all virtual addresses definition via one macro
      ARM: clps711x: merge all CLPS711X-defconfigs into one
      ARM: clps711x: merge files related to EDB7211-board into one
      ARM: clps711x: Using platform_driver for ethernet device
      ARM: clps711x: p720t: Using "leds-gpio" driver for LED control
      ARM: clps711x: Transform clps711x-framebuffer to platform driver and use it
      ARM: clps711x: p720t: Unneeded inclusion of head-sa1100.S removed
      ARM: clps711x: Always select AUTO_ZRELADDR for a platform
      ARM: clps711x: cdb89712: Special driver for handling memory is removed
      ARM: clps711x: Implement usage "SPARSE_IRQ" kernel option for a platform
      ARM: clps711x: Implement usage "MULTI_IRQ_HANDLER" kernel option for a platform
      ARM: clps711x: Add FIQ interrupt handling
      ARM: clps711x: Unused empty "ACK" calls for IRQ-chips removed
      ARM: clps711x: autcpu12: Special driver for handling NAND memory is removed
      ARM: clps711x: Moving power management of framebuffer driver to the board
      ARM: clps711x: p720t: Special driver for handling NAND memory is removed
      ARM: clps711x: Moving backlight controls of framebuffer driver to the board
      ARM: clps711x: edb7211: Add support for NOR-Flash
      ARM: clps711x: Rename board files to match functionality
      ARM: clps711x: Update defconfig due latest changes and new kernel symbols
      MAINTAINERS: Add ARM CLPS711X entry

Arnd Bergmann (6):
      Merge branch 'ux500-core' of git://git.kernel.org/.../linusw/linux-stericsson into next/soc
      Merge branch 'clps711x/soc' into next/soc
      ARM: smp_twd: fix build warning
      Merge branch 'lpc32xx/core' of git://git.antcom.de/linux-2.6 into next/soc
      Merge branch 'soc' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'imx-soc' of git://git.pengutronix.de/git/imx/linux-2.6 into next/soc

Axel Lin (2):
      clocksource: sunxi_timer: Add terminating entry for sunxi_timer_dt_ids
      irqchip: irq-sunxi: Add terminating entry for sunxi_irq_dt_ids

Bartlomiej Zolnierkiewicz (1):
      ARM: dts: add node for PL330 MDMA1 controller for exynos4

Bastian Hecht (4):
      ARM: shmobile: emev2: Replace modify_scu_cpu_psr with scu_power_mode
      ARM: shmobile: sh73a0: Replace modify_scu_cpu_psr with scu_power_mode
      ARM: shmobile: r8a7779: Replace modify_scu_cpu_psr with scu_power_mode
      ARM: mach-shmobile: add FLCTL DMA slave definitions for sh7372

Ben Gardiner (1):
      ARM: davinci: sram: switch from iotable to ioremapped regions

Christian Daudt (1):
      Add support for generic BCM SoC chipsets

Danny Huang (3):
      ARM: tegra: flexible spare fuse read function
      ARM: tegra: Add speedo-based process identification
      ARM: tegra: Tegra30 speedo-based process identification

Doug Anderson (1):
      ARM: EXYNOS: Avoid early use of of_machine_is_compatible()

Fabio Estevam (4):
      ARM: dts: imx27-3ds: Remove local watchdog inclusion
      ARM: clk-imx27: Add missing clock for mx2-camera
      mx2_camera: Fix regression caused by clock conversion
      ARM: mx5: Replace clk_register_clkdev with clock DT lookup

Gaëtan Carlier (1):
      ARM : i.MX27 : split code for allocation of ressources of camera and eMMA

Joseph Lo (14):
      ARM: tegra30: clocks: add AHB and APB clocks
      ARM: tegra: dt: add L2 cache controller
      ARM: tegra: common: using OF api for L2 cache init
      ARM: tegra: enable data prefetch on L2
      ARM: tegra: cpuidle: replace LP3 with ARM_CPUIDLE_WFI_STATE
      ARM: tegra: rename the file of "sleep-tXX" to "sleep-tegraXX"
      ARM: tegra: cpuidle: separate cpuidle driver for different chips
      ARM: tegra: cpuidle: add CPU resume function
      ARM: tegra30: cpuidle: add powered-down state for secondary CPUs
      ARM: tegra30: common: enable csite clock
      ARM: tegra30: clocks: add CPU low-power function into tegra_cpu_car_ops
      ARM: tegra30: flowctrl: add cpu_suspend_exter/exit function
      ARM: tegra30: cpuidle: add powered-down state for CPU0
      ARM: tegra: retain L2 content over CPU suspend/resume

Josh Cartwright (1):
      ARM: sunxi: add missing include for mdelay()

Kukjin Kim (3):
      Merge remote-tracking branch 'pinctrl/samsung' into next/pinctrl-samsung
      ARM: EXYNOS: add support for EXYNOS5440 SoC
      ARM: dts: add initial dts file for EXYNOS5440, SSDK5440

Kuninori Morimoto (14):
      ARM: shmobile: r8a7740: fixup DT machine desc name typo
      ARM: shmobile: r8a7779: add HSPI clock support
      ARM: shmobile: r8a7779: add I2C clock support
      ARM: shmobile: r8a7779: add I2C driver support
      ARM: shmobile: r8a7779: PFC rename PENCx -> USB_PENCx
      ARM: shmobile: r8a7740: add USB24 clock explain
      ARM: shmobile: r8a7779: add USB EHCI clock support
      ARM: shmobile: r8a7779: add USB OHCI clock support
      sh: clkfwk: add sh_clk_fsidiv_register()
      ARM: shmobile: sh7372: sh7372_fsidivX_clk become non-global
      ARM: shmobile: sh7372: use sh_clk_fsidiv_register() for FSI-DIV clocks
      ARM: shmobile: r8a7740: add FSI-DVI clocks
      ARM: shmobile: add fsi external clock on r8a7740
      ARM: shmobile: add fsi external clock sh7372

Laxman Dewangan (2):
      ARM: tegra: Add OF_DEV_AUXDATA for SLINK driver in board dt
      ARM: tegra: Add OF_DEV_AUXDATA for sflash driver in board dt

Linus Walleij (6):
      ARM: ux500: support the HREFP520 board variant
      ARM: ux500: add DB serial number to entropy pool
      ARM: plat-versatile: use simple irqdomain for FPGA IRQ
      ARM: integrator: get rid of preallocated irq descriptors
      ARM: plat-versatile: move FPGA irq driver to drivers/irqchip
      irq: versatile: delete dangling variable

Matt Porter (3):
      uio: uio_pruss: replace private SRAM API with genalloc
      ARM: davinci: add platform hook to fetch the SRAM pool
      ARM: davinci: da8xx: add DA850 PRUSS support

Maxime Ripard (8):
      clk: sunxi: Add dummy fixed rate clock for Allwinner A1X SoCs
      clocksource: sunxi: Add Allwinner A1X Timer Driver
      irqchip: sunxi: Add irq controller driver
      ARM: sunxi: Add basic support for Allwinner A1x SoCs
      ARM: sunxi: Add earlyprintk support
      ARM: sunxi: Add device tree for the A13 and the Olinuxino board
      ARM: sunxi: Add entry to MAINTAINERS
      ARM: sunxi: Add sunxi restart function via onchip watchdog

Nobuhiro Iwamatsu (3):
      ARM: shmobile: Remove SH7367 support
      ARM: shmobile: Remove SH7377 support
      ARM: shmobile: r8a7740: Enable PMU

Olof Johansson (30):
      Merge branch 'soc' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'calxeda-ecx-2000' of git://sources.calxeda.com/kernel/linux into next/soc
      Merge tag 'integrator-irq' of git://git.kernel.org/.../linusw/linux-integrator into next/soc
      ARM: highbank: add ifdef guards to core.h
      Merge tag 'davinci-for-v3.8/soc' of git://gitorious.org/linux-davinci/linux-davinci into next/soc
      Merge tag 'tags/sunxi-support-for-3.8' of git://github.com/mripard/linux into next/soc
      Merge branch 'clps711x/soc' into clps711x/soc2
      Merge tag 'tegra-for-3.8-soc' of git://git.kernel.org/.../swarren/linux-tegra into next/soc
      Merge tag 'tegra-for-3.8-cpuidle' of git://git.kernel.org/.../swarren/linux-tegra into next/soc
      Merge tag 'tegra-for-3.8-defconfig' of git://git.kernel.org/.../swarren/linux-tegra into next/soc
      Merge tag 'bcm2835-for-3.8-soc' of git://git.kernel.org/.../swarren/linux-rpi into next/soc
      Merge tag 'bcm2835-for-3.8-defconfig' of git://git.kernel.org/.../swarren/linux-rpi into next/soc
      Merge branch 'depends/clk' into next/soc
      Merge branch 'vexpress-clk-soc' of git://git.linaro.org/people/pawelmoll/linux into next/soc
      Merge tag 'highbank-debugll-cleanup' of git://sources.calxeda.com/kernel/linux into next/soc
      Merge tag 'highbank-cpuidle' of git://sources.calxeda.com/kernel/linux into next/soc
      Merge branch 'depends/gpio-devel' into next/soc
      Merge branch 'clps711x/soc2' into next/soc
      Merge branch 'samsung/pinctrl' into next/soc
      Merge branch 'sunxi/soc2' into next/soc
      Merge branch 'depends/gpio-devel' into next/soc
      Merge tag 'imx-soc-1' of git://git.pengutronix.de/git/imx/linux-2.6 into next/soc
      Merge branch 'next/soc-exynos5440' of git://git.kernel.org/.../kgene/linux-samsung into next/soc
      ARM: EXYNOS: add UART3 to DEBUG_LL ports
      Merge branch 'next/cam-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge branch 'next/pinctrl-samsung-2' of git://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge branch 'next/devel-samsung-3' of git://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge branch 'sunxi/soc2' into next/soc
      Merge branch 'integrator/irq' into next/soc
      Merge tag 'sunxi-fixes-for-3.8' of git://github.com/mripard/linux into next/soc

Pawel Moll (6):
      mfd: Versatile Express config infrastructure
      mfd: Versatile Express system registers driver
      ARM: vexpress: Add config bus components and clocks to DTs
      ARM: vexpress: Start using new Versatile Express infrastructure
      ARM: vexpress: Remove motherboard dependencies in the DTS files
      mfd: vexpress-sysreg: Remove LEDs code

Peter De Schrijver (1):
      ARM: tegra: Implement 6395/1 for Tegra

Rob Herring (10):
      ARM: highbank: disable unused sdhci and gpio in dts
      ARM: highbank: enable coherent DMA for xgmac in dts
      ARM: dts: Add Calxeda ECX-2000 support
      ARM: smp_twd: don't warn on no DT node
      ARM: highbank: abstract out SCU usage
      ARM: highbank: Add initial ECX-2000 support
      ARM: implement debug_ll_io_init()
      cpuidle: add Calxeda SOC idle support
      Merge remote-tracking branch 'arm-soc/devel/debug_ll_init' into debug_ll
      ARM: highbank: use common debug_ll_io_init

Roland Stigge (5):
      ARM: LPC32xx: Remove superfluous irq_alloc_descs()
      ARM: LPC32xx: Relocate calls to irq_set_chained_handler()
      ARM: LPC32xx: Cleanup irq.c
      ARM: mach-imx: Support for DryIce RTC in i.MX53
      watchdog: Support imx watchdog on SOC_IMX53

Sachin Kamat (1):
      pinctrl: samsung: Do not initialise statics to 0

Sascha Hauer (14):
      Merge remote-tracking branch 'arm-soc/imx/multiplatform' into x
      ARM i.MX27: Fix low reference clock path
      ARM i.MX51: setup MIPI during startup
      ARM i.MX5: switch IPU clk support to devicetree bindings
      ARM i.MX53: Add IPU support
      ARM i.MX51: Add IPU support
      ARM i.MX6: Add IPU support
      ARM i.MX51 babbage: Add display support
      ARM i.MX53: Add pwm support
      ARM i.MX51: Add pwm support
      ARM i.MX6: Add pwm support
      ARM i.MX6: rename PLLs according to datasheet
      ARM i.MX6: Fix ethernet PLL clocks
      ARM i.MX6: remove gate_mask from pllv3

Sekhar Nori (1):
      ARM: davinci: serial: provide API to initialze UART clocks

Stefan Roese (4):
      ARM: sunxi: Restructure sunxi dts/dtsi files
      ARM: sunxi: Add earlyprintk support for UART0 (sun4i)
      ARM: sunxi: Add sun4i and cubieboard support
      ARM: sunxi: Add missing sun4i.dtsi file

Steffen Trumtrar (1):
      ARM i.MX6: fix ldb_di_sel mux

Stephen Warren (3):
      ARM: bcm2835: implement machine restart hook
      ARM: bcm2835: enable GPIO/pinctrl
      ARM: tegra: defconfig updates

Subhasish Ghosh (1):
      ARM: davinci: da850: changed SRAM allocator to shared ram.

Sylwester Nawrocki (2):
      ARM: SAMSUNG: Add s3c24xx/s3c64xx CAMIF GPIO setup helpers
      ARM: S3C24XX: Add clkdev entry for camif-upll clock

Thierry Reding (4):
      ARM: tegra: Add AUXDATA for Tegra20 host1x
      ARM: tegra: Add Tegra20 host1x clock support
      ARM: tegra: Add AUXDATA for Tegra30 host1x
      ARM: tegra: Add Tegra30 host1x clock support

Thomas Abraham (2):
      pinctrl: exynos5440: add pinctrl driver for Samsung EXYNOS5440 SoC
      ARM: dts: Add pin controller node for Samsung EXYNOS5440 SoC

Thomas Petazzoni (1):
      ARM: bcm2835: enable procfs and sysfs in defconfig

Tomasz Figa (17):
      pinctrl: samsung: Detect and handle unsupported configuration types
      pinctrl: samsung: Do not pass gpio_chip to pin_to_reg_bank
      pinctrl: samsung: Assing pin numbers dynamically
      pinctrl: samsung: Remove static pin enumerations
      pinctrl: samsung: Distinguish between pin group and bank nodes
      ARM: dts: exynos4210-pinctrl: Add nodes for pin banks
      pinctrl: samsung: Match pin banks with their device nodes
      pinctrl: samsung: Hold pointer to driver data in bank struct
      pinctrl: samsung: Include bank-specific eint offset in bank struct
      pinctrl: exynos: Use one IRQ domain per pin bank
      pinctrl: samsung: Use one GPIO chip per pin bank
      pinctrl: samsung: Use per-bank IRQ domain for wake-up interrupts
      pinctrl: exynos: Set pin function to EINT in irq_set_type of wake-up EINT
      pinctrl: samsung: Add GPIO to IRQ translation
      Documentation: Update samsung-pinctrl device tree bindings documentation
      pinctrl: samsung: Add support for EXYNOS4X12
      ARM: EXYNOS: Add support for secondary CPU bring-up on Exynos4412

Tushar Behera (1):
      pinctrl: samsung: Update error check for unsigned variables

Wei Ni (1):
      ARM: tegra: set up wlan clocks for tegra dt

m-karicheri2@ti.com (1):
      ARM: davinci: convert platform code to use clk_prepare/clk_unprepare


 Documentation/arm/sunxi/README                  |   19 +
 .../devicetree/bindings/arm/bcm/bcm11351.txt    |    9 +
 .../devicetree/bindings/arm/calxeda.txt         |   13 +-
 .../devicetree/bindings/arm/vexpress-sysreg.txt |   50 +
 .../devicetree/bindings/arm/vexpress.txt        |   98 +-
 .../devicetree/bindings/clock/imx5-clock.txt    |  191 ++
 .../devicetree/bindings/clock/imx6q-clock.txt   |    9 +-
 .../interrupt-controller/allwinner,sunxi-ic.txt |  104 ++
 .../bindings/pinctrl/samsung-pinctrl.txt        |  119 +-
 .../bindings/timer/allwinner,sunxi-timer.txt    |   17 +
 .../bindings/watchdog/brcm,bcm2835-pm-wdog.txt  |   13 +
 .../devicetree/bindings/watchdog/sunxi-wdt.txt  |   13 +
 MAINTAINERS                                     |   12 +
 arch/arm/Kconfig                                |   17 +-
 arch/arm/Kconfig.debug                          |   26 +
 arch/arm/Makefile                               |    2 +
 arch/arm/boot/compressed/Makefile               |    5 -
 arch/arm/boot/dts/Makefile                      |    9 +-
 arch/arm/boot/dts/bcm11351-brt.dts              |   30 +
 arch/arm/boot/dts/bcm11351.dtsi                 |   50 +
 arch/arm/boot/dts/bcm2835-rpi-b.dts             |   15 +
 arch/arm/boot/dts/bcm2835.dtsi                  |   28 +
 arch/arm/boot/dts/ecx-2000.dts                  |  104 ++
 arch/arm/boot/dts/ecx-common.dtsi               |  237 +++
 arch/arm/boot/dts/exynos4.dtsi                  |    6 +
 arch/arm/boot/dts/exynos4210-pinctrl.dtsi       |  278 +++
 arch/arm/boot/dts/exynos4210.dtsi               |  241 +--
 arch/arm/boot/dts/exynos5440-ssdk5440.dts       |   46 +
 arch/arm/boot/dts/exynos5440.dtsi               |  159 ++
 arch/arm/boot/dts/highbank.dts                  |  212 +--
 arch/arm/boot/dts/imx27-3ds.dts                 |    4 -
 arch/arm/boot/dts/imx51-babbage.dts             |   16 +
 arch/arm/boot/dts/imx51.dtsi                    |  124 ++
 arch/arm/boot/dts/imx53.dtsi                    |   73 +
 arch/arm/boot/dts/imx6q.dtsi                    |   34 +
 arch/arm/boot/dts/sh7377.dtsi                   |   21 -
 arch/arm/boot/dts/sun4i-cubieboard.dts          |   38 +
 arch/arm/boot/dts/sun4i.dtsi                    |   19 +
 arch/arm/boot/dts/sun5i-olinuxino.dts           |   30 +
 arch/arm/boot/dts/sun5i.dtsi                    |   20 +
 arch/arm/boot/dts/sunxi.dtsi                    |   80 +
 arch/arm/boot/dts/tegra20.dtsi                  |    9 +
 arch/arm/boot/dts/tegra30.dtsi                  |    9 +
 arch/arm/boot/dts/vexpress-v2m-rs1.dtsi         |  146 +-
 arch/arm/boot/dts/vexpress-v2m.dtsi             |  146 +-
 arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts     |  121 +-
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts      |  186 +-
 arch/arm/boot/dts/vexpress-v2p-ca5s.dts         |   84 +-
 arch/arm/boot/dts/vexpress-v2p-ca9.dts          |  136 +-
 arch/arm/configs/armadillo800eva_defconfig      |    1 +
 arch/arm/configs/bcm2835_defconfig              |    2 -
 arch/arm/configs/bcm_defconfig                  |  114 ++
 arch/arm/configs/clps711x_defconfig             |   90 +
 arch/arm/configs/edb7211_defconfig              |   27 -
 arch/arm/configs/fortunet_defconfig             |   28 -
 arch/arm/configs/marzen_defconfig               |    2 +
 arch/arm/configs/tegra_defconfig                |   21 +-
 arch/arm/include/asm/hardware/sp810.h           |    6 -
 arch/arm/include/asm/mach/map.h                 |    7 +
 arch/arm/include/debug/sunxi.S                  |   27 +
 arch/arm/kernel/debug.S                         |   14 +
 arch/arm/kernel/smp_twd.c                       |    6 +-
 arch/arm/mach-bcm/Kconfig                       |   19 +
 arch/arm/mach-bcm/Makefile                      |   13 +
 arch/arm/mach-bcm/board_bcm.c                   |   57 +
 arch/arm/mach-bcm2835/bcm2835.c                 |   46 +
 arch/arm/mach-bcm2835/include/mach/gpio.h       |    1 +
 arch/arm/mach-clps711x/Kconfig                  |    2 -
 arch/arm/mach-clps711x/Makefile                 |   12 +-
 arch/arm/mach-clps711x/Makefile.boot            |    1 -
 arch/arm/mach-clps711x/autcpu12.c               |   92 -
 arch/arm/mach-clps711x/board-autcpu12.c         |  179 ++
 arch/arm/mach-clps711x/board-cdb89712.c         |  147 ++
 .../{clep7312.c => board-clep7312.c}            |    4 +-
 arch/arm/mach-clps711x/board-edb7211.c          |  180 ++
 .../{fortunet.c => board-fortunet.c}            |    2 +
 arch/arm/mach-clps711x/board-p720t.c            |  232 +++
 arch/arm/mach-clps711x/cdb89712.c               |   63 -
 arch/arm/mach-clps711x/common.c                 |  181 +-
 arch/arm/mach-clps711x/common.h                 |    7 +-
 arch/arm/mach-clps711x/edb7211-arch.c           |   66 -
 arch/arm/mach-clps711x/edb7211-mm.c             |   82 -
 arch/arm/mach-clps711x/include/mach/autcpu12.h  |   23 +-
 arch/arm/mach-clps711x/include/mach/clps711x.h  |   27 +
 .../mach-clps711x/include/mach/entry-macro.S    |   51 -
 arch/arm/mach-clps711x/include/mach/hardware.h  |   67 +-
 arch/arm/mach-clps711x/include/mach/irqs.h      |   50 -
 arch/arm/mach-clps711x/include/mach/syspld.h    |    9 +-
 arch/arm/mach-clps711x/p720t.c                  |  181 --
 arch/arm/mach-davinci/board-dm355-evm.c         |    2 +-
 arch/arm/mach-davinci/board-dm355-leopard.c     |    2 +-
 arch/arm/mach-davinci/board-dm365-evm.c         |    4 +-
 arch/arm/mach-davinci/board-dm644x-evm.c        |    2 +-
 arch/arm/mach-davinci/board-neuros-osd2.c       |    2 +-
 arch/arm/mach-davinci/da850.c                   |   17 +-
 arch/arm/mach-davinci/devices-da8xx.c           |   77 +-
 arch/arm/mach-davinci/dm355.c                   |    6 -
 arch/arm/mach-davinci/dm365.c                   |    6 -
 arch/arm/mach-davinci/dm644x.c                  |    6 -
 arch/arm/mach-davinci/dm646x.c                  |    6 -
 arch/arm/mach-davinci/include/mach/common.h     |    2 -
 arch/arm/mach-davinci/include/mach/da8xx.h      |    3 +
 arch/arm/mach-davinci/include/mach/serial.h     |    1 +
 arch/arm/mach-davinci/include/mach/sram.h       |    3 +
 arch/arm/mach-davinci/serial.c                  |   39 +-
 arch/arm/mach-davinci/sram.c                    |   23 +-
 arch/arm/mach-davinci/time.c                    |    4 +-
 arch/arm/mach-exynos/Kconfig                    |   11 +-
 arch/arm/mach-exynos/Makefile                   |    2 +-
 arch/arm/mach-exynos/common.c                   |   79 +-
 arch/arm/mach-exynos/include/mach/irqs.h        |    5 +
 arch/arm/mach-exynos/include/mach/map.h         |    5 +
 arch/arm/mach-exynos/include/mach/regs-pmu.h    |    1 +
 arch/arm/mach-exynos/mach-exynos4-dt.c          |    1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c          |   34 +-
 arch/arm/mach-exynos/mct.c                      |   11 +-
 arch/arm/mach-exynos/platsmp.c                  |   30 +-
 arch/arm/mach-exynos/setup-i2c0.c               |    2 +-
 arch/arm/mach-highbank/Kconfig                  |    2 +-
 arch/arm/mach-highbank/Makefile                 |    1 -
 arch/arm/mach-highbank/core.h                   |   10 +-
 arch/arm/mach-highbank/highbank.c               |   33 +-
 arch/arm/mach-highbank/hotplug.c                |    6 +-
 arch/arm/mach-highbank/lluart.c                 |   34 -
 arch/arm/mach-highbank/platsmp.c                |    7 +-
 arch/arm/mach-highbank/pm.c                     |    3 -
 arch/arm/mach-highbank/sysregs.h                |   19 +
 arch/arm/mach-highbank/system.c                 |    2 -
 arch/arm/mach-imx/Kconfig                       |    2 +
 arch/arm/mach-imx/clk-imx27.c                   |   18 +-
 arch/arm/mach-imx/clk-imx51-imx53.c             |   44 +-
 arch/arm/mach-imx/clk-imx6q.c                   |   42 +-
 arch/arm/mach-imx/clk-pllv3.c                   |   72 +-
 arch/arm/mach-imx/clk.h                         |    3 +-
 arch/arm/mach-imx/devices-imx27.h               |    4 +-
 arch/arm/mach-imx/devices/Kconfig               |    3 +
 arch/arm/mach-imx/devices/Makefile              |    1 +
 arch/arm/mach-imx/devices/devices-common.h      |    9 +-
 arch/arm/mach-imx/devices/platform-mx2-camera.c |   17 -
 arch/arm/mach-imx/imx51-dt.c                    |   28 +-
 arch/arm/mach-imx/mach-imx53.c                  |   31 +-
 arch/arm/mach-imx/mm-imx5.c                     |   20 +
 arch/arm/mach-integrator/include/mach/irqs.h    |  109 +-
 arch/arm/mach-integrator/integrator_ap.c        |    5 +-
 arch/arm/mach-integrator/integrator_cp.c        |    6 +-
 arch/arm/mach-lpc32xx/clock.c                   |    8 +
 arch/arm/mach-lpc32xx/include/mach/platform.h   |    1 +
 arch/arm/mach-lpc32xx/irq.c                     |   23 +-
 arch/arm/mach-s3c24xx/Kconfig                   |    1 +
 arch/arm/mach-s3c24xx/clock-s3c2440.c           |    1 +
 arch/arm/mach-shmobile/Kconfig                  |   12 -
 arch/arm/mach-shmobile/Makefile                 |    6 -
 arch/arm/mach-shmobile/board-ap4evb.c           |    2 +-
 arch/arm/mach-shmobile/board-mackerel.c         |    2 +-
 arch/arm/mach-shmobile/clock-r8a7740.c          |   34 +
 arch/arm/mach-shmobile/clock-r8a7779.c          |   23 +-
 arch/arm/mach-shmobile/clock-sh7367.c           |  355 ----
 arch/arm/mach-shmobile/clock-sh7372.c           |   94 +-
 arch/arm/mach-shmobile/clock-sh7377.c           |  366 ----
 arch/arm/mach-shmobile/include/mach/common.h    |   18 -
 arch/arm/mach-shmobile/include/mach/r8a7779.h   |    2 +-
 arch/arm/mach-shmobile/include/mach/sh7367.h    |  332 ----
 arch/arm/mach-shmobile/include/mach/sh7372.h    |    6 +-
 arch/arm/mach-shmobile/include/mach/sh7377.h    |  360 ----
 arch/arm/mach-shmobile/intc-sh7367.c            |  413 -----
 arch/arm/mach-shmobile/intc-sh7377.c            |  592 ------
 arch/arm/mach-shmobile/pfc-r8a7779.c            |   16 +-
 arch/arm/mach-shmobile/pfc-sh7367.c             | 1727 ------------------
 arch/arm/mach-shmobile/pfc-sh7377.c             | 1688 -----------------
 arch/arm/mach-shmobile/setup-r8a7740.c          |   18 +-
 arch/arm/mach-shmobile/setup-r8a7779.c          |   77 +
 arch/arm/mach-shmobile/setup-sh7367.c           |  481 -----
 arch/arm/mach-shmobile/setup-sh7372.c           |   20 +
 arch/arm/mach-shmobile/setup-sh7377.c           |  549 ------
 arch/arm/mach-shmobile/smp-emev2.c              |   22 +-
 arch/arm/mach-shmobile/smp-r8a7779.c            |   25 +-
 arch/arm/mach-shmobile/smp-sh73a0.c             |   23 +-
 arch/arm/mach-sunxi/Kconfig                     |    9 +
 arch/arm/mach-sunxi/Makefile                    |    1 +
 arch/arm/mach-sunxi/Makefile.boot               |    1 +
 arch/arm/mach-sunxi/sunxi.c                     |   96 +
 arch/arm/mach-sunxi/sunxi.h                     |   20 +
 arch/arm/mach-tegra/Makefile                    |   13 +-
 arch/arm/mach-tegra/board-dt-tegra20.c          |   23 +
 arch/arm/mach-tegra/board-dt-tegra30.c          |   25 +
 arch/arm/mach-tegra/common.c                    |   22 +-
 arch/arm/mach-tegra/cpuidle-tegra20.c           |   66 +
 arch/arm/mach-tegra/cpuidle-tegra30.c           |  188 ++
 arch/arm/mach-tegra/cpuidle.c                   |   83 +-
 arch/arm/mach-tegra/cpuidle.h                   |   32 +
 arch/arm/mach-tegra/flowctrl.c                  |   47 +
 arch/arm/mach-tegra/flowctrl.h                  |    8 +
 arch/arm/mach-tegra/fuse.c                      |   49 +-
 arch/arm/mach-tegra/fuse.h                      |   16 +
 arch/arm/mach-tegra/headsmp.S                   |   71 +
 arch/arm/mach-tegra/pm.c                        |  216 +++
 arch/arm/mach-tegra/pm.h                        |   35 +
 arch/arm/mach-tegra/reset.c                     |    6 +
 arch/arm/mach-tegra/reset.h                     |    9 +
 .../mach-tegra/{sleep-t20.S => sleep-tegra20.S} |    0
 .../mach-tegra/{sleep-t30.S => sleep-tegra30.S} |   66 +
 arch/arm/mach-tegra/sleep.S                     |   78 +
 arch/arm/mach-tegra/sleep.h                     |   37 +
 arch/arm/mach-tegra/tegra20_clocks_data.c       |   11 +-
 arch/arm/mach-tegra/tegra20_speedo.c            |  109 ++
 arch/arm/mach-tegra/tegra30_clocks.c            |  214 +++
 arch/arm/mach-tegra/tegra30_clocks.h            |    1 +
 arch/arm/mach-tegra/tegra30_clocks_data.c       |   51 +-
 arch/arm/mach-tegra/tegra30_speedo.c            |  292 +++
 arch/arm/mach-tegra/tegra_cpu_car.h             |   37 +
 arch/arm/mach-ux500/board-mop500.c              |   13 +-
 arch/arm/mach-ux500/cpu-db8500.c                |    3 +
 arch/arm/mach-versatile/core.c                  |    2 +-
 arch/arm/mach-vexpress/Kconfig                  |    4 +-
 arch/arm/mach-vexpress/Makefile                 |    2 +-
 arch/arm/mach-vexpress/ct-ca9x4.c               |   41 +-
 .../mach-vexpress/include/mach/motherboard.h    |   81 -
 arch/arm/mach-vexpress/platsmp.c                |    3 +-
 arch/arm/mach-vexpress/v2m.c                    |  349 +---
 arch/arm/mm/mmu.c                               |   16 +
 arch/arm/plat-mxc/devices/platform-mx2-emma.c   |   40 +
 arch/arm/plat-samsung/Kconfig                   |    6 +
 arch/arm/plat-samsung/Makefile                  |    1 +
 arch/arm/plat-samsung/include/plat/cpu.h        |    8 +
 arch/arm/plat-samsung/setup-camif.c             |   70 +
 arch/arm/plat-versatile/Kconfig                 |    9 -
 arch/arm/plat-versatile/Makefile                |    1 -
 drivers/clk/Makefile                            |    1 +
 drivers/clk/clk-sunxi.c                         |   30 +
 drivers/clocksource/Kconfig                     |    3 +
 drivers/clocksource/Makefile                    |    1 +
 drivers/clocksource/sunxi_timer.c               |  171 ++
 drivers/cpuidle/Kconfig                         |   10 +
 drivers/cpuidle/Makefile                        |    2 +
 drivers/cpuidle/cpuidle-calxeda.c               |  161 ++
 drivers/irqchip/Kconfig                         |    9 +-
 drivers/irqchip/Makefile                        |    2 +
 drivers/irqchip/irq-sunxi.c                     |  151 ++
 .../irqchip/irq-versatile-fpga.c                |   55 +-
 drivers/media/platform/soc_camera/mx2_camera.c  |   39 +-
 drivers/mfd/Kconfig                             |    6 +
 drivers/mfd/Makefile                            |    1 +
 drivers/mfd/vexpress-config.c                   |  277 +++
 drivers/mfd/vexpress-sysreg.c                   |  475 +++++
 drivers/mtd/maps/Kconfig                        |    7 -
 drivers/mtd/maps/Makefile                       |    1 -
 drivers/mtd/maps/cdb89712.c                     |  278 ---
 drivers/mtd/nand/Kconfig                        |   13 -
 drivers/mtd/nand/Makefile                       |    2 -
 drivers/mtd/nand/autcpu12.c                     |  237 ---
 drivers/mtd/nand/spia.c                         |  176 --
 drivers/pinctrl/Kconfig                         |    5 +
 drivers/pinctrl/Makefile                        |    1 +
 drivers/pinctrl/pinctrl-exynos.c                |  477 +++--
 drivers/pinctrl/pinctrl-exynos.h                |  170 +-
 drivers/pinctrl/pinctrl-exynos5440.c            |  919 ++++++++++
 drivers/pinctrl/pinctrl-samsung.c               |  207 ++-
 drivers/pinctrl/pinctrl-samsung.h               |   30 +-
 drivers/sh/clk/cpg.c                            |   86 +
 drivers/tty/serial/samsung.c                    |    3 +-
 drivers/uio/Kconfig                             |    1 +
 drivers/uio/uio_pruss.c                         |   24 +-
 drivers/video/clps711xfb.c                      |  156 +-
 include/linux/clk/sunxi.h                       |   22 +
 include/linux/irqchip/sunxi.h                   |   27 +
 .../linux/irqchip/versatile-fpga.h              |    0
 include/linux/platform_data/uio_pruss.h         |    3 +-
 include/linux/sh_clk.h                          |    9 +
 include/linux/sunxi_timer.h                     |   24 +
 include/linux/vexpress.h                        |  121 ++
 270 files changed, 10139 insertions(+), 10616 deletions(-)
 create mode 100644 Documentation/arm/sunxi/README
 create mode 100644 Documentation/devicetree/bindings/arm/bcm/bcm11351.txt
 create mode 100644 Documentation/devicetree/bindings/arm/vexpress-sysreg.txt
 create mode 100644 Documentation/devicetree/bindings/clock/imx5-clock.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/allwinner,sunxi-ic.txt
 create mode 100644 Documentation/devicetree/bindings/timer/allwinner,sunxi-timer.txt
 create mode 100644 Documentation/devicetree/bindings/watchdog/brcm,bcm2835-pm-wdog.txt
 create mode 100644 Documentation/devicetree/bindings/watchdog/sunxi-wdt.txt
 create mode 100644 arch/arm/boot/dts/bcm11351-brt.dts
 create mode 100644 arch/arm/boot/dts/bcm11351.dtsi
 create mode 100644 arch/arm/boot/dts/ecx-2000.dts
 create mode 100644 arch/arm/boot/dts/ecx-common.dtsi
 create mode 100644 arch/arm/boot/dts/exynos5440-ssdk5440.dts
 create mode 100644 arch/arm/boot/dts/exynos5440.dtsi
 delete mode 100644 arch/arm/boot/dts/sh7377.dtsi
 create mode 100644 arch/arm/boot/dts/sun4i-cubieboard.dts
 create mode 100644 arch/arm/boot/dts/sun4i.dtsi
 create mode 100644 arch/arm/boot/dts/sun5i-olinuxino.dts
 create mode 100644 arch/arm/boot/dts/sun5i.dtsi
 create mode 100644 arch/arm/boot/dts/sunxi.dtsi
 create mode 100644 arch/arm/configs/bcm_defconfig
 create mode 100644 arch/arm/configs/clps711x_defconfig
 delete mode 100644 arch/arm/configs/edb7211_defconfig
 delete mode 100644 arch/arm/configs/fortunet_defconfig
 create mode 100644 arch/arm/include/debug/sunxi.S
 create mode 100644 arch/arm/mach-bcm/Kconfig
 create mode 100644 arch/arm/mach-bcm/Makefile
 create mode 100644 arch/arm/mach-bcm/board_bcm.c
 create mode 100644 arch/arm/mach-bcm2835/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-clps711x/autcpu12.c
 create mode 100644 arch/arm/mach-clps711x/board-autcpu12.c
 create mode 100644 arch/arm/mach-clps711x/board-cdb89712.c
 rename arch/arm/mach-clps711x/{clep7312.c => board-clep7312.c} (95%)
 create mode 100644 arch/arm/mach-clps711x/board-edb7211.c
 rename arch/arm/mach-clps711x/{fortunet.c => board-fortunet.c} (96%)
 create mode 100644 arch/arm/mach-clps711x/board-p720t.c
 delete mode 100644 arch/arm/mach-clps711x/cdb89712.c
 delete mode 100644 arch/arm/mach-clps711x/edb7211-arch.c
 delete mode 100644 arch/arm/mach-clps711x/edb7211-mm.c
 delete mode 100644 arch/arm/mach-clps711x/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-clps711x/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-clps711x/p720t.c
 delete mode 100644 arch/arm/mach-highbank/lluart.c
 delete mode 100644 arch/arm/mach-shmobile/clock-sh7367.c
 delete mode 100644 arch/arm/mach-shmobile/clock-sh7377.c
 delete mode 100644 arch/arm/mach-shmobile/include/mach/sh7367.h
 delete mode 100644 arch/arm/mach-shmobile/include/mach/sh7377.h
 delete mode 100644 arch/arm/mach-shmobile/intc-sh7367.c
 delete mode 100644 arch/arm/mach-shmobile/intc-sh7377.c
 delete mode 100644 arch/arm/mach-shmobile/pfc-sh7367.c
 delete mode 100644 arch/arm/mach-shmobile/pfc-sh7377.c
 delete mode 100644 arch/arm/mach-shmobile/setup-sh7367.c
 delete mode 100644 arch/arm/mach-shmobile/setup-sh7377.c
 create mode 100644 arch/arm/mach-sunxi/Kconfig
 create mode 100644 arch/arm/mach-sunxi/Makefile
 create mode 100644 arch/arm/mach-sunxi/Makefile.boot
 create mode 100644 arch/arm/mach-sunxi/sunxi.c
 create mode 100644 arch/arm/mach-sunxi/sunxi.h
 create mode 100644 arch/arm/mach-tegra/cpuidle-tegra20.c
 create mode 100644 arch/arm/mach-tegra/cpuidle-tegra30.c
 create mode 100644 arch/arm/mach-tegra/cpuidle.h
 create mode 100644 arch/arm/mach-tegra/pm.c
 create mode 100644 arch/arm/mach-tegra/pm.h
 rename arch/arm/mach-tegra/{sleep-t20.S => sleep-tegra20.S} (100%)
 rename arch/arm/mach-tegra/{sleep-t30.S => sleep-tegra30.S} (63%)
 create mode 100644 arch/arm/mach-tegra/tegra20_speedo.c
 create mode 100644 arch/arm/mach-tegra/tegra30_speedo.c
 create mode 100644 arch/arm/plat-mxc/devices/platform-mx2-emma.c
 create mode 100644 arch/arm/plat-samsung/setup-camif.c
 create mode 100644 drivers/clk/clk-sunxi.c
 create mode 100644 drivers/clocksource/sunxi_timer.c
 create mode 100644 drivers/cpuidle/cpuidle-calxeda.c
 create mode 100644 drivers/irqchip/irq-sunxi.c
 rename arch/arm/plat-versatile/fpga-irq.c => drivers/irqchip/irq-versatile-fpga.c (83%)
 create mode 100644 drivers/mfd/vexpress-config.c
 create mode 100644 drivers/mfd/vexpress-sysreg.c
 delete mode 100644 drivers/mtd/maps/cdb89712.c
 delete mode 100644 drivers/mtd/nand/autcpu12.c
 delete mode 100644 drivers/mtd/nand/spia.c
 create mode 100644 drivers/pinctrl/pinctrl-exynos5440.c
 create mode 100644 include/linux/clk/sunxi.h
 create mode 100644 include/linux/irqchip/sunxi.h
 rename arch/arm/plat-versatile/include/plat/fpga-irq.h => include/linux/irqchip/versatile-fpga.h (100%)
 create mode 100644 include/linux/sunxi_timer.h
 create mode 100644 include/linux/vexpress.h
