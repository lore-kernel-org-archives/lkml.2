Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab1CQSbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:31:05 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:35765 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab1CQSbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:31:03 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18ST0fDI/M0w6UPp5ejqObx
Date: Thu, 17 Mar 2011 11:30:48 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110317183048.GW7258@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull omap changes for this merge window from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-for-linus

To summarize, this contains omap3 and 4 PM updates, new ti816x
processor support, changes many drivers to use common hwmod
platform code, thumb-2 changes, early init changes and a bunch
of clean-up patches.

Looks like there are again few minor merge conflicts that
git mergetool handles automatically except for the following
two conflicts.

I've also attached the relevant parts of the conflict resolution
patch to the end of this message, here's what's conflicting:

1. arch/arm/mach-omap2/usb-musb.c

In usb_musb_init, platform_device_register can be left out.

And the following part

	if (cpu_is_omap44xx())
		omap4430_phy_init(dev);

needs to be added towards the end of the function after
dev = &pdev->dev is initialized so dev_err works properly
in omap4430_phy_init.

2. drivers/usb/musb/musb_core.h

In struct musb_context_registers the ifdef block is not needed
at all.

Regards,

Tony


The following changes since commit 521cb40b0c44418a4fd36dc633f575813d59a43d:

  Linux 2.6.38 (2011-03-14 18:20:32 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-for-linus

Aaro Koskinen (7):
      arm: plat-omap: dma: make omap_dma_in_1510_mode() static
      arm: mach-omap1: board-h2: make h2_nand_platdata static
      arm: mach-omap1: board-innovator: make innovator_mmc_init() static
      arm: mach-omap1: board-htcherald: make htcpld_chips and htcpld_pfdata static
      arm: mach-omap1: board-h3: make nand_platdata static
      arm: mach-omap1: board-voiceblue: add missing include
      arm: plat-omap: iommu: fix request_mem_region() error path

Abhilash Vadakkepat Koyamangalath (1):
      audio : AM3517 : Adding i2c info for AIC23 codec

Adrian Hunter (3):
      OMAP: OneNAND: fix 104MHz support
      OMAP: OneNAND: determine frequency in one place
      OMAP: OneNAND: let boards determine OneNAND frequency

Anand Gadiyar (4):
      arm: omap4: usb: explicitly configure MUSB pads
      arm: omap4: 4430sdp: drop ehci support
      omap: mmc: split out init for 2420
      OMAP4: hwmod data: enable HSMMC

Anand S Sawant (1):
      OMAP2+: smartreflex: remove SR debug directory in omap_sr_remove()

Andy Green (1):
      OMAP2+: Common CPU DIE ID reading code reads wrong registers for OMAP4430

Avinash.H.M (1):
      omap: hwmod: add syss reset done flags to omap2, omap3 hwmods

Balaji T K (2):
      OMAP4: Fix -EINVAL for vana, vcxio, vdac
      OMAP2: add regulator for MMC1

Benoit Cousson (15):
      OMAP4: hwmod data: Add hwspinlock
      OMAP4: hwmod data: Add McSPI
      OMAP4: hwmod data: Add timer
      OMAP4: hwmod data: Add DSS, DISPC, DSI1&2, RFBI, HDMI and VENC
      OMAP4: hwmod data: Add mailbox
      OMAP4: hwmod data: Add DMIC
      OMAP4: hwmod data: Add McBSP
      OMAP4: hwmod data: Add AESS, McPDM, bandgap, counter_32k, MMC, KBD, ISS & IPU
      OMAP4: hwmod data: Add USBOTG
      OMAP4: hwmod data: Add rev and dev_attr fields in McSPI
      OMAP4: hwmod data: Prevent timer1 to be reset and idle during init
      omap4: clockdomain: Fix the CPUx domain name
      Revert "OMAP4: hwmod data: Prevent timer1 to be reset and idle during init"
      OMAP3: hwmod data: Fix incorrect SmartReflex -> L4 CORE interconnect links
      OMAP3: hwmod data: Remove masters port links for interconnects.

Charulatha V (7):
      OMAP2420: hwmod data: Add McSPI
      OMAP2430: hwmod data: Add McSPI
      OMAP3: hwmod data: Add McSPI
      OMAP: devices: Modify McSPI device to adapt to hwmod framework
      OMAP2420: hwmod data: Add McBSP
      OMAP2430: hwmod data: Add McBSP
      OMAP3: hwmod data: Add McBSP

Dave Martin (5):
      ARM: omap4: Provide do_wfi() for Thumb-2
      ARM: omap4: Convert END() to ENDPROC() for correct linkage with CONFIG_THUMB2_KERNEL
      ARM: omap3: Remove hand-encoded SMC instructions
      ARM: omap3: Thumb-2 compatibility for sram34xx.S
      ARM: omap3: Thumb-2 compatibility for sleep34xx.S

David Cohen (5):
      omap: IOMMU: add missing function declaration
      omap: iommu: print module name on error messages
      OMAP2+: IOMMU: don't print fault warning on specific layer
      omap: IOMMU: add support to callback during fault handling
      omap: iovmm: don't check 'da' to set IOVMF_DA_FIXED flag

Eyal Reizer (2):
      omap3evm: add support for the WL12xx WLAN module to the AM/DM3xx Evaluation Module
      omap: omap3evm: add support for the WL12xx WLAN module to the omap3evm

Felipe Balbi (8):
      arm: omap: i2c: fix compile warning
      arm: omap1: fix compile warning
      arm: omap1: fix compile warnings
      arm: omap1: fix a bunch of section mismatches
      arm: omap2: irq: fix compile warning:
      arm: omap2: clksel: fix compile warningOrganization: Texas Instruments\n
      OMAP3: l3: Introduce l3-interconnect error handling driver
      OMAP: clock: fix compile warning

Felipe Contreras (2):
      OMAP3: hwmod data: add mailbox data
      OMAP: mailbox: build device using omap_device/omap_hwmod

Govindraj.R (1):
      OMAP: runtime: McSPI driver runtime conversion

Guy Eilam (1):
      omap: panda: Add TI-ST driver support

Hema HK (5):
      usb: musb: AM35x: moving internal phy functions out of usb_musb.c file
      OMAP2430: hwmod data: Add USBOTG
      OMAP3xxx: hwmod data: Add USBOTG
      AM35xx: hwmod data: Add USBOTG
      OMAP2+: musb: hwmod adaptation for musb registration

Hemant Pedanekar (4):
      TI816X: Update common omap platform files
      TI816X: Update common OMAP machine specific sources
      TI816X: Create board support and enable build for TI816X EVM
      TI816X: Add low level debug support

Ilkka Koskinen (3):
      omap: rx51: Add support for vibra
      omap: Remove unnecessary twl4030_codec_audio settings from board files
      mfd: twl4030_codec: Remove unused and duplicate audio_mclk fields

Jarkko Nikula (1):
      omap: rx51: Add SI4713 FM transmitter

Jean Pihet (1):
      perf: add OMAP support for the new power events

Kevin Hilman (2):
      MAINTAINERS: update Kevin's email for OMAP PM section
      OMAP2+: remove unused UART base addresses from omap_globals

Kishon Vijay Abraham I (12):
      omap: McBSP: Remove unused audio macros in mcbsp.h
      OMAP: hwmod: allow hwmod to provide address space accessible from SDMA
      OMAP: McBSP: Convert McBSP to platform device model
      OMAP4: hwmod: Naming of address space
      OMAP3: hwmod: add dev_attr for McBSP sidetone
      OMAP2+: McBSP: hwmod adaptation for McBSP
      OMAP: McBSP: use omap_device APIs to modify SYSCONFIG
      OMAP: McBSP: Add pm runtime support
      OMAP: McBSP: APIs to pass DMA params from McBSP driver to client drivers
      ASoC: McBSP: get hw params from McBSP driver
      OMAP: hwmod: Removal of macros for data that is obtained from hwmod database
      OMAP2+: hwmod: add API to handle autoidle mode

Kishore Kadiyala (5):
      OMAP: hsmmc: Enable MMC4 and MMC5 on OMAP4 platforms
      OMAP: hwmod data: Add dev_attr and use in the host driver
      OMAP: hsmmc: Move mux configuration to hsmmc.c
      OMAP: adapt hsmmc to hwmod framework
      OMAP: hsmmc: Rename the device and driver

Martin Hostettler (1):
      omap: iommu: Gracefully fail iommu_enable if no arch_iommu is registered

Menon, Nishanth (1):
      OMAP3|4: OPP: make omapx_opp_init non-static

Michael Jones (1):
      omap: iovmm: disallow mapping NULL address when IOVMF_DA_ANON is set

Ming Lei (1):
      arm: omap: fix section mismatch warning

Nishant Kamat (1):
      omap: Add chip id recognition for OMAP4 ES2.1 and ES2.2

Nishanth Menon (1):
      OMAP3: beagle xm: enable up to 800MHz OPP

Ohad Ben-Cohen (2):
      drivers: hwspinlock: add framework
      omap: zoom: host should not pull up wl1271's irq line

Omar Ramirez Luna (2):
      OMAP2: hwmod data: add mailbox data
      OMAP: mailbox: use runtime pm for clk and sysc handling

Panduranga Mallireddy (4):
      omap: panda: wlan board muxing
      omap: select REGULATOR_FIXED_VOLTAGE by default for panda and sdp4430
      omap: panda: add fixed regulator device for wlan
      omap: panda: add mmc5/wl1271 device support

Paul Walmsley (48):
      OMAP2+: clock: autoidle as many clocks as possible if CONFIG_OMAP_RESET_CLOCKS
      OMAP2+: clock: disable autoidle on all clocks during clock init
      OMAP2+: hwmod: allow multiple calls to omap_hwmod_init()
      OMAP2+: hwmod: rename some init functions
      OMAP2+: hwmod: find MPU initiator hwmod during in _register()
      OMAP2+: hwmod: ignore attempts to re-setup a hwmod
      OMAP2+: hwmod: add ability to setup individual hwmods
      OMAP2+: clockevent: set up GPTIMER clockevent hwmod right before timer init
      OMAP2+: sdrc: fix compile break on OMAP4-only config on current omap-for-linus
      OMAP2430: hwmod data: Add HSMMC
      OMAP3: hwmod data: Add HSMMC
      MMC: omap_hsmmc: enable interface clock before calling mmc_host_enable()
      OMAP2/3: WKUP powerdomain: mark as being always on
      OMAP2+: powerdomain: fix bank power state bitfields
      OMAP2+: powerdomain: add pwrdm_can_ever_lose_context()
      OMAP2: clock: add DPLL autoidle support
      OMAP2xxx: clock: add clockfw autoidle support for APLLs
      OMAP2+: clock: comment that osc_ck/osc_sys_ck should use clockfw autoidle control
      OMAP2+: clock: add interface clock type code with autoidle support
      OMAP2420: clock: add sdrc_ick
      OMAP2420: clock: use autoidle clkops for all autoidle-controllable interface clocks
      OMAP2430/3xxx: clock: add modem clock autoidle support
      OMAP2430: clock: use autoidle clkops for all autoidle-controllable interface clocks
      OMAP3: clock: use autoidle clkops for all autoidle-controllable interface clocks
      OMAP2/3: PM: remove manual CM_AUTOIDLE bit setting in mach-omap2/pm*xx.c
      OMAP: smartreflex: move plat/smartreflex.h to mach-omap2/smartreflex.h
      OMAP: voltage: move plat/voltage.h to mach-omap2/voltage.h
      OMAP2xxx: clock: fix parents for L3-derived clocks
      OMAP2xxx: clock: fix low-frequency oscillator clock rate
      OMAP2xxx: clock: fix interface clocks and clockdomains for modules in the WKUP domain
      OMAP: clock: bail out early if arch_clock functions not implemented
      OMAP2+: clock: remove the DPLL rate tolerance code
      OMAP2xxx: clock: remove dsp_irate_ick
      OMAP2xxx: clock: fix clockdomains on gpt7_ick, 2430 mmchs2_fck clocks
      OMAP2xxx: clock data: clean up some comments
      OMAP1: McBSP: fix build break for non-multi-OMAP1 configs
      OMAP2/3: VENC hwmod: add OCPIF_SWSUP_IDLE flag to interface
      OMAP2/3: PM: remove unnecessary wakeup/sleep dependency clear
      MAINTAINERS: add entry for OMAP powerdomain/clockdomain per-SoC layer support
      OMAP2+: hwmod: fix a documentation bug with HWMOD_NO_OCP_AUTOIDLE
      OMAP2+: hwmod: allow board files to prevent devices from being reset upon init
      OMAP2+: clockdomain: add flag that will block autodeps from being added for a clockdomain
      OMAP2+: voltage: reorganize, split code from data
      Watchdog: omap_wdt: add fine grain runtime-pm
      OMAP3: wdtimer: Fix CORE idle transition
      Merge remote branches 'remotes/origin/pwrdm_clkdm_b_2.6.39', 'remotes/origin/pwrdm_add_can_lose_context_fns_2.6.39', 'remotes/origin/omap_device_a_2.6.39', 'remotes/origin/mmc_a_2.6.39', 'remotes/origin/hwmod_b_2.6.39', 'remotes/origin/dmtimer_a_2.6.39', 'remotes/origin/pwrdm_clkdm_a_2.6.39', 'remotes/origin/clkdm_statdep_omap4_2.6.39', 'remotes/origin/clk_a_2.6.39', 'remotes/origin/clk_autoidle_a_2.6.39', 'remotes/origin/clk_autoidle_b_2.6.39', 'remotes/origin/clk_b_2.6.39', 'remotes/origin/clk_clkdm_a_2.6.39', 'remotes/origin/misc_a_2.6.39', 'remotes/origin/for_2.6.39/omap3_hwmod_data' and 'remotes/origin/wdtimer_a_2.6.39' into tmp-integration-2.6.39-20110310-024
      Merge remote branch 'remotes/origin/hwmod_a_2.6.39' into tmp-integration-2.6.39-20110310-024
      Merge remote branch 'remotes/origin/voltage_split_2.6.39' into tmp-integration-2.6.39-20110310-024

R Sricharan (4):
      omap2+: mux: Remove the use of IDLE flag
      omap4: board-4430sdp: Initialise the serial pads
      omap3: board-3430sdp: Initialise the serial pads
      omap4: board-omap4panda: Initialise the serial pads

Radek Pilař (Mrkva) (1):
      OMAP3 Touchbook: fix board initialization

Rajendra Nayak (20):
      omap3sdp: Fix regulator mapping for ads7846 TS controller
      omap3sdp: clean regulator supply mapping in board file
      OMAP: powerdomain: remove unused func declaration
      OMAP: clockdomain: Infrastructure to put arch specific code
      OMAP: clockdomain: Arch specific funcs to handle deps
      OMAP: clockdomain: Arch specific funcs for sleep/wakeup of clkdm
      OMAP: clockdomain: Arch specific funcs for hwsup control of clkdm
      OMAP: clockdomain: Arch specific funcs for clkdm_clk_enable/disable
      OMAP4: clockdomain: Add clkdm static dependency srcs
      OMAP4: CM: Add CM accesor api for bitwise control
      OMAP4: clockdomain: Add wkup/sleep dependency support
      OMAP4: clockdomain: Remove pr_errs' stating unsupported wkdep
      omap: clock: Check for enable/disable ops support
      omap3: dpll: Populate clkops for dpll1_ck
      OMAP: clock: Add allow_idle/deny_idle support in clkops
      OMAP3/4: DPLL: Add allow_idle/deny_idle support for all DPLL's
      OMAP4: DPLL: Add dpll api to control GATE_CTRL
      omap4: dpll: Enable auto gate control for all MX postdividers
      OMAP2+: omap_device/clock: Do not expect an entry in clkdev for opt_clks
      OMAP2+: hwmod: Fix what _init_clock returns

Ricardo Salveti de Araujo (1):
      OMAP3630: PM: don't warn the user with a trace in case of PM34XX_ERRATUM

Roman Tereshonkov (1):
      mtd: OneNAND: OMAP2: increase multiblock erase verify timeout

Russell King - ARM Linux (2):
      ARM: OMAP: Allow platforms to hook reset cleanly
      ARM: OMAP2: use early init hook

Sanjeev Premi (4):
      omap3: fix minor typos
      omap3: flash: use pr_err instead of printk
      omap2/3: clockdomains: fix compile-time warnings
      OMAP3: PM: Initialize IVA only if available

Santosh Shilimkar (11):
      omap2plus: omap4: Set NR_CPU to 2 instead of default 4
      omap4: Remove 'FIXME: omap44xx_sram_init not implemented'
      omap4: powerdomain: Use intended PWRSTS_* flags instead of values
      OMAP4: l3: Introduce l3-interconnect error handling driver
      omap3: pm: Use exported set_cr() instead of a custom one.
      omap3: cpuidle: Add description field to each C-state.
      OMAP3: PM: Use ARMv7 supported instructions instead of legacy CP15 ones
      OMAP3: PM: Fix the MMU on sequence in the asm code
      OMAP3: PM: Allow the cache clean when L1 is lost.
      OMAP3: PM: Remove un-necessary cp15 registers form low power cpu context
      OMAP3: PM: Clear the SCTLR C bit in asm code to prevent data cache allocation

Senthilvadivu Guruswamy (5):
      OMAP2420: hwmod data: add DSS DISPC RFBI VENC
      OMAP2430: hwmod data: add DSS DISPC RFBI VENC
      OMAP3: hwmod data: add DSS DISPC RFBI DSI VENC
      OMAP2, 3: DSS2: Use Regulator init with driver name
      OMAP2, 3: DSS2: board files: replace platform_device_register with omap_display_init()

Shweta Gulati (3):
      OMAP4: Enable 800 MHz and 1 GHz MPU-OPP
      OMAP4: Update Voltage Rail Values for MPU, IVA and CORE
      OMAP4: Add IVA OPP enteries.

Simon Que (2):
      drivers: hwspinlock: add OMAP implementation
      omap: add hwspinlock device

Sukumar Ghorai (7):
      omap3630: nand: fix device size to work in polled mode
      omap3: nand: configurable transfer type per board
      omap: gpmc: enable irq mode in gpmc
      omap3: nand: prefetch in irq mode support
      omap3: nand: configurable fifo threshold to gain the throughput
      omap3: nand: ecc layout select from board file
      omap3: nand: making ecc layout as compatible with romcode ecc

Sumit Semwal (1):
      OMAP2, 3: DSS2: Create new file display.c for central dss driver registration.

Syed Rafiuddin (1):
      OMAP4: keypad: Add the board support

Tarun Kanti DebBarma (1):
      OMAP2+: hwmod: fix incorrect computation of autoidle_mask

Tero Kristo (1):
      omap2/3: dmtimer: Enable autoidle

Thara Gopinath (4):
      OMAP2420: hwmod data: add dmtimer
      OMAP2430: hwmod data: add dmtimer
      OMAP3: hwmod data: add dmtimer
      OMAP3: PM: Set/clear T2 bit for Smartreflex on TWL

Tony Lindgren (28):
      omap: Start using CONFIG_SOC_OMAP
      omap2+: Make omap_hwmod_late_init into core_initcall
      omap2+: Fix omap_serial_early_init to work with init_early hook
      omap: hwmod: Populate _mpu_rt_va later on in omap_hwmod_late_init
      TI816X: Update to use init_early
      Merge branches 'devel-cleanup', 'devel-board', 'devel-early-init' and 'devel-ti816x' into omap-for-linus
      Merge branch 'for_2.6.39/omap4_hwmod_data' of git://gitorious.org/omap-pm/linux into omap-for-linus
      Merge branches 'devel-hwspinlock' and 'devel-mcspi' into omap-for-linus
      Merge branch 'for-tony' of git://gitorious.org/usb/usb into omap-for-linus
      Merge branches 'devel-cleanup', 'devel-omap4', 'devel-board' and 'devel-nand' into omap-for-linus
      Merge branch 'for-tony' of git://gitorious.org/linux-omap-dss2/linux into omap-for-linus
      omap2+: Minimize board specific init_early calls
      omap: Fix compile if MTD_NAND_OMAP2 is not selected
      omap2+: Minimize board specific init_early calls
      Merge branch 'hwmod_clockevent_2.6.39' of git://git.pwsan.com/linux-2.6 into omap-for-linus
      ldp: Fix regulator mapping for ads7846 TS controller
      Merge branch 'devel-cleanup' into omap-for-linus
      Merge branches 'devel-iommu-mailbox', 'devel-mcbsp', 'devel-board' and 'devel-hsmmc' into omap-for-linus
      Merge branch 'omap-l3-for-next' of git://dev.omapzoom.org/pub/scm/santosh/kernel-omap4-base into omap-for-linus
      omap: Fix H4 init_irq to not call h4_init_flash
      Merge branch 'for_2.6.39/pm-misc' of ssh://master.kernel.org/.../khilman/linux-omap-pm into omap-for-linus
      Merge branch 'integration-2.6.39-for-tony' of git://git.pwsan.com/linux-integration into omap-for-linus
      Merge branch 'for_2.6.39/pm-integration' of ssh://master.kernel.org/.../khilman/linux-omap-pm into omap-for-linus
      omap2+: Add separate list for dynamic pads to mux
      omap2+: mux: Add macro for configuring static with omap_hwmod_mux_init
      omap2+: mux: Fix compile when CONFIG_OMAP_MUX is not selected
      omap4: mux: Remove duplicate mux modes
      Merge branches 'devel-mux' and 'devel-misc' into omap-for-linus

Uwe Kleine-König (4):
      ARM: omap1/nokia770: mark some functions __init
      ARM: omap: move omap_get_config et al. to .init.text
      ARM: omap: move omap_board_config_kernel to .init.data
      wip: fix section mismatches in omap1_defconfig

Vaibhav Hiremath (6):
      OMAP3EVM: Reset the smsc911x ethernet controller in board_init
      omap3evm: Change TWL related gpio API's to gpio*_cansleep
      OMAP3EVM: Add vio regulator supply required for ads7846 TSC driver
      AM/DM37x: DSS mux configuration for >Rev-B processor cards
      OMAP3EVM: Made backlight GPIO default state to off
      OMAP3EVM: Set TSC wakeup option in pad config

Vasiliy Kulikov (1):
      OMAP: PM: SmartReflex: fix potential NULL dereference

Vishwanath BS (1):
      OMAP3+: OPP: Replace voltage values with Macros

omar ramirez (1):
      OMAP2+: hwmod: use status bit info for reset line

sricharan (4):
      OMAP3: hwmod_data: Add address space and irq in L3 hwmod.
      OMAP3: devices: Initialise the l3 device with the hwmod data.
      OMAP4: hwmod_data: Add address space and irq in L3 hwmod.
      OMAP4: Initialise the l3 device with the hwmod data.

 Documentation/hwspinlock.txt                       |  293 ++
 MAINTAINERS                                        |   12 +-
 arch/arm/configs/omap2plus_defconfig               |    1 +
 arch/arm/mach-omap1/Makefile                       |    2 +-
 arch/arm/mach-omap1/board-ams-delta.c              |   16 +-
 arch/arm/mach-omap1/board-fsample.c                |    4 +-
 arch/arm/mach-omap1/board-h2.c                     |    2 +-
 arch/arm/mach-omap1/board-h3.c                     |    2 +-
 arch/arm/mach-omap1/board-htcherald.c              |    4 +-
 arch/arm/mach-omap1/board-innovator.c              |    2 +-
 arch/arm/mach-omap1/board-nokia770.c               |    6 +-
 arch/arm/mach-omap1/board-palmte.c                 |   13 -
 arch/arm/mach-omap1/board-voiceblue.c              |  107 +-
 arch/arm/mach-omap1/mcbsp.c                        |  333 ++-
 arch/arm/mach-omap1/reset.c                        |   25 +
 arch/arm/mach-omap2/Kconfig                        |   28 +-
 arch/arm/mach-omap2/Makefile                       |   66 +-
 arch/arm/mach-omap2/board-2430sdp.c                |   34 +-
 arch/arm/mach-omap2/board-3430sdp.c                |  215 +-
 arch/arm/mach-omap2/board-3630sdp.c                |   15 +-
 arch/arm/mach-omap2/board-4430sdp.c                |  209 +-
 arch/arm/mach-omap2/board-am3517crane.c            |   14 +-
 arch/arm/mach-omap2/board-am3517evm.c              |   41 +-
 arch/arm/mach-omap2/board-apollon.c                |   12 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |   43 +-
 arch/arm/mach-omap2/board-cm-t3517.c               |   15 +-
 arch/arm/mach-omap2/board-devkit8000.c             |   27 +-
 arch/arm/mach-omap2/board-flash.c                  |   34 +-
 arch/arm/mach-omap2/board-flash.h                  |    4 +-
 arch/arm/mach-omap2/board-generic.c                |   12 +-
 arch/arm/mach-omap2/board-h4.c                     |   16 +-
 arch/arm/mach-omap2/board-igep0020.c               |   34 +-
 arch/arm/mach-omap2/board-igep0030.c               |   12 +-
 arch/arm/mach-omap2/board-ldp.c                    |   35 +-
 arch/arm/mach-omap2/board-n8x0.c                   |   20 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |   73 +-
 arch/arm/mach-omap2/board-omap3evm.c               |  246 +-
 arch/arm/mach-omap2/board-omap3logic.c             |    9 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |   28 +-
 arch/arm/mach-omap2/board-omap3stalker.c           |   37 +-
 arch/arm/mach-omap2/board-omap3touchbook.c         |   20 +-
 arch/arm/mach-omap2/board-omap4panda.c             |  158 +-
 arch/arm/mach-omap2/board-overo.c                  |   16 +-
 arch/arm/mach-omap2/board-rm680.c                  |   10 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |   61 +-
 arch/arm/mach-omap2/board-rx51-video.c             |   15 +-
 arch/arm/mach-omap2/board-rx51.c                   |   14 +-
 arch/arm/mach-omap2/board-ti8168evm.c              |   62 +
 arch/arm/mach-omap2/board-zoom-display.c           |   15 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c       |    6 +-
 arch/arm/mach-omap2/board-zoom.c                   |   21 +-
 arch/arm/mach-omap2/clkt2xxx_apll.c                |   24 +
 arch/arm/mach-omap2/clkt2xxx_dpll.c                |   63 +
 arch/arm/mach-omap2/clkt2xxx_osc.c                 |   14 +
 arch/arm/mach-omap2/clkt_clksel.c                  |    2 +-
 arch/arm/mach-omap2/clkt_dpll.c                    |   91 +-
 arch/arm/mach-omap2/clkt_iclk.c                    |   82 +
 arch/arm/mach-omap2/clock.c                        |   37 +-
 arch/arm/mach-omap2/clock.h                        |   21 +-
 arch/arm/mach-omap2/clock2420_data.c               |  221 +-
 arch/arm/mach-omap2/clock2430_data.c               |  244 +-
 arch/arm/mach-omap2/clock2xxx.h                    |    8 +-
 arch/arm/mach-omap2/clock34xx.c                    |   29 +-
 arch/arm/mach-omap2/clock34xx.h                    |    5 +-
 arch/arm/mach-omap2/clock3517.c                    |    4 +-
 arch/arm/mach-omap2/clock3xxx.c                    |    3 -
 arch/arm/mach-omap2/clock3xxx_data.c               |  182 +-
 arch/arm/mach-omap2/clock44xx_data.c               |   77 +-
 arch/arm/mach-omap2/clock_common_data.c            |    6 +
 arch/arm/mach-omap2/clockdomain.c                  |  439 +--
 arch/arm/mach-omap2/clockdomain.h                  |   70 +-
 arch/arm/mach-omap2/clockdomain2xxx_3xxx.c         |  274 ++
 arch/arm/mach-omap2/clockdomain44xx.c              |  137 +
 arch/arm/mach-omap2/clockdomains2xxx_3xxx_data.c   |   28 +-
 arch/arm/mach-omap2/clockdomains44xx_data.c        |  396 ++-
 arch/arm/mach-omap2/cm-regbits-24xx.h              |    3 +
 arch/arm/mach-omap2/cm2xxx_3xxx.c                  |   69 +
 arch/arm/mach-omap2/cm2xxx_3xxx.h                  |    8 +
 arch/arm/mach-omap2/cm44xx.h                       |    1 +
 arch/arm/mach-omap2/cminst44xx.c                   |   21 +
 arch/arm/mach-omap2/cminst44xx.h                   |    6 +
 arch/arm/mach-omap2/common.c                       |   39 +-
 arch/arm/mach-omap2/control.h                      |    6 +
 arch/arm/mach-omap2/cpuidle34xx.c                  |   15 +-
 arch/arm/mach-omap2/devices.c                      |  675 +---
 arch/arm/mach-omap2/display.c                      |   45 +
 arch/arm/mach-omap2/dpll44xx.c                     |   84 +
 arch/arm/mach-omap2/gpmc-nand.c                    |    7 +-
 arch/arm/mach-omap2/gpmc-onenand.c                 |  113 +-
 arch/arm/mach-omap2/gpmc.c                         |   56 +-
 arch/arm/mach-omap2/hsmmc.c                        |  421 ++-
 arch/arm/mach-omap2/hwspinlock.c                   |   63 +
 arch/arm/mach-omap2/id.c                           |   77 +-
 arch/arm/mach-omap2/include/mach/debug-macro.S     |   12 +
 arch/arm/mach-omap2/include/mach/entry-macro.S     |   13 +
 arch/arm/mach-omap2/include/mach/omap4-common.h    |    4 +
 arch/arm/mach-omap2/io.c                           |   42 +-
 arch/arm/mach-omap2/iommu2.c                       |   33 +-
 arch/arm/mach-omap2/irq.c                          |    9 +-
 arch/arm/mach-omap2/mailbox.c                      |   74 +-
 arch/arm/mach-omap2/mcbsp.c                        |  231 +-
 arch/arm/mach-omap2/mux.c                          |   85 +-
 arch/arm/mach-omap2/mux.h                          |    7 +-
 arch/arm/mach-omap2/mux44xx.c                      |  282 +--
 arch/arm/mach-omap2/omap-headsmp.S                 |    2 +-
 arch/arm/mach-omap2/omap44xx-smc.S                 |    8 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |  333 ++-
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         | 1454 +++++++-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         | 2606 ++++++++++--
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         | 3524 +++++++++++++---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         | 4321 +++++++++++++++++---
 arch/arm/mach-omap2/omap_l3_noc.c                  |  253 ++
 arch/arm/mach-omap2/omap_l3_noc.h                  |  132 +
 arch/arm/mach-omap2/omap_l3_smx.c                  |  314 ++
 arch/arm/mach-omap2/omap_l3_smx.h                  |  338 ++
 arch/arm/mach-omap2/omap_opp_data.h                |   24 +
 arch/arm/mach-omap2/omap_phy_internal.c            |   93 +
 arch/arm/mach-omap2/omap_twl.c                     |   62 +-
 arch/arm/mach-omap2/opp2xxx.h                      |    2 +-
 arch/arm/mach-omap2/opp3xxx_data.c                 |  115 +-
 arch/arm/mach-omap2/opp4xxx_data.c                 |   66 +-
 arch/arm/mach-omap2/pm.c                           |   12 +-
 arch/arm/mach-omap2/pm.h                           |    1 +
 arch/arm/mach-omap2/pm24xx.c                       |   85 +-
 arch/arm/mach-omap2/pm34xx.c                       |  159 +-
 arch/arm/mach-omap2/powerdomain.c                  |   69 +-
 arch/arm/mach-omap2/powerdomain.h                  |   19 +-
 arch/arm/mach-omap2/powerdomains2xxx_3xxx_data.c   |    9 +-
 arch/arm/mach-omap2/powerdomains2xxx_data.c        |   24 +-
 arch/arm/mach-omap2/powerdomains3xxx_data.c        |   38 +-
 arch/arm/mach-omap2/powerdomains44xx_data.c        |   88 +-
 arch/arm/mach-omap2/prcm-common.h                  |    8 +
 arch/arm/mach-omap2/prcm.c                         |    5 +-
 arch/arm/mach-omap2/prcm_mpu44xx.h                 |    4 +-
 arch/arm/mach-omap2/prm2xxx_3xxx.c                 |   18 +-
 arch/arm/mach-omap2/prm2xxx_3xxx.h                 |    5 +-
 arch/arm/mach-omap2/serial.c                       |   17 +-
 arch/arm/mach-omap2/sleep34xx.S                    |  282 +-
 arch/arm/mach-omap2/smartreflex-class3.c           |    2 +-
 arch/arm/mach-omap2/smartreflex.c                  |   33 +-
 .../include/plat => mach-omap2}/smartreflex.h      |    3 +-
 arch/arm/mach-omap2/sr_device.c                    |    4 +-
 arch/arm/mach-omap2/sram34xx.S                     |   36 +-
 arch/arm/mach-omap2/timer-gp.c                     |    7 +-
 arch/arm/mach-omap2/usb-musb.c                     |  219 +-
 arch/arm/mach-omap2/vc.h                           |   83 +
 arch/arm/mach-omap2/vc3xxx_data.c                  |   63 +
 arch/arm/mach-omap2/vc44xx_data.c                  |   75 +
 arch/arm/mach-omap2/voltage.c                      | 1020 ++----
 .../include/plat => mach-omap2}/voltage.h          |   89 +-
 arch/arm/mach-omap2/voltagedomains3xxx_data.c      |   95 +
 arch/arm/mach-omap2/voltagedomains44xx_data.c      |  102 +
 arch/arm/mach-omap2/vp.h                           |  143 +
 arch/arm/mach-omap2/vp3xxx_data.c                  |   82 +
 arch/arm/mach-omap2/vp44xx_data.c                  |  100 +
 arch/arm/plat-omap/clock.c                         |   99 +-
 arch/arm/plat-omap/common.c                        |   11 +-
 arch/arm/plat-omap/counter_32k.c                   |    4 +-
 arch/arm/plat-omap/cpu-omap.c                      |    2 +-
 arch/arm/plat-omap/devices.c                       |   10 +-
 arch/arm/plat-omap/dma.c                           |    2 +-
 arch/arm/plat-omap/dmtimer.c                       |    4 +
 arch/arm/plat-omap/i2c.c                           |    2 +-
 arch/arm/plat-omap/include/plat/board.h            |    4 +-
 arch/arm/plat-omap/include/plat/clkdev_omap.h      |    1 +
 arch/arm/plat-omap/include/plat/clock.h            |   28 +-
 arch/arm/plat-omap/include/plat/common.h           |    5 +-
 arch/arm/plat-omap/include/plat/cpu.h              |   44 +-
 arch/arm/plat-omap/include/plat/display.h          |   11 +
 arch/arm/plat-omap/include/plat/dmtimer.h          |   11 +
 arch/arm/plat-omap/include/plat/fpga.h             |   92 +-
 arch/arm/plat-omap/include/plat/gpmc.h             |   18 +-
 arch/arm/plat-omap/include/plat/hardware.h         |    1 +
 arch/arm/plat-omap/include/plat/io.h               |   12 +-
 arch/arm/plat-omap/include/plat/iommu.h            |   16 +-
 arch/arm/plat-omap/include/plat/iovmm.h            |    2 -
 arch/arm/plat-omap/include/plat/irqs.h             |   11 +-
 arch/arm/plat-omap/include/plat/l3_2xxx.h          |   20 +
 arch/arm/plat-omap/include/plat/l3_3xxx.h          |   20 +
 arch/arm/plat-omap/include/plat/l4_2xxx.h          |   24 +
 arch/arm/plat-omap/include/plat/l4_3xxx.h          |   10 +
 arch/arm/plat-omap/include/plat/mcbsp.h            |   64 +-
 arch/arm/plat-omap/include/plat/mcspi.h            |   11 +
 arch/arm/plat-omap/include/plat/mmc.h              |   29 +-
 arch/arm/plat-omap/include/plat/multi.h            |    4 +-
 arch/arm/plat-omap/include/plat/nand.h             |   11 +
 arch/arm/plat-omap/include/plat/omap_hwmod.h       |   25 +-
 arch/arm/plat-omap/include/plat/onenand.h          |   10 +-
 arch/arm/plat-omap/include/plat/prcm.h             |    1 -
 arch/arm/plat-omap/include/plat/sdrc.h             |    8 +-
 arch/arm/plat-omap/include/plat/serial.h           |    9 +-
 arch/arm/plat-omap/include/plat/system.h           |   38 +-
 arch/arm/plat-omap/include/plat/ti816x.h           |   27 +
 arch/arm/plat-omap/include/plat/uncompress.h       |    7 +
 arch/arm/plat-omap/include/plat/usb.h              |    4 +
 arch/arm/plat-omap/io.c                            |    5 +-
 arch/arm/plat-omap/iommu.c                         |   69 +-
 arch/arm/plat-omap/iovmm.c                         |   27 +-
 arch/arm/plat-omap/mcbsp.c                         |  203 +-
 arch/arm/plat-omap/omap_device.c                   |   36 +-
 arch/arm/plat-omap/sram.c                          |   20 +-
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    2 +
 drivers/hwspinlock/Kconfig                         |   22 +
 drivers/hwspinlock/Makefile                        |    6 +
 drivers/hwspinlock/hwspinlock_core.c               |  548 +++
 drivers/hwspinlock/hwspinlock_internal.h           |   61 +
 drivers/hwspinlock/omap_hwspinlock.c               |  231 ++
 drivers/mmc/host/Kconfig                           |    2 +-
 drivers/mmc/host/omap_hsmmc.c                      |   36 +-
 drivers/mtd/nand/Kconfig                           |   17 -
 drivers/mtd/nand/omap2.c                           |  367 ++-
 drivers/mtd/onenand/omap2.c                        |   36 +-
 drivers/spi/omap2_mcspi.c                          |  222 +-
 drivers/usb/musb/musb_core.c                       |    2 +-
 drivers/usb/musb/musb_core.h                       |    6 +-
 drivers/usb/musb/musbhsdma.h                       |    2 +-
 drivers/usb/otg/isp1301_omap.c                     |    2 +-
 drivers/w1/masters/Kconfig                         |    2 +-
 drivers/watchdog/omap_wdt.c                        |   25 +-
 include/linux/hwspinlock.h                         |  292 ++
 include/linux/i2c/twl.h                            |    2 -
 include/linux/mtd/onenand_regs.h                   |    1 +
 sound/soc/omap/omap-mcbsp.c                        |  126 +-
 sound/soc/omap/omap-mcbsp.h                        |    4 +-
 225 files changed, 20476 insertions(+), 6715 deletions(-)
 create mode 100644 Documentation/hwspinlock.txt
 create mode 100644 arch/arm/mach-omap1/reset.c
 create mode 100644 arch/arm/mach-omap2/board-ti8168evm.c
 create mode 100644 arch/arm/mach-omap2/clkt2xxx_dpll.c
 create mode 100644 arch/arm/mach-omap2/clkt_iclk.c
 create mode 100644 arch/arm/mach-omap2/clockdomain2xxx_3xxx.c
 create mode 100644 arch/arm/mach-omap2/clockdomain44xx.c
 create mode 100644 arch/arm/mach-omap2/display.c
 create mode 100644 arch/arm/mach-omap2/dpll44xx.c
 create mode 100644 arch/arm/mach-omap2/hwspinlock.c
 create mode 100644 arch/arm/mach-omap2/omap_l3_noc.c
 create mode 100644 arch/arm/mach-omap2/omap_l3_noc.h
 create mode 100644 arch/arm/mach-omap2/omap_l3_smx.c
 create mode 100644 arch/arm/mach-omap2/omap_l3_smx.h
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/smartreflex.h (99%)
 create mode 100644 arch/arm/mach-omap2/vc.h
 create mode 100644 arch/arm/mach-omap2/vc3xxx_data.c
 create mode 100644 arch/arm/mach-omap2/vc44xx_data.c
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/voltage.h (63%)
 create mode 100644 arch/arm/mach-omap2/voltagedomains3xxx_data.c
 create mode 100644 arch/arm/mach-omap2/voltagedomains44xx_data.c
 create mode 100644 arch/arm/mach-omap2/vp.h
 create mode 100644 arch/arm/mach-omap2/vp3xxx_data.c
 create mode 100644 arch/arm/mach-omap2/vp44xx_data.c
 create mode 100644 arch/arm/plat-omap/include/plat/l3_2xxx.h
 create mode 100644 arch/arm/plat-omap/include/plat/l3_3xxx.h
 create mode 100644 arch/arm/plat-omap/include/plat/l4_2xxx.h
 create mode 100644 arch/arm/plat-omap/include/plat/ti816x.h
 create mode 100644 drivers/hwspinlock/Kconfig
 create mode 100644 drivers/hwspinlock/Makefile
 create mode 100644 drivers/hwspinlock/hwspinlock_core.c
 create mode 100644 drivers/hwspinlock/hwspinlock_internal.h
 create mode 100644 drivers/hwspinlock/omap_hwspinlock.c
 create mode 100644 include/linux/hwspinlock.h

diff --cc arch/arm/mach-omap2/usb-musb.c
index 241fc94,a9d4d14..9c85758
mode 100644,100644..100755
--- a/arch/arm/mach-omap2/usb-musb.c
+++ b/arch/arm/mach-omap2/usb-musb.c
@@@ -212,12 -132,35 +132,37 @@@ void __init usb_musb_init(struct omap_m
  	musb_plat.mode = board_data->mode;
  	musb_plat.extvbus = board_data->extvbus;
  
- 	if (platform_device_register(&musb_device) < 0)
- 		printk(KERN_ERR "Unable to register HS-USB (MUSB) device\n");
+ 	if (cpu_is_omap3517() || cpu_is_omap3505()) {
+ 		oh_name = "am35x_otg_hs";
+ 		name = "musb-am35x";
+ 	} else {
+ 		oh_name = "usb_otg_hs";
+ 		name = "musb-omap2430";
+ 	}
+ 
+ 	oh = omap_hwmod_lookup(oh_name);
+ 	if (!oh) {
+ 		pr_err("Could not look up %s\n", oh_name);
+ 		return;
+ 	}
+ 
+ 	od = omap_device_build(name, bus_id, oh, &musb_plat,
+ 			       sizeof(musb_plat), omap_musb_latency,
+ 			       ARRAY_SIZE(omap_musb_latency), false);
+ 	if (IS_ERR(od)) {
+ 		pr_err("Could not build omap_device for %s %s\n",
+ 						name, oh_name);
+ 		return;
+ 	}
  
+ 	pdev = &od->pdev;
+ 	dev = &pdev->dev;
 +	if (cpu_is_omap44xx())
 +		omap4430_phy_init(dev);
- 
+ 	get_device(dev);
+ 	dev->dma_mask = &musb_dmamask;
+ 	dev->coherent_dma_mask = musb_dmamask;
+ 	put_device(dev);
  }
  
  #else
diff --cc drivers/usb/musb/musb_core.h
index 4f0dd2e,3fb617e..4bd9e21
mode 100644,100644..100755
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
