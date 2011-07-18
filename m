Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab1GRQib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 12:38:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55984 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab1GRQiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 12:38:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Merge plans: what's im arm-soc.git for 3.1
Date: Mon, 18 Jul 2011 16:37:09 +0000
User-Agent: KMail/1.13.6 (Linux/2.6.37; KDE/4.6.90; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201107181637.09878.arnd@arndb.de>
X-Provags-ID: V02:K0:WE+tuyJx2dMfczQnvvHbtrkfzZQMEamJcWe7Y7yPyW7
 TfMq1i5H97uOZKIwRU+HzIpg9af7J4dbotcHG41XzuEpoLCD/E
 7w/Fa6EP9cPVLJeNNdPwoXG5fZLbXw/rXnwM3ADiuNrNZpBymq
 FqIpgmeDq9fCuW2eS3RPr0yaAeEX0iaWQTrvM2LedrckqxJ3qn
 fqYRfnsVkzck0EQh0X0/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This is an overview of the patches that have accumulated in the arm-soc
tree to date. Right now, the plan is to send it all in about 10 stages:

next/fixes    -- bug fixes with no dependencies
next/cleanup  -- cleanups and code consolidation
next/fixes2   -- bug fixes depending on cleanups
next/deletion -- removal of outdated board support (maybe fold into cleanup)
next/cross-platform -- consolidation towards a single zImage
next/devel    -- new features for existing machines (depends on external gpio tree)
next/devicetree -- device tree conversions (depends on external devicetree tree)
next/soc      -- support for new socs (prima2, zynq, omap4460)
next/board    -- new board support for existing platforms
next/devel2   -- more new code for existing platforms (depends on omap_dss2 tree)

The devicetree work is not yet merged in arm-soc, I expect Grant to send it
to me soon. This will make it possible to replace board files with device tree
files in multiple subarchitectures

As usual, the contents are dominated by the omap2 platform in terms of lines
changed, which has been the case for a long time. The reason for this is mostly
a huge effort on cleanups there, but also a lot of work going into support for
the twl6040 companion chip (in drivers/mfd) and the omap4460 SOC.

Two new platforms are getting added, the Xilinx Zynq and the CSR
SirfPrima2. Both are entirely based on probing through the device tree
and are consequently much smaller than the existing platforms. As we
continue to consolidate header files across platforms, they will shrink
even further.

I haven't seen pull requests at all for Samsung and Qualcomm platforms,
and since they are not in arm/for-next I assume that these don't go through
Russell's tree either. It's not too late to send me pull requests yet, but
any new features submitted now will go into next/devel2 or a branch that
I submit later than that.

	Arnd
---

The following changes since commit 8480ef63103d11a25da1cbc5f963430200e3b11c:

  Merge branches 'depends/gpio' and 'depends/omap_dss2' of git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc into tmp (2011-07-18 17:55:17 +0200)

are available in the git repository at:

  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc.git for-next

Ambresh K (1):
      OMAP4: DMTIMER: enable autoidle mode

Ameya Palande (1):
      omap: rx51: Platform support for lp5523 led chip

Andre Silva (7):
      ARM: mach-mx5/mx53_ard: Add support for i.MX53 ARD board
      ARM:mach-mx5/board-mx53_loco: Add CD and WP GPIOs
      ARM:mach-mx5/board-mx51_babbage: Add CD and WP GPIOs
      ARM:mach-mx5/mx53_ard: Add ESDHC support
      ARM:mach-mx5/mx53_ard: Add Watchdog timer support
      ARM:mx53: Add I2C3 support
      ARM:mach-mx5/mx53_ard: Add I2C2 and I2C3 support

Andy Green (6):
      I2C: OMAP2+: Set hwmod flags to only allow 16-bit accesses to i2c
      I2C: OMAP2+: increase omap_i2c_dev_attr flags from u8 to u32
      I2C: OMAP2+:  Introduce I2C IP versioning constants
      I2C: OMAP1/OMAP2+: create omap I2C functionality flags for each cpu_... test
      I2C: OMAP2+: Tag all OMAP2+ hwmod defintions with I2C IP revision
      I2C: OMAP2+: add correct functionality flags to all omap2plus i2c dev_attr

Aneesh V (2):
      OMAP: ID: introduce chip detection for OMAP4460
      OMAP4: ID: add omap_has_feature for max freq supported

Anton Vorontsov (1):
      ARM: cns3xxx: Add support for L2 Cache Controller

Arnd Bergmann (23):
      omap2+: fix build regression
      ARM: Xilinx: merge board file into main platform code
      Merge branch 'cleanup-part-2' of git+ssh://master.kernel.org/.../tmlind/linux-omap-2.6 into omap/cleanup
      Merge branch 'fixes-part-2' of git://git.kernel.org/.../tmlind/linux-omap-2.6 into omap/fixes
      Merge branch 'fixes-for-arnd' of git://git.pengutronix.de/git/imx/linux-2.6 into imx/fixes
      Merge branches 'at91/fixes', 'imx/fixes' and 'pxa/fixes' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into next/fixes
      Merge branches 'davinci/cleanup', 'imx/cleanup', 'omap/cleanup' and 'pxa/cleanup' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into next/cleanup
      Merge branches 'cns3xxx/devel', 'davinci/devel', 'imx/devel', 'lpc32xx/devel', 'pxa/devel', 'tegra/devel' and 'stericsson/master' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into next/devel
      Merge branch 'omap/board' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into next/board
      Merge branch 'zynq/master' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into next/soc
      Merge branch 'omap/4460' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into next/soc
      Merge branches 'omap/prcm' and 'omap/mfd' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into next/devel-2
      Merge branch 'next/deletion' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into for-next
      Merge branch 'next/cross-platform' into for-next

Avinash.H.M (1):
      OMAP: hwmod: fix the i2c-reset timeout during bootup

Axel Castaneda Gonzalez (1):
      ASoC: twl6040: Configure ramp step based on platform

Axel Lin (1):
      ARM i.MX23/28: platform-mxsfb: Add missing include of linux/dma-mapping.h

Barry Song (5):
      ARM: CNS3XXX: add UL suffix to VMALLOC_END to ensure it is properly typed
      ARM: LPC32XXX: add UL suffix to VMALLOC_END to ensure it is properly typed
      ARM: NUC93X: add UL suffix to VMALLOC_END to ensure it is properly typed
      ARM: CSR: mapping early DEBUG_LL uart
      MAINTAINERS: add maintainer of CSR SiRFprimaII machine

Benoit Cousson (35):
      OMAP2+: hwmod: Fix smart-standby + wakeup support
      OMAP4: hwmod data: Add MSTANDBY_SMART_WKUP flag
      OMAP2+: hwmod: Do not write the enawakeup bit if SYSC_HAS_ENAWAKEUP is not set
      OMAP2+: hwmod: Remove _populate_mpu_rt_base warning
      OMAP2+: hwmod: Fix the HW reset management
      OMAP: hwmod: Add warnings if enable failed
      OMAP: hwmod: Move pr_debug to improve the readability
      OMAP4: hwmod data: Fix L3 interconnect data order and alignement
      OMAP4: hwmod data: Remove un-needed parens
      OMAP4: hwmod data: Fix bad alignement
      OMAP4: hwmod data: Align interconnect format with regular modules
      OMAP4: clock data: Add sddiv to USB DPLL
      OMAP4: clock data: Remove usb_host_fs clkdev with NULL dev
      OMAP4: clock data: Re-order some clock nodes and structure fields
      OMAP4: clock data: Fix max mult and div for USB DPLL
      OMAP4: prcm: Fix errors in few defines name
      OMAP4: prm: Remove wrong clockdomain offsets
      OMAP4: powerdomain data: Fix indentation
      OMAP4: cm: Remove RESTORE macros to avoid access from SW
      OMAP4: prcm_mpu: Fix indent in few macros
      OMAP4: clockdomain data: Fix data order and wrong name
      OMAP4: powerdomain data: Fix core mem states and missing cefuse flag
      OMAP: omap_device: Create clkdev entry for hwmod main_clk
      OMAP4: hwmod data: Add clock domain attribute
      OMAP2+: hwmod: Init clkdm field at boot time
      OMAP4: hwmod: Replace CLKCTRL absolute address with offset macros
      OMAP: hwmod: Wait the idle status to be disabled
      OMAP4: hwmod: Replace RSTCTRL absolute address with offset macros
      OMAP4: prm: Replace warm reset API with the offset based version
      OMAP4: prm: Remove deprecated functions
      OMAP4: hwmod data: Add PRM context register offset
      OMAP4: hwmod data: Add modulemode entry in omap_hwmod structure
      OMAP4: cm: Add two new APIs for modulemode control
      OMAP4: hwmod: Introduce the module control in hwmod control
      OMAP2+: clockdomain: Add 2 APIs to control clockdomain from hwmod framework

Binghua Duan (1):
      ARM: CSR: Adding CSR SiRFprimaII board support

Charulatha V (1):
      omap: ZOOM: QUART: Request reset GPIO

Christian Riesch (1):
      davinci: da850: add a .set_rate method to ref_clk

Colin Cross (3):
      ARM: tegra: remove mach/barriers.h
      ARM: tegra: remove copy-and-pasted i2c platform data in boards
      ARM: tegra: remove copy-and-pasted usb platform data from boards

Daiane Angolini (1):
      ARM: mach-mx5/mx53_ard: Add gpio_keys support

Daniel Mack (1):
      omap: Overo: remove duplicate call to overo_ads7846_init()

Dinh Nguyen (1):
      ARM: mx51: Add support for low power suspend on MX51

Dmitry Eremin-Solenikov (1):
      ARM: scoop: drop pcmcia_init callback

Dong Aisheng (1):
      ARM: mxs-dma: include <linux/dmaengine.h>

Eric Miao (7):
      ARM: pxa/saarb: make use of pxa3xx_map_io()
      ARM: pxa: enable AUTO_ZRELADDR
      ARM: pxa: add common header file for pxa3xx
      ARM: pxa: avoid accessing interrupt registers directly
      ARM: pxa: introduce {icip,ichp}_handle_irq() to prepare MULTI_IRQ_HANDLER
      ARM: pxa: move declarations from generic.h to <soc>.h
      ARM: pxa: enable MULTI_IRQ_HANDLER for all boards

Fabio Estevam (28):
      mx51: Let USB Storage be built by default
      ARM: mx53: Fix alternate modes for MX53_PAD_PATA_DATA6
      ARM: mx53: Fix the chip select addresses
      ARM: mach-imx/mx27_3ds: Use the standard i.MX macro for GPIO numbering
      ARM: mach-imx/mx31_3ds: Fix IOMUX for SPI1 signals
      mxc: iomuxv1: Do not use gpio_request when setting the pin as GPIO
      ARM: mach-imx/mx27_3ds: Fix regulator support
      ARM: mxc: iomux-v1: Fix build warning
      ARM: mx51: Fix the address space length for SSI
      ARM: mx53: Fix some interrupts marked as reserved.
      ARM: mx5/mx51_babbage: Move GPIO initialization for USB PHY Reset line to common place
      ARM: mx5/mx51_babbage: Use gpio_request_array for USBH1 pins
      ARM: imx/mach-apf9328: Simplify UART0 registration
      ARM: mach-imx/scb9328: Make the UART gpio setup simpler
      ARM: mach-imx/mx27_3ds: Use the standard gpio_to_irq function
      ARM: mach-imx/mx27_3ds: Do not annotate the chip select as internal
      ARM: mx5/mx53_loco: Add support for LED
      ARM: mx5/mx53_evk: Add support for LED
      ARM: mx53: Add SDMA clock
      ARM: mx53: Add SDMA support for MX53
      ARM: imx2: Fix GPIO iosize
      ARM: mach-imx/mx27_3ds: Add LCD support
      ARM: mach-imx/mx27_3ds: Add touchscreen support
      ARM: mx53: Add support for missing UARTs
      ARM: mx53: Add SSI suport
      ARM: mx53: Add keypad support
      ARM: mach-mx5/mx53_ard: Add missing definition
      ARM: mx25: Fix typo on CAN1_RX pad setting

Grazvydas Ignotas (1):
      omap: cleanup NAND platform data

H Hartley Sweeten (1):
      plat-mxc/pwm.c: use resource_size()

Haojian Zhuang (2):
      ARM: pxa: add clk_set_rate()
      ARM: mmp/dkb: enable max7312 gpio expander

Igor Grinberg (7):
      arm: omap3: cm-t35: minor comments fixes
      arm: omap3: cm-t35: fix slow path warning
      arm: omap3: cm-t35: add support for cm-t3730
      ARM: pxa/cm-x300: fix V3020 RTC functionality
      ARM: pxa/cm-x300: GPIO cleanup
      ARM: pxa/cm-x300: minor style cleanup
      ARM: pxa/cm-x300: update cm_x300_defconfig

Imre Kaloz (1):
      ARM: cns3xxx: Should select CPU_V6K

Jarkko Nikula (4):
      omap: mcbsp: Drop SPI mode support
      omap: mcbsp: Drop in-driver transfer support
      omap: mcbsp: Remove rx_/tx_word_length variables
      omap: mcbsp: Remove port number enums

Jean Pihet (1):
      OMAP PM: remove OMAP_PM_NONE config option

Joel A Fernandes (1):
      OMAP3: beagle: add support for beagleboard xM revision C

John Linn (1):
      ARM: Xilinx: Adding Xilinx board support

Jon Hunter (3):
      OMAP4: clock data: Remove McASP2, McASP3 and MMC6 clocks
      OMAP4: clock data: Remove UNIPRO clock nodes
      OMAP: Add debugfs node to show the summary of all clocks

Jonathan Cameron (1):
      pcmcia: pxa2xx/trizeps4: remove unnecessary ifdefs

Julia Lawall (1):
      arch/arm/mach-omap2/clock.c: add missing clk_put

Jürgen Lambrecht (1):
      Enable RTC driver.

KOSAKI Motohiro (1):
      arm,tegra: replace cpu_set() with modern api

Kalle Jokiniemi (1):
      OMAP3: rx-51: Add full regulator definitions

Kevin Hilman (4):
      OMAP3: PM debug: remove sleep_while_idle feature
      OMAP2: PM debug: remove register dumping
      OMAP3: PM debug: remove register dumping
      OMAP: omap_device: replace _find_by_pdev() with to_omap_device()

Lei Wen (2):
      ARM: pxa910: correct nand pmu setting
      ARM: pxa168: correct nand pmu setting

Liam Girdwood (3):
      ASoC: twl6040: add all ABE DAIs
      ASoC: twl6040: Support other sample rates in constraints.
      ASoC: twl6040: set default constraints.

Linus Walleij (10):
      mach-ux500: add HREFv60 Kconfig option
      mach-ux500: fix HREFv60 regression
      mach-ux500: correct MMC/SDI parameters
      mach-ux500: activate USB in the U8500 defconfig
      mach-ux500: complete regulator constraints for MOP500 board
      mach-u300: cleanup clockevent code
      mach-u300: set apropriate FIFO trigger levels
      mach-ux500: register a clock for the SMP TWD
      mach-ux500: fix USB build error
      mach-integrator: delete bits.h include file

Lothar Waßmann (2):
      mach-mx5: fix the I2C clock parents
      iomux-mx53: add missing 'IOMUX_CONFIG_SION' for some I2C pad definitions

Marc Dietrich (5):
      ARM: tegra: paz00: whitespace cleanup
      ARM: tegra: paz00: register i2c busses
      ARM: tegra: paz00: enable usb ports
      ARM: tegra: paz00: cleanup sdhci ports
      ARM: tegra: paz00: change the machine name

Marc Kleine-Budde (1):
      ARM: mx53: Fix the base addresses for the DDR memory regions

Mathieu J. Poirier (3):
      mach-ux500: setting proper uart for snowball
      mach-ux500: Add SDI support for snowball board
      mach-ux500: Kconfig for snowball board

Mattias Wallin (1):
      mach-ux500: iomap PRCMU TCDM memory

Miguel Vadillo (1):
      OMAP2+: hwmod: Enable module in shutdown to access sysconfig

Mike Rapoport (3):
      ARM: tegra: trimslice: register i2c busses and devices
      ARM: tegra: trimslice: add audio devices and clocks
      ARM: tegra: trimslice: enable USB ports

Misael Lopez Cruz (5):
      mfd: twl6040: Add initial support
      ASoC: twl6040: Convert into TWL6040 MFD child
      input: Add initial support for TWL6040 vibrator
      ASoC: twl6040: Remove pll and headset mode dependency
      OMAP4: SDP4430: Add twl6040 codec platform support

Nicolas Pitre (3):
      ARM: mach-s3c24a0: delete
      ARM: mach-s3c2400: delete
      ARM: mach-loki: delete

Nishanth Menon (4):
      OMAP3+: SR: make notify independent of class
      OMAP3+: SR: disable interrupt by default
      OMAP3+: SR: enable/disable SR only on need
      OMAP3+: SR: fix cosmetic indentation

Ohad Ben-Cohen (2):
      omap: iovmm: s/sg_dma_len(sg)/sg->length/
      OMAP4: iommu: fix clock name

Oleg Drokin (2):
      cleanup regulator supply definitions in mach-omap2
      Remove old-style supply.dev assignments common in hsmmc init

Paul Parsons (1):
      ARM: pxa: fix PGSR register address calculation

Paul Walmsley (14):
      OMAP: dmtimer: add missing include
      omap_hwmod: use a null structure record to terminate omap_hwmod_addr_space arrays
      omap_hwmod: share identical omap_hwmod_addr_space arrays
      omap_hwmod: use a terminator record with omap_hwmod_mpu_irqs arrays
      omap_hwmod: share identical omap_hwmod_mpu_irqs arrays
      omap_hwmod: use a terminator record with omap_hwmod_dma_info arrays
      omap_hwmod: share identical omap_hwmod_dma_info arrays
      omap_hwmod: share identical omap_hwmod_class, omap_hwmod_class_sysconfig arrays
      Merge branches 'dmtimer_precleanup_3.1', 'hwmod_core_cleanup_a_3.1', 'combine_common_hwmod_3.1', 'omap4_hwmod_data_cleanup_a_3.1', 'clock_cleanup_a_3.1', 'prcm_cleanup_a_3.1', 'omap_pm_cleanup_3.1' and 'omap_device_cleanup_3.1' into prcm-cleanup-3.1
      Merge branches 'powerdomain_fixes_3.1', 'hardware_workarounds_3.1', 'hwmod_dss_fix_3.1' and 'i2c_fixes_3.1' into prcm-fixes-3.1
      OMAP2+: clockdomain: add clkdm_in_hwsup()
      OMAP2+: clock: allow per-SoC clock init code to prevent clockdomain calls from clock code
      Merge branches 'omap4_clockdomain_hwmod_3.1', 'clock_debugfs_a_3.1', 'omap4_clock_auxclk_3.1' and 'omap_device_a_3.1' into prcm-devel-3.1
      ASoC: omap: McBSP: fix build breakage on OMAP1

Peter Ujfalusi (22):
      omap: board-omap3evm: Fix compilation error
      OMAP: New twl-common for common TWL configuration
      OMAP4: Move common twl6030 configuration to twl-common
      OMAP3: Move common twl configuration to twl-common
      OMAP3: Move common regulator configuration to twl-common
      MFD: twl4030-codec: Rename internals from codec to audio
      MFD: twl4030-codec -> twl4030-audio: Rename the driver
      MFD: twl4030-audio: Rename platform data
      MFD: twl6040: Change platform data for soc codec driver
      OMAP4: SDP4430: Add twl6040 vibrator platform support
      MFD: twl6040: Use resource to provide irq number for slaves
      input: twl6040-vibra: Do not use wrapper for irq request
      ASoC: twl6040: Do not use wrapper for irq request
      MFD: twl6040: Demand valid interrupt configuration
      MFD: twl6040: Remove wrapper for threaded irq request
      ASoC: twl6040: Use neutral name for power mode text/enum
      ASoC: twl6040: Move PLL selection to codec driver
      ASoC: twl6040: Simplify sample rate constraint handling
      ASoC: twl6040: Configure PLL only once
      MFD: twl6040: Remove enum for PLL tracking
      ASoC: twl6040: No need to convert the PLL ID
      ASoC: twl6040: Add back support for legacy mode

Philipp Zabel (4):
      ARM: pxa/magician: fix MAGICIAN_EGPIO_BASE, align with NR_BUILTIN_GPIO
      ARM: pxa/magician: use gpio arrays for backlight and global gpios
      ARM: pxa/hx4700: use gpio arrays for global gpios
      ARM: pxa/mioa701: use gpio arrays for global and gsm gpios

Rajendra Nayak (7):
      OMAP4: PRCM: OMAP4460 specific PRM and CM register bitshifts
      OMAP4: clocks: Update the clock tree with 4460 clock nodes
      OMAP2+: PM: Initialise sleep_switch to a non-valid value
      OMAP4: clock data: Add missing divider selection for auxclks
      OMAP2+: PM: idle clkdms only if already in idle
      OMAP2+: clockdomain: Add per clkdm lock to prevent concurrent state programming
      OMAP2+: hwmod: Follow the recommended PRCM module enable sequence

Rob Herring (6):
      powerpc: rename ppc_pci_*_flags to pci_*_flags
      pci: move microblaze and powerpc pci flag functions into asm-generic
      ARM: remove unnecessary mach/hardware.h includes
      ARM: pci: make pcibios_assign_all_busses use pci_has_flag
      ARM: convert PCI defines to variables
      ARM: set vga memory base at run-time

Robert Marklund (4):
      mach-x500: fix SECTION warnings in uib
      mach-ux500: add basic support for snowball board
      mach-ux500: Add pin configuration for snowball board
      mach-ux500: add configs for snowball board

Robert Morell (1):
      arm: tegra: remove generic disp clock divisor flag

Rongjun Ying (1):
      ARM: CSR: initializing L2 cache

Russell King - ARM Linux (2):
      Convert OMAPs 32kHz clocksource implementation to use the generic MMIO     clocksource support.  This achieves several things:
      ARM: introduce handle_IRQ() not to dump exception stack

Sanjeev Premi (1):
      OMAP2+: PM: fix section mismatch in pm_dbg_init()

Santosh Shilimkar (2):
      OMAP4: clock data: Keep GPMC clocks always enabled and hardware managed
      OMAP4: powerdomain data: Remove unsupported MPU powerdomain state

Sascha Hauer (11):
      ARM i.MX dma: Fix burstsize settings
      ARM i.MX: fix last user of iomux.h and remove it
      ARM i.MX: define CLOCK_TICK_RATE to bogus value
      ARM i.MX: remove SoC defines around header includes
      ARM i.MX: dmav1: kill SoC ifdefs
      ARM i.MX mxc.h: use CONFIG_SOC_* instead of CONFIG_ARCH_*
      ARM i.MX tzic: do not depend on MXC_INTERNAL_IRQS
      ARM i.MX avic: do not depend on MXC_INTERNAL_IRQS
      ARM i.MX: get rid of wrong MXC_INTERNAL_IRQ usage
      ARM i.MX debug macro: use CONFIG_SOC_* instead of CONFIG_ARCH_*
      Merge remote-tracking branch 'grant/gpio/next-mx' into devel-features

Sekhar Nori (6):
      davinci: psc.h: clean up indentation done using spaces
      davinci: dm6467/T EVM: fix setting up of reference clock rate
      davinci: pass clock flags to davinci_psc_config()
      davinci: enable forced transitions on PSC
      davinci: da850: add support for SATA interface
      davinci: da850 evm: register SATA device

Shawn Guo (10):
      ARM: mxs_defconfig: Change CONFIG_RTC_CLASS 'm' to 'y'
      ARM: mxc: imx-sdma device gets 16K iosize than 4K
      ARM: mxc: sdma on imx25 is a V2 block
      ARM: mxc: change imx-dma default to_version to 1
      ARM: mxc: imx-dma on imx25 has no other TO version but TO1
      ARM: mxs_defconfig: Add mx23evk and mx28evk build
      ARM: mxs/mx28evk: add leds-gpio device for heartbeat
      ARM: mxc: convert tzic to use generic irq chip
      ARM: mxc: clean up imx-dma device registration
      dmaengine: imx-sdma: pass sdma firmware name via platform data

Shubhrajyoti Datta (1):
      OMAP4: Keyboard: Mux changes in the board file

Silesh C V (2):
      omap: HSMMC: Fix GPIO muxing
      omap: 4430SDP: Register the card detect GPIO properly

Stephen Warren (1):
      ARM: Tegra: Seaboard: Re-order sdhci device registration

Suman Anna (1):
      omap: iommu: fix pte programming

Tanmay Upadhyay (3):
      ARM: pxa168: Add support for UART3
      ARM: pxa168: Add support for Ethernet
      ARM: pxa168: Add board support for gplugD

Tomi Valkeinen (2):
      OMAP4: hwmod data: Modify DSS opt clocks
      OMAP4: hwmod data: Change DSS main_clk scheme

Tony Lindgren (18):
      omap: Use separate init_irq functions to avoid cpu_is_omap tests early
      omap: Set separate timer init functions to avoid cpu_is_omap tests
      omap: Move dmtimer defines to dmtimer.h
      omap: Make a subset of dmtimer functions into inline functions
      omap2+: Use dmtimer macros for clockevent
      omap2+: Remove gptimer_wakeup for now
      omap2+: Reserve clocksource and timesource and initialize dmtimer later
      omap2+: Use dmtimer macros for clocksource
      omap2+: Remove omap2_gp_clockevent_set_gptimer
      omap2+: Rename timer-gp.c into timer.c to combine timer init functions
      Merge branch 'devel-timer' into devel-cleanup
      Merge branch 'for_3.1/pm-misc' of git://git.kernel.org/.../khilman/linux-omap-pm into devel-cleanup
      Merge branch 'iommu-for-tony' of git://github.com/ohadbc/omap-iommu into devel-fixes
      Merge branch 'peter/topic/for-tony_mach-cleanup' of git://gitorious.org/omap-audio/linux-audio into cleanup-part-2
      Merge branch 'peter/topic/for-tony' of git://gitorious.org/omap-audio/linux-audio into twl-asoc
      Merge branch 'cleanup-part-2' into devel-board
      Merge branch 'prcm-cleanup-3.1' of git://git.pwsan.com/linux-2.6 into cleanup-part-3
      Merge branch 'prcm-fixes-3.1' of git://git.pwsan.com/linux-2.6 into fixes-part-2

Troy Kisky (5):
      MXC: iomux-v3: correct NO_PAD_CTRL definition
      ARM: i.MX53: Fix IOMUX type o's
      ARM: i.MX53: UARTn_TXD pin should not change RXD input select
      ARM: i.MX53: UARTn_CTS pin should not change RTS input select
      ARM: i.MX53: consistently use MX53_UART_PAD_CTRL for uart txd/rxd/rts/cts

Uwe Kleine-König (4):
      ARM: mxs/tx28: according to the TX28's datasheet D4-D7 are not used for MMC0
      ARM: imx: convert to new leds-gpio registration helper
      ARM: mx5: convert to new leds-gpio registration helper
      ARM: mxs/tx28: convert to new leds-gpio registration helper

Vaibhav Bedia (1):
      OMAP: clockdomain: Remove redundant call to pwrdm_wait_transition()

Vasily Khoruzhick (1):
      ARM: pxa/z2: add poweroff function

Vishal Mahaveer (1):
      omap: blaze: add mmc5/wl1283 device support

Wolfram Sang (3):
      arm: mxs: add mmc-device for mach-tx28
      arm: lpc32xx: add tsc-device
      arm: lpc32xx: add rtc-device

 Documentation/arm/Samsung-S3C24XX/Overview.txt     |    7 +-
 Documentation/devicetree/bindings/arm/sirf.txt     |    3 +
 Documentation/devicetree/bindings/arm/xilinx.txt   |    7 +
 MAINTAINERS                                        |    6 +
 arch/arm/Kconfig                                   |   44 +-
 arch/arm/Makefile                                  |    7 +-
 arch/arm/boot/dts/prima2-cb.dts                    |  416 +++++++++
 arch/arm/boot/dts/zynq-ep107.dts                   |   52 ++
 arch/arm/configs/cm_x300_defconfig                 |   18 +-
 arch/arm/configs/loki_defconfig                    |  120 ---
 arch/arm/configs/mx51_defconfig                    |    3 +-
 arch/arm/configs/mxs_defconfig                     |    4 +-
 arch/arm/configs/u8500_defconfig                   |   32 +-
 arch/arm/include/asm/hardware/scoop.h              |    1 -
 arch/arm/include/asm/irq.h                         |    1 +
 arch/arm/include/asm/pci.h                         |   12 +-
 arch/arm/include/asm/vga.h                         |    5 +-
 arch/arm/kernel/irq.c                              |   19 +-
 arch/arm/lib/ecard.S                               |    1 -
 arch/arm/lib/io-readsw-armv3.S                     |    1 -
 arch/arm/lib/io-writesw-armv3.S                    |    1 -
 arch/arm/mach-bcmring/include/mach/hardware.h      |    2 -
 arch/arm/mach-cns3xxx/cns3420vb.c                  |    3 +-
 arch/arm/mach-cns3xxx/core.c                       |   43 +
 arch/arm/mach-cns3xxx/core.h                       |    6 +
 arch/arm/mach-cns3xxx/include/mach/hardware.h      |   22 -
 arch/arm/mach-cns3xxx/include/mach/vmalloc.h       |    2 +-
 arch/arm/mach-cns3xxx/pcie.c                       |    3 +
 arch/arm/mach-davinci/board-da850-evm.c            |    7 +
 arch/arm/mach-davinci/board-dm646x-evm.c           |   17 +-
 arch/arm/mach-davinci/clock.c                      |   46 +-
 arch/arm/mach-davinci/clock.h                      |    3 +
 arch/arm/mach-davinci/da850.c                      |   10 +
 arch/arm/mach-davinci/devices-da8xx.c              |  126 +++
 arch/arm/mach-davinci/dm646x.c                     |    4 +-
 arch/arm/mach-davinci/include/mach/da8xx.h         |    2 +
 arch/arm/mach-davinci/include/mach/dm646x.h        |    2 -
 arch/arm/mach-davinci/include/mach/psc.h           |  151 ++--
 arch/arm/mach-davinci/psc.c                        |   14 +-
 arch/arm/mach-dove/include/mach/hardware.h         |    7 -
 arch/arm/mach-dove/pcie.c                          |    3 +
 arch/arm/mach-ep93xx/include/mach/hardware.h       |    2 -
 arch/arm/mach-footbridge/dc21285.c                 |    3 +
 arch/arm/mach-footbridge/include/mach/hardware.h   |    5 -
 arch/arm/mach-imx/Kconfig                          |    6 +
 arch/arm/mach-imx/dma-v1.c                         |   25 +-
 arch/arm/mach-imx/eukrea_mbimx27-baseboard.c       |   23 +-
 arch/arm/mach-imx/eukrea_mbimxsd25-baseboard.c     |   15 +-
 arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c     |   13 +-
 arch/arm/mach-imx/mach-apf9328.c                   |    7 +-
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c        |    2 +-
 arch/arm/mach-imx/mach-mx27_3ds.c                  |  137 +++-
 arch/arm/mach-imx/mach-mx31_3ds.c                  |   10 +-
 arch/arm/mach-imx/mach-mx31moboard.c               |   14 +-
 arch/arm/mach-imx/mach-mx35_3ds.c                  |    2 +-
 arch/arm/mach-imx/mach-scb9328.c                   |   17 +-
 arch/arm/mach-imx/mm-imx21.c                       |    3 +
 arch/arm/mach-imx/mm-imx25.c                       |   25 +
 arch/arm/mach-imx/mm-imx27.c                       |    3 +
 arch/arm/mach-imx/mm-imx31.c                       |   27 +
 arch/arm/mach-imx/mm-imx35.c                       |   47 +
 arch/arm/mach-imx/mx31lite-db.c                    |   15 +-
 arch/arm/mach-integrator/include/mach/bits.h       |   61 --
 arch/arm/mach-integrator/include/mach/hardware.h   |    7 -
 arch/arm/mach-integrator/pci_v3.c                  |    5 +
 arch/arm/mach-iop13xx/include/mach/hardware.h      |    7 -
 arch/arm/mach-iop13xx/pci.c                        |    5 +-
 arch/arm/mach-iop32x/include/mach/hardware.h       |    3 -
 arch/arm/mach-iop33x/include/mach/hardware.h       |    3 -
 arch/arm/mach-ixp2000/include/mach/hardware.h      |    8 -
 arch/arm/mach-ixp2000/pci.c                        |    5 +
 arch/arm/mach-ixp23xx/include/mach/hardware.h      |    4 -
 arch/arm/mach-ixp23xx/pci.c                        |    5 +
 arch/arm/mach-ixp4xx/common-pci.c                  |    5 +
 arch/arm/mach-ixp4xx/include/mach/hardware.h       |    5 -
 arch/arm/mach-kirkwood/include/mach/hardware.h     |    7 -
 arch/arm/mach-kirkwood/pcie.c                      |    3 +
 arch/arm/mach-ks8695/include/mach/hardware.h       |    9 -
 arch/arm/mach-ks8695/pci.c                         |    3 +
 arch/arm/mach-loki/Kconfig                         |   13 -
 arch/arm/mach-loki/Makefile                        |    3 -
 arch/arm/mach-loki/addr-map.c                      |  122 ---
 arch/arm/mach-loki/common.c                        |  162 ----
 arch/arm/mach-loki/common.h                        |   37 -
 arch/arm/mach-loki/include/mach/bridge-regs.h      |   28 -
 arch/arm/mach-loki/include/mach/debug-macro.S      |   19 -
 arch/arm/mach-loki/include/mach/entry-macro.S      |   30 -
 arch/arm/mach-loki/include/mach/hardware.h         |   15 -
 arch/arm/mach-loki/include/mach/io.h               |   26 -
 arch/arm/mach-loki/include/mach/irqs.h             |   58 --
 arch/arm/mach-loki/include/mach/loki.h             |   83 --
 arch/arm/mach-loki/include/mach/memory.h           |   10 -
 arch/arm/mach-loki/include/mach/system.h           |   36 -
 arch/arm/mach-loki/include/mach/timex.h            |   11 -
 arch/arm/mach-loki/include/mach/uncompress.h       |   47 -
 arch/arm/mach-loki/include/mach/vmalloc.h          |    5 -
 arch/arm/mach-loki/irq.c                           |   22 -
 arch/arm/mach-loki/lb88rc8480-setup.c              |   99 --
 arch/arm/mach-lpc32xx/clock.c                      |    2 +-
 arch/arm/mach-lpc32xx/common.c                     |   42 +
 arch/arm/mach-lpc32xx/common.h                     |    2 +
 arch/arm/mach-lpc32xx/include/mach/vmalloc.h       |    2 +-
 arch/arm/mach-mmp/Kconfig                          |    7 +
 arch/arm/mach-mmp/Makefile                         |    1 +
 arch/arm/mach-mmp/clock.c                          |   15 +
 arch/arm/mach-mmp/clock.h                          |    1 +
 arch/arm/mach-mmp/gplugd.c                         |  189 ++++
 arch/arm/mach-mmp/include/mach/mfp-gplugd.h        |   52 ++
 arch/arm/mach-mmp/include/mach/mfp-pxa168.h        |   19 +
 arch/arm/mach-mmp/include/mach/pxa168.h            |    8 +
 arch/arm/mach-mmp/include/mach/regs-apmu.h         |    1 +
 arch/arm/mach-mmp/pxa168.c                         |    8 +-
 arch/arm/mach-mmp/pxa910.c                         |    2 +-
 arch/arm/mach-mmp/ttc_dkb.c                        |   31 +-
 arch/arm/mach-mv78xx0/include/mach/hardware.h      |    7 -
 arch/arm/mach-mv78xx0/pcie.c                       |    3 +
 arch/arm/mach-mx5/Kconfig                          |   18 +
 arch/arm/mach-mx5/Makefile                         |    2 +
 arch/arm/mach-mx5/board-cpuimx51.c                 |   12 +-
 arch/arm/mach-mx5/board-mx51_3ds.c                 |    3 +-
 arch/arm/mach-mx5/board-mx51_babbage.c             |   56 +-
 arch/arm/mach-mx5/board-mx51_efikamx.c             |   15 +-
 arch/arm/mach-mx5/board-mx51_efikasb.c             |   16 +-
 arch/arm/mach-mx5/board-mx53_ard.c                 |  254 ++++++
 arch/arm/mach-mx5/board-mx53_evk.c                 |   17 +
 arch/arm/mach-mx5/board-mx53_loco.c                |   35 +-
 arch/arm/mach-mx5/clock-mx51-mx53.c                |   22 +-
 arch/arm/mach-mx5/crm_regs.h                       |    2 +
 arch/arm/mach-mx5/devices-imx53.h                  |    8 +
 arch/arm/mach-mx5/eukrea_mbimx51-baseboard.c       |   24 +-
 arch/arm/mach-mx5/eukrea_mbimxsd-baseboard.c       |   19 +-
 arch/arm/mach-mx5/mm.c                             |   44 +
 arch/arm/mach-mx5/pm-imx5.c                        |   73 ++
 arch/arm/mach-mxs/Kconfig                          |    3 +
 arch/arm/mach-mxs/devices/platform-mxsfb.c         |    1 +
 arch/arm/mach-mxs/include/mach/dma.h               |    2 +
 arch/arm/mach-mxs/mach-mx28evk.c                   |   21 +
 arch/arm/mach-mxs/mach-tx28.c                      |   19 +-
 arch/arm/mach-nuc93x/include/mach/vmalloc.h        |    2 +-
 arch/arm/mach-omap1/board-ams-delta.c              |    4 +-
 arch/arm/mach-omap1/board-fsample.c                |    4 +-
 arch/arm/mach-omap1/board-generic.c                |    4 +-
 arch/arm/mach-omap1/board-h2.c                     |    4 +-
 arch/arm/mach-omap1/board-h3.c                     |    4 +-
 arch/arm/mach-omap1/board-htcherald.c              |    4 +-
 arch/arm/mach-omap1/board-innovator.c              |    4 +-
 arch/arm/mach-omap1/board-nokia770.c               |    4 +-
 arch/arm/mach-omap1/board-osk.c                    |    4 +-
 arch/arm/mach-omap1/board-palmte.c                 |    4 +-
 arch/arm/mach-omap1/board-palmtt.c                 |    4 +-
 arch/arm/mach-omap1/board-palmz71.c                |    4 +-
 arch/arm/mach-omap1/board-perseus2.c               |    4 +-
 arch/arm/mach-omap1/board-sx1.c                    |    4 +-
 arch/arm/mach-omap1/board-voiceblue.c              |    4 +-
 arch/arm/mach-omap1/irq.c                          |    2 +-
 arch/arm/mach-omap1/mcbsp.c                        |    4 +-
 arch/arm/mach-omap1/time.c                         |    6 +-
 arch/arm/mach-omap1/timer32k.c                     |    4 -
 arch/arm/mach-omap2/Kconfig                        |    6 +-
 arch/arm/mach-omap2/Makefile                       |   20 +-
 arch/arm/mach-omap2/board-2430sdp.c                |    4 +-
 arch/arm/mach-omap2/board-3430sdp.c                |   93 +--
 arch/arm/mach-omap2/board-3630sdp.c                |    4 +-
 arch/arm/mach-omap2/board-4430sdp.c                |  341 +++++---
 arch/arm/mach-omap2/board-am3517crane.c            |    4 +-
 arch/arm/mach-omap2/board-am3517evm.c              |    4 +-
 arch/arm/mach-omap2/board-apollon.c                |    4 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |  176 ++--
 arch/arm/mach-omap2/board-cm-t3517.c               |    5 +-
 arch/arm/mach-omap2/board-devkit8000.c             |   64 +-
 arch/arm/mach-omap2/board-flash.c                  |    4 -
 arch/arm/mach-omap2/board-generic.c                |    4 +-
 arch/arm/mach-omap2/board-h4.c                     |    4 +-
 arch/arm/mach-omap2/board-igep0020.c               |   79 +--
 arch/arm/mach-omap2/board-ldp.c                    |   29 +-
 arch/arm/mach-omap2/board-n8x0.c                   |   12 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |  167 ++---
 arch/arm/mach-omap2/board-omap3evm.c               |  111 +--
 arch/arm/mach-omap2/board-omap3logic.c             |   19 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |  119 +--
 arch/arm/mach-omap2/board-omap3stalker.c           |   99 +--
 arch/arm/mach-omap2/board-omap3touchbook.c         |   97 +--
 arch/arm/mach-omap2/board-omap4panda.c             |  161 +---
 arch/arm/mach-omap2/board-overo.c                  |   84 +--
 arch/arm/mach-omap2/board-rm680.c                  |   12 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |  194 ++++-
 arch/arm/mach-omap2/board-rx51.c                   |    4 +-
 arch/arm/mach-omap2/board-ti8168evm.c              |    9 +-
 arch/arm/mach-omap2/board-zoom-debugboard.c        |    9 +
 arch/arm/mach-omap2/board-zoom-peripherals.c       |  128 +---
 arch/arm/mach-omap2/board-zoom.c                   |    8 +-
 arch/arm/mach-omap2/clock.c                        |   28 +-
 arch/arm/mach-omap2/clock.h                        |    3 +
 arch/arm/mach-omap2/clock2420_data.c               |   22 +-
 arch/arm/mach-omap2/clock2430_data.c               |   32 +-
 arch/arm/mach-omap2/clock3xxx_data.c               |   44 +-
 arch/arm/mach-omap2/clock44xx.h                    |    7 -
 arch/arm/mach-omap2/clock44xx_data.c               |  482 ++++++-----
 arch/arm/mach-omap2/clockdomain.c                  |  210 ++++-
 arch/arm/mach-omap2/clockdomain.h                  |   11 +
 arch/arm/mach-omap2/clockdomain2xxx_3xxx.c         |    6 +-
 arch/arm/mach-omap2/clockdomain44xx.c              |   13 +-
 arch/arm/mach-omap2/clockdomains44xx_data.c        |  124 ++--
 arch/arm/mach-omap2/cm-regbits-44xx.h              |  659 ++++++--------
 arch/arm/mach-omap2/cm1_44xx.h                     |   64 +-
 arch/arm/mach-omap2/cm2_44xx.h                     |   73 +--
 arch/arm/mach-omap2/cm44xx.h                       |    8 +-
 arch/arm/mach-omap2/cminst44xx.c                   |  150 +++-
 arch/arm/mach-omap2/cminst44xx.h                   |   10 +-
 arch/arm/mach-omap2/common-board-devices.c         |   27 +-
 arch/arm/mach-omap2/common-board-devices.h         |   26 +-
 arch/arm/mach-omap2/devices.c                      |    3 +-
 arch/arm/mach-omap2/gpmc-nand.c                    |   10 +-
 arch/arm/mach-omap2/hsmmc.c                        |    7 +-
 arch/arm/mach-omap2/i2c.c                          |   68 ++
 arch/arm/mach-omap2/id.c                           |   53 +-
 arch/arm/mach-omap2/io.c                           |   17 +-
 arch/arm/mach-omap2/iommu2.c                       |    4 +-
 arch/arm/mach-omap2/irq.c                          |   32 +-
 arch/arm/mach-omap2/omap-iommu.c                   |    2 +-
 arch/arm/mach-omap2/omap4-common.c                 |   10 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |  404 ++++++++--
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |  841 +++---------------
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |  917 +++----------------
 .../omap_hwmod_2xxx_3xxx_interconnect_data.c       |  173 ++++
 .../mach-omap2/omap_hwmod_2xxx_3xxx_ipblock_data.c |  322 +++++++
 .../mach-omap2/omap_hwmod_2xxx_interconnect_data.c |  130 +++
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c |  150 ++++
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  672 +++-----------
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |  940 +++++++++++++-------
 arch/arm/mach-omap2/omap_hwmod_common_data.c       |   20 -
 arch/arm/mach-omap2/omap_hwmod_common_data.h       |   93 ++-
 arch/arm/mach-omap2/pm-debug.c                     |  372 +--------
 arch/arm/mach-omap2/pm.c                           |    6 +-
 arch/arm/mach-omap2/pm.h                           |   16 -
 arch/arm/mach-omap2/pm24xx.c                       |    6 +-
 arch/arm/mach-omap2/pm34xx.c                       |    6 -
 arch/arm/mach-omap2/powerdomains44xx_data.c        |   27 +-
 arch/arm/mach-omap2/prcm.c                         |    2 +-
 arch/arm/mach-omap2/prcm_mpu44xx.h                 |   69 +-
 arch/arm/mach-omap2/prm-regbits-44xx.h             |    8 +
 arch/arm/mach-omap2/prm44xx.c                      |  145 +---
 arch/arm/mach-omap2/prm44xx.h                      |   44 +-
 arch/arm/mach-omap2/prminst44xx.c                  |  112 +++-
 arch/arm/mach-omap2/prminst44xx.h                  |   12 +-
 arch/arm/mach-omap2/smartreflex.c                  |   38 +-
 arch/arm/mach-omap2/timer-gp.c                     |  266 ------
 arch/arm/mach-omap2/timer-gp.h                     |   16 -
 arch/arm/mach-omap2/timer.c                        |  342 +++++++
 arch/arm/mach-omap2/twl-common.c                   |  304 +++++++
 arch/arm/mach-omap2/twl-common.h                   |   59 ++
 arch/arm/mach-orion5x/include/mach/hardware.h      |    7 -
 arch/arm/mach-orion5x/pci.c                        |    2 +
 arch/arm/mach-prima2/Makefile                      |    7 +
 arch/arm/mach-prima2/Makefile.boot                 |    3 +
 arch/arm/mach-prima2/clock.c                       |  509 +++++++++++
 arch/arm/mach-prima2/common.h                      |   26 +
 arch/arm/mach-prima2/include/mach/clkdev.h         |   15 +
 arch/arm/mach-prima2/include/mach/debug-macro.S    |   29 +
 arch/arm/mach-prima2/include/mach/entry-macro.S    |   29 +
 arch/arm/mach-prima2/include/mach/hardware.h       |   15 +
 arch/arm/mach-prima2/include/mach/io.h             |   16 +
 arch/arm/mach-prima2/include/mach/irqs.h           |   17 +
 arch/arm/mach-prima2/include/mach/map.h            |   16 +
 arch/arm/mach-prima2/include/mach/memory.h         |   21 +
 arch/arm/mach-prima2/include/mach/system.h         |   29 +
 arch/arm/mach-prima2/include/mach/timex.h          |   14 +
 arch/arm/mach-prima2/include/mach/uart.h           |   23 +
 arch/arm/mach-prima2/include/mach/uncompress.h     |   40 +
 arch/arm/mach-prima2/include/mach/vmalloc.h        |   16 +
 arch/arm/mach-prima2/irq.c                         |   71 ++
 arch/arm/mach-prima2/l2x0.c                        |   59 ++
 arch/arm/mach-prima2/lluart.c                      |   25 +
 arch/arm/mach-prima2/prima2.c                      |   41 +
 arch/arm/mach-prima2/rstc.c                        |   69 ++
 arch/arm/mach-prima2/timer.c                       |  217 +++++
 arch/arm/mach-pxa/balloon3.c                       |    1 +
 arch/arm/mach-pxa/capc7117.c                       |    1 +
 arch/arm/mach-pxa/clock.c                          |   15 +
 arch/arm/mach-pxa/clock.h                          |    1 +
 arch/arm/mach-pxa/cm-x2xx-pci.c                    |    3 +
 arch/arm/mach-pxa/cm-x2xx.c                        |    5 +-
 arch/arm/mach-pxa/cm-x300.c                        |   59 +-
 arch/arm/mach-pxa/colibri-pxa270.c                 |    2 +
 arch/arm/mach-pxa/colibri-pxa300.c                 |    1 +
 arch/arm/mach-pxa/colibri-pxa320.c                 |    4 +-
 arch/arm/mach-pxa/corgi.c                          |    3 +
 arch/arm/mach-pxa/csb726.c                         |    4 +-
 arch/arm/mach-pxa/em-x270.c                        |    2 +
 arch/arm/mach-pxa/eseries.c                        |    6 +
 arch/arm/mach-pxa/ezx.c                            |    6 +
 arch/arm/mach-pxa/generic.h                        |   13 -
 arch/arm/mach-pxa/gumstix.c                        |    1 +
 arch/arm/mach-pxa/h5000.c                          |    2 +
 arch/arm/mach-pxa/himalaya.c                       |    4 +-
 arch/arm/mach-pxa/hx4700.c                         |   71 +--
 arch/arm/mach-pxa/icontrol.c                       |    1 +
 arch/arm/mach-pxa/idp.c                            |    1 +
 arch/arm/mach-pxa/include/mach/hardware.h          |    3 -
 arch/arm/mach-pxa/include/mach/irqs.h              |   12 +
 arch/arm/mach-pxa/include/mach/magician.h          |    3 +-
 arch/arm/mach-pxa/include/mach/pxa25x.h            |    9 +
 arch/arm/mach-pxa/include/mach/pxa27x.h            |    5 +
 arch/arm/mach-pxa/include/mach/pxa300.h            |    3 +-
 arch/arm/mach-pxa/include/mach/pxa320.h            |    3 +-
 arch/arm/mach-pxa/include/mach/pxa3xx.h            |   14 +
 arch/arm/mach-pxa/include/mach/pxa930.h            |    3 +-
 arch/arm/mach-pxa/include/mach/regs-intc.h         |   30 -
 arch/arm/mach-pxa/irq.c                            |   36 +-
 arch/arm/mach-pxa/littleton.c                      |    1 +
 arch/arm/mach-pxa/lpd270.c                         |    1 +
 arch/arm/mach-pxa/lubbock.c                        |    1 +
 arch/arm/mach-pxa/magician.c                       |   58 +-
 arch/arm/mach-pxa/mainstone.c                      |    1 +
 arch/arm/mach-pxa/mfp-pxa2xx.c                     |    4 +-
 arch/arm/mach-pxa/mioa701.c                        |   71 +--
 arch/arm/mach-pxa/mp900.c                          |    1 +
 arch/arm/mach-pxa/palmld.c                         |    1 +
 arch/arm/mach-pxa/palmt5.c                         |    1 +
 arch/arm/mach-pxa/palmtc.c                         |    4 +-
 arch/arm/mach-pxa/palmte2.c                        |    3 +-
 arch/arm/mach-pxa/palmtreo.c                       |    2 +
 arch/arm/mach-pxa/palmtx.c                         |    1 +
 arch/arm/mach-pxa/palmz72.c                        |    1 +
 arch/arm/mach-pxa/pcm027.c                         |    1 +
 arch/arm/mach-pxa/poodle.c                         |    1 +
 arch/arm/mach-pxa/pxa3xx.c                         |    5 +-
 arch/arm/mach-pxa/pxa95x.c                         |    1 -
 arch/arm/mach-pxa/raumfeld.c                       |    8 +-
 arch/arm/mach-pxa/saar.c                           |    1 +
 arch/arm/mach-pxa/saarb.c                          |    3 +-
 arch/arm/mach-pxa/spitz.c                          |    3 +
 arch/arm/mach-pxa/stargate2.c                      |    2 +
 arch/arm/mach-pxa/tavorevb.c                       |    1 +
 arch/arm/mach-pxa/tavorevb3.c                      |    1 +
 arch/arm/mach-pxa/tosa.c                           |    1 +
 arch/arm/mach-pxa/trizeps4.c                       |    2 +
 arch/arm/mach-pxa/viper.c                          |    1 +
 arch/arm/mach-pxa/vpac270.c                        |    1 +
 arch/arm/mach-pxa/xcep.c                           |    4 +-
 arch/arm/mach-pxa/z2.c                             |   18 +
 arch/arm/mach-pxa/zeus.c                           |    4 +-
 arch/arm/mach-pxa/zylonite.c                       |    3 +-
 arch/arm/mach-s3c2400/Kconfig                      |    7 -
 arch/arm/mach-s3c2400/Makefile                     |   15 -
 arch/arm/mach-s3c2400/gpio.c                       |   42 -
 arch/arm/mach-s3c2400/include/mach/map.h           |   66 --
 arch/arm/mach-s3c2410/include/mach/gpio-fns.h      |    6 -
 arch/arm/mach-s3c2410/include/mach/regs-gpio.h     |  241 -----
 arch/arm/mach-s3c2410/include/mach/regs-mem.h      |   28 -
 arch/arm/mach-s3c2412/Kconfig                      |    2 +-
 arch/arm/mach-s3c24a0/include/mach/debug-macro.S   |   27 -
 arch/arm/mach-s3c24a0/include/mach/io.h            |   18 -
 arch/arm/mach-s3c24a0/include/mach/irqs.h          |  117 ---
 arch/arm/mach-s3c24a0/include/mach/map.h           |   86 --
 arch/arm/mach-s3c24a0/include/mach/memory.h        |   21 -
 arch/arm/mach-s3c24a0/include/mach/regs-clock.h    |   88 --
 arch/arm/mach-s3c24a0/include/mach/regs-irq.h      |   25 -
 arch/arm/mach-s3c24a0/include/mach/system.h        |   25 -
 arch/arm/mach-s3c24a0/include/mach/tick.h          |   15 -
 arch/arm/mach-s3c24a0/include/mach/timex.h         |   18 -
 arch/arm/mach-s3c24a0/include/mach/vmalloc.h       |   17 -
 arch/arm/mach-sa1100/include/mach/hardware.h       |    8 -
 arch/arm/mach-sa1100/pci-nanoengine.c              |    3 +
 arch/arm/mach-shark/include/mach/hardware.h        |    6 -
 arch/arm/mach-shark/pci.c                          |   12 +-
 arch/arm/mach-tegra/board-harmony.c                |   22 -
 arch/arm/mach-tegra/board-paz00-pinmux.c           |   10 +-
 arch/arm/mach-tegra/board-paz00.c                  |   31 +-
 arch/arm/mach-tegra/board-paz00.h                  |   10 +-
 arch/arm/mach-tegra/board-seaboard.c               |   26 +-
 arch/arm/mach-tegra/board-trimslice-pinmux.c       |    7 +-
 arch/arm/mach-tegra/board-trimslice.c              |   56 ++
 arch/arm/mach-tegra/board-trimslice.h              |    3 +
 arch/arm/mach-tegra/devices.c                      |   53 +-
 arch/arm/mach-tegra/include/mach/barriers.h        |   30 -
 arch/arm/mach-tegra/include/mach/system.h          |    1 -
 arch/arm/mach-tegra/io.c                           |    1 -
 arch/arm/mach-tegra/pcie.c                         |    2 +
 arch/arm/mach-tegra/platsmp.c                      |    3 +-
 arch/arm/mach-tegra/tegra2_clocks.c                |    4 +-
 arch/arm/mach-u300/spi.c                           |    4 +-
 arch/arm/mach-u300/timer.c                         |   33 +-
 arch/arm/mach-ux500/Kconfig                        |   15 +-
 arch/arm/mach-ux500/board-mop500-pins.c            |   43 +
 arch/arm/mach-ux500/board-mop500-regulators.c      |    9 +-
 arch/arm/mach-ux500/board-mop500-sdi.c             |   61 +-
 arch/arm/mach-ux500/board-mop500-uib.c             |    2 +-
 arch/arm/mach-ux500/board-mop500.c                 |  154 +++-
 arch/arm/mach-ux500/board-mop500.h                 |    5 +
 arch/arm/mach-ux500/clock.c                        |   48 +
 arch/arm/mach-ux500/cpu-db5500.c                   |    1 +
 arch/arm/mach-ux500/include/mach/uncompress.h      |    3 +-
 arch/arm/mach-ux500/usb.c                          |    1 +
 arch/arm/mach-versatile/include/mach/hardware.h    |    6 -
 arch/arm/mach-versatile/pci.c                      |    3 +
 arch/arm/mach-zynq/Makefile                        |    6 +
 arch/arm/{mach-loki => mach-zynq}/Makefile.boot    |    0
 arch/arm/mach-zynq/common.c                        |  118 +++
 .../include/mach/hardware.h => mach-zynq/common.h} |   20 +-
 .../hardware.h => mach-zynq/include/mach/clkdev.h} |   26 +-
 arch/arm/mach-zynq/include/mach/debug-macro.S      |   36 +
 .../include/mach/entry-macro.S}                    |   26 +-
 .../include/mach/hardware.h                        |   18 +-
 .../hardware.h => mach-zynq/include/mach/io.h}     |   31 +-
 .../hardware.h => mach-zynq/include/mach/irqs.h}   |   19 +-
 .../hardware.h => mach-zynq/include/mach/memory.h} |   20 +-
 .../hardware.h => mach-zynq/include/mach/system.h} |   26 +-
 .../hardware.h => mach-zynq/include/mach/timex.h}  |   21 +-
 .../hardware.h => mach-zynq/include/mach/uart.h}   |   23 +-
 arch/arm/mach-zynq/include/mach/uncompress.h       |   51 ++
 .../include/mach/vmalloc.h}                        |   18 +-
 arch/arm/mach-zynq/include/mach/zynq_soc.h         |   48 +
 arch/arm/mach-zynq/timer.c                         |  298 +++++++
 arch/arm/mm/Kconfig                                |    3 +-
 arch/arm/mm/iomap.c                                |   12 +
 arch/arm/mm/proc-xsc3.S                            |    1 -
 arch/arm/plat-iop/pci.c                            |    3 +
 arch/arm/plat-mxc/avic.c                           |   12 +-
 arch/arm/plat-mxc/devices.c                        |   16 +-
 arch/arm/plat-mxc/devices/platform-imx-dma.c       |  204 +----
 arch/arm/plat-mxc/devices/platform-imx-i2c.c       |    3 +-
 arch/arm/plat-mxc/devices/platform-imx-keypad.c    |    5 +
 arch/arm/plat-mxc/devices/platform-imx-ssi.c       |   12 +-
 arch/arm/plat-mxc/devices/platform-imx-uart.c      |    2 +
 arch/arm/plat-mxc/include/mach/debug-macro.S       |   10 +-
 arch/arm/plat-mxc/include/mach/devices-common.h    |    6 +
 arch/arm/plat-mxc/include/mach/hardware.h          |   28 +-
 arch/arm/plat-mxc/include/mach/iomux-mx25.h        |    2 +-
 arch/arm/plat-mxc/include/mach/iomux-mx53.h        |  128 ++--
 arch/arm/plat-mxc/include/mach/iomux-v1.h          |    4 -
 arch/arm/plat-mxc/include/mach/iomux-v3.h          |    2 +-
 arch/arm/plat-mxc/include/mach/iomux.h             |   26 -
 arch/arm/plat-mxc/include/mach/mx53.h              |   54 +-
 arch/arm/plat-mxc/include/mach/mxc.h               |    8 +-
 arch/arm/plat-mxc/include/mach/sdma.h              |    6 +-
 arch/arm/plat-mxc/include/mach/timex.h             |   13 +-
 arch/arm/plat-mxc/include/mach/uncompress.h        |    1 +
 arch/arm/plat-mxc/iomux-v1.c                       |   34 +-
 arch/arm/plat-mxc/irq-common.c                     |   13 +-
 arch/arm/plat-mxc/pwm.c                            |    8 +-
 arch/arm/plat-mxc/tzic.c                           |   99 +--
 arch/arm/plat-omap/Kconfig                         |    3 -
 arch/arm/plat-omap/clock.c                         |   39 +
 arch/arm/plat-omap/counter_32k.c                   |  123 +--
 arch/arm/plat-omap/dmtimer.c                       |  213 +----
 arch/arm/plat-omap/include/plat/clkdev_omap.h      |    1 +
 arch/arm/plat-omap/include/plat/clock.h            |    4 +-
 arch/arm/plat-omap/include/plat/common.h           |    6 +-
 arch/arm/plat-omap/include/plat/cpu.h              |   35 +-
 arch/arm/plat-omap/include/plat/dmtimer.h          |  251 +++++-
 arch/arm/plat-omap/include/plat/i2c.h              |    6 +-
 arch/arm/plat-omap/include/plat/irqs.h             |   18 +-
 arch/arm/plat-omap/include/plat/mcbsp.h            |   74 +--
 arch/arm/plat-omap/include/plat/nand.h             |    6 +-
 arch/arm/plat-omap/include/plat/omap-pm.h          |    8 -
 arch/arm/plat-omap/include/plat/omap4-keypad.h     |    3 +-
 arch/arm/plat-omap/include/plat/omap_hwmod.h       |   35 +-
 arch/arm/plat-omap/include/plat/uncompress.h       |    1 +
 arch/arm/plat-omap/iovmm.c                         |    6 +-
 arch/arm/plat-omap/mcbsp.c                         |  604 +------------
 arch/arm/plat-omap/omap_device.c                   |   94 ++-
 arch/arm/plat-s3c24xx/Kconfig                      |    2 +-
 arch/arm/plat-s3c24xx/cpu.c                        |   15 -
 arch/arm/plat-s3c24xx/include/plat/regs-iis.h      |    9 -
 arch/arm/plat-s3c24xx/include/plat/regs-spi.h      |    1 -
 arch/arm/plat-s3c24xx/include/plat/s3c2400.h       |   31 -
 .../plat-samsung/include/plat/gpio-cfg-helpers.h   |    2 +-
 arch/arm/plat-samsung/include/plat/regs-serial.h   |    8 -
 arch/microblaze/include/asm/pci-bridge.h           |   67 +--
 arch/powerpc/include/asm/pci-bridge.h              |   50 +-
 arch/powerpc/include/asm/pci.h                     |    2 +-
 arch/powerpc/kernel/pci-common.c                   |   22 +-
 arch/powerpc/kernel/pci_32.c                       |    2 +-
 arch/powerpc/kernel/pci_64.c                       |    4 +-
 arch/powerpc/kernel/rtas_pci.c                     |    2 +-
 arch/powerpc/platforms/40x/ep405.c                 |    2 +-
 arch/powerpc/platforms/40x/ppc40x_simple.c         |    2 +-
 arch/powerpc/platforms/40x/walnut.c                |    2 +-
 arch/powerpc/platforms/44x/canyonlands.c           |    2 +-
 arch/powerpc/platforms/44x/ebony.c                 |    2 +-
 arch/powerpc/platforms/44x/ppc44x_simple.c         |    2 +-
 arch/powerpc/platforms/44x/sam440ep.c              |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pci.c          |    2 +-
 arch/powerpc/platforms/82xx/pq2.c                  |    2 +-
 arch/powerpc/platforms/chrp/pci.c                  |    2 +-
 arch/powerpc/platforms/powermac/pci.c              |    6 +-
 arch/powerpc/sysdev/fsl_pci.c                      |    4 +-
 arch/powerpc/sysdev/grackle.c                      |    2 +-
 arch/powerpc/sysdev/ppc4xx_pci.c                   |    2 +-
 drivers/dma/imx-dma.c                              |    3 +-
 drivers/dma/imx-sdma.c                             |    6 +-
 drivers/input/misc/Kconfig                         |   13 +-
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/twl4030-vibra.c                 |   12 +-
 drivers/input/misc/twl6040-vibra.c                 |  423 +++++++++
 drivers/mfd/Kconfig                                |    8 +-
 drivers/mfd/Makefile                               |    3 +-
 drivers/mfd/twl-core.c                             |   13 +-
 drivers/mfd/twl4030-audio.c                        |  277 ++++++
 drivers/mfd/twl4030-codec.c                        |  277 ------
 drivers/mfd/twl6040-core.c                         |  620 +++++++++++++
 drivers/mfd/twl6040-irq.c                          |  191 ++++
 drivers/mmc/host/mxcmmc.c                          |    8 +-
 drivers/pcmcia/pxa2xx_sharpsl.c                    |    3 -
 drivers/pcmcia/pxa2xx_trizeps4.c                   |    4 -
 drivers/tty/serial/Kconfig                         |   15 -
 drivers/tty/serial/Makefile                        |    2 -
 drivers/tty/serial/s3c2400.c                       |  105 ---
 drivers/tty/serial/s3c24a0.c                       |  117 ---
 include/asm-generic/pci-bridge.h                   |   62 ++
 include/linux/i2c-omap.h                           |   27 +
 include/linux/i2c/twl.h                            |   25 +-
 .../linux/mfd/{twl4030-codec.h => twl4030-audio.h} |   16 +-
 include/linux/mfd/twl6040.h                        |  228 +++++
 sound/soc/codecs/Kconfig                           |    3 +-
 sound/soc/codecs/twl4030.c                         |   22 +-
 sound/soc/codecs/twl6040.c                         |  733 +++++++---------
 sound/soc/codecs/twl6040.h                         |  119 +---
 sound/soc/imx/imx-pcm-dma-mx2.c                    |    4 +-
 sound/soc/omap/sdp3430.c                           |    2 +-
 sound/soc/omap/sdp4430.c                           |   52 +-
 sound/soc/omap/zoom2.c                             |    2 +-
 523 files changed, 13192 insertions(+), 11436 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/sirf.txt
 create mode 100644 Documentation/devicetree/bindings/arm/xilinx.txt
 create mode 100644 arch/arm/boot/dts/prima2-cb.dts
 create mode 100644 arch/arm/boot/dts/zynq-ep107.dts
 delete mode 100644 arch/arm/configs/loki_defconfig
 delete mode 100644 arch/arm/mach-cns3xxx/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-integrator/include/mach/bits.h
 delete mode 100644 arch/arm/mach-loki/Kconfig
 delete mode 100644 arch/arm/mach-loki/Makefile
 delete mode 100644 arch/arm/mach-loki/addr-map.c
 delete mode 100644 arch/arm/mach-loki/common.c
 delete mode 100644 arch/arm/mach-loki/common.h
 delete mode 100644 arch/arm/mach-loki/include/mach/bridge-regs.h
 delete mode 100644 arch/arm/mach-loki/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-loki/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-loki/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-loki/include/mach/io.h
 delete mode 100644 arch/arm/mach-loki/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-loki/include/mach/loki.h
 delete mode 100644 arch/arm/mach-loki/include/mach/memory.h
 delete mode 100644 arch/arm/mach-loki/include/mach/system.h
 delete mode 100644 arch/arm/mach-loki/include/mach/timex.h
 delete mode 100644 arch/arm/mach-loki/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-loki/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-loki/irq.c
 delete mode 100644 arch/arm/mach-loki/lb88rc8480-setup.c
 create mode 100644 arch/arm/mach-mmp/gplugd.c
 create mode 100644 arch/arm/mach-mmp/include/mach/mfp-gplugd.h
 create mode 100644 arch/arm/mach-mx5/board-mx53_ard.c
 create mode 100644 arch/arm/mach-mx5/pm-imx5.c
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_2xxx_3xxx_interconnect_data.c
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_2xxx_3xxx_ipblock_data.c
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_2xxx_interconnect_data.c
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c
 delete mode 100644 arch/arm/mach-omap2/timer-gp.c
 delete mode 100644 arch/arm/mach-omap2/timer-gp.h
 create mode 100644 arch/arm/mach-omap2/timer.c
 create mode 100644 arch/arm/mach-omap2/twl-common.c
 create mode 100644 arch/arm/mach-omap2/twl-common.h
 create mode 100644 arch/arm/mach-prima2/Makefile
 create mode 100644 arch/arm/mach-prima2/Makefile.boot
 create mode 100644 arch/arm/mach-prima2/clock.c
 create mode 100644 arch/arm/mach-prima2/common.h
 create mode 100644 arch/arm/mach-prima2/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-prima2/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-prima2/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-prima2/include/mach/hardware.h
 create mode 100644 arch/arm/mach-prima2/include/mach/io.h
 create mode 100644 arch/arm/mach-prima2/include/mach/irqs.h
 create mode 100644 arch/arm/mach-prima2/include/mach/map.h
 create mode 100644 arch/arm/mach-prima2/include/mach/memory.h
 create mode 100644 arch/arm/mach-prima2/include/mach/system.h
 create mode 100644 arch/arm/mach-prima2/include/mach/timex.h
 create mode 100644 arch/arm/mach-prima2/include/mach/uart.h
 create mode 100644 arch/arm/mach-prima2/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-prima2/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-prima2/irq.c
 create mode 100644 arch/arm/mach-prima2/l2x0.c
 create mode 100644 arch/arm/mach-prima2/lluart.c
 create mode 100644 arch/arm/mach-prima2/prima2.c
 create mode 100644 arch/arm/mach-prima2/rstc.c
 create mode 100644 arch/arm/mach-prima2/timer.c
 create mode 100644 arch/arm/mach-pxa/include/mach/pxa3xx.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/regs-intc.h
 delete mode 100644 arch/arm/mach-s3c2400/Kconfig
 delete mode 100644 arch/arm/mach-s3c2400/Makefile
 delete mode 100644 arch/arm/mach-s3c2400/gpio.c
 delete mode 100644 arch/arm/mach-s3c2400/include/mach/map.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/io.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/map.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/memory.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/regs-clock.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/regs-irq.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/system.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/tick.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/timex.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-tegra/include/mach/barriers.h
 create mode 100644 arch/arm/mach-zynq/Makefile
 rename arch/arm/{mach-loki => mach-zynq}/Makefile.boot (100%)
 create mode 100644 arch/arm/mach-zynq/board_dt.c
 create mode 100644 arch/arm/mach-zynq/common.c
 copy arch/arm/{mach-tegra/include/mach/hardware.h => mach-zynq/common.h} (58%)
 copy arch/arm/{mach-tegra/include/mach/hardware.h => mach-zynq/include/mach/clkdev.h} (57%)
 create mode 100644 arch/arm/mach-zynq/include/mach/debug-macro.S
 copy arch/arm/{mach-tegra/include/mach/hardware.h => mach-zynq/include/mach/entry-macro.S} (51%)
 copy arch/arm/{mach-tegra => mach-zynq}/include/mach/hardware.h (58%)
 copy arch/arm/{mach-tegra/include/mach/hardware.h => mach-zynq/include/mach/io.h} (52%)
 copy arch/arm/{mach-tegra/include/mach/hardware.h => mach-zynq/include/mach/irqs.h} (58%)
 copy arch/arm/{mach-tegra/include/mach/hardware.h => mach-zynq/include/mach/memory.h} (58%)
 copy arch/arm/{mach-tegra/include/mach/hardware.h => mach-zynq/include/mach/system.h} (58%)
 copy arch/arm/{mach-tegra/include/mach/hardware.h => mach-zynq/include/mach/timex.h} (58%)
 copy arch/arm/{mach-tegra/include/mach/hardware.h => mach-zynq/include/mach/uart.h} (53%)
 create mode 100644 arch/arm/mach-zynq/include/mach/uncompress.h
 rename arch/arm/{mach-tegra/include/mach/hardware.h => mach-zynq/include/mach/vmalloc.h} (58%)
 create mode 100644 arch/arm/mach-zynq/include/mach/zynq_soc.h
 create mode 100644 arch/arm/mach-zynq/timer.c
 delete mode 100644 arch/arm/plat-mxc/include/mach/iomux.h
 delete mode 100644 arch/arm/plat-s3c24xx/include/plat/s3c2400.h
 create mode 100644 drivers/input/misc/twl6040-vibra.c
 create mode 100644 drivers/mfd/twl4030-audio.c
 delete mode 100644 drivers/mfd/twl4030-codec.c
 create mode 100644 drivers/mfd/twl6040-core.c
 create mode 100644 drivers/mfd/twl6040-irq.c
 delete mode 100644 drivers/tty/serial/s3c2400.c
 delete mode 100644 drivers/tty/serial/s3c24a0.c
 create mode 100644 include/asm-generic/pci-bridge.h
 rename include/linux/mfd/{twl4030-codec.h => twl4030-audio.h} (96%)
 create mode 100644 include/linux/mfd/twl6040.h
