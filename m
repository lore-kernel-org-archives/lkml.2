Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab1AGCu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 21:50:59 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:12046 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab1AGCu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 21:50:57 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX187A3BqtFO9ivgGFxxYO/MA
Date: Thu, 6 Jan 2011 18:50:45 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] omap changes for v2.6.38
Message-ID: <20110107025044.GF7771@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull omap changes from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-for-linus

The interesting changes for this merge window are:

- Start using common code for omap hardware modules (hwmod) for resetting,
  enabling, and idling the hardare modules. This allows us to do fine
  grained power management using runtime PM in a way where the drivers
  stay generic.

- Power management updates to get closer to have DVFS working

- Combine all omap1 defconfigs into one omap1_defconfig

- Various omap4 updates, pin multiplexing updates, clean-up and
  board updates

There's a trivial merge conflict in arch/arm/plat-omap/Kconfig
that git mergetool handles automatically.

Regards,

Tony


The following changes since commit 3c0cb7c31c206aaedb967e44b98442bbeb17a6c4:

  Merge branch 'devel' of master.kernel.org:/home/rmk/linux-2.6-arm (2011-01-06 16:50:35 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-for-linus

Aaro Koskinen (19):
      arm: omap1: add missing includes
      arm: omap1: make some functions static
      arm: omap1: mbox: make variables static
      arm: omap1: mbox: delete unused variable
      arm: omap1: board-ams-delta: fix cast
      arm: omap2: timer-gp: delete unused variable
      arm: mach-omap2: remove NULL board_mux from board files
      arm: mach-omap2: n8x0: clean up dummy onenand init
      arm: mach-omap2: rx51: clean up dummy onenand init
      arm: omap: rename board-rx51-sdram.c to sdram-nokia.c
      arm: omap: add sdram-nokia.h
      arm: omap: sdram-nokia: prepare for new memory timings
      arm: omap: sdram-nokia: use array to list timings
      arm: omap: sdram-nokia: improve error handling
      arm: omap: sdram-nokia: delete redundant timing data
      arm: omap: sdram-nokia: add 97.6/195.2 MHz timing data
      arm: omap: add minimal support for RM-680
      arm: mach-omap2: hsmmc_reset: fix clk_get() error handling
      arm: mach-omap2: Kconfig: fix incorrect option

Adrian Hunter (2):
      OMAP2/3: GPMC: put sync_clk value in picoseconds instead of nanoseconds
      OMAP2/3: OneNAND: add 104MHz support

Anand Gadiyar (2):
      omap: remove dead wdt code in plat-omap/devices.c
      omap2430: hwmod: remove stray declaration

Andrei Emeltchenko (2):
      OMAP: Serial: Define OMAP uart MDR1 reg and remove magic numbers
      omap: Serial: Define register access modes in LCR

Arno Steffen (1):
      OMAP3: fix typo in OMAP3_IVA_MASK

Ben Gamari (1):
      omap2: Make OMAP2PLUS select OMAP_DM_TIMER

Benoit Cousson (30):
      OMAP4: hwmod: add I2C hwmods for OMAP4430
      OMAP: mux: Replace printk with pr_xxx macros
      OMAP: mux: Add support for control module split in several partitions
      OMAP4: mux: Add CBL package data for OMAP4430 ES1
      OMAP4: sdp4430: Select CBL package for ES1 and initialize mux
      OMAP4: mux: Add CBS package data for OMAP4430 ES2
      OMAP4: sdp4430: Select CBS package for ES2
      OMAP4: hwmod data: Add GPIO
      omap: serial: Change device name: omap-hsuart -> omap_uart
      I2C: i2c-omap: Change device name: i2c_omap -> omap_i2c
      OMAP4: hwmod data: add system DMA
      OMAP4: PRCM: Add SCRM header file
      OMAP4: clock data: Add control for pad_clks_ck and slimbus_clk
      OMAP3: clock data: Add "wkup_clkdm" in sr1_fck and sr2_fck
      OMAP4: hwmod data: Fix hwmod entries order
      OMAP4: hwmod data: Add SYSS_HAS_RESET_STATUS flag
      OMAP4: hwmod data: Fix missing address in DMM and EMIF_FW
      OMAP4: hwmod data: Add IVA and DSP
      OMAP4: hwmod & clock data: Fix GPIO opt_clks and ocp_if iclk
      OMAP2430: hwmod data: Use common dev_attr for i2c1 and i2c2
      OMAP2+: hwmod: Make omap_hwmod_register private and remove omap_hwmod_unregister
      OMAP2+: hwmod: Mark functions used only during initialization with __init
      OMAP2+: hwmod: Remove omap_hwmod_mutex
      OMAP2+: hwmod: Add wakeup support for new OMAP4 IPs
      OMAP4: hwmod data: Add SIDLE_SMART_WKUP modes to several IPs
      OMAP4: hwmod: Add inital data for smartreflex modules.
      OMAP4: hwmod data: Fix missing SIDLE_SMART_WKUP in smartreflexsysc
      OMAP4: hwmod data: Move the smartreflex structures
      OMAP4: hwmod data: Move the DMA structures
      OMAP4: hwmod data: Fix alignment and end of line in structurefields

Bryan Wu (1):
      omap: kill all section mismatch warning for omap2plus_defconfig

Charulatha V (1):
      OMAP3: clock: Update clock domain name for mcspi fck

Dan Murphy (1):
      OMAP: mux: Add __func__ macro to pr_xxx macros

Daniel Morsing (1):
      OMAP2: Devkit8000: Use _cansleep GPIO functions for displayreset lines

Eduardo Valentin (1):
      OMAP3630: PM: Erratum i583: disable coreoff if < ES1.2

Enric Balletbo i Serra (3):
      omap3: IGEP v2: Remove onenand_setup no-op function
      omap3: IGEP v2: Remove igep2_config array
      omap3: IGEP v2: Improve igep2_flash_init() function

Evgeny Kuznetsov (1):
      omap: Ptr "isr_reg" tracked as NULL was dereferenced

Felipe Balbi (3):
      arm: omap: combine zoom2 and zoom3 board-files
      arm: omap: zoom: substitute gpio number with symbolic name
      arm: omap: tusb6010: add name for MUSB IRQ

Felipe Contreras (1):
      OMAP: iommu: make iva2 iommu selectable

Fernando Guzman Lugo (1):
      OMAP: mailbox: change full flag per mailbox queue instead of global

G, Manjunath Kondaiah (8):
      OMAP: DMA: Replace read/write macros with functions
      OMAP: DMA: Introduce errata handling feature
      OMAP2420: hwmod data: add system DMA
      OMAP2430: hwmod data: add system DMA
      OMAP3: hwmod data: add system DMA
      OMAP1: DMA: Implement in platform device model
      OMAP2+: DMA: hwmod: Device registration
      OMAP: DMA: Convert DMA library into platform driver

Grazvydas Ignotas (1):
      omap: pandora: fix wifi support

Guzman Lugo, Fernando (4):
      OMAP: iovmm: no gap checking for fixed address
      OMAP: iovmm: add superpages support to fixed da address
      OMAP: iovmm: replace __iounmap with iounmap
      OMAP: iommu: create new api to set valid da range

Hari Kanigeri (1):
      OMAP4: clocks: add dummy clock for mailbox

Hemanth V (2):
      omap4: Add platform changes for Ambient Light sensor
      omap4: Add platform changes for PWM LED

Janusz Krzysztofik (3):
      OMAP1: drop AMS_DELTA_FIQ config option
      OMAP1: clock_data: use runtime cpu / machine checks
      Keyboard: omap-keypad: use matrix_keypad.h

Jarkko Nikula (7):
      omap: McBSP: Fix potential memory leak in omap_mcbsp_remove
      omap: rx51: Remove extra tlv320aic3x.h inclusion
      omap: rx51: Add supplies and data for codec b part ofTLV320AIC34
      omap: rx51: Switch rx51_tpa6130a2_data __initdata to__initdata_or_module
      omap: rx51: Cleanup vdds_sdi supply construction
      omap: rx51: Add vdda_dac supply for tvout
      omap: rx51: Remove tvout code that plays with gpio 40

Jean Pihet (9):
      OMAP3: add comments for erratas i540 and i478 workarounds
      OMAP2+: disable idle early in the suspend sequence
      OMAP3: remove unused code from the ASM sleep code
      OMAP2+: use global values for the SRAM PA addresses
      OMAP3: remove hardcoded values from the ASM sleep code
      OMAP3: re-organize the ASM sleep code
      OMAP3: rework of the ASM sleep code execution paths
      OMAP3: add comments for low power code errata
      OMAP3: ASM sleep code format rework

John Rigby (1):
      OMAP4: enable smc instruction in new assembler versions

Jon Hunter (2):
      OMAP: clock: fix configuration of J-Type DPLLs to work for OMAP3 and OMAP4
      OMAP4: clock data: Add missing fixed divisors

Jonathan Bergsagel (1):
      OMAP4: clock data: Add missing fields in iva_hsd_byp_clk_mux_ck

Kanigeri, Hari (3):
      OMAP: mailbox: fix checkpatch warnings
      OMAP: mailbox: send message in process context
      OMAP: mailbox: add notification support for multiple readers

Kevin Hilman (6):
      OMAP3: remove OPP interfaces from OMAP PM layer
      OMAP2+: omap_hwmod: fix wakeup enable/disable for consistency
      OMAP2+: powerdomain: add API to get context loss count
      OMAP: PM: implement context loss count APIs
      OMAP: PM noop: implement context loss count for non-omap_devices
      OMAP2: PM: fix compile error when !CONFIG_SUSPEND

Laurent Pinchart (2):
      omap3: igepv2: Don't call gpio_set_value right aftergpio_direction_output
      omap3: igepv2: LED gpio-led:green:d1 is active low

Mans Rullgard (1):
      omap4: l2x0: enable instruction and data prefetching

Marc Zyngier (1):
      Fix IGEPv2 second MMC channel power supply

Marek Belisko (2):
      omap1: htc_herald: Fix compilation warning
      omap1: pm_bus: Fix compilation warning

Nishanth Menon (5):
      omap: opp: add OMAP3 OPP table data and common init
      omap4: opp: add OPP table data
      OMAP3: pm: introduce errata handling
      OMAP3630: PM: Erratum i608: disable RTA
      OMAP3: PM: make omap3_cpuidle_update_states independent of enable_off_mode

Ohad Ben-Cohen (1):
      omap: boards w/ wl12xx should select REGULATOR_FIXED_VOLTAGE

Omar Ramirez Luna (2):
      OMAP: mailbox: remove unreachable return
      OMAP: mailbox: fix detection for previously supported chips

Paul Walmsley (35):
      OMAP2xxx: hwmod: add I2C hwmods for OMAP2420, 2430
      OMAP: I2C: split device registration and convert OMAP2+ to omap_device
      OMAP1: I2C: fix device initialization
      OMAP2+: io: split omap2_init_common_hw()
      OMAP2+: hwmod: allow custom pre-shutdown functions
      OMAP2+: hwmod: add postsetup state
      OMAP2+: hwmod: add support for per-class custom device reset functions
      OMAP2+: hwmod: upgrade per-hwmod mutex to a spinlock
      OMAP2+: hwmod: fix a warning, add some docs, remove unused fields
      OMAP2+: wd_timer: separate watchdog disable code from the rest of mach-omap2/devices.c
      OMAP2+: wd_timer: disable on boot via hwmod postsetup mechanism
      OMAP2+: powerdomains: move powerdomain static data to .c files
      OMAP2+: clockdomains: move clockdomain static data to .c files
      OMAP3: control/PRCM: add omap3_ctrl_write_boot_mode()
      OMAP3: control/PRCM: move CONTROL_PADCONF_SYS_NIRQ save/restore to SCM code
      OMAP4: PRCM: reorganize existing OMAP4 PRCM header files
      OMAP4: PRCM: rename _MOD macros to _INST
      OMAP2/3: PRCM: split OMAP2/3-specific PRCM code into OMAP2/3-specific files
      OMAP3: PRM/CM: separate CM context save/restore; remove PRM context save/restore
      OMAP4: PRCM: add OMAP4-specific accessor/mutator functions
      OMAP4: PRCM: move global reset function for OMAP4 to an OMAP4-specific file
      OMAP2/3: PRM/CM: prefix OMAP2 PRM/CM functions with "omap2_"
      OMAP4: powerdomains: add PRCM partition data; use OMAP4 PRM functions
      OMAP2+: clockdomains: split the clkdm hwsup enable/disable function
      OMAP4: CM instances: add clockdomain register offsets
      OMAP4: clockdomains: add OMAP4 PRCM data and OMAP4 support
      OMAP2/3: clockdomain: remove unneeded .clkstctrl_reg, remove some direct CM register accesses
      OMAP2+: clockdomain: move header file from plat-omap to mach-omap2
      OMAP2+: powerdomain: move header file from plat-omap to mach-omap2
      OMAP3: control/PM: move padconf save code to mach-omap2/control.c
      OMAP2xxx clock: fix dss2_fck recalc to use clksel
      OMAP3: clock: clarify usage of struct clksel_rate.flags and struct omap_clk.cpu
      OMAP3: clock: fix incorrect rate display when switching MPU rate at boot
      OMAP2/3: SRAM: add comment about crashes during a TLB miss
      MAINTAINERS: OMAP: hwmod: update hwmod code, data maintainership

Peter 'p2' De Schrijver (2):
      OMAP3: PM: Erratum i581 support: dll kick strategy
      OMAP3630: PM: Disable L2 cache while invalidating L2 cache

Raghuveer Murthy (2):
      OMAP4: Pandaboard: Add omap_reserve functionality
      OMAP4: Pandaboard: Fix MMC card detect gpio line

Rajendra Nayak (14):
      OMAP3: hwmod: add I2C hwmods for OMAP3430
      OMAP: I2C: Convert i2c driver to use PM runtime api's
      OMAP2+: hwmod: Update the sysc_cache in case module context is lost
      OMAP: powerdomain: Move static allocations from powerdomains.h to a .c file
      OMAP: powerdomain: Infrastructure to put arch specific code
      OMAP: powerdomain: Arch specific funcs for state control
      OMAP: powerdomain: Arch specific funcs for logic control
      OMAP: powerdomain: Arch specific funcs for mem control
      OMAP4: clock data: Add SCRM auxiliary clock nodes
      OMAP4: clock data: Export control to enable/disable CORE/PER M3 clocks
      OMAP2+: hwmod: Disable clocks when hwmod enable fails
      OMAP4: PM: Use the low-power state change feature on OMAP4
      OMAP4: PM: Do not assume clkdm supports hw transitions
      OMAP4: powerdomain: l4per pwrdm does not support OFF

Richard Woodruff (1):
      OMAP3: PM: Update clean_l2 to use v7_flush_dcache_all

Santosh Shilimkar (7):
      ARM: l2x0: Add aux control register bitfields
      omap4: l2x0: Construct the AUXCTRL value using defines
      omap4: l2x0: Set share override bit
      omap4: l2x0: Enable early BRESP bit
      OMAP4: powerdomain: Add pwrdm_clear_all_prev_pwrst
      OMAP4: powerdomain: Remove L3INIT_PD OFF state
      OMAP4: clock data: Keep L3INSTR clock domain modulemode under HW control

Shubhrajyoti D (1):
      omap: McBSP: Make the free variable update more readable

Srikar (1):
      Added video data to support tvout on rx51

Srinath (2):
      omap: AM3517/05: Add craneboard support
      arm: omap: craneboard: Add USB EHCI support

Thara Gopinath (15):
      OMAP: pm.c correct the initcall for an early init.
      OMAP4: clock data: Add missing DPLL x2 clock nodes
      OMAP3: PM: Adding voltage driver support.
      OMAP: Introduce voltage domain information in the hwmod structures
      OMAP3: PM: Adding smartreflex driver support.
      OMAP3: PM: Adding smartreflex device file.
      OMAP3: PM: Adding smartreflex hwmod data
      OMAP3: PM: Adding smartreflex class3 driver
      OMAP3: PM: Register TWL4030 pmic info with the voltage driver.
      OMAP3: PM: Adding debug support to Voltage and Smartreflex drivers
      OMAP3: PM: Program correct init voltages for VDD1 and VDD2
      OMAP4: Register voltage PMIC parameters with the voltage layer
      OMAP4: Adding voltage driver support
      OMAP4: PM: Program correct init voltages for scalable VDDs
      OMAP4: Smartreflex framework extensions

Thomas Weber (1):
      OMAP3: Devkit8000: Add DEBUG_LL support

Tony Lindgren (33):
      Merge branches 'devel-cleanup', 'devel-serial' and 'devel-board' into omap-for-linus
      Merge branch 'pm-hwmod-i2c' of ssh://master.kernel.org/.../khilman/linux-omap-pm into omap-for-linus
      Merge branch 'ctrl-wip/mux-omap4-v4' of git://gitorious.org/omap-pm/linux into omap-for-linus
      omap: Fix undefined reference to omap2_i2c_mux_pins
      omap: Don't select mux by default for each board
      omap: Fix gpio_request calls to happen as arch_initcall
      OMAP: GPIO: Make omap_gpio_show_rev bank specific
      omap1: Fix gpio mpuio bank to work for multi-omap for 7xx/15xx/16xx
      Merge branch 'devel-cleanup' into omap-for-linus
      omap1: Use asm_irq_flags for entry-macro.S
      omap2+: Initialize omap_irq_base for entry-macro.S from platform code
      Merge branch 'devel-omap-irq' into omap-for-linus
      omap: Split omap_read/write functions for omap1 and omap2+
      omap1: Add initcall checks for omap1 and booted board
      omap1: Add omap1_defconfig
      omap1: Delete old defconfigs
      Merge branch 'devel-gpio' into omap-for-linus
      omap: Fix setting omap_irq_base for 2430
      Merge branch 'devel-board' into omap-for-linus
      Merge branch 'for_2.6.38' of git://gitorious.org/iommu_mailbox/iommu_mailbox into devel-iommu-mailbox
      omap1: Fix innovator FPGA init for multi-omap
      Merge branches 'devel-iommu-mailbox' and 'devel-l2x0' into omap-for-linus
      Merge branch 'devel-dma' into omap-for-linus
      Merge branch 'pm-next' of ssh://master.kernel.org/.../khilman/linux-omap-pm into omap-for-linus
      Merge branch 'pm-opp' of ssh://master.kernel.org/.../khilman/linux-omap-pm into omap-for-linus
      Merge branches 'devel-gpmc' and 'devel-misc' into omap-for-linus
      Merge branch 'integration-2.6.38-for-tony' of git://git.pwsan.com/linux-2.6 into omap-for-linus
      Merge branch 'pm-sr' of ssh://master.kernel.org/.../khilman/linux-omap-pm into omap-for-linus
      omap2+: Add omap_mux_get_by_name
      omap2+: Add support for hwmod specific muxing of devices
      omap2+: Allow hwmod state changes to mux pads based on the state changes
      omap2+: Add struct omap_board_data and use it for platform level serial init
      omap2+: Initialize serial port for dynamic remuxing for n8x0

Varadarajan, Charulatha (9):
      OMAP: GPIO: prepare for platform driver
      OMAP15xx: GPIO: Introduce support for GPIO init
      OMAP16xx: GPIO: Introduce support for GPIO init
      OMAP7xx: GPIO: Introduce support for GPIO init
      OMAP2420: hwmod data: Add GPIO
      OMAP2430: hwmod data: Add GPIO
      OMAP3: hwmod data: Add GPIO
      OMAP2+: GPIO: device registration
      OMAP: GPIO: Implement GPIO as a platform device

Vishwanath BS (1):
      OMAP3: SDRC: Add comments on Errata i520 for Global SW reset

sricharan (1):
      OMAP4: pandaboard: Select CBL & CBS package and initialize mux

 Documentation/arm/OMAP/omap_pm                     |   25 +
 MAINTAINERS                                        |   14 +
 arch/arm/configs/ams_delta_defconfig               |  121 --
 arch/arm/configs/htcherald_defconfig               |   73 -
 arch/arm/configs/n770_defconfig                    |  138 --
 arch/arm/configs/omap1_defconfig                   |  286 ++++
 arch/arm/configs/omap_generic_1510_defconfig       |   84 -
 arch/arm/configs/omap_generic_1610_defconfig       |   87 -
 arch/arm/configs/omap_generic_1710_defconfig       |   75 -
 arch/arm/configs/omap_h2_1610_defconfig            |  109 --
 arch/arm/configs/omap_innovator_1510_defconfig     |  102 --
 arch/arm/configs/omap_innovator_1610_defconfig     |   58 -
 arch/arm/configs/omap_osk_5912_defconfig           |   87 -
 arch/arm/configs/omap_perseus2_730_defconfig       |   65 -
 arch/arm/configs/palmte_defconfig                  |   48 -
 arch/arm/configs/palmtt_defconfig                  |   56 -
 arch/arm/configs/palmz71_defconfig                 |   53 -
 arch/arm/configs/sx1_defconfig                     |  110 --
 arch/arm/include/asm/hardware/cache-l2x0.h         |   12 +-
 arch/arm/include/asm/io.h                          |   13 +-
 arch/arm/mach-davinci/include/mach/io.h            |    4 +-
 arch/arm/mach-iop13xx/include/mach/io.h            |    4 +-
 arch/arm/mach-iop32x/include/mach/io.h             |    4 +-
 arch/arm/mach-iop33x/include/mach/io.h             |    4 +-
 arch/arm/mach-ixp23xx/include/mach/io.h            |    4 +-
 arch/arm/mach-ixp4xx/include/mach/io.h             |    4 +-
 arch/arm/mach-kirkwood/include/mach/io.h           |    4 +-
 arch/arm/mach-omap1/Kconfig                        |   11 +-
 arch/arm/mach-omap1/Makefile                       |   12 +-
 arch/arm/mach-omap1/board-ams-delta.c              |  137 +-
 arch/arm/mach-omap1/board-fsample.c                |   89 +-
 arch/arm/mach-omap1/board-h2.c                     |   79 +-
 arch/arm/mach-omap1/board-h3.c                     |   97 +-
 arch/arm/mach-omap1/board-htcherald.c              |  102 +-
 arch/arm/mach-omap1/board-innovator.c              |   32 +-
 arch/arm/mach-omap1/board-nokia770.c               |   30 +-
 arch/arm/mach-omap1/board-osk.c                    |   27 +-
 arch/arm/mach-omap1/board-palmte.c                 |   29 +-
 arch/arm/mach-omap1/board-palmtt.c                 |   28 +-
 arch/arm/mach-omap1/board-palmz71.c                |   31 +-
 arch/arm/mach-omap1/board-perseus2.c               |   91 +-
 arch/arm/mach-omap1/board-sx1.c                    |   58 +-
 arch/arm/mach-omap1/board-voiceblue.c              |    7 +-
 arch/arm/mach-omap1/clock_data.c                   |   27 +-
 arch/arm/mach-omap1/devices.c                      |    4 +
 arch/arm/mach-omap1/dma.c                          |  390 +++++
 arch/arm/mach-omap1/flash.c                        |    1 +
 arch/arm/mach-omap1/fpga.c                         |   10 +-
 arch/arm/mach-omap1/gpio15xx.c                     |   99 ++
 arch/arm/mach-omap1/gpio16xx.c                     |  200 +++
 arch/arm/mach-omap1/gpio7xx.c                      |  262 ++++
 arch/arm/mach-omap1/include/mach/entry-macro.S     |   27 +-
 arch/arm/mach-omap1/io.c                           |   39 +
 arch/arm/mach-omap1/irq.c                          |    5 +
 arch/arm/mach-omap1/lcd_dma.c                      |    3 +
 arch/arm/mach-omap1/leds.c                         |    3 +
 arch/arm/mach-omap1/mailbox.c                      |    5 +-
 arch/arm/mach-omap1/mcbsp.c                        |    5 +-
 arch/arm/mach-omap1/mux.c                          |    2 +-
 arch/arm/mach-omap1/pm.c                           |    3 +
 arch/arm/mach-omap1/pm_bus.c                       |    4 +-
 arch/arm/mach-omap1/serial.c                       |   11 +-
 arch/arm/mach-omap1/time.c                         |    1 +
 arch/arm/mach-omap2/Kconfig                        |   34 +-
 arch/arm/mach-omap2/Makefile                       |   83 +-
 arch/arm/mach-omap2/board-2430sdp.c                |    8 +-
 arch/arm/mach-omap2/board-3430sdp.c                |    6 +-
 arch/arm/mach-omap2/board-3630sdp.c                |    8 +-
 arch/arm/mach-omap2/board-4430sdp.c                |   45 +-
 arch/arm/mach-omap2/board-am3517crane.c            |  116 ++
 arch/arm/mach-omap2/board-am3517evm.c              |    7 +-
 arch/arm/mach-omap2/board-apollon.c                |   10 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |   15 +-
 arch/arm/mach-omap2/board-cm-t3517.c               |    4 +-
 arch/arm/mach-omap2/board-devkit8000.c             |   14 +-
 arch/arm/mach-omap2/board-generic.c                |    3 +-
 arch/arm/mach-omap2/board-h4.c                     |   71 +-
 arch/arm/mach-omap2/board-igep0020.c               |  124 +-
 arch/arm/mach-omap2/board-igep0030.c               |    7 +-
 arch/arm/mach-omap2/board-ldp.c                    |    8 +-
 arch/arm/mach-omap2/board-n8x0.c                   |   70 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |    8 +-
 arch/arm/mach-omap2/board-omap3evm.c               |    6 +-
 arch/arm/mach-omap2/board-omap3logic.c             |    6 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |   10 +-
 arch/arm/mach-omap2/board-omap3stalker.c           |    6 +-
 arch/arm/mach-omap2/board-omap3touchbook.c         |    8 +-
 arch/arm/mach-omap2/board-omap4panda.c             |   22 +-
 arch/arm/mach-omap2/board-overo.c                  |    8 +-
 arch/arm/mach-omap2/board-rm680.c                  |  187 +++
 arch/arm/mach-omap2/board-rx51-peripherals.c       |   77 +-
 arch/arm/mach-omap2/board-rx51-video.c             |    9 +-
 arch/arm/mach-omap2/board-rx51.c                   |   10 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c       |    2 +-
 .../arm/mach-omap2/{board-zoom3.c => board-zoom.c} |  102 +-
 arch/arm/mach-omap2/board-zoom2.c                  |  117 --
 arch/arm/mach-omap2/clkt2xxx_apll.c                |   12 +-
 arch/arm/mach-omap2/clkt2xxx_dpllcore.c            |   10 +-
 arch/arm/mach-omap2/clkt2xxx_osc.c                 |    2 +-
 arch/arm/mach-omap2/clkt2xxx_sys.c                 |    2 +-
 arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c       |   14 +-
 arch/arm/mach-omap2/clkt_dpll.c                    |    1 -
 arch/arm/mach-omap2/clock.c                        |    6 +-
 arch/arm/mach-omap2/clock.h                        |    1 -
 arch/arm/mach-omap2/clock2420_data.c               |   14 +-
 arch/arm/mach-omap2/clock2430.c                    |    2 +-
 arch/arm/mach-omap2/clock2430_data.c               |   14 +-
 arch/arm/mach-omap2/clock34xx.c                    |    2 +-
 arch/arm/mach-omap2/clock3517.c                    |    2 +-
 arch/arm/mach-omap2/clock3xxx.c                    |    6 +-
 arch/arm/mach-omap2/clock3xxx_data.c               |  230 ++--
 arch/arm/mach-omap2/clock44xx_data.c               |  690 ++++++---
 arch/arm/mach-omap2/clockdomain.c                  |  220 ++--
 .../include/plat => mach-omap2}/clockdomain.h      |   40 +-
 ...clockdomains.h => clockdomains2xxx_3xxx_data.c} |  109 +--
 ...{clockdomains44xx.h => clockdomains44xx_data.c} |  169 ++-
 arch/arm/mach-omap2/cm-regbits-24xx.h              |   11 +-
 arch/arm/mach-omap2/cm-regbits-34xx.h              |   13 +-
 arch/arm/mach-omap2/cm-regbits-44xx.h              |    3 -
 arch/arm/mach-omap2/cm.c                           |   68 -
 arch/arm/mach-omap2/cm.h                           |  137 +--
 arch/arm/mach-omap2/cm1_44xx.h                     |  261 ++++
 arch/arm/mach-omap2/cm2_44xx.h                     |  508 ++++++
 arch/arm/mach-omap2/cm2xxx_3xxx.c                  |  471 ++++++
 arch/arm/mach-omap2/cm2xxx_3xxx.h                  |  147 ++
 arch/arm/mach-omap2/cm44xx.c                       |   52 +
 arch/arm/mach-omap2/cm44xx.h                       |  668 +--------
 arch/arm/mach-omap2/cm4xxx.c                       |   62 -
 arch/arm/mach-omap2/cminst44xx.c                   |  214 +++
 arch/arm/mach-omap2/cminst44xx.h                   |   31 +
 arch/arm/mach-omap2/control.c                      |  133 ++-
 arch/arm/mach-omap2/control.h                      |   42 +-
 arch/arm/mach-omap2/cpuidle34xx.c                  |   40 +-
 arch/arm/mach-omap2/devices.c                      |  108 +-
 arch/arm/mach-omap2/dma.c                          |  297 ++++
 arch/arm/mach-omap2/dpll3xxx.c                     |   57 +-
 arch/arm/mach-omap2/dsp.c                          |   23 +-
 arch/arm/mach-omap2/gpio.c                         |  104 ++
 arch/arm/mach-omap2/gpmc-nand.c                    |    2 +-
 arch/arm/mach-omap2/gpmc-onenand.c                 |   19 +-
 arch/arm/mach-omap2/gpmc.c                         |   12 +-
 arch/arm/mach-omap2/include/mach/entry-macro.S     |   44 +-
 arch/arm/mach-omap2/io.c                           |  141 ++-
 arch/arm/mach-omap2/irq.c                          |    5 +-
 arch/arm/mach-omap2/mailbox.c                      |   19 +-
 arch/arm/mach-omap2/mux.c                          |  525 +++++--
 arch/arm/mach-omap2/mux.h                          |  154 ++-
 arch/arm/mach-omap2/mux2420.c                      |   10 +-
 arch/arm/mach-omap2/mux2430.c                      |   10 +-
 arch/arm/mach-omap2/mux34xx.c                      |    9 +-
 arch/arm/mach-omap2/mux44xx.c                      | 1625 +++++++++++++++++++
 arch/arm/mach-omap2/mux44xx.h                      |  298 ++++
 arch/arm/mach-omap2/omap-iommu.c                   |   10 +-
 arch/arm/mach-omap2/omap4-common.c                 |   30 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |  483 ++++---
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |  465 ++++++-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |  519 ++++++-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  870 +++++++++++-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         | 1644 +++++++++++++++++---
 arch/arm/mach-omap2/omap_opp_data.h                |   72 +
 arch/arm/mach-omap2/omap_twl.c                     |  277 ++++
 arch/arm/mach-omap2/opp.c                          |   93 ++
 arch/arm/mach-omap2/opp3xxx_data.c                 |  107 ++
 arch/arm/mach-omap2/opp4xxx_data.c                 |   57 +
 arch/arm/mach-omap2/pm-debug.c                     |   21 +-
 arch/arm/mach-omap2/pm.c                           |  144 ++-
 arch/arm/mach-omap2/pm.h                           |   59 +-
 arch/arm/mach-omap2/pm24xx.c                       |  224 ++--
 arch/arm/mach-omap2/pm34xx.c                       |  236 ++--
 arch/arm/mach-omap2/pm44xx.c                       |   18 +-
 arch/arm/mach-omap2/powerdomain-common.c           |  110 ++
 arch/arm/mach-omap2/powerdomain.c                  |  441 ++----
 arch/arm/mach-omap2/powerdomain.h                  |  233 +++
 arch/arm/mach-omap2/powerdomain2xxx_3xxx.c         |  242 +++
 arch/arm/mach-omap2/powerdomain44xx.c              |  225 +++
 arch/arm/mach-omap2/powerdomains.h                 |  153 --
 arch/arm/mach-omap2/powerdomains2xxx_3xxx_data.c   |   79 +
 arch/arm/mach-omap2/powerdomains2xxx_3xxx_data.h   |   22 +
 ...{powerdomains24xx.h => powerdomains2xxx_data.c} |   48 +-
 ...{powerdomains34xx.h => powerdomains3xxx_data.c} |   56 +-
 ...{powerdomains44xx.h => powerdomains44xx_data.c} |   92 +-
 arch/arm/mach-omap2/prcm-common.h                  |   85 +-
 arch/arm/mach-omap2/prcm.c                         |  556 +------
 arch/arm/mach-omap2/prcm44xx.h                     |   42 +
 arch/arm/mach-omap2/prcm_mpu44xx.c                 |   45 +
 arch/arm/mach-omap2/prcm_mpu44xx.h                 |  104 ++
 arch/arm/mach-omap2/prm-regbits-24xx.h             |    2 +-
 arch/arm/mach-omap2/prm-regbits-34xx.h             |   11 +-
 arch/arm/mach-omap2/prm-regbits-44xx.h             |    2 -
 arch/arm/mach-omap2/prm.h                          |  369 +-----
 arch/arm/mach-omap2/prm2xxx_3xxx.c                 |   64 +-
 arch/arm/mach-omap2/prm2xxx_3xxx.h                 |  367 +++++
 arch/arm/mach-omap2/prm44xx.c                      |   81 +-
 arch/arm/mach-omap2/prm44xx.h                      |  766 +++++-----
 arch/arm/mach-omap2/prminst44xx.c                  |   66 +
 arch/arm/mach-omap2/prminst44xx.h                  |   25 +
 arch/arm/mach-omap2/scrm44xx.h                     |  175 +++
 .../{board-rx51-sdram.c => sdram-nokia.c}          |  102 +-
 arch/arm/mach-omap2/sdram-nokia.h                  |   12 +
 arch/arm/mach-omap2/sdrc.c                         |    2 -
 arch/arm/mach-omap2/sdrc.h                         |    1 -
 arch/arm/mach-omap2/sdrc2xxx.c                     |    6 +-
 arch/arm/mach-omap2/serial.c                       |   69 +-
 arch/arm/mach-omap2/sleep34xx.S                    |  836 ++++++-----
 arch/arm/mach-omap2/smartreflex-class3.c           |   59 +
 arch/arm/mach-omap2/smartreflex.c                  | 1029 ++++++++++++
 arch/arm/mach-omap2/sr_device.c                    |  146 ++
 arch/arm/mach-omap2/sram242x.S                     |   10 +-
 arch/arm/mach-omap2/sram243x.S                     |   10 +-
 arch/arm/mach-omap2/sram34xx.S                     |    8 +-
 arch/arm/mach-omap2/timer-gp.c                     |    3 +-
 arch/arm/mach-omap2/usb-tusb6010.c                 |    5 +-
 arch/arm/mach-omap2/voltage.c                      | 1571 +++++++++++++++++++
 arch/arm/mach-omap2/wd_timer.c                     |   54 +
 arch/arm/mach-omap2/wd_timer.h                     |   17 +
 arch/arm/mach-orion5x/include/mach/io.h            |    4 +-
 arch/arm/mach-tegra/include/mach/io.h              |    4 +-
 arch/arm/plat-omap/Kconfig                         |   35 +
 arch/arm/plat-omap/devices.c                       |   40 -
 arch/arm/plat-omap/dma.c                           |  695 ++++-----
 arch/arm/plat-omap/gpio.c                          |  670 +++------
 arch/arm/plat-omap/i2c.c                           |  128 +-
 arch/arm/plat-omap/include/plat/clkdev_omap.h      |   20 +-
 arch/arm/plat-omap/include/plat/clock.h            |   16 +-
 arch/arm/plat-omap/include/plat/common.h           |    2 +
 arch/arm/plat-omap/include/plat/dma.h              |  232 ++--
 arch/arm/plat-omap/include/plat/fpga.h             |    4 -
 arch/arm/plat-omap/include/plat/gpio.h             |   48 +-
 arch/arm/plat-omap/include/plat/gpmc.h             |    9 +-
 arch/arm/plat-omap/include/plat/i2c.h              |   13 +
 arch/arm/plat-omap/include/plat/io.h               |    9 +-
 arch/arm/plat-omap/include/plat/iommu.h            |    5 +
 arch/arm/plat-omap/include/plat/irqs.h             |    2 +-
 arch/arm/plat-omap/include/plat/keypad.h           |   35 +-
 arch/arm/plat-omap/include/plat/l4_3xxx.h          |   24 +
 arch/arm/plat-omap/include/plat/mailbox.h          |    8 +-
 arch/arm/plat-omap/include/plat/omap-pm.h          |   39 +-
 arch/arm/plat-omap/include/plat/omap-serial.h      |   14 +-
 arch/arm/plat-omap/include/plat/omap_device.h      |    1 +
 arch/arm/plat-omap/include/plat/omap_hwmod.h       |   73 +-
 arch/arm/plat-omap/include/plat/powerdomain.h      |  167 --
 arch/arm/plat-omap/include/plat/prcm.h             |   20 +-
 arch/arm/plat-omap/include/plat/serial.h           |    5 +-
 arch/arm/plat-omap/include/plat/smartreflex.h      |  245 +++
 arch/arm/plat-omap/include/plat/sram.h             |   11 +
 arch/arm/plat-omap/include/plat/uncompress.h       |    3 +
 arch/arm/plat-omap/include/plat/voltage.h          |  146 ++
 arch/arm/plat-omap/io.c                            |   58 -
 arch/arm/plat-omap/iommu.c                         |   24 +
 arch/arm/plat-omap/iovmm.c                         |   81 +-
 arch/arm/plat-omap/mailbox.c                       |  130 +-
 arch/arm/plat-omap/mcbsp.c                         |   26 +-
 arch/arm/plat-omap/omap-pm-noop.c                  |   78 +-
 arch/arm/plat-omap/omap_device.c                   |   28 +
 arch/arm/plat-omap/sram.c                          |   14 +-
 drivers/i2c/busses/i2c-omap.c                      |   73 +-
 drivers/input/keyboard/omap-keypad.c               |   41 +-
 drivers/input/serio/Kconfig                        |    1 -
 drivers/mtd/onenand/omap2.c                        |    3 +
 drivers/serial/8250.c                              |   26 +-
 drivers/serial/omap-serial.c                       |   40 +-
 drivers/staging/tidspbridge/core/_tiomap.h         |   15 +-
 include/linux/i2c-omap.h                           |    5 +
 include/linux/input/matrix_keypad.h                |    2 +-
 include/linux/serial_reg.h                         |   19 +
 265 files changed, 21079 insertions(+), 8727 deletions(-)
 delete mode 100644 arch/arm/configs/ams_delta_defconfig
 delete mode 100644 arch/arm/configs/htcherald_defconfig
 delete mode 100644 arch/arm/configs/n770_defconfig
 create mode 100644 arch/arm/configs/omap1_defconfig
 delete mode 100644 arch/arm/configs/omap_generic_1510_defconfig
 delete mode 100644 arch/arm/configs/omap_generic_1610_defconfig
 delete mode 100644 arch/arm/configs/omap_generic_1710_defconfig
 delete mode 100644 arch/arm/configs/omap_h2_1610_defconfig
 delete mode 100644 arch/arm/configs/omap_innovator_1510_defconfig
 delete mode 100644 arch/arm/configs/omap_innovator_1610_defconfig
 delete mode 100644 arch/arm/configs/omap_osk_5912_defconfig
 delete mode 100644 arch/arm/configs/omap_perseus2_730_defconfig
 delete mode 100644 arch/arm/configs/palmte_defconfig
 delete mode 100644 arch/arm/configs/palmtt_defconfig
 delete mode 100644 arch/arm/configs/palmz71_defconfig
 delete mode 100644 arch/arm/configs/sx1_defconfig
 create mode 100644 arch/arm/mach-omap1/dma.c
 create mode 100644 arch/arm/mach-omap1/gpio15xx.c
 create mode 100644 arch/arm/mach-omap1/gpio16xx.c
 create mode 100644 arch/arm/mach-omap1/gpio7xx.c
 create mode 100644 arch/arm/mach-omap2/board-am3517crane.c
 create mode 100644 arch/arm/mach-omap2/board-rm680.c
 rename arch/arm/mach-omap2/{board-zoom3.c => board-zoom.c} (74%)
 delete mode 100644 arch/arm/mach-omap2/board-zoom2.c
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/clockdomain.h (82%)
 rename arch/arm/mach-omap2/{clockdomains.h => clockdomains2xxx_3xxx_data.c} (87%)
 rename arch/arm/mach-omap2/{clockdomains44xx.h => clockdomains44xx_data.c} (58%)
 delete mode 100644 arch/arm/mach-omap2/cm.c
 create mode 100644 arch/arm/mach-omap2/cm1_44xx.h
 create mode 100644 arch/arm/mach-omap2/cm2_44xx.h
 create mode 100644 arch/arm/mach-omap2/cm2xxx_3xxx.c
 create mode 100644 arch/arm/mach-omap2/cm2xxx_3xxx.h
 create mode 100644 arch/arm/mach-omap2/cm44xx.c
 delete mode 100644 arch/arm/mach-omap2/cm4xxx.c
 create mode 100644 arch/arm/mach-omap2/cminst44xx.c
 create mode 100644 arch/arm/mach-omap2/cminst44xx.h
 create mode 100644 arch/arm/mach-omap2/dma.c
 create mode 100644 arch/arm/mach-omap2/gpio.c
 create mode 100644 arch/arm/mach-omap2/mux44xx.c
 create mode 100644 arch/arm/mach-omap2/mux44xx.h
 create mode 100644 arch/arm/mach-omap2/omap_opp_data.h
 create mode 100644 arch/arm/mach-omap2/omap_twl.c
 create mode 100644 arch/arm/mach-omap2/opp.c
 create mode 100644 arch/arm/mach-omap2/opp3xxx_data.c
 create mode 100644 arch/arm/mach-omap2/opp4xxx_data.c
 create mode 100644 arch/arm/mach-omap2/powerdomain-common.c
 create mode 100644 arch/arm/mach-omap2/powerdomain.h
 create mode 100644 arch/arm/mach-omap2/powerdomain2xxx_3xxx.c
 create mode 100644 arch/arm/mach-omap2/powerdomain44xx.c
 delete mode 100644 arch/arm/mach-omap2/powerdomains.h
 create mode 100644 arch/arm/mach-omap2/powerdomains2xxx_3xxx_data.c
 create mode 100644 arch/arm/mach-omap2/powerdomains2xxx_3xxx_data.h
 rename arch/arm/mach-omap2/{powerdomains24xx.h => powerdomains2xxx_data.c} (76%)
 rename arch/arm/mach-omap2/{powerdomains34xx.h => powerdomains3xxx_data.c} (86%)
 rename arch/arm/mach-omap2/{powerdomains44xx.h => powerdomains44xx_data.c} (79%)
 create mode 100644 arch/arm/mach-omap2/prcm44xx.h
 create mode 100644 arch/arm/mach-omap2/prcm_mpu44xx.c
 create mode 100644 arch/arm/mach-omap2/prcm_mpu44xx.h
 create mode 100644 arch/arm/mach-omap2/prm2xxx_3xxx.h
 create mode 100644 arch/arm/mach-omap2/prminst44xx.c
 create mode 100644 arch/arm/mach-omap2/prminst44xx.h
 create mode 100644 arch/arm/mach-omap2/scrm44xx.h
 rename arch/arm/mach-omap2/{board-rx51-sdram.c => sdram-nokia.c} (66%)
 create mode 100644 arch/arm/mach-omap2/sdram-nokia.h
 create mode 100644 arch/arm/mach-omap2/smartreflex-class3.c
 create mode 100644 arch/arm/mach-omap2/smartreflex.c
 create mode 100644 arch/arm/mach-omap2/sr_device.c
 create mode 100644 arch/arm/mach-omap2/voltage.c
 create mode 100644 arch/arm/mach-omap2/wd_timer.c
 create mode 100644 arch/arm/mach-omap2/wd_timer.h
 create mode 100644 arch/arm/plat-omap/include/plat/l4_3xxx.h
 delete mode 100644 arch/arm/plat-omap/include/plat/powerdomain.h
 create mode 100644 arch/arm/plat-omap/include/plat/smartreflex.h
 create mode 100644 arch/arm/plat-omap/include/plat/voltage.h
