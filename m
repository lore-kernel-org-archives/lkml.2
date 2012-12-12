Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab2LLQlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:41:50 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43774 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab2LLQls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:41:48 -0500
Date: Wed, 12 Dec 2012 08:41:45 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: [GIT PULL 3/5] ARM: arm-soc: Cleanups on various subarchitectures
Message-ID: <20121212164145.GC16288@quad.lixom.net>
References: <20121212163942.GA16036@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121212163942.GA16036@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,


Cleanup patches for various ARM platforms and some of their associated
drivers. There's also a branch in here that enables Freescale i.MX to be
part of the multiplatform support -- the first "big" SoC that is moved
over (more multiplatform work comes in a separate branch later during
the merge window).


Conflicts seen with this merge:

arch/arm/mach-omap2/omap_hwmod_44xx_data.c:
Same include was introduced in the branch above, so take the conflicting
one out.

arch/arm/mach-omap2/board-common.c:
Restart functions were renamed in previous branch, and a new call to the
old function is added in this branch. Please replace 'omap_prcm_restart'
with "omap3xxx_restart' on line 115.


----------------------------------------------------------------

The following changes since commit 5d522d9742f62703e51e0b8193d125ac16108a80:

  Merge branch 'next/headers' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup

for you to fetch changes up to 794b175fc0c0c4844dbb7b137a73bbfd01f6c608:

  Merge tag 'omap-for-v3.8/cleanup-headers-iommu-signed' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into next/cleanup

----------------------------------------------------------------

Afzal Mohammed (2):
      ARM: dts: AM33XX: Add rtc node
      usb: musb: dsps: dt binding - add resources, example

Ajay Kumar Gupta (1):
      ARM: dts: AM33XX: Add usbss node

Alexander Varnin (1):
      ARM: S3C24XX: SPI clock channel setup is fixed for S3C2443

Andrew Lunn (3):
      ARM: Kirkwood: Remove unused includes
      ARM: Kirkwood: Fix sparse warnings.
      ARM: Kirkwood: checkpatch cleanups

Andrey Gusakov (2):
      ARM: S3C64XX: Remove duplicated camera clock
      ARM: S3C64XX: Statically define parent clock of "camera" clock

AnilKumar Ch (18):
      ARM: dts: AM33XX: Add device tree OPP table
      ARM: dts: AM33XX: Add basic pinctrl device tree data
      ARM: dts: AM33XX: Add D_CAN device tree data
      ARM: dts: AM33XX: Add lis331dlh device tree data to am335x-evm
      ARM: dts: AM33XX: Add temperature sensor device tree data to am335x-evm
      ARM: dts: AM33XX: Add tsl2550 ambient light sensor DT data
      ARM: dts: Add am335x-evmsk.dts
      Documentation: dt: i2c: Update trivial-devices list
      ARM: dts: AM33XX: Add pinmux configuration for matrix keypad to EVM
      ARM: dts: AM33XX: Add matrix keypad device tree data to am335x-evm
      ARM: dts: AM33XX: Add pinmux configuration for volume-keys to EVM
      ARM: dts: AM33XX: Add volume-keys device tree data to am335x-evm
      ARM: dts: AM33XX: Add pinmux configuration for user-leds to BONE
      ARM: dts: AM33XX: Add user-leds device tree data to am335x-bone
      ARM: dts: AM33XX: Add pinmux configuration for gpio-leds to EVMSK
      ARM: dts: AM33XX: Add user-leds device tree data to am335x-evmsk
      ARM: dts: AM33XX: Add pinmux configuration for gpio-keys to EVMSK
      ARM: dts: AM33XX: Add push-buttons device tree data to am335x-evmsk

Arnd Bergmann (7):
      Merge branch 'imx/multi-platform' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/cleanup
      Merge branch 'cleanups/dma' into next/cleanup
      Merge branch 'omap/headers4' into next/cleanup
      Merge tag 'omap-for-v3.8/cleanup-fixes-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge tag 'omap-for-v3.8/cleanup-prcm-part2-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge tag 'omap-for-v3.8/cleanup-fixes-part2-v2-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge tag 'integrator-for-arm-soc' of git://git.kernel.org/.../linusw/linux-integrator into next/cleanup

Benoit Cousson (4):
      ARM: dts: OMAP: Move interrupt-parent to the root node to avoid duplication
      ARM: dts: OMAP: Rename pandaES and var_som for consistency
      ARM: dts: Makefile: Add the am335x-evmsk target in dtbs list
      ARM: OMAP: debug-leds: Use resource_size instead of hard coded macro

Constantine Shulyupin (1):
      ARM: davinci: usb: remove CONFIG_USB_MUSB_HOST etc

Daniel Kurtz (1):
      ARM: EXYNOS: no duplicate mask/unmask in eint0_15

Domenico Andreoli (2):
      ARM: bcm2835: Add missing static modifiers
      ARM: bcm2835: Fix typo in the error message

Eunki Kim (1):
      ARM: SAMSUNG: use devm_ functions for ADC driver

Fabio Estevam (1):
      ARM: mach-imx: Fix selection of ARCH_MXC

Haojian Zhuang (1):
      ARM: pxa: remove pxa95x support

Igor Grinberg (2):
      ARM: OMAP2+: timer: remove CONFIG_OMAP_32K_TIMER
      ARM: OMAP3: cm-t3517: use GPTIMER for system clock

Ivan Khoronzhuk (1):
      ARM: OMAP4: ID: Improve features detection and check

Jaehoon Chung (1):
      ARM: EXYNOS: remove the MMC_CAP2_BROKEN_VOLTAGE

Jason Gunthorpe (1):
      ARM: Kirkwood: Use hw_pci.ops instead of hw_pci.scan

Jingoo Han (1):
      ARM: EXYNOS: reorder inclusions of <linux/platform_data/xxx.h>

Jon Hunter (32):
      ARM: dts: Add omap3-beagle.dts
      ARM: dts: OMAP: Add timer nodes
      ARM: dts: OMAP: Add counter-32k nodes
      ARM: dts: OMAP4: Update timer addresses
      ARM: dts: OMAP5: Add timer nodes
      ARM: dts: OMAP5: Add counter node
      ARM: OMAP3: Dynamically disable secure timer nodes for secure devices
      ARM: OMAP: Add function to request a timer by capability
      ARM: OMAP3: Add generic machine descriptor for boards with OMAP3 GP devices
      ARM: OMAP: Add DT support for timer driver
      ARM: OMAP2+: Add device-tree support for 32kHz counter
      ARM: OMAP: Add DMTIMER definitions for posted mode
      ARM: OMAP3+: Implement timer workaround for errata i103 and i767
      ARM: OMAP: Fix timer posted mode support
      ARM: OMAP3: Correct HWMOD DMTIMER SYSC register declarations
      ARM: OMAP2/3: Define HWMOD software reset status for DMTIMERs
      ARM: OMAP2+: Don't use __omap_dm_timer_reset()
      ARM: OMAP: Fix dmtimer reset for timer1
      ARM: OMAP: Don't restore of DMTIMER TISTAT register
      ARM: OMAP: Don't restore DMTIMER interrupt status register
      ARM: OMAP: Fix spurious interrupts when using timer match feature
      ARM: OMAP: Add dmtimer interrupt disable function
      ARM: OMAP: Remove unnecessary call to clk_get()
      ARM: OMAP: Remove __omap_dm_timer_set_source function
      ARM: OMAP: Clean-up dmtimer reset code
      ARM: OMAP: Define omap_dm_timer_prepare function as static
      ARM: OMAP: Don't store timers physical address
      ARM: OMAP2+: Remove unnecessary local variable in timer code
      ARM: OMAP: Remove unnecessary omap_dm_timer structure declaration
      ARM: OMAP: Add platform data header for DMTIMERs
      ARM: OMAP: Remove unnecessary inclusion of dmtimer.h
      ARM: OMAP2+: Fix compiler warning for 32k timer

Josh Cartwright (4):
      zynq: use GIC device tree bindings
      zynq: use pl310 device tree bindings
      zynq: remove use of CLKDEV_LOOKUP
      zynq: move static peripheral mappings

Kishon Vijay Abraham I (3):
      ARM: dts: Add twl6030-usb data
      ARM: dts: Add twl4030-usb data
      ARM: dts: OMAP4: add *reg* property for ocp2scp

Kukjin Kim (1):
      Merge branch 'next/cleanup-samsung' into next/cleanup-samsung-2

Linus Walleij (7):
      ARM: integrator: hook the AP into the SoC bus
      ARM: integrator: hook the CP into the SoC bus
      ARM: integrator: remove static AP syscon mapping
      ARM: integrator: remove static CP syscon mapping
      ARM: integrator: delete SC mapping on the CP
      ARM: integrator: delete static UART1 mapping
      ARM: integrator: push down SC dependencies

Lokesh Vutla (3):
      ARM: dts: omap5-evm: Fix size of memory defined for EVM
      ARM: dts: omap5: EMIF device tree data for OMAP5 boards
      ARM: dts: omap5-evm: LPDDR2 memory device details for EVM

Marek Szyprowski (6):
      ARM: samsung: remove obsoleted init_consistent_dma_size()
      ARM: davinci: remove obsoleted init_consistent_dma_size()
      ARM: shmobile: remove obsoleted init_consistent_dma_size()
      ARM: u300: remove obsoleted init_consistent_dma_size()
      ARM: at91: remove obsoleted init_consistent_dma_size()
      ARM: dma-mapping: remove init_consistent_dma_size() stub

Michael Walle (1):
      ARM: kirkwood: cleanup lsxl board includes

Nicolas Ferre (1):
      ARM: at91/atmel-mci: remove unused setup_dma_addr() macro

Olof Johansson (14):
      Merge branch 'imx/multi-platform' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/cleanup
      Merge tag 'cleanup-for-3.8' of git://server.prisktech.co.nz/git/linuxwmt into next/cleanup
      Merge branch 'arm-next' of git://git.xilinx.com/linux-xlnx into next/cleanup
      Merge tag 'davinci-for-v3.8/cleanup' of git://gitorious.org/linux-davinci/linux-davinci into next/cleanup
      Merge tag 'at91-for-next-cleanup' of git://github.com/at91linux/linux-at91 into next/cleanup
      Merge tag 'tegra-for-3.8-cleanup' of git://git.kernel.org/.../swarren/linux-tegra into next/cleanup
      Merge tag 'bcm2835-for-3.8-cleanup' of git://git.kernel.org/.../swarren/linux-rpi into next/cleanup
      Merge branch 'next/cleanup-samsung-2' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'v3.7-rc7' into next/cleanup
      Merge tag 'orion_cleanup_for_3.8' of git://git.infradead.org/users/jcooper/linux into next/cleanup
      Merge tag 'omap-for-v3.8/cleanup-timer-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      ARM: omap: fix typo on timer cleanup
      Merge branch 'next/cleanup-samsung-3' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'omap-for-v3.8/cleanup-headers-iommu-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup

Paul Walmsley (17):
      ARM: OMAP1: CGRM: fix omap1_get_reset_sources() return type
      ARM: OMAP2+: WDT: move init; add read_reset_sources pdata function pointer
      watchdog: OMAP: use standard GETBOOTSTATUS interface; use platform_data fn ptr
      ARM: OMAP2+: PRCM: remove omap_prcm_get_reset_sources()
      ARM: OMAP2+: common: remove mach-omap2/common.c globals and map_common_io code
      ARM: OMAP2/3: PRM: add SoC reset functions (using the CORE DPLL method)
      ARM: OMAP2xxx: clock: remove global 'dclk' variable
      ARM: OMAP2xxx: clock: move virt_prcm_set code into clkt2xxx_virt_prcm_set.c
      ARM: OMAP2+: PRCM: create SoC-specific chip restart functions
      ARM: OMAP2+: board files: use SoC-specific system restart functions
      ARM: OMAP2xxx: APLL/CM: convert to use omap2_cm_wait_module_ready()
      ARM: OMAP2+: CM/clock: convert _omap2_module_wait_ready() to use SoC-independent CM functions
      ARM: OMAP2+: PRCM: remove omap2_cm_wait_idlest()
      ARM: OMAP2+: PRCM: split and relocate the PRM/CM globals setup
      ARM: OMAP2+: PRCM: consolidate PRCM-related timeout macros
      ARM: OMAP2+: hwmod: call to _omap4_disable_module() should use the SoC-specific call
      ARM: OMAP2+: PRCM: remove obsolete prcm.[ch]

Peter Senna Tschudin (1):
      ARM: davinci: board-dm646x-evm.c: Remove unecessary semicolon

Peter Ujfalusi (1):
      ARM: OMAP2: Fix compillation error in cm_common

Philip, Avinash (1):
      ARM: dts: AM33XX: Add SPI node

Ricardo Neri (2):
      ARM: dts: omap4-panda: Add pinmux configuration for HDMI
      ARM: dts: omap4-sdp: Add pinmux configuration for HDMI

Sachin Kamat (2):
      ARM: EXYNOS: Make combiner_of_init function static
      ARM: EXYNOS: Add missing static storage class specifiers in clock-exynos5.c

Sangsu Park (1):
      ARM: EXYNOS: Remove wrong I2S0 clock from peril clock

Sasha Levin (1):
      ARM: integrator: use BUG_ON where possible

Sebastien Guiriec (4):
      ARM: dts: omap5: Update GPIO with address space and interrupts
      ARM: dts: omap5: Update I2C with address space and interrupts
      ARM: dts: omap5: Update UART with address space and interrupts
      ARM: dts: omap5: Update MMC with address space and interrupts

Shawn Guo (32):
      ARM: imx: include board headers in the same folder
      ARM: imx: move iomux drivers and headers into mach-imx
      ARM: imx: remove unnecessary inclusion from device-imx*.h
      ARM: imx: move platform device code into mach-imx
      ARM: imx: merge plat-mxc into mach-imx
      ARM: imx: include common.h rather than mach/common.h
      ARM: imx: ARM: imx: include cpuidle.h rather than mach/cpuidle.h
      ARM: imx: include iim.h rather than mach/iim.h
      ARM: imx: include iram.h rather than mach/iram.h
      ARM: imx: include ulpi.h rather than mach/ulpi.h
      ARM: imx: remove mach/dma-mx1-mx2.h
      dma: ipu: rename mach/ipu.h to include/linux/dma/ipu-dma.h
      dma: imx-sdma: remove unneeded mach/hardware.h inclusion
      ASoC: imx-ssi: remove unneeded mach/hardware.h inclusion
      usb: ehci-mxc: remove unneeded mach/hardware.h inclusion
      video: mx3fb: remove unneeded mach/hardware.h inclusion
      watchdog: imx2_wdt: remove unneeded mach/hardware.h inclusion
      i2c: imx: remove cpu_is_xxx by using platform_device_id
      mtd: mxc_nand: remove cpu_is_xxx by using platform_device_id
      rtc: mxc_rtc: remove cpu_is_xxx by using platform_device_id
      dma: imx-dma: use devm_kzalloc and devm_request_irq
      dma: imx-dma: retrieve MEM and IRQ from resources
      dma: imx-dma: remove cpu_is_xxx by using platform_device_id
      media: mx2_camera: remove cpu_is_xxx by using platform_device_id
      mmc: mxcmmc: remove cpu_is_xxx by using platform_device_id
      video: imxfb: remove cpu_is_xxx by using platform_device_id
      ARM: imx: move debug macros to include/debug
      ARM: imx: include hardware.h rather than mach/hardware.h
      ARM: imx: remove header file mach/irqs.h
      ARM: imx: call mxc_device_init() in soc specific function
      ARM: imx: enable multi-platform build
      ARM: imx: select HAVE_IMX_SRC when SMP is enabled

Srinivas Kandagatla (1):
      ARM: pxa: use module_platform_driver macro

Stephen Warren (11):
      usb: host: tegra remove include of <mach/iomap.h>
      usb: phy: tegra remove include of <mach/iomap.h>
      ARM: tegra: update *.dts for regulator-compatible deprecation
      crypto: tegra: remove include of <mach/clk.h>
      staging: nvec: remove include of <mach/iomap.h>
      iommu: tegra: remove include of <mach/iomap.h>
      ARM: tegra: remove unnecessary includes of <mach/*.h>
      ARM: tegra: move tegra-ahb.h out of arch/arm/mach-tegra/
      ARM: tegra: remove <mach/dma.h>
      ARM: tegra: move iomap.h to mach-tegra
      ARM: tegra: move irammap.h to mach-tegra

Thomas Abraham (5):
      ARM: EXYNOS: Remove static io-remapping for gic and combiner
      ARM: EXYNOS: Remove unused static uart resource information
      ARM: EXYNOS: Remove i2c0 resource information and setting of device names
      ARM: EXYNOS: Remove unused non-dt support for dwmci controller
      ARM: EXYNOS: Remove unused regs-mem.h file

Thomas Petazzoni (1):
      ARM: bcm2835: remove useless variables from Makefile.boot

Tomasz Figa (1):
      ARM: EXYNOS: Make s3c_device_i2c0 always use id 0

Tony Lindgren (10):
      Merge branch 'for_3.8/dts' of git://git.kernel.org/.../bcousson/linux-omap-dt into omap-for-v3.8/dt
      Merge branch 'dev-dt-timer' of github.com:jonhunter/linux into omap-for-v3.8/dt
      Merge branch 'for_3.8/dts_part2' of git://git.kernel.org/.../bcousson/linux-omap-dt into omap-for-v3.8/dt
      Merge tag 'omap-cleanup-b2-for-3.8' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.8/cleanup-prcm
      Merge branch 'omap-for-v3.8/cleanup-headers-prepare-multiplatform-v3' into omap-for-v3.8/dt
      Merge branch 'linus' into omap-for-v3.8/cleanup-headers-prepare-multiplatform-v3
      Merge branch 'omap-for-v3.8/cleanup-headers-prepare-multiplatform-v3' into omap-for-v3.8/dt
      Merge branch 'fixes-timer' of github.com:jonhunter/linux into omap-for-v3.8/timer
      ARM: OMAP: Fix compile for OMAP_PM_NOOP if PM is not selected
      Merge branch 'cleanup-timer' of git://github.com/jonhunter/linux into omap-for-v3.8/timer

Tony Prisk (3):
      vt8500: Remove unused headers from include/mach/
      vt8500: Remove arm/boot/compressed/head-vt8500.S
      vt8500: Fix header in mach-vt8500/timer.c

Vivek Gautam (1):
      ARM: EXYNOS: Remove wrongly placed usb2.0 PHY_CFG definition from PMU_REG

Wei Yongjun (1):
      ARM: OMAP2+: remove duplicated include from board-overo.c


 .../devicetree/bindings/arm/arm-boards          |   4 +
 .../devicetree/bindings/arm/omap/counter.txt    |  15 +
 .../devicetree/bindings/arm/omap/timer.txt      |  31 ++
 .../devicetree/bindings/bus/omap-ocp2scp.txt    |  18 +
 .../devicetree/bindings/i2c/i2c-imx.txt         |   4 +-
 .../devicetree/bindings/i2c/trivial-devices.txt |   2 +
 .../devicetree/bindings/usb/am33xx-usb.txt      |  21 +
 MAINTAINERS                                     |   1 -
 arch/arm/Kconfig                                |  18 +-
 arch/arm/Kconfig.debug                          |   8 +
 arch/arm/Makefile                               |   2 -
 arch/arm/boot/compressed/Makefile               |   4 -
 arch/arm/boot/compressed/head-vt8500.S          |  46 ---
 arch/arm/boot/dts/Makefile                      |   6 +-
 arch/arm/boot/dts/am335x-bone.dts               |  50 +++
 arch/arm/boot/dts/am335x-evm.dts                | 118 ++++++
 arch/arm/boot/dts/am335x-evmsk.dts              | 250 ++++++++++++
 arch/arm/boot/dts/am33xx.dtsi                   | 156 +++++++-
 arch/arm/boot/dts/imx27.dtsi                    |   4 +-
 arch/arm/boot/dts/imx51.dtsi                    |   4 +-
 arch/arm/boot/dts/imx53.dtsi                    |   6 +-
 arch/arm/boot/dts/imx6q.dtsi                    |   6 +-
 arch/arm/boot/dts/integratorap.dts              |   5 +
 arch/arm/boot/dts/integratorcp.dts              |   5 +
 arch/arm/boot/dts/omap2.dtsi                    |  86 +++++
 arch/arm/boot/dts/omap2420.dtsi                 |  16 +-
 arch/arm/boot/dts/omap2430.dtsi                 |  19 +-
 arch/arm/boot/dts/omap3-beagle-xm.dts           |   6 -
 arch/arm/boot/dts/omap3-beagle.dts              |  67 ++++
 arch/arm/boot/dts/omap3.dtsi                    | 107 +++++-
 arch/arm/boot/dts/omap4-panda-a4.dts            |  17 +
 .../{omap4-pandaES.dts => omap4-panda-es.dts}   |   9 +
 arch/arm/boot/dts/omap4-panda.dts               |  22 ++
 arch/arm/boot/dts/omap4-sdp-es23plus.dts        |  17 +
 arch/arm/boot/dts/omap4-sdp.dts                 |  22 ++
 .../{omap4-var_som.dts => omap4-var-som.dts}    |   0
 arch/arm/boot/dts/omap4.dtsi                    | 105 ++++-
 arch/arm/boot/dts/omap5-evm.dts                 |  13 +-
 arch/arm/boot/dts/omap5.dtsi                    | 178 ++++++++-
 arch/arm/boot/dts/samsung_k3pe0e000b.dtsi       |  67 ++++
 arch/arm/boot/dts/tegra20-harmony.dts           |  63 +--
 arch/arm/boot/dts/tegra20-paz00.dts             |  59 +--
 arch/arm/boot/dts/tegra20-seaboard.dts          |  59 +--
 arch/arm/boot/dts/tegra20-tamonten.dtsi         |  63 +--
 arch/arm/boot/dts/tegra20-ventana.dts           |  59 +--
 arch/arm/boot/dts/tegra20-whistler.dts          | 119 ++----
 arch/arm/boot/dts/tegra30-cardhu.dtsi           |  47 +--
 arch/arm/boot/dts/twl4030.dtsi                  |  27 ++
 arch/arm/boot/dts/twl6030.dtsi                  |   5 +
 arch/arm/boot/dts/zynq-ep107.dts                |  19 +-
 arch/arm/configs/imx_v4_v5_defconfig            |   4 +-
 arch/arm/configs/imx_v6_v7_defconfig            |   2 +
 arch/arm/include/asm/dma-mapping.h              |   7 -
 .../mach/debug-macro.S => include/debug/imx.S}  |  33 +-
 arch/arm/mach-at91/at91sam9g45.c                |   1 -
 arch/arm/mach-at91/include/mach/atmel-mci.h     |   7 -
 arch/arm/mach-bcm2835/Makefile.boot             |   4 +-
 arch/arm/mach-bcm2835/bcm2835.c                 |   4 +-
 arch/arm/mach-davinci/board-dm646x-evm.c        |   2 +-
 arch/arm/mach-davinci/common.c                  |   2 -
 arch/arm/mach-davinci/usb.c                     |   6 -
 arch/arm/mach-exynos/Kconfig                    |   5 -
 arch/arm/mach-exynos/Makefile                   |   1 -
 arch/arm/mach-exynos/clock-exynos4.c            |   5 -
 arch/arm/mach-exynos/clock-exynos5.c            |  18 +-
 arch/arm/mach-exynos/common.c                   |  58 +--
 arch/arm/mach-exynos/dev-audio.c                |   2 +-
 arch/arm/mach-exynos/dev-dwmci.c                |  75 ----
 arch/arm/mach-exynos/dev-ohci.c                 |   2 +-
 arch/arm/mach-exynos/dev-uart.c                 |  24 --
 arch/arm/mach-exynos/include/mach/dwmci.h       |  20 -
 arch/arm/mach-exynos/include/mach/irqs.h        |   5 -
 arch/arm/mach-exynos/include/mach/map.h         |   1 -
 arch/arm/mach-exynos/include/mach/regs-mem.h    |  23 --
 arch/arm/mach-exynos/include/mach/regs-pmu.h    |   2 -
 arch/arm/mach-exynos/mach-nuri.c                |   7 +-
 arch/arm/mach-exynos/mach-origen.c              |   6 +-
 arch/arm/mach-exynos/mach-smdk4x12.c            |   2 +-
 arch/arm/mach-exynos/mach-smdkv310.c            |   6 +-
 arch/arm/mach-exynos/mach-universal_c210.c      |   5 +-
 .../arm/{plat-mxc => mach-imx}/3ds_debugboard.c |   2 +-
 .../include/mach => mach-imx}/3ds_debugboard.h  |   0
 arch/arm/mach-imx/Kconfig                       |  90 ++++-
 arch/arm/mach-imx/Makefile                      |  22 ++
 arch/arm/{plat-mxc => mach-imx}/avic.c          |   5 +-
 .../include/mach => mach-imx}/board-mx31lilly.h |   0
 .../include/mach => mach-imx}/board-mx31lite.h  |   0
 .../mach => mach-imx}/board-mx31moboard.h       |   0
 .../include/mach => mach-imx}/board-pcm038.h    |   0
 arch/arm/mach-imx/clk-imx1.c                    |  17 +-
 arch/arm/mach-imx/clk-imx21.c                   |  18 +-
 arch/arm/mach-imx/clk-imx25.c                   |  26 +-
 arch/arm/mach-imx/clk-imx27.c                   |  40 +-
 arch/arm/mach-imx/clk-imx31.c                   |  21 +-
 arch/arm/mach-imx/clk-imx35.c                   |  13 +-
 arch/arm/mach-imx/clk-imx51-imx53.c             |  15 +-
 arch/arm/mach-imx/clk-imx6q.c                   |   3 +-
 arch/arm/mach-imx/clk-pllv1.c                   |   4 +-
 .../include/mach => mach-imx}/common.h          |   1 +
 arch/arm/mach-imx/cpu-imx25.c                   |   5 +-
 arch/arm/mach-imx/cpu-imx27.c                   |   2 +-
 arch/arm/mach-imx/cpu-imx31.c                   |   7 +-
 arch/arm/mach-imx/cpu-imx35.c                   |   5 +-
 arch/arm/mach-imx/cpu-imx5.c                    |   3 +-
 arch/arm/{plat-mxc => mach-imx}/cpu.c           |   3 +-
 arch/arm/mach-imx/cpu_op-mx51.c                 |   3 +-
 arch/arm/{plat-mxc => mach-imx}/cpufreq.c       |   3 +-
 arch/arm/{plat-mxc => mach-imx}/cpuidle.c       |   0
 .../include/mach => mach-imx}/cpuidle.h         |   0
 arch/arm/mach-imx/devices-imx1.h                |   3 +-
 arch/arm/mach-imx/devices-imx21.h               |   3 +-
 arch/arm/mach-imx/devices-imx25.h               |   3 +-
 arch/arm/mach-imx/devices-imx27.h               |   3 +-
 arch/arm/mach-imx/devices-imx31.h               |   3 +-
 arch/arm/mach-imx/devices-imx35.h               |   3 +-
 arch/arm/mach-imx/devices-imx50.h               |   3 +-
 arch/arm/mach-imx/devices-imx51.h               |   3 +-
 arch/arm/{plat-mxc => mach-imx}/devices/Kconfig |   0
 .../arm/{plat-mxc => mach-imx}/devices/Makefile |   2 +
 .../mach => mach-imx/devices}/devices-common.h  |   9 +-
 .../{plat-mxc => mach-imx/devices}/devices.c    |   4 +-
 .../devices/platform-ahci-imx.c                 |   5 +-
 .../devices/platform-fec.c                      |   5 +-
 .../devices/platform-flexcan.c                  |   4 +-
 .../devices/platform-fsl-usb2-udc.c             |   5 +-
 .../devices/platform-gpio-mxc.c                 |   2 +-
 .../devices/platform-gpio_keys.c                |   5 +-
 .../devices/platform-imx-dma.c                  |  23 +-
 .../devices/platform-imx-fb.c                   |  16 +-
 .../devices/platform-imx-i2c.c                  |  32 +-
 .../devices/platform-imx-keypad.c               |   4 +-
 .../devices/platform-imx-ssi.c                  |   4 +-
 .../devices/platform-imx-uart.c                 |   4 +-
 .../devices/platform-imx2-wdt.c                 |   5 +-
 .../devices/platform-imx21-hcd.c                |   4 +-
 .../devices/platform-imx27-coda.c               |   4 +-
 .../devices/platform-imx_udc.c                  |   4 +-
 .../devices/platform-imxdi_rtc.c                |   5 +-
 .../devices/platform-ipu-core.c                 |   5 +-
 .../devices/platform-mx1-camera.c               |   4 +-
 .../devices/platform-mx2-camera.c               |  16 +-
 .../devices/platform-mxc-ehci.c                 |   5 +-
 .../devices/platform-mxc-mmc.c                  |  20 +-
 .../devices/platform-mxc_nand.c                 |  25 +-
 .../devices/platform-mxc_pwm.c                  |   4 +-
 .../devices/platform-mxc_rnga.c                 |   4 +-
 .../devices/platform-mxc_rtc.c                  |  13 +-
 .../devices/platform-mxc_w1.c                   |   4 +-
 .../devices/platform-pata_imx.c                 |   4 +-
 .../devices/platform-sdhci-esdhc-imx.c          |   5 +-
 .../devices/platform-spi_imx.c                  |   4 +-
 arch/arm/mach-imx/ehci-imx25.c                  |   4 +-
 arch/arm/mach-imx/ehci-imx27.c                  |   4 +-
 arch/arm/mach-imx/ehci-imx31.c                  |   4 +-
 arch/arm/mach-imx/ehci-imx35.c                  |   4 +-
 arch/arm/mach-imx/ehci-imx5.c                   |   4 +-
 arch/arm/{plat-mxc => mach-imx}/epit.c          |   6 +-
 .../mach => mach-imx}/eukrea-baseboards.h       |   0
 arch/arm/mach-imx/eukrea_mbimx27-baseboard.c    |   7 +-
 arch/arm/mach-imx/eukrea_mbimxsd25-baseboard.c  |   8 +-
 arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c  |   7 +-
 arch/arm/mach-imx/eukrea_mbimxsd51-baseboard.c  |   7 +-
 .../include/mach => mach-imx}/hardware.h        |  26 +-
 arch/arm/mach-imx/hotplug.c                     |   3 +-
 .../{plat-mxc/include/mach => mach-imx}/iim.h   |   0
 arch/arm/mach-imx/imx27-dt.c                    |  11 +-
 arch/arm/mach-imx/imx31-dt.c                    |   5 +-
 arch/arm/mach-imx/imx51-dt.c                    |   9 +-
 arch/arm/mach-imx/include/mach/dma-mx1-mx2.h    |  10 -
 arch/arm/mach-imx/iomux-imx31.c                 |   5 +-
 .../include/mach => mach-imx}/iomux-mx1.h       |   2 +-
 .../include/mach => mach-imx}/iomux-mx21.h      |   4 +-
 .../include/mach => mach-imx}/iomux-mx25.h      |   2 +-
 .../include/mach => mach-imx}/iomux-mx27.h      |   4 +-
 .../include/mach => mach-imx}/iomux-mx2x.h      |   0
 .../include/mach => mach-imx}/iomux-mx3.h       |   0
 .../include/mach => mach-imx}/iomux-mx35.h      |   2 +-
 .../include/mach => mach-imx}/iomux-mx50.h      |   2 +-
 .../include/mach => mach-imx}/iomux-mx51.h      |   2 +-
 arch/arm/{plat-mxc => mach-imx}/iomux-v1.c      |   5 +-
 .../include/mach => mach-imx}/iomux-v1.h        |   0
 arch/arm/{plat-mxc => mach-imx}/iomux-v3.c      |   5 +-
 .../include/mach => mach-imx}/iomux-v3.h        |   0
 .../{plat-mxc/include/mach => mach-imx}/iram.h  |   0
 arch/arm/{plat-mxc => mach-imx}/iram_alloc.c    |   3 +-
 arch/arm/{plat-mxc => mach-imx}/irq-common.c    |   0
 arch/arm/{plat-mxc => mach-imx}/irq-common.h    |   3 +
 arch/arm/mach-imx/lluart.c                      |   3 +-
 arch/arm/mach-imx/mach-apf9328.c                |   7 +-
 arch/arm/mach-imx/mach-armadillo5x0.c           |   9 +-
 arch/arm/mach-imx/mach-bug.c                    |   7 +-
 arch/arm/mach-imx/mach-cpuimx27.c               |  11 +-
 arch/arm/mach-imx/mach-cpuimx35.c               |   9 +-
 arch/arm/mach-imx/mach-cpuimx51sd.c             |   9 +-
 arch/arm/mach-imx/mach-eukrea_cpuimx25.c        |  10 +-
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c     |   6 +-
 arch/arm/mach-imx/mach-imx27ipcam.c             |   6 +-
 arch/arm/mach-imx/mach-imx27lite.c              |   6 +-
 arch/arm/mach-imx/mach-imx53.c                  |  11 +-
 arch/arm/mach-imx/mach-imx6q.c                  |   6 +-
 arch/arm/mach-imx/mach-kzm_arm11_01.c           |   7 +-
 arch/arm/mach-imx/mach-mx1ads.c                 |   7 +-
 arch/arm/mach-imx/mach-mx21ads.c                |   6 +-
 arch/arm/mach-imx/mach-mx25_3ds.c               |   8 +-
 arch/arm/mach-imx/mach-mx27_3ds.c               |  10 +-
 arch/arm/mach-imx/mach-mx27ads.c                |   6 +-
 arch/arm/mach-imx/mach-mx31_3ds.c               |  12 +-
 arch/arm/mach-imx/mach-mx31ads.c                |   5 +-
 arch/arm/mach-imx/mach-mx31lilly.c              |  11 +-
 arch/arm/mach-imx/mach-mx31lite.c               |  11 +-
 arch/arm/mach-imx/mach-mx31moboard.c            |  14 +-
 arch/arm/mach-imx/mach-mx35_3ds.c               |   8 +-
 arch/arm/mach-imx/mach-mx50_rdp.c               |   7 +-
 arch/arm/mach-imx/mach-mx51_3ds.c               |   9 +-
 arch/arm/mach-imx/mach-mx51_babbage.c           |   7 +-
 arch/arm/mach-imx/mach-mxt_td60.c               |   6 +-
 arch/arm/mach-imx/mach-pca100.c                 |   8 +-
 arch/arm/mach-imx/mach-pcm037.c                 |   8 +-
 arch/arm/mach-imx/mach-pcm037_eet.c             |   5 +-
 arch/arm/mach-imx/mach-pcm038.c                 |  13 +-
 arch/arm/mach-imx/mach-pcm043.c                 |   9 +-
 arch/arm/mach-imx/mach-qong.c                   |   6 +-
 arch/arm/mach-imx/mach-scb9328.c                |   7 +-
 arch/arm/mach-imx/mach-vpr200.c                 |   7 +-
 arch/arm/mach-imx/mm-imx1.c                     |   9 +-
 arch/arm/mach-imx/mm-imx21.c                    |  14 +-
 arch/arm/mach-imx/mm-imx25.c                    |  12 +-
 arch/arm/mach-imx/mm-imx27.c                    |  14 +-
 arch/arm/mach-imx/mm-imx3.c                     |  13 +-
 arch/arm/mach-imx/mm-imx5.c                     |  12 +-
 .../{plat-mxc/include/mach => mach-imx}/mx1.h   |   0
 .../{plat-mxc/include/mach => mach-imx}/mx21.h  |   0
 .../{plat-mxc/include/mach => mach-imx}/mx25.h  |   0
 .../{plat-mxc/include/mach => mach-imx}/mx27.h  |   0
 .../{plat-mxc/include/mach => mach-imx}/mx2x.h  |   0
 .../{plat-mxc/include/mach => mach-imx}/mx31.h  |   0
 arch/arm/mach-imx/mx31lilly-db.c                |   9 +-
 arch/arm/mach-imx/mx31lite-db.c                 |   9 +-
 arch/arm/mach-imx/mx31moboard-devboard.c        |   9 +-
 arch/arm/mach-imx/mx31moboard-marxbot.c         |   9 +-
 arch/arm/mach-imx/mx31moboard-smartbot.c        |  11 +-
 .../{plat-mxc/include/mach => mach-imx}/mx35.h  |   0
 .../{plat-mxc/include/mach => mach-imx}/mx3x.h  |   0
 .../{plat-mxc/include/mach => mach-imx}/mx50.h  |   0
 .../{plat-mxc/include/mach => mach-imx}/mx51.h  |   0
 .../{plat-mxc/include/mach => mach-imx}/mx53.h  |   0
 .../{plat-mxc/include/mach => mach-imx}/mx6q.h  |   0
 .../{plat-mxc/include/mach => mach-imx}/mxc.h   |   0
 arch/arm/mach-imx/pcm970-baseboard.c            |   7 +-
 arch/arm/mach-imx/platsmp.c                     |   5 +-
 arch/arm/mach-imx/pm-imx27.c                    |   3 +-
 arch/arm/mach-imx/pm-imx3.c                     |   7 +-
 arch/arm/mach-imx/pm-imx5.c                     |   7 +-
 arch/arm/mach-imx/pm-imx6q.c                    |   5 +-
 arch/arm/{plat-mxc => mach-imx}/ssi-fiq-ksym.c  |   0
 arch/arm/{plat-mxc => mach-imx}/ssi-fiq.S       |   0
 arch/arm/{plat-mxc => mach-imx}/system.c        |   5 +-
 arch/arm/{plat-mxc => mach-imx}/time.c          |   5 +-
 arch/arm/{plat-mxc => mach-imx}/tzic.c          |   6 +-
 arch/arm/{plat-mxc => mach-imx}/ulpi.c          |   2 +-
 .../{plat-mxc/include/mach => mach-imx}/ulpi.h  |   0
 arch/arm/mach-integrator/Kconfig                |   2 +
 arch/arm/mach-integrator/common.h               |   8 +-
 arch/arm/mach-integrator/core.c                 | 141 ++++---
 .../arm/mach-integrator/include/mach/platform.h |   1 -
 arch/arm/mach-integrator/integrator_ap.c        | 158 ++++++--
 arch/arm/mach-integrator/integrator_cp.c        | 115 ++++--
 arch/arm/mach-integrator/pci_v3.c               |  32 +-
 arch/arm/mach-kirkwood/board-dockstar.c         |  13 -
 arch/arm/mach-kirkwood/board-dreamplug.c        |  15 -
 arch/arm/mach-kirkwood/board-dt.c               |   4 +-
 arch/arm/mach-kirkwood/board-goflexnet.c        |  13 -
 arch/arm/mach-kirkwood/board-ib62x0.c           |   6 -
 arch/arm/mach-kirkwood/board-iconnect.c         |   8 -
 arch/arm/mach-kirkwood/board-iomega_ix2_200.c   |   2 -
 arch/arm/mach-kirkwood/board-lsxl.c             |   8 -
 arch/arm/mach-kirkwood/board-ts219.c            |   3 -
 arch/arm/mach-kirkwood/common.c                 |  11 +-
 arch/arm/mach-kirkwood/common.h                 |   3 +-
 arch/arm/mach-kirkwood/cpuidle.c                |   2 +-
 arch/arm/mach-kirkwood/dockstar-setup.c         |   2 +-
 arch/arm/mach-kirkwood/irq.c                    |   1 +
 arch/arm/mach-kirkwood/lacie_v2-common.c        |   1 +
 arch/arm/mach-kirkwood/mpp.c                    |   4 +-
 arch/arm/mach-kirkwood/netspace_v2-setup.c      |   4 +-
 arch/arm/mach-kirkwood/openrd-setup.c           |  14 +-
 arch/arm/mach-kirkwood/pcie.c                   |  31 +-
 arch/arm/mach-kirkwood/sheevaplug-setup.c       |   2 +-
 arch/arm/mach-kirkwood/t5325-setup.c            |   6 +-
 arch/arm/mach-kirkwood/ts41x-setup.c            |   3 +-
 arch/arm/mach-kirkwood/tsx1x-common.c           |   7 +-
 arch/arm/mach-omap1/common.h                    |   2 +-
 arch/arm/mach-omap1/devices.c                   |  21 +-
 arch/arm/mach-omap1/reset.c                     |   9 +-
 arch/arm/mach-omap1/timer.c                     |   1 +
 arch/arm/mach-omap1/timer32k.c                  |   1 -
 arch/arm/mach-omap2/Makefile                    |  10 +-
 arch/arm/mach-omap2/am33xx.h                    |   1 +
 arch/arm/mach-omap2/board-2430sdp.c             |   2 +-
 arch/arm/mach-omap2/board-3430sdp.c             |   2 +-
 arch/arm/mach-omap2/board-3630sdp.c             |   2 +-
 arch/arm/mach-omap2/board-4430sdp.c             |   2 +-
 arch/arm/mach-omap2/board-am3517crane.c         |   2 +-
 arch/arm/mach-omap2/board-am3517evm.c           |   2 +-
 arch/arm/mach-omap2/board-apollon.c             |   2 +-
 arch/arm/mach-omap2/board-cm-t35.c              |  18 +-
 arch/arm/mach-omap2/board-cm-t3517.c            |   4 +-
 arch/arm/mach-omap2/board-devkit8000.c          |   2 +-
 arch/arm/mach-omap2/board-generic.c             |  27 +-
 arch/arm/mach-omap2/board-h4.c                  |   2 +-
 arch/arm/mach-omap2/board-igep0020.c            |   4 +-
 arch/arm/mach-omap2/board-ldp.c                 |   2 +-
 arch/arm/mach-omap2/board-n8x0.c                |   6 +-
 arch/arm/mach-omap2/board-omap3beagle.c         |   2 +-
 arch/arm/mach-omap2/board-omap3evm.c            |   2 +-
 arch/arm/mach-omap2/board-omap3logic.c          |   4 +-
 arch/arm/mach-omap2/board-omap3pandora.c        |   2 +-
 arch/arm/mach-omap2/board-omap3stalker.c        |   2 +-
 arch/arm/mach-omap2/board-omap3touchbook.c      |   2 +-
 arch/arm/mach-omap2/board-omap4panda.c          |   2 +-
 arch/arm/mach-omap2/board-overo.c               |   2 +-
 arch/arm/mach-omap2/board-rm680.c               |   4 +-
 arch/arm/mach-omap2/board-rx51.c                |   2 +-
 arch/arm/mach-omap2/board-ti8168evm.c           |   4 +-
 arch/arm/mach-omap2/board-zoom.c                |   4 +-
 arch/arm/mach-omap2/clkt2xxx_apll.c             |  57 +--
 arch/arm/mach-omap2/clkt2xxx_dpllcore.c         |  36 +-
 arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c    |  70 +++-
 arch/arm/mach-omap2/clkt_iclk.c                 |   1 -
 arch/arm/mach-omap2/clock.c                     |  57 ++-
 arch/arm/mach-omap2/clock.h                     |  28 --
 arch/arm/mach-omap2/clock2420_data.c            |  26 +-
 arch/arm/mach-omap2/clock2430_data.c            |  26 +-
 arch/arm/mach-omap2/clock2xxx.c                 |  16 -
 arch/arm/mach-omap2/clock2xxx.h                 |   9 +-
 arch/arm/mach-omap2/cm-regbits-24xx.h           |   2 +
 arch/arm/mach-omap2/cm.h                        |  20 +-
 arch/arm/mach-omap2/cm2xxx.c                    | 128 ++++++-
 arch/arm/mach-omap2/cm2xxx.h                    |   4 +
 arch/arm/mach-omap2/cm2xxx_3xxx.h               |   8 +-
 arch/arm/mach-omap2/cm3xxx.c                    |  66 ++++
 arch/arm/mach-omap2/cm3xxx.h                    |   5 +
 arch/arm/mach-omap2/cm_common.c                 |  71 +++-
 arch/arm/mach-omap2/cminst44xx.h                |   2 +
 arch/arm/mach-omap2/common.c                    | 183 ---------
 arch/arm/mach-omap2/common.h                    | 134 ++-----
 arch/arm/mach-omap2/control.c                   |  10 +-
 arch/arm/mach-omap2/control.h                   |   2 +
 arch/arm/mach-omap2/cpuidle34xx.c               |   1 -
 arch/arm/mach-omap2/devices.c                   |  26 --
 arch/arm/mach-omap2/display.c                   |   2 +-
 arch/arm/mach-omap2/hdq1w.c                     |   4 +-
 arch/arm/mach-omap2/i2c.c                       |   6 +-
 arch/arm/mach-omap2/id.c                        |  32 +-
 arch/arm/mach-omap2/io.c                        |  85 ++++-
 arch/arm/mach-omap2/mcbsp.c                     |   2 +-
 arch/arm/mach-omap2/msdi.c                      |   4 +-
 arch/arm/mach-omap2/omap2-restart.c             |  65 ++++
 arch/arm/mach-omap2/omap3-restart.c             |  36 ++
 arch/arm/mach-omap2/omap4-common.c              |  19 +
 arch/arm/mach-omap2/omap_hwmod.c                |   8 +-
 arch/arm/mach-omap2/omap_hwmod_2420_data.c      |   1 -
 arch/arm/mach-omap2/omap_hwmod_2430_data.c      |   1 -
 .../mach-omap2/omap_hwmod_2xxx_ipblock_data.c   |  15 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c      |  41 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c      |   6 +-
 arch/arm/mach-omap2/pm-debug.c                  |   1 -
 arch/arm/mach-omap2/pm34xx.c                    |   1 -
 arch/arm/mach-omap2/powerdomain.c               |   2 -
 arch/arm/mach-omap2/prcm-common.h               |  22 --
 arch/arm/mach-omap2/prcm.c                      | 189 ---------
 arch/arm/mach-omap2/prcm_mpu44xx.c              |  17 +
 arch/arm/mach-omap2/prcm_mpu44xx.h              |   9 +-
 arch/arm/mach-omap2/prm.h                       |  24 +-
 arch/arm/mach-omap2/prm2xxx.c                   |  15 +-
 arch/arm/mach-omap2/prm2xxx.h                   |   2 +
 arch/arm/mach-omap2/prm2xxx_3xxx.h              |   7 -
 arch/arm/mach-omap2/prm3xxx.c                   |  16 +-
 arch/arm/mach-omap2/prm3xxx.h                   |   2 +
 arch/arm/mach-omap2/prm44xx.c                   |   1 -
 arch/arm/mach-omap2/prm_common.c                |  17 +-
 arch/arm/mach-omap2/prminst44xx.h               |   2 +
 arch/arm/mach-omap2/sdrc.c                      |   8 +-
 arch/arm/mach-omap2/sdrc.h                      |   2 +
 arch/arm/mach-omap2/soc.h                       |   8 +-
 arch/arm/mach-omap2/ti81xx.h                    |   9 +
 arch/arm/mach-omap2/timer.c                     | 382 +++++++++++++------
 arch/arm/mach-omap2/wd_timer.c                  |  40 +-
 arch/arm/mach-pxa/Kconfig                       |  34 --
 arch/arm/mach-pxa/Makefile                      |   3 -
 arch/arm/mach-pxa/clock.h                       |   2 +-
 arch/arm/mach-pxa/devices.c                     |   8 +-
 arch/arm/mach-pxa/include/mach/hardware.h       |  28 --
 arch/arm/mach-pxa/include/mach/irqs.h           |   1 -
 arch/arm/mach-pxa/include/mach/pxa3xx.h         |   1 -
 arch/arm/mach-pxa/include/mach/pxa95x.h         |   7 -
 arch/arm/mach-pxa/pxa3xx-ulpi.c                 |  13 +-
 arch/arm/mach-pxa/pxa95x.c                      | 295 --------------
 arch/arm/mach-pxa/saarb.c                       | 115 ------
 arch/arm/mach-pxa/tavorevb3.c                   | 136 -------
 arch/arm/mach-s3c24xx/clock-s3c2443.c           |   6 -
 arch/arm/mach-s3c64xx/clock.c                   |  20 +-
 arch/arm/mach-s3c64xx/common.c                  |   1 -
 arch/arm/mach-s5p64x0/common.c                  |   2 -
 arch/arm/mach-s5pv210/common.c                  |   2 -
 arch/arm/mach-s5pv210/mach-goni.c               |   1 -
 arch/arm/mach-shmobile/setup-r8a7740.c          |   6 -
 arch/arm/mach-shmobile/setup-sh7372.c           |   6 -
 arch/arm/mach-tegra/apbio.c                     |   5 +-
 arch/arm/mach-tegra/board-dt-tegra20.c          |   4 +-
 arch/arm/mach-tegra/board-dt-tegra30.c          |   3 +-
 arch/arm/mach-tegra/clock.c                     |   2 -
 arch/arm/mach-tegra/common.c                    |   2 +-
 arch/arm/mach-tegra/cpu-tegra.c                 |   3 -
 arch/arm/mach-tegra/cpuidle.c                   |   2 -
 arch/arm/mach-tegra/flowctrl.c                  |   3 +-
 arch/arm/mach-tegra/fuse.c                      |   3 +-
 arch/arm/mach-tegra/headsmp.S                   |   3 +-
 arch/arm/mach-tegra/include/mach/debug-macro.S  |   4 +-
 arch/arm/mach-tegra/include/mach/dma.h          |  54 ---
 arch/arm/mach-tegra/include/mach/powergate.h    |   2 +
 arch/arm/mach-tegra/include/mach/uncompress.h   |   4 +-
 arch/arm/mach-tegra/io.c                        |   2 +-
 arch/arm/mach-tegra/{include/mach => }/iomap.h  |   2 -
 .../arm/mach-tegra/{include/mach => }/irammap.h |   0
 arch/arm/mach-tegra/irq.c                       |   3 +-
 arch/arm/mach-tegra/pcie.c                      |   2 +-
 arch/arm/mach-tegra/platsmp.c                   |   3 +-
 arch/arm/mach-tegra/pmc.c                       |   2 +-
 arch/arm/mach-tegra/powergate.c                 |   2 +-
 arch/arm/mach-tegra/reset.c                     |   5 +-
 arch/arm/mach-tegra/sleep-t20.S                 |   2 -
 arch/arm/mach-tegra/sleep-t30.S                 |   2 -
 arch/arm/mach-tegra/sleep.S                     |   2 +-
 arch/arm/mach-tegra/sleep.h                     |   2 +-
 arch/arm/mach-tegra/tegra20_clocks.c            |   3 +-
 arch/arm/mach-tegra/tegra20_clocks_data.c       |   2 -
 arch/arm/mach-tegra/tegra2_emc.c                |   2 -
 arch/arm/mach-tegra/tegra30_clocks.c            |   3 +-
 arch/arm/mach-tegra/timer.c                     |   2 +-
 arch/arm/mach-u300/core.c                       |   2 -
 arch/arm/mach-vt8500/include/mach/hardware.h    |  12 -
 arch/arm/mach-vt8500/include/mach/i8042.h       |  18 -
 arch/arm/mach-vt8500/include/mach/restart.h     |  17 -
 arch/arm/mach-vt8500/timer.c                    |   2 +-
 arch/arm/mach-vt8500/vt8500.c                   |   2 -
 arch/arm/mach-zynq/common.c                     |  23 +-
 arch/arm/mach-zynq/include/mach/clkdev.h        |  32 --
 arch/arm/mach-zynq/include/mach/zynq_soc.h      |  31 +-
 arch/arm/plat-mxc/Kconfig                       |  89 -----
 arch/arm/plat-mxc/Makefile                      |  24 --
 arch/arm/plat-mxc/include/mach/irqs.h           |  21 -
 arch/arm/plat-mxc/include/mach/timex.h          |  22 --
 arch/arm/plat-mxc/include/mach/uncompress.h     | 132 -------
 arch/arm/plat-omap/Kconfig                      |   6 +
 arch/arm/plat-omap/debug-leds.c                 |   2 +-
 arch/arm/plat-omap/dmtimer.c                    | 218 ++++++++---
 arch/arm/plat-omap/include/plat/dmtimer.h       | 143 ++++---
 arch/arm/plat-omap/include/plat/prcm.h          |  37 --
 arch/arm/plat-pxa/Makefile                      |   1 -
 arch/arm/plat-pxa/include/plat/mfp.h            |   4 +-
 arch/arm/plat-samsung/adc.c                     |  48 +--
 arch/arm/plat-samsung/devs.c                    |   4 -
 arch/arm/plat-samsung/include/plat/devs.h       |   1 -
 drivers/amba/tegra-ahb.c                        |   1 +
 drivers/clk/clk-bcm2835.c                       |   2 +-
 drivers/crypto/tegra-aes.c                      |   2 -
 drivers/dma/imx-dma.c                           | 137 ++++---
 drivers/dma/imx-sdma.c                          |   1 -
 drivers/dma/ipu/ipu_idmac.c                     |   3 +-
 drivers/dma/ipu/ipu_irq.c                       |   3 +-
 drivers/gpio/gpio-pxa.c                         |   2 +-
 drivers/i2c/busses/i2c-imx.c                    |  40 +-
 drivers/iommu/tegra-smmu.c                      |   4 +-
 drivers/media/platform/soc_camera/mx2_camera.c  |  95 +++--
 drivers/media/platform/soc_camera/mx3_camera.c  |   2 +-
 drivers/mmc/host/mxcmmc.c                       |  31 +-
 drivers/mtd/nand/mxc_nand.c                     |  96 +++--
 drivers/rtc/rtc-mxc.c                           |  34 +-
 drivers/staging/nvec/nvec.c                     |   1 -
 drivers/staging/tidspbridge/core/ue_deh.c       |   1 -
 drivers/usb/host/ehci-mxc.c                     |   1 -
 drivers/video/imxfb.c                           |  38 +-
 drivers/video/mx3fb.c                           |   3 +-
 drivers/watchdog/imx2_wdt.c                     |   1 -
 drivers/watchdog/omap_wdt.c                     |  26 +-
 .../mach/ipu.h => include/linux/dma/ipu-dma.h   |   6 +-
 include/linux/platform_data/asoc-imx-ssi.h      |   2 +
 include/linux/platform_data/dma-imx.h           |   4 +-
 include/linux/platform_data/dmtimer-omap.h      |  31 ++
 include/linux/platform_data/omap-wd-timer.h     |  38 ++
 .../include/mach => include/linux}/tegra-ahb.h  |   6 +-
 sound/soc/fsl/imx-pcm-fiq.c                     |   1 -
 sound/soc/fsl/imx-ssi.c                         |   1 -
 sound/soc/tegra/tegra30_ahub.c                  |   1 -
 sound/soc/tegra/tegra_pcm.h                     |   2 -
 496 files changed, 4718 insertions(+), 4091 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/omap/counter.txt
 create mode 100644 Documentation/devicetree/bindings/arm/omap/timer.txt
 delete mode 100644 arch/arm/boot/compressed/head-vt8500.S
 create mode 100644 arch/arm/boot/dts/am335x-evmsk.dts
 create mode 100644 arch/arm/boot/dts/omap3-beagle.dts
 create mode 100644 arch/arm/boot/dts/omap4-panda-a4.dts
 rename arch/arm/boot/dts/{omap4-pandaES.dts => omap4-panda-es.dts} (70%)
 create mode 100644 arch/arm/boot/dts/omap4-sdp-es23plus.dts
 rename arch/arm/boot/dts/{omap4-var_som.dts => omap4-var-som.dts} (100%)
 create mode 100644 arch/arm/boot/dts/samsung_k3pe0e000b.dtsi
 rename arch/arm/{plat-mxc/include/mach/debug-macro.S => include/debug/imx.S} (59%)
 delete mode 100644 arch/arm/mach-exynos/dev-dwmci.c
 delete mode 100644 arch/arm/mach-exynos/include/mach/dwmci.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/regs-mem.h
 rename arch/arm/{plat-mxc => mach-imx}/3ds_debugboard.c (99%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/3ds_debugboard.h (100%)
 rename arch/arm/{plat-mxc => mach-imx}/avic.c (98%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/board-mx31lilly.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/board-mx31lite.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/board-mx31moboard.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/board-pcm038.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/common.h (99%)
 rename arch/arm/{plat-mxc => mach-imx}/cpu.c (97%)
 rename arch/arm/{plat-mxc => mach-imx}/cpufreq.c (99%)
 rename arch/arm/{plat-mxc => mach-imx}/cpuidle.c (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/cpuidle.h (100%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/Kconfig (100%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/Makefile (98%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/devices}/devices-common.h (97%)
 rename arch/arm/{plat-mxc => mach-imx/devices}/devices.c (92%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-ahci-imx.c (98%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-fec.c (97%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-flexcan.c (96%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-fsl-usb2-udc.c (96%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-gpio-mxc.c (96%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-gpio_keys.c (94%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imx-dma.c (63%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imx-fb.c (79%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imx-i2c.c (76%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imx-keypad.c (97%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imx-ssi.c (98%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imx-uart.c (98%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imx2-wdt.c (97%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imx21-hcd.c (94%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imx27-coda.c (93%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imx_udc.c (96%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imxdi_rtc.c (94%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-ipu-core.c (98%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-mx1-camera.c (94%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-mx2-camera.c (83%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-mxc-ehci.c (97%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-mxc-mmc.c (76%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-mxc_nand.c (74%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-mxc_pwm.c (97%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-mxc_rnga.c (95%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-mxc_rtc.c (77%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-mxc_w1.c (95%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-pata_imx.c (96%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-sdhci-esdhc-imx.c (98%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-spi_imx.c (98%)
 rename arch/arm/{plat-mxc => mach-imx}/epit.c (99%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/eukrea-baseboards.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/hardware.h (94%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iim.h (100%)
 delete mode 100644 arch/arm/mach-imx/include/mach/dma-mx1-mx2.h
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-mx1.h (99%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-mx21.h (99%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-mx25.h (99%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-mx27.h (99%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-mx2x.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-mx3.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-mx35.h (99%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-mx50.h (99%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-mx51.h (99%)
 rename arch/arm/{plat-mxc => mach-imx}/iomux-v1.c (98%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-v1.h (100%)
 rename arch/arm/{plat-mxc => mach-imx}/iomux-v3.c (97%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-v3.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iram.h (100%)
 rename arch/arm/{plat-mxc => mach-imx}/iram_alloc.c (98%)
 rename arch/arm/{plat-mxc => mach-imx}/irq-common.c (100%)
 rename arch/arm/{plat-mxc => mach-imx}/irq-common.h (94%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx1.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx21.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx25.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx27.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx2x.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx31.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx35.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx3x.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx50.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx51.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx53.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx6q.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mxc.h (100%)
 rename arch/arm/{plat-mxc => mach-imx}/ssi-fiq-ksym.c (100%)
 rename arch/arm/{plat-mxc => mach-imx}/ssi-fiq.S (100%)
 rename arch/arm/{plat-mxc => mach-imx}/system.c (97%)
 rename arch/arm/{plat-mxc => mach-imx}/time.c (99%)
 rename arch/arm/{plat-mxc => mach-imx}/tzic.c (98%)
 rename arch/arm/{plat-mxc => mach-imx}/ulpi.c (99%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/ulpi.h (100%)
 create mode 100644 arch/arm/mach-omap2/omap2-restart.c
 create mode 100644 arch/arm/mach-omap2/omap3-restart.c
 delete mode 100644 arch/arm/mach-omap2/prcm.c
 delete mode 100644 arch/arm/mach-pxa/include/mach/pxa95x.h
 delete mode 100644 arch/arm/mach-pxa/pxa95x.c
 delete mode 100644 arch/arm/mach-pxa/saarb.c
 delete mode 100644 arch/arm/mach-pxa/tavorevb3.c
 delete mode 100644 arch/arm/mach-tegra/include/mach/dma.h
 rename arch/arm/mach-tegra/{include/mach => }/iomap.h (99%)
 rename arch/arm/mach-tegra/{include/mach => }/irammap.h (100%)
 delete mode 100644 arch/arm/mach-vt8500/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-vt8500/include/mach/i8042.h
 delete mode 100644 arch/arm/mach-vt8500/include/mach/restart.h
 delete mode 100644 arch/arm/mach-zynq/include/mach/clkdev.h
 delete mode 100644 arch/arm/plat-mxc/Kconfig
 delete mode 100644 arch/arm/plat-mxc/Makefile
 delete mode 100644 arch/arm/plat-mxc/include/mach/irqs.h
 delete mode 100644 arch/arm/plat-mxc/include/mach/timex.h
 delete mode 100644 arch/arm/plat-mxc/include/mach/uncompress.h
 delete mode 100644 arch/arm/plat-omap/include/plat/prcm.h
 rename arch/arm/plat-mxc/include/mach/ipu.h => include/linux/dma/ipu-dma.h (97%)
 create mode 100644 include/linux/platform_data/dmtimer-omap.h
 create mode 100644 include/linux/platform_data/omap-wd-timer.h
 rename {arch/arm/mach-tegra/include/mach => include/linux}/tegra-ahb.h (86%)
