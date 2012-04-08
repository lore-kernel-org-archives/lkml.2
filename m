Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab2DHCKE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 22:10:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58885 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab2DHCKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 22:10:00 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 7 Apr 2012 19:09:38 -0700
X-Google-Sender-Auth: UNQ-s9K-n4pk4U15iP7uK4rJ4yI
Message-ID: <CA+55aFwbR10YVSbaa8RAKVxOkN-D+vyybMK1MfqwJWe-gbv1Og@mail.gmail.com>
Subject: Linux 3.4-rc2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc. It actually *felt* pretty calm, but
according to the numbers it's a fairly average -rc2, maybe it even has
slightly more changes than usual.

That said, there doesn't seem to be a lot of scary stuff. A fair
amount of the changes are some (hopefully largely final) fixups for
the header file changes, and then there are the three pull requests
mentioned in -the rc1 announcement: HSI (high-speed serial interface)
framework, dma-buf prime, and the DMA mapping stuff. Those three all
got several people piping up and saying "yes, please pull". Pohmelfs
didn't get merged, for the simple reason that nobody actually asked
for it.

Apart from the header file fixups and the three delayed pulls, there's
the usual fixes. I'm going to be stricter about pulls from here on
out, there was a lot of "noise", not just pure fixes. Some of it as
induced by me: a series of selinux patches by Eric Paris to make
selinux wrapper stack usage much better.

Bulk of changes in some architecture files (arm, tile, powerpc, x86)
and in drivers (especially a networking but also regulator, drm and
mmc). And some power management updates.

Shortlog is appended. And I'm hoping -rc3 will already have a
noticeably shorter shortlog.

                  Linus

----
Aaro Koskinen (1):
      sparc: pgtable_64: change include order

Akinobu Mita (1):
      rionet: fix page allocation order of rionet_active

Al Cooper (1):
      mmc: Prevent 1.8V switch for SD hosts that don't support UHS modes.

Alan Stern (1):
      PM / Runtime: don't forget to wake up waitqueue on failure

Alex Deucher (1):
      drm/radeon/kms: fix fans after resume

Alexander Duyck (1):
      ixgbe: Fix issues with SR-IOV loopback when flow control is disabled

Alexander Graf (3):
      KVM: PPC: Book3S: Compile fix for ppc32 in HIOR access code
      KVM: PPC: Save/Restore CR over vcpu_run
      KVM: PPC: Book3S: PR: Fix preemption

Alf Høgemark (1):
      mmc: sdhci-dove: Fix compile error by including module.h

Ameya Palande (1):
      ARM: OMAP4: clock data: fix mult and div mask for USB_DPLL

Andi Kleen (1):
      x86: Use -mno-avx when available

Andras Domokos (3):
      HSI: hsi_char: Add HSI char device driver
      HSI: hsi_char: Add HSI char device kernel configuration
      HSI: hsi_char: Update ioctl-number.txt

Andre Przywara (1):
      hwmon: (k10temp) Add support for AMD Trinity CPUs

Andreas Mohr (1):
      via-rhine: fix wait-bit inversion.

Andrew Morton (4):
      net/netfilter/nfnetlink_acct.c: use linux/atomic.h
      powerpc/eeh: Fix use of set_current_state() in eeh event
handling set_current_state() wart
      fs/xattr.c:listxattr(): fall back to vmalloc() if kmalloc() failed
      fs/xattr.c:setxattr(): improve handling of allocation failures

Andrzej Pietrasiewicz (8):
      X86 & IA64: adapt for dma_map_ops changes
      MIPS: adapt for dma_map_ops changes
      PowerPC: adapt for dma_map_ops changes
      SPARC: adapt for dma_map_ops changes
      Alpha: adapt for dma_map_ops changes
      SH: adapt for dma_map_ops changes
      Microblaze: adapt for dma_map_ops changes
      Unicore32: adapt for dma_map_ops changes

Anisse Astier (1):
      drm/i915: no-lvds quirk on MSI DC500

Anton Vorontsov (1):
      sysrq: use SEND_SIG_FORCED instead of force_sig()

Artem Savkov (1):
      r8169: enable napi on resume.

Ashish Jangam (1):
      backlight: add driver for DA9052/53 PMIC v1

Axel Lin (13):
      regulator: tps6586x: Fix list minimal voltage setting for LDO0
      regulator: Fix set and get current limit for wm831x_buckv
      regulator: Fix unbalanced lock/unlock in mc13892_regulator_probe
error path
      regulator: Fix restoring pmic.dcdcx_hib_mode settings in
wm8350_dcdc_set_suspend_enable
      regulator: Do proper shift to set correct bit for DC[2|5]_HIB_MODE setting
      regulator: wm831x-dcdc: Fix the logic to choose best current limit setting
      regulator: wm831x-isink: Fix the logic to choose best current
limit setting
      regulator: wm8350: Fix the logic to choose best current limit setting
      regulator: Return microamps in wm8350_isink_get_current
      regulator: Fix setting low power mode for wm831x aldo
      regulator: Only update [LDOx|DCx]_HIB_MODE bits in
wm8350_[ldo|dcdc]_set_suspend_disable
      regulator: Fix comments in include/linux/regulator/machine.h
      regulator: Fix setting new voltage in s5m8767_set_voltage

Balaji T K (3):
      mmc: omap_hsmmc: use runtime put sync in probe error patch
      mmc: omap_hsmmc: context save after enabling runtime pm
      mmc: omap_hsmmc: fix module re-insertion

Ben Hutchings (6):
      ethtool: Remove exception to the requirement of holding RTNL lock
      doc, net: Remove obsolete reference to dev->poll
      doc, net: Update documentation of synchronisation for TX multiqueue
      doc, net: Update netdev operation names
      doc, net: Remove instruction to set net_device::trans_start
      doc, net: Update ndo_start_xmit return type and values

Ben Skeggs (3):
      drm/nouveau: oops, create m2mf for nvd9 too
      Revert "drm/nouveau: inform userspace of new kernel subchannel
requirements"
      drm/nouveau: inform userspace of relaxed kernel subchannel requirements

Benjamin Herrenschmidt (3):
      powerpc/kvm: Fallout from system.h disintegration
      nouveau: Fix crash when pci_ram_rom() returns a size of 0
      nouveau/bios: Fix tracking of BIOS image data

Benjamin LaHaise (2):
      net/ipv4: fix IPv4 multicast over network namespaces
      net/core: dev_forward_skb() should clear skb_iif

Bob Copeland (1):
      ath5k: drop self from MAINTAINERS

Bob Liu (2):
      blackfin: gpio: fix compile error if !CONFIG_GPIOLIB
      blackfin: update defconfig for bf527-ezkit

Borislav Petkov (1):
      MCE, AMD: Drop too granulary family model checks

Bruce Allan (1):
      e1000e: prevent oops when adapter is being closed and reset simultaneously

Carlos Chinea (2):
      HSI: hsi: Introducing HSI framework
      HSI: Add HSI API documentation

Chris Ball (2):
      Revert "mmc: sdhci-pci: add quirks for broken MSI on O2Micro controllers"
      Revert "mmc: sdhci-pci: Add MSI support"

Chris Metcalf (38):
      arch/tile/Kconfig: remove pointless "!M386" test.
      arch/tile/Kconfig: rename tile_defconfig to tilepro_defconfig
      arch/tile/Kconfig: don't specify CONFIG_PAGE_OFFSET for 64-bit builds
      arch/tile: fix typo in <arch/spr_def.h>
      arch/tile: revert comment for atomic64_add_unless().
      arch/tile: fix gcc 4.6 warnings in <asm/bitops_64.h>
      arch/tile: use 0 for IRQ_RESCHEDULE instead of 1
      arch/tile: avoid false corrupt frame warning in early boot
      arch/tile: make sure to build memcpy_user_64 without frame pointer
      arch/tile: various bugs in stack backtracer
      arch/tile: work around a hardware issue with the return-address stack
      arch/tile: fix up some minor trap handling issues
      arch/tile: fix a couple of comments that needed updating
      arch/tile/Makefile: use KCFLAGS when figuring out the libgcc path.
      arch/tile: don't wait for migrating PTEs in an NMI handler
      arch/tile: don't set the homecache of a PTE unless appropriate
      arch/tile: don't enable irqs unconditionally in page fault handler
      arch/tile: fix bug in loading kernels larger than 16 MB
      arch/tile: fix bug in delay_backoff()
      arch/tile: don't leak kernel memory when we unload modules
      arch/tile: fix up locking in pgtable.c slightly
      arch/tile: use proper memparse() for "maxmem" options
      arch/tile: add "nop" after "nap" to help GX idle power draw
      arch/tile: implement panic_smp_self_stop()
      arch/tile: fix single-stepping over swint1 instructions on tilegx
      arch/tile: fix pointer cast in cacheflush.c
      arch/tile: export the page_home() function.
      arch/tile: stop mentioning the "kvm" subdirectory
      arch/tile: use atomic exchange in arch_write_unlock()
      arch/tile: fix finv_buffer_remote() for tilegx
      arch/tile: return SIGBUS for addresses that are unaligned AND invalid
      arch/tile: remove bogus performance optimization
      arch/tile: avoid accidentally unmasking NMI-type interrupt accidentally
      edac: say "TILEGx" not "TILEPro" for the tilegx edac driver
      tile-srom.c driver: minor code cleanup
      tilepro ethernet driver: fix a few minor issues
      MAINTAINERS: update EDAC information
      drivers/net/ethernet/tile: fix netdev_alloc_skb() bombing

Chris Wilson (3):
      drm/i915: Sanitize BIOS debugging bits from PIPECONF
      drm/i915: Mark untiled BLT commands as fenced on gen2/3
      drm: Validate requested virtual size against allocated fb size

Christopher Li (1):
      MAINTAINERS: add entry for sparse checker

Colin Cross (1):
      ARM: EXYNOS: fix CONFIG_DEBUG_LL

Dan Carpenter (2):
      mISDN: array underflow in open_bchannel()
      cifs: writing past end of struct in cifs_convert_address()

Daniel Vetter (6):
      drm/i915: properly restore the ppgtt page directory on resume
      drm/i915: quirk away broken OpRegion VBT
      drm/i915: apply CS reg readback trick against missed IRQ on snb
      drm/i915: properly clear SSC1 bit in the pch refclock init code
      drm/i915: disable ppgtt on snb when dmar is enabled
      drm/i915: don't leak struct_mutex lock on ppgtt init failures

Dave Airlie (2):
      drm: base prime/dma-buf support (v5)
      drm/nouveau: select POWER_SUPPLY

Dave Jones (1):
      fs/xattr.c: suppress page allocation failure warnings from sys_listxattr()

Dave Liu (1):
      powerpc/qe: Update the SNUM table for MPC8569 Rev2.0

David Ward (1):
      net/garp: avoid infinite loop if attribute already exists

David Woodhouse (1):
      ppp: Don't stop and restart queue on every TX packet

Diana CRACIUN (1):
      powerpc/dts: Removed fsl,msi property from dts.

Dima Zavin (1):
      ARM: EXYNOS: use chip_id reg in uncompress to select uart base phys

Dmitry Kravkov (1):
      bnx2x: fix vector traveling while looking for an empty entry

Don Skidmore (2):
      ixgbe: fix typo in enumeration name
      ixgbe: update version number

Eliad Peller (1):
      mac80211: remove outdated comment

Eric Dumazet (9):
      ath9k: fix a memory leak in ath_rx_tasklet()
      eql: dont rely on HZ=100
      f_phonet: fix skb truesize underestimation
      cdc-phonet: fix skb truesize underestimation
      net: fix /proc/net/dev regression
      tcp: allow splice() to build full TSO packets
      tcp: tcp_sendpages() should call tcp_push() once
      netlink: fix races after skb queueing
      net: fix a race in sock_queue_err_skb()

Eric Paris (5):
      LSM: shrink sizeof LSM specific portion of common_audit_data
      LSM: shrink the common_audit_data data union
      SELinux: remove avd from selinux_audit_data
      SELinux: remove avd from slow_avc_audit()
      SELinux: do not allocate stack space for AVC data unless needed

Eugeni Dodonov (3):
      drm/i915: allow to select rc6 modes via kernel parameter
      drm/i915: enable plain RC6 on Sandy Bridge by default
      drm/i915: add Ivy Bridge GT2 Server entries

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

Felipe Balbi (3):
      mmc: omap_hsmmc: trivial cleanups
      mmc: omap_hsmmc: make it behave well as a module
      mmc: omap_hsmmc: convert to module_platform_driver

Fernando Luis Vazquez Cao (1):
      TCP: update ip_local_port_range documentation

Geert Uytterhoeven (2):
      m68k/mac: Add missing platform check before registering platform devices
      m68k/q40: Add missing platform check before registering platform devices

Gleb Natapov (1):
      KVM: Resolve RCU vs. async page fault problem

Govindraj.R (1):
      ARM: OMAP2+: omap_hwmod: Allow io_ring wakeup configuration for
all modules

Graeme Smecher (1):
      hwmon: (ad7314) Adds missing spi_dev initialization

Grazvydas Ignotas (2):
      ARM: OMAP3xxx: HSMMC: avoid erratum workaround when transceiver
is attached
      ARM: OMAP3xxx: clock data: fix DPLL4 CLKSEL masks

Greg Ungerer (1):
      m68k: include asm/cmpxchg.h in our m68k atomic.h

Guan Xin (1):
      USB: Add Motorola Rokr E6 Id to the USBNet driver "zaurus"

Guenter Roeck (4):
      hwmon: (gpio-fan) Fix Kconfig dependencies
      hwmon: (sht15) Fix Kconfig dependencies
      hwmon: (f75375s) Fix warning message seen in some configurations
      hwmon: (adm1031) Fix compiler warning

Hillf Danton (1):
      hugetlbfs: remove unregister_filesystem() when initializing module

Igor Grinberg (1):
      ARM: OMAP: fix section mismatches in usb-host.c

Igor Mammedov (1):
      xen: only check xen_platform_pci_unplug if hvm

Igor Murzov (1):
      MAINTAINERS: Update git url for ACPI

Il Han (1):
      ARM: EXYNOS: fix ISO C90 warning

Ilya Yanok (1):
      ARM: OMAP AM3517/3505: clock data: change EMAC clocks aliases

Jan Beulich (3):
      netfilter: xt_LOG: don't use xchg() for simple assignment
      xen/pciback: fix XEN_PCI_OP_enable_msix result
      xen/pcifront: avoid pci_frontend_enable_msix() falsely returning success

Jan Engelhardt (1):
      netfilter: ipset: avoid use of kernel-only types

Jan Seiffert (2):
      bpf jit: Make the filter.c::__load_pointer helper non-static for the jits
      bpf jit: Let the x86 jit handle negative offsets

Jason Wessel (6):
      kdb: Fix smatch warning on dbg_io_ops->is_console
      kgdbts: Fix kernel oops with CONFIG_DEBUG_RODATA
      kgdbts: (1 of 2) fix single step awareness to work correctly with SMP
      kgdbts: (2 of 2) fix single step awareness to work correctly with SMP
      kgdb,debug_core: pass the breakpoint struct instead of address and memory
      x86,kgdb: Fix DEBUG_RODATA limitation using text_poke()

Javier Martin (1):
      MX2: Fix mx2_camera clock regression.

Jeff Layton (1):
      cifs: silence compiler warnings showing up with gcc-4.7.0

Jerry Huang (2):
      powerpc/85xx: add the P1020MBG-PC DTS support
      powerpc/85xx: add the P1020UTM-PC DTS support

Jes Sorensen (1):
      md: Avoid OOPS when reshaping raid1 to raid0

Jesse Barnes (1):
      drm/i915: treat src w & h as fixed point in sprite handling code

Jett.Zhou (1):
      drivers/rtc/rtc-88pm860x.c: fix rtc irq enable callback

Jiri Pirko (1):
      e1000: fix vlan processing regression

Joe Perches (1):
      MAINTAINERS: fix REMOTEPROC F: typo

John W. Linville (1):
      cfg80211: allow CFG80211_SIGNAL_TYPE_UNSPEC in station_info

Julia Lawall (2):
      scripts/coccinelle/api/simple_open.cocci: semantic patch for simple_open()
      mmc: sdhci-s3c: use devm_ functions

Kees Cook (1):
      sysctl: fix write access to dmesg_restrict/kptr_restrict

Kenth Eriksson (1):
      Fix non TBI PHY access; a bad merge undid bug fix in a previous commit.

Konrad Rzeszutek Wilk (1):
      xen/x86: Workaround 'x86/ioapic: Add register level checks to
detect bogus io-apic entries'

Konstantin Khlebnikov (1):
      mm, drm/udl: fixup vma flags on mmap

Kukjin Kim (2):
      ARM: S3C24XX: fix missing common.h in mach-s3c24xx/
      EXYNOS: fix dependency for EXYNOS_CPUFREQ

Kyle McMartin (1):
      hwmon: (acpi_power_meter) fix lockdep spew due to non-static lock class

Larry Finger (1):
      rtlwifi: rtl8192ce: rtl8192cu: rtl8192de: Fix low-gain setting
when scanning

Lars-Peter Clausen (1):
      regmap: rbtree: Fix register default look-up in sync

Len Brown (1):
      x86: Remove the ancient and deprecated disable_hlt() and
enable_hlt() facility

Lino Sanfilippo (1):
      sky2: dont overwrite settings for PHY Quick link

Linus Torvalds (4):
      lsm_audit: don't specify the audit pre/post callbacks in 'struct
common_audit_data'
      Revert "nouveau/bios: Fix tracking of BIOS image data"
      Make the "word-at-a-time" helper functions more commonly usable
      Linux 3.4-rc2

Liu, Chuansheng (1):
      x86: Preserve lazy irq disable semantics in fixup_irqs()

Ludovic Desroches (4):
      ARM: at91: dt: remove unit-address part for memory nodes
      mmc: atmel-mci: correct data timeout computation
      mmc: atmel-mci: r/w proof capability only available since v2xx
      mmc: atmel-mci: add support for odd clock dividers

Manuel Lauss (1):
      mmc: sdhci-pci: add quirks for broken MSI on O2Micro controllers

Marc Kleine-Budde (1):
      stmmac: re-add IFF_UNICAST_FLT for dwmac1000

Marcelo Tosatti (2):
      x86, kvm: Call restore_sched_clock_state() only after %gs is initialized
      KVM: VMX: vmx_set_cr0 expects kvm->srcu locked

Marek Szyprowski (6):
      common: dma-mapping: introduce generic alloc() and free() methods
      Hexagon: adapt for dma_map_ops changes
      common: dma-mapping: remove old alloc_coherent and free_coherent methods
      common: dma-mapping: introduce mmap method
      common: DMA-mapping: add WRITE_COMBINE attribute
      common: DMA-mapping: add NON-CONSISTENT attribute

Mark A. Greer (2):
      arm: omap3: pm34xx.c: Fix omap3_pm_init() error out paths
      arm: omap3: pm34xx.c: Replace printk() with appropriate pr_*()

Mark Brown (5):
      regulator: Fix deadlock on removal of regulators with supplies
      hwmon: (max6639) Convert to dev_pm_ops
      regmap: Export regcache_sync_region()
      mmc: sdhci-s3c: Use CONFIG_PM_SLEEP to ifdef system suspend
      mmc: sdhci-s3c: Enable runtime power management

Mark Rustad (2):
      tcm_fc: Add abort flag for gracefully handling exchange timeout
      tcm_fc: Do not free tpg structure during wq allocation failure

Matt Carlson (1):
      tg3: Fix 5717 serdes powerdown problem

Matt Fleming (2):
      alpha: use set_current_blocked() and block_sigmask()
      C6X: use set_current_blocked() and block_sigmask()

Matthew Vick (1):
      e1000e: Guarantee descriptor writeback flush success.

Michal Hocko (1):
      memcg swap: use mem_cgroup_uncharge_swap fix

Michal Simek (6):
      microblaze: Fix __futex_atomic_op macro register usage
      microblaze: Fix tlb_skip variable on noMMU system
      microblaze: Fix stack usage in PAGE_SIZE copy_tofrom_user
      microblaze: Add missing headers caused by disintegration asm/system.h
      microblaze: Do not use tlb_skip in early_printk
      microblaze: Fix ret_from_fork declaration

Michel Dänzer (1):
      drm/radeon: Don't dereference possibly-NULL pointer.

Mike Frysinger (1):
      blackfin: fix L1 data A overflow link issue

Ming Lei (1):
      ARM: OMAP3+: fix oops triggered in omap_prcm_register_chain_handler(v1)

Multanen, Eric W (1):
      ixgbe: driver fix for link flap

MyungJoo Ham (1):
      PM / QoS: add pm_qos_update_request_timeout() API

NeilBrown (3):
      APM: fix deadlock in APM_IOC_SUSPEND ioctl
      md/raid5: fix handling of bad blocks during recovery.
      md/raid1,raid10: don't compare excess byte during consistency check.

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

Nobuhiro Iwamatsu (1):
      net: sh_eth: Add support SH7734

Oleg Nesterov (2):
      tracing, sched, vfs: Fix 'old_pid' usage in trace_sched_process_exec()
      powerpc/eeh: Remove eeh_event_handler()->daemonize()

Pablo Neira Ayuso (4):
      netfilter: xt_CT: remove a compile warning
      netfilter: xt_CT: allocation has to be GFP_ATOMIC under
rcu_read_lock section
      netfilter: xt_CT: fix missing put timeout object in error path
      netfilter: nf_conntrack: fix count leak in error path of
__nf_conntrack_alloc

Paul Gortmaker (12):
      irq_work: fix compile failure on MIPS from system.h split
      tile: fix multiple build failures from system.h dismantle
      ARM: mach-msm: fix compile fail from system.h fallout
      avr32: fix build failures from mis-naming of atmel_nand.h
      blackfin: fix cmpxchg build fails from system.h fallout
      parisc: fix missing cmpxchg file error from system.h split
      frv: fix warnings in mb93090-mb00/pci-dma.c about implicit EXPORT_SYMBOL
      firewire: restore the device.h include in linux/firewire.h
      asm-generic: add linux/types.h to cmpxchg.h
      ARM: versatile: fix build failure in pci.c
      ARM: fix lcd power build failure in collie_defconfig
      avr32: fix nop compile fails from system.h split up

Paul Mackerras (2):
      KVM: PPC: Book3S HV: Fix kvm_alloc_linear in case where no linears exist
      KVM: PPC: Book3S HV: Save and restore CR in __kvmppc_vcore_entry

Paul Mundt (5):
      sh: fix up fallout from system.h disintegration.
      sh: dwarf unwinder depends on SHcompact.
      sh: dma: Fix up device attribute mismatch from sysdev fallout.
      sh: vsyscall: Fix up .eh_frame generation.
      serial: sh-sci: use serial_port_in/out vs sci_in/out.

Paul Walmsley (4):
      ARM: OMAP44xx: clockdomain data: correct the emu_sys_clkdm CLKTRCTRL data
      ARM: OMAP4: hwmod data: Add aliases for McBSP fclk clocks
      ARM: OMAP3: clock data: fill in some missing clockdomains
      mmc: use really long write timeout to deal with crappy cards

Pavel Shilovsky (2):
      CIFS: Fix VFS lock usage for oplocked files
      CIFS: Fix VFS lock usage for oplocked files

Peter Zijlstra (1):
      perf/x86/p4: Add format attributes

Phil Sutter (2):
      wimax: i2400m - prevent a possible kernel bug due to missing
fw_name string
      wimax: i2400m-usb - use a private struct ethtool_ops

R Sricharan (1):
      ARM: OMAP2+: Fix omap2+ build error

Rabin Vincent (1):
      net: usb: cdc_eem: fix mtu

Rafael J. Wysocki (7):
      firmware_class: Rework usermodehelper check
      firmware_class: Split _request_firmware() into three functions, v2
      firmware_class: Do not warn that system is not ready from async loads
      PM / Hibernate: Disable usermode helpers right before freezing tasks
      PM / Sleep: Move disabling of usermode helpers to the freezer
      PM / Sleep: Mitigate race between the freezer and request_firmware()
      mmc: sdio: Use empty system suspend/resume callbacks at the bus level

Rajendra Nayak (4):
      ARM: OMAP: hwmod: Use sysc_fields->srst_shift and get rid of
hardcoded SYSC_TYPE2_SOFTRESET_MASK
      ARM: OMAP4: clock data: Force a DPLL clkdm/pwrdm ON before a relock
      ARM: OMAP2+: hwmod: Restore sysc after a reset
      ARM: OMAP2+: hwmod: Make omap_hwmod_softreset wait for reset status

Rajkumar Manoharan (3):
      ath9k: fix max noise floor threshold
      ath9k: reduce listen time period
      mac80211: fix oper channel timestamp updation

Rick Jones (1):
      virtio_net: do not rate limit counter increments

Rob Herring (1):
      ARM: fix __io macro for PCMCIA

RongQing.Li (1):
      ipv6: fix array index in ip6_mc_add_src()

Russ Dill (6):
      regulator: Remove non-existent parameter from fixed-helper.c kernel doc
      ARM: OMAP2+: smsc911x: Remove odd gpmc_cfg/board_data redirection
      ARM: OMAP2+ smsc911x: Fix possible stale smsc911x flags
      ARM: OMAP2+: smsc911x: Remove unused rate calculation
      ARM: OMAP2+: smsc911x: Remove regulator support from gmpc-smsc911x
      ARM: OMAP2+: smsc911x: Add fixed board regulators

Russell King (4):
      ARM: sa11x0: fix build errors from DMA engine API updates
      ARM: fix missing bug.h include in arch/arm/kernel/insn.c
      ARM: fix bios32.c build warning
      ARM: fix more fallout from 9f97da78bf (Disintegrate asm/system.h for ARM)

Rusty Russell (4):
      remove references to cpu_*_map in arch/
      drivers/cpufreq/db8500-cpufreq: remove references to cpu_*_map.
      documentation: remove references to cpu_*_map.
      cpumask: remove old cpu_*_map.

Sachin Kamat (1):
      ARM: EXYNOS: Fix compiler warning in dma.c file

Sachin Prabhu (2):
      Remove unnecessary check for NULL in password parser
      Fix UNC parsing on mount

Sam Ravnborg (1):
      serial/sunzilog: fix keyboard on SUN SPARCstation

Santosh Nayak (1):
      net: orinoco: add error handling for failed kmalloc().

Santosh Shilimkar (2):
      ARM: OMAP4: Workaround the OCP synchronisation issue with 32K synctimer.
      ARM: OMAP2+: powerdomain: Wait for powerdomain transition in
pwrdm_state_switch()

Sasha Levin (1):
      phonet: Check input from user before allocating

Sasikantha babu (1):
      KVM: PMU: Fix integer constant is too large warning in kvm_pmu_set_msr()

Sean Paul (1):
      drm/i915: Add lock on drm_helper_resume_force_mode

Shaveta Leekha (1):
      powerpc/85xx: Enable I2C_CHARDEV and I2C_MPC options in defconfigs

Shawn Guo (1):
      regulator: fix sysfs name collision between dummy and fixed
dummy regulator

Shimoda, Yoshihiro (1):
      sh: fix clock-sh7757 for the latest sh_mobile_sdhi driver

Shlomo Pongratz (2):
      net/bonding: emit address change event also in bond_release
      net/bonding: correctly proxy slave neigh param setup ndo function

Shmulik Ladkani (1):
      ipv6: Fix RTM_GETROUTE's interpretation of RTA_IIF to be
consistent with ipv4

Simon Horman (3):
      mmc: sh_mmcif: double clock speed
      mmc: sh_mmcif: mmc->f_max should be half of the bus clock
      mmc: sh_mmcif: Simplify calculation of mmc->f_min

Srinivas Kandagatla (1):
      phy:icplus:fix Auto Power Saving in ip101a_config_init.

Srivatsa S. Bhat (1):
      xen/smp: Remove unnecessary call to smp_processor_id()

Stanislav Yakovlev (2):
      net/wireless: ipw2x00: fix a typo in wiphy struct initilization
      MAINTAINERS: adding maintainer for ipw2x00

Stanislaw Gruszka (5):
      iwlegacy: do not nulify il->vif on reset
      iwlegacy: fix BSSID setting
      rt2x00: rt2800usb: schedule txdone work on timeout
      rt2x00: rt2800usb: fix status register reread logic
      mac80211: fix possible tid_rx->reorder_timer use after free

Steffen Klassert (6):
      padata: Add a reference to the api documentation
      padata: Use the online cpumask as the default
      padata: Fix cpu hotplug
      crypto: pcrypt - Use the online cpumask as the default
      crypto: user - Fix lookup of algorithms with IV generator
      crypto: user - Fix size of netlink dump message

Stephen Boyd (5):
      firmware_class: Reorganize fw_create_instance()
      firmware_class: Move request_firmware_nowait() to workqueues
      Subject: [PATCH] tags.sh: Add missing quotes
      libfs: add simple_open()
      simple_open: automatically convert to simple_open()

Stephen Rothwell (1):
      powerpc: Fix fallout from system.h split up

Stephen Warren (3):
      gpio: tegra: fix register address calculations for Tegra30
      gpio: tegra: Iterate over the correct number of banks
      regmap: prevent division by zero in rbtree_show

Steve French (1):
      Revert "CIFS: Fix VFS lock usage for oplocked files"

Subhash Jadavani (2):
      mmc: bus: print bus speed mode of UHS-I card
      mmc: core: fix power class selection

Sujith Manoharan (1):
      ath9k: Use HW HT capabilites properly

Tero Kristo (1):
      ARM: OMAP4: prm: fix interrupt register offsets

Thadeu Lima de Souza Cascardo (1):
      mlx4: allocate just enough pages instead of always 4 pages

Thomas Abraham (3):
      mmc: sdhci-s3c: Remove usage of clk_type member in platform data
      mmc: sdhci-s3c: derive transfer width host cap from max_width in platdata
      mmc: sdhci-s3c: Keep a copy of platform data and use it

Thomas Graf (1):
      sctp: Allow struct sctp_event_subscribe to grow without breaking binaries

Timur Tabi (2):
      powerpc/8xxx: remove 85xx/86xx restrictions from fsl_guts.h
      powerpc/epapr: add "memory" as a clobber to all hypercalls

Tony Luck (1):
      ACPI processor: Use safe_halt() rather than halt() in
acpi_idle_play_dead()

Toshi Kani (1):
      cpuidle: Fix panic in CPU off-lining with no idle driver

Ulf Hansson (1):
      mmc: block: Remove use of mmc_blk_set_blksize

Uwe Kleine-König (2):
      hwmon: (w83627ehf) mark const init data with __initconst instead
of __initdata
      powerpc: Mark const init data with __initconst instead of __initdata

Vaibhav Hiremath (1):
      ARM: OMAP2+: hwmod: Fix wrong SYSC_TYPE1_XXX_MASK bit definitions

Vasiliy Kulikov (1):
      proc: fix mount -t proc -o AAA

Veaceslav Falico (1):
      bonding: properly unset current_arp_slave on slave link up

Weiping Pan (1):
      bonding: emit event when bonding changes MAC

Will Deacon (1):
      ARM: 7337/1: ptrace: fix ptrace_read_user for !CONFIG_MMU platforms

Yaniv Rosner (10):
      bnx2x: PFC fix
      bnx2x: Fix BCM57810-KR FC
      bnx2x: Fix BCM57810-KR AN speed transition
      bnx2x: Fix BCM578x0-SFI pre-emphasis settings
      bnx2x: Restore 1G LED on BCM57712+BCM8727 designs.
      bnx2x: Fix link issue for BCM8727 boards.
      bnx2x: Fix BCM84833 PHY FW version presentation
      bnx2x: Clear BCM84833 LED after fan failure
      bnx2x: Fix BCM57711+BCM84823 link issue
      bnx2x: Clear MDC/MDIO warning message

Yi Zou (2):
      net: do not do gso for CHECKSUM_UNNECESSARY in netif_needs_gso
      fcoe: use CHECKSUM_UNNECESSARY instead of CHECKSUM_PARTIAL on tx

Ying-Chun Liu (PaulLiu) (1):
      regulator: anatop: patching to device-tree property "reg".

Yoshihiro Shimoda (1):
      net: sh_eth: fix endian check for architecture independent

Yuval Mintz (2):
      bnx2x: previous driver unload revised
      bnx2x: correction to firmware interface

danborkmann@iogearbox.net (1):
      rose_dev: fix memcpy-bug in rose_set_mac_address

huajun li (1):
      usb/rtl8150 : Remove duplicated definitions

majianpeng (5):
      md/linear: If md_integrity_register() fails, linear_run() must
free the mem.
      md/raid0: If md_integrity_register() fails, raid0_run() must free the mem.
      md/raid1: If md_integrity_register() failed,run() must free the mem
      md/raid1:Remove unnecessary rcu_dereference(conf->mirrors[i].rdev).
      md/raid5: Fix a bug about judging if the operation is syncing or replacing

stephen hemminger (3):
      intel: make wired ethernet driver message level consistent (rev2)
      sky2: copy received packets on inefficient unaligned architecture
      MAINTAINERS: update for Marvell Ethernet drivers

stigge@antcom.de (1):
      net: lpc_eth: Fix rename of dev_hw_addr_random

zhuangfeiran@ict.ac.cn (1):
      x86 bpf_jit: fix a bug in emitting the 16-bit immediate operand of AND
