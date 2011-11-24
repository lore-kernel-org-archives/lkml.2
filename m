Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab1KXE7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 23:59:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62872 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab1KXE7G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 23:59:06 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 Nov 2011 20:58:42 -0800
X-Google-Sender-Auth: P_e6rthScEZtwVGPza5aGrjNCN4
Message-ID: <CA+55aFyNUC+k1gp3MQkxQzernEzRZwYOH4EBnOq=6UiaJ2oh4A@mail.gmail.com>
Subject: Linux 3.2-rc3 - just in time for Thanksgiving
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, since most of the US will be in a food-induced coma tomorrow, I
just *know* that doing a new release candidate is a good idea.

One quarter arch updates, two quarters drivers, and one quarter random
changes. Shake vigorously and serve cold..

And maybe the rest of the world can try to make up for the lack of any
expected US participation? Hmm?

Anyway, whether you will be stuffing yourself with turkey tomorrow or
not, there's a new -rc out. I'd love to say that things have been
calming down, and that the number of commits just keep shrinking, but
I'd be lying. -rc3 is actually bigger than -rc2, mainly due to a
network update (none in -rc2) and with Greg doing his normal
usb/driver-core/tty/staging thing.

We also had a drm update.

That said, most of the commits are pretty small and reasonable. So
there's certainly more churn than I'd like, but it's not like it's a
lot of big changes, there's just a fair number of small things going
on. The shortlog (appended) gives a fair flavor of the details.

                              Linus

---

Aaro Koskinen (2):
      Input: ams_delta_serio - include linux/module.h
      MIPS: errloongson2_clock: Fix build error by including linux/module.h

Adam Jackson (1):
      drm/i915: intel_choose_pipe_bpp_dither messages should be DRM_DEBUG_KMS

Afzal Mohammed (1):
      regulator: TPS65910: Fix VDD1/2 voltage selector count

Al Cooper (1):
      MIPS: Kernel hangs occasionally during boot.

Al Viro (12):
      powerpc: Fix build breakage in jump_label.c
      carma-fpga: Missed switch from of_register_platform_driver()
      powerpc/fsl_udc_core: Fix dumb typo
      powerpc/fsl: MCU_MPC8349EMITX wants I2C built-in, modular won't do...
      btrfs: fix double mntput() in mount_subvol()
      switch create_mnt_ns() to saner calling conventions, fix double
mntput() in nfs
      new helper: mount_subtree()
      minixfs: kill manual hweight(), simplify
      fix braino in um patchset (mea culpa)
      microblaze: bury asm/namei.h
      iio: fix a leak due to improper use of anon_inode_getfd()
      mount_subtree() pointless use-after-free

Alan Cox (1):
      serial,mfd: Fix CMSPAR setup

Alan Stern (4):
      USB: workaround for bug in old version of GCC
      USB: XHCI: resume root hubs when the controller resumes
      usb-storage: Accept 8020i-protocol commands longer than 12 bytes
      OHCI: final fix for NVIDIA problems (I hope)

Alex Deucher (5):
      drm/radeon: add some missing FireMV pci ids
      drm/radeon/kms: fix up gpio i2c mask bits for r4xx
      drm/radeon/kms: fix segfault in pm rework
      drm/radeon/kms: fix up gpio i2c mask bits for r4xx for real
      drm/radeon/kms/atom: unify i2c gpio table handling

Alex Elder (1):
      MAINTAINERS: update XFS maintainer entry

Alexander Aring (1):
      usb: gadget: fsl_udc_core: fix compile error.

Alexander Beregalov (1):
      libata: fix build without BMDMA

Alexander Graf (1):
      Revert "KVM: PPC: Add support for explicit HIOR setting"

Amitkumar Karwar (1):
      mwifiex: fix association issue with AP configured in hidden SSID mode

Andrew Worsley (1):
      USB: Fix Corruption issue in USB ftdi driver ftdi_sio.c

Andrey Vagin (1):
      bridge: Fix potential deadlock on br->multicast_lock

Andrzej Kaczmarek (1):
      Bluetooth: Use miliseconds for L2CAP channel timeouts

Anton Blanchard (2):
      powerpc: panic if we can't instantiate RTAS
      powerpc: Copy down exception vectors after feature fixups

Arek Lichwa (1):
      Bluetooth: Revert: Fix L2CAP connection establishment

Arend van Spriel (1):
      brcm80211: smac: eliminate a null pointer dereference in dma.c

Arnaud Lacombe (1):
      arch/unicore32: do not use EXTRA_AFLAGS or EXTRA_CFLAGS

Arnd Hannemann (1):
      Btrfs: prefix resize related printks with btrfs:

Avi Kivity (1):
      KVM guest: prevent tracing recursion with kvmclock

Axel Lin (3):
      PM / devfreq: fix use after free in devfreq_remove_device
      pcie-gadget-spear: Add "platform:" prefix for platform modalias
      rtc: rtc-puv3: Add __devinit and __devexit markers for probe and remove

Bart Hartgers (1):
      USB: ark3116 initialisation fix

Bartlomiej Zolnierkiewicz (3):
      piix: ICH7 MWDMA1 errata
      icside: DMA support fix
      cy82c693: fix PCI device selection

Ben Hutchings (2):
      block: Always check length of all iov entries in blk_rq_map_user_iov()
      sparc: sigutil: Include <linux/errno.h>

Ben Widawsky (1):
      drm/i915: forcewake warning fixes in debugfs

Benjamin Herrenschmidt (1):
      powerpc: Fix atomic_xxx_return barrier semantics

Bjorn Helgaas (1):
      PCI hotplug: shpchp: don't blindly claim non-AMD 0x7450 device IDs

Brian Haley (1):
      ipv6: drop packets when source address is multicast

Casey Schaufler (1):
      Smack: smackfs cipso seq read repair

Catalin Marinas (1):
      ARM: 7150/1: Allow kernel unaligned accesses on ARMv6+ processors

Charles Chin (1):
      ALSA: hda - pwr_nids cleanup for IDT codecs

Chris Mason (2):
      Btrfs: fix barrier flushes
      Btrfs: remove free-space-cache.c WARN during log replay

Christian Borntraeger (3):
      qeth: remove WARN_ON leftover
      KVM: s390: Fix tprot locking
      KVM: s390: announce SYNC_MMU

Claudio Scordino (2):
      RS485: fix inconsistencies in the meaning of some variables
      drivers/base/node.c: fix compilation error with older versions of gcc

Cornelia Huck (2):
      KVM: s390: Fix RUNNING flag misinterpretation
      KVM: s390: handle SIGP sense running intercepts

Dan Carpenter (7):
      drm/i915: fix if statement (bogus semi-colon)
      [SCSI] mpt2sas: add missing allocation.
      bio: change some signed vars to unsigned
      paride: fix potential information leak in pg_read()
      xen-gntdev: integer overflow in gntdev_alloc_map()
      xen-gntalloc: integer overflow in gntalloc_ioctl_alloc()
      xen-gntalloc: signedness bug in add_grefs()

Daniel De Graaf (2):
      xen: Remove hanging references to CONFIG_XEN_PLATFORM_PCI
      xen/balloon: Avoid OOM when requesting highmem

Daniel Mack (1):
      usb: gadget: fix MIDI gadget jack allocation

Daniel Vetter (4):
      drm/i915: disable temporal dithering on the internal panel
      drm/i915: only match on PCI_BASE_CLASS_DISPLAY
      drm/i915: Ivybridge still has fences!
      drm/i915: add constants to size fence arrays and fields

Dave Airlie (1):
      vgaarb: a NULL bridge is acceptable for root devices.

David Daney (3):
      MIPS: Hook up process_vm_readv and process_vm_writev system calls.
      STAGING: octeon-ethernet: Fix compile error caused by
skb_frag_struct change
      MIPS: Octeon: Fix compile error in arch/mips/cavium-octeon/flash_setup.c

David Howells (2):
      KEYS: Fix a NULL pointer deref in the user-defined key type
      VFS: Log the fact that we've given ELOOP rather than creating a loop

David Rientjes (1):
      hugetlb: remove dummy definitions of HPAGE_MASK and HPAGE_SIZE

David S. Miller (5):
      net: Fix references to deleted NET_ETHERNET Kconfig setting.
      sparc: Fix handling of orig_i0 wrt. debugging when restarting syscalls.
      sparc: Stash orig_i0 into %g6 instead of %g2
      sparc: Kill custom io_remap_pfn_range().
      sparc64: Patch sun4v code sequences properly on module load.

David Sterba (1):
      btrfs: fix stat blocks accounting

David Vrabel (1):
      xen: map foreign pages for shared rings by updating the PTEs directly

Dirk B (1):
      ARM: 7152/1: distclean: Remove generated .dtb files

Dirk Brandewie (1):
      x86/mrst: Add support for Penwell clock calibration

Dmitry Artamonow (1):
      watchdog: fix initialisation printout in s3c2410_wdt

Dmitry Kravkov (1):
      bnx2x: cache-in compressed fw image

Dmitry Monakhov (2):
      loop: prevent information leak after failed read
      loop: cleanup set_status interface

Don Zickus (2):
      usb, xhci: fix lockdep warning on endpoint timeout
      usb, xhci: Clear warm reset change event during init

Donggeun Kim (1):
      hwmon: (exynos4_tmu) Fix Kconfig dependency

Doug Anderson (1):
      tty/serial: Prevent drop of DCD on suspend for Tegra UARTs

Edward Donovan (1):
      genirq: Fix irqfixup, irqpoll regression

Einar Lueck (1):
      qeth: Reduce CPU consumption through less SIGA-r calls

Eliad Peller (1):
      mac80211: use min rate as basic rate for buggy APs

Emmanuel Grumbach (1):
      iwlwifi: avoid a panic when unloading the module with RF Kill

Eric Anholt (3):
      drm/i915: Fix object refcount leak on mmappable size limit error path.
      drm/i915: Turn on a required 3D clock gating bit on Sandybridge.
      drm/i915: Turn on another required clock gating bit on gen6.

Eric Dumazet (5):
      l2tp: fix l2tp_udp_recv_core()
      net: min_pmtu default is 552
      tcp: clear xmit timers in tcp_v4_syn_recv_sock()
      ping: dont increment ICMP_MIB_INERRORS
      ipv4: fix redirect handling

Eyal Shapira (1):
      wl12xx: fix wl12xx_scan_sched_scan_ssid_list() check that all
given ssids are in filters

Fabio Estevam (1):
      ARM: 7155/1: arch.h: Declare 'pt_regs' locally

Felipe Balbi (6):
      usb: gadget: udc-core: fix bug on soft_connect and srp interfaces
      usb: musb: gadget: don't call ->disconnect() on exit
      usb: gadget: core: fix bug when removing gadget drivers
      usb: gadget: core: allow everybody to read sysfs attributes
      usb: musb: fix compilation breakage introduced by de47725
      USB: storage: ene_ub6250: fix compile warnings

Feng King (1):
      tcp: Fix comments for Nagle algorithm

Feng Tang (1):
      x86/platform: Add a wallclock_init func to x86_platforms ops

Ferenc Wagner (1):
      USB: option: add PID of Huawei E173s 3G modem

Florian Fainelli (2):
      MIPS: BCM47xx: fix build with GENERIC_GPIO configuration
      r6040: fix check against MCRO_HASHEN bit in r6040_multicast_list

Francesco Virlinzi (2):
      stmmac: use mdelay on timeout of sw reset
      stmmac: fix pm functions avoiding sleep on spinlock

Frank Blaschka (1):
      qeth: l3 fix rcu splat in xmit

Geoff Levand (2):
      powerpc/ps3: Fix lost SMP IPIs
      powerpc/ps3: Fix SMP lockdep boot warning

Geoff Thorpe (1):
      uio: documentation fixups

Gertjan van Wingerde (2):
      rt2x00: Add USB device ID of Buffalo WLI-UC-GNHP.
      rt2x00: Fix sleep-while-atomic bug in powersaving code.

Giuseppe CAVALLARO (1):
      stmmac: parameters auto-tuning through HW cap reg

Gleb Natapov (3):
      KVM: VMX: add support for switching of PERF_GLOBAL_CTRL
      KVM: VMX: Add support for guest/host-only profiling
      KVM: VMX: Check for automatic switch msr table overflow

Grant Grundler (5):
      net-next:asix:PHY_MODE_RTL8211CL should be 0xC
      net-next:asix:poll in asix_get_phyid in case phy not ready
      net-next:asix: reduce AX88772 init time by about 2 seconds
      net-next:asix: V2 more fixes for ax88178 phy init sequence
      net-next:asix: V2 Update VERSION

Greg Kroah-Hartman (2):
      MAINTAINERS: add CHAR and MISC driver maintainers
      Revert "tty/serial: Prevent drop of DCD on suspend for Tegra UARTs"

Guan Xuetao (1):
      unicore32: fix build error for find bitops

Guennadi Liakhovetski (2):
      PM / shmobile: Don't skip debugging output in pd_power_up()
      PM / QoS: Properly use the WARN() macro in dev_pm_qos_add_request()

Hannes Reinecke (1):
      [SCSI] Silencing 'killing requests for dead queue'

Havard Skinnemoen (1):
      USB: cdc-acm: Fix disconnect() vs close() race

Heiko Carstens (4):
      [S390] wire up process_vm syscalls
      [S390] pfault: ignore leftover completion interrupts
      [S390] topology: fix topology on z10 machines
      virtio: add HAS_IOMEM dependency to MMIO platform bus driver

Helmut Schaa (1):
      ath: Fix NULL ptr dereference in ath_reg_apply_world_flags

Hillf Danton (1):
      hugetlb: release pages in the error path of hugetlb_cow()

Holger Dengler (1):
      [S390] ap: Setup processing for messages in request queue.

JJ Ding (1):
      Input: elantech - adjust hw_version detection logic

Jacob Pan (3):
      x86/apic: Do not clear nr_irqs_gsi if no legacy irqs
      x86/apic: Allow use of lapic timer early calibration result
      x86/mrst: Avoid reporting wrong nmi status

James Bottomley (1):
      [SCSI] fix WARNING: at drivers/scsi/scsi_lib.c:1704

Jan Glauber (2):
      [S390] avoid STCKF if running in ESA mode
      [S390] crypto: avoid MSA3 and MSA4 instructions in ESA mode

Jan Kara (1):
      mm: Make task in balance_dirty_pages() killable

Jan Schmidt (1):
      btrfs: mirror_num should be int, not u64

Janusz.Dziedzic@tieto.com (1):
      mac80211: uAPSD - fix IEEE80211_FCTL_MOREDATA bit setting

Jayachandran C (1):
      usb: Netlogic: Fix HC_LENGTH call in ehci-xls.c

Jean Delvare (3):
      drivers/firmware/dmi_scan.c: make dmi_name_in_vendors more focused
      i2c: Fix device name for 10-bit slave address
      i2c: Delete ANY_I2C_BUS

Jean-Christophe PLAGNIOL-VILLARD (2):
      USB: at91: at91-ohci: fix set/get power
      net/cadence: enable by default NET_ATMEL

Jeff Layton (2):
      nfs: when attempting to open a directory, fall back on normal
lookup (try #5)
      nfs: move nfs_file_operations declaration to bottom of file.c (try #2)

Jeff Mahoney (1):
      btrfs: Fix up 32/64-bit compatibility for new ioctls

Jeffrey (Sheng-Hui) Chu (1):
      i2c-algo-bit: Generate correct i2c address sequence for 10-bit target

Jeremy Fitzhardinge (1):
      Xen: update MAINTAINER info

Jesper Juhl (5):
      net, wireless, mwifiex: Fix mem leak in mwifiex_update_curr_bss_params()
      net/packet: remove dead code and unneeded variable from
prb_setup_retire_blk_timer()
      ALSA: hda/realtek: remove redundant semicolon
      net/packet: Revert incorrect dead-code changes to
prb_setup_retire_blk_timer
      Net, libertas: Resolve memory leak in if_spi_host_to_card()

Jesse Barnes (1):
      drm/i915: enable cacheable objects on Ivybridge

Jiri Slaby (3):
      TTY: ldisc, allow waiting for ldisc arbitrarily long
      TTY: ldisc, move wait idle to caller
      TTY: ldisc, wait for ldisc infinitely in hangup

Joe Perches (1):
      pch_gbe: Move #include of module.h

Joerg Roedel (2):
      PCI: Fix compile errors with PCI_ATS and !PCI_IOV
      PCI: Let PCI_PRI depend on PCI

Johan Hovold (1):
      Revert "leds: save the delay values after a successful call to
blink_set()"

Johannes Berg (7):
      nl80211: fix HT capability attribute validation
      cfg80211: allow setting TXQ parameters only in AP mode
      cfg80211: fix cmp_ies
      cfg80211: fix missing kernel-doc
      mac80211: fix NULL dereference in radiotap code
      mac80211: fix bug in ieee80211_build_probe_req
      mac80211: fix race between connection monitor & suspend

John Crispin (2):
      MIPS: lantiq: use export.h in favour of module.h
      NET: MIPS: lantiq: fix etop compile error

Josef Bacik (3):
      Btrfs: wait on caching if we're loading the free space cache
      Btrfs: clear pages dirty for io and set them extent mapped
      Btrfs: sectorsize align offsets in fiemap

Josh Boyer (3):
      ip6_tunnel: copy parms.name after register_netdevice
      USB: add quirk for Logitech C600 web cam
      fs/minix: Verify bitmap block counts before mounting

Julia Lawall (1):
      drivers/gpu/vga/vgaarb.c: add missing kfree

KAMEZAWA Hiroyuki (1):
      MAINTAINERS: add new cgroup list to CC notice

Keith Packard (12):
      agp: iommu_gfx_mapped only available if CONFIG_INTEL_IOMMU is set
      drm/i915: Use mode_config.mutex in ironlake_panel_vdd_work
      drm/i915: Module parameters using '-1' as default must be signed type
      drm/i915: Move common PCH_PP_CONTROL setup to ironlake_get_pp_control
      drm/i915: Remove link_status field from intel_dp structure
      drm/i915: Treat PCH eDP like DP in most places
      drm/i915: Let panel power sequencing hardware do its job
      drm/i915: Make DP prepare/commit consistent with DP dpms
      drm/i915: Try harder during dp pattern 1 link training
      drm/i915: Remove trailing white space
      drm/i915: Initiate DP link training only on the lanes we'll be using
      drm/i915: Use DPCD value for max DP lanes.

Kenji Kaneshige (2):
      PCI: pciehp: wait 1000 ms before Link Training check
      PCI: pciehp: wait 100 ms after Link Training check

Kevin Hao (1):
      powerpc/trace: Add a dummy stack frame for trace_hardirqs_off

Kumar Gala (3):
      powerpc: Revert show_regs() define for readability
      powerpc: Remove extraneous CONFIG_PPC_ADV_DEBUG_REGS define
      powerpc/book3e-64: Fix debug support for userspace

Kuninori Morimoto (6):
      usb: gadget: renesas_usbhs: fixup struct completion usage
      usb: gadget: renesas_usbhs: fixup bogus conversion
      usb: gadget: renesas_usbhs: fixup section mismatch warning
      usb: gadget: renesas_usbhs: bugfix: care pipe direction
      usb: gadget: renesas_usbhs: bugfix: disable irq when device stop
      usb: gadget: renesas_usbhs: bugfix: set DATA0 when usbhsh_endpoint_alloc()

Kyle Moffett (1):
      powerpc: Remove buggy 9-year-old test for binutils < 2.12.1

Li Wei (1):
      ipv4: fix for ip_options_rcv_srr() daddr update.

Li Zefan (2):
      Btrfs: fix to search one more bitmap for cluster setup
      Btrfs: avoid unnecessary bitmap search for cluster setup

Linus Torvalds (2):
      Revert "of/irq: of_irq_find_parent: check for parent equal to child"
      Linux 3.2-rc3

Liu Bo (1):
      Btrfs: fix tree corruption after multi-thread snapshots and
inode_cache flush

Lucas Kannebley Tavares (1):
      jsm: Change maintainership

Luciano Coelho (1):
      usb: musb: hdrc: fix dependency on USB_GADGET_DUALSPEED in Kconfig

Luis R. Rodriguez (1):
      cfg80211: fix bug on regulatory core exit on access to last_request

Maciej Żenczykowski (1):
      net-netlink: Add a new attribute to expose TCLASS values via netlink

Magnus Damm (2):
      ARM: mach-shmobile: sh7372 A3SP no_suspend_console fix
      PM / Clocks: Only disable enabled clocks in pm_clk_suspend()

Maksim Rayskiy (1):
      MIPS: ASID conflict after CPU hotplug

Marc Kleine-Budde (4):
      USB: gadgetfs: gadgetfs_disconnect: fix inconsistent lock state
      USB: ci13xxx_udc: fix deadlock during rmmod
      USB: ci13xxx_udc: fix debug trace code
      USB: ci13xxx_msm: add module license

Marcos Paulo de Souza (1):
      device.h: Fix struct member documentation

Marek Olšák (1):
      drm/radeon/kms: add a CS ioctl flag not to rewrite tiling flags in the CS

Mark Brown (1):
      watchdog: Don't overwrite error value in wm831x_wdt_set_timeout()

Mark Einon (1):
      linux-next: et131x: Fix build error when CONFIG_PM_SLEEP not enabled

Mark Kamichoff (1):
      net/usb: Misc. fixes for the LG-VL600 LTE USB modem

Martin Schwidefsky (2):
      [S390] fix pgste update logic
      [S390] incorrect note program header

Mathias Krause (1):
      unicore32, exec: remove redundant set_fs(USER_DS)

Mathias Nyman (1):
      x86, ioapic: Only print ioapic debug information for IRQs
belonging to an ioapic chip

Matthew Garrett (2):
      The Windows driver .inf disables ASPM on all cciss devices. Do the same.
      [SCSI] hpsa: Disable ASPM

Maxin B. John (2):
      ARM: 7153/1: mach-bcmring: fix build error in core.c
      ARM: 7154/1: mach-bcmring: fix build error in dma.c

Mian Yousaf Kaukab (1):
      usb: musb: remove incorrectly added ARCH_U5500 define

Michael Grzeschik (1):
      USB: ci13xxx_udc: fix logic to mark request dma addresses as invalid

Michael Hennerich (1):
      misc: ad525x_dpot: Fix AD8400 spi transfer size.

Michael Holzheu (2):
      [S390] Kconfig: Select CONFIG_KEXEC for CONFIG_CRASH_DUMP
      [S390] zfcpdump: Do not initialize zfcpdump in kdump mode

Michael Neuling (1):
      powerpc: Add hvcall.h include to book3s_hv.c

Michael S. Tsirkin (1):
      virtio-pci: make reset operation safer

Michal Hocko (1):
      oom: do not kill tasks with oom_score_adj OOM_SCORE_ADJ_MIN

Mikulas Patocka (1):
      IDE: Don't powerdown Compaq Triflex IDE device on suspend

Mimi Zohar (2):
      encrypted-keys: fix error return code
      encrypted-keys: module build fixes

Mitsuo Hayasaka (1):
      xfs: use doalloc flag in xfs_qm_dqattach_one()

MyungJoo Ham (2):
      PM / devfreq: Remove compiler error after irq.h update
      PM / devfreq: correct Kconfig dependency

Namjae Jeon (1):
      ext4: add blk_finish_plug in error case of writepages.

Nick Bowler (3):
      ah: Correctly pass error codes in ahash output callback.
      ah: Read nexthdr value before overwriting it in ahash input callback.
      ah: Don't return NET_XMIT_DROP on input.

Nico Erfurth (1):
      Fix incorrect usage of NET_IP_ALIGN

Olof Johansson (1):
      ARM: 7156/1: l2x0: fix compile error on !CONFIG_USE_OF

Paul Bolle (5):
      net: drivers/net/hippi/Kconfig should be sourced
      rds: drop "select LLIST"
      unicore32: drop unused Kconfig symbols
      drivers/misc/eeprom: fix dependecy on 'PPC_MPC5200_GPIO'
      unicore32: Fix typo 'PUV3_I2C'

Paul Menage (1):
      cgroup: Replace Paul Menage with Tejun Heo as cgroups maintainer

Paul Zimmerman (2):
      usb: gadget: storage: check for valid USB_BULK_GET_MAX_LUN_REQUEST
      usb: gadget: storage: check for valid USB_BULK_RESET_REQUEST wLength

Peter Chen (1):
      PM / driver core: disable device's runtime PM during shutdown

Rabin Vincent (3):
      backing-dev: ensure wakeup_timer is deleted
      x86: Call stop_machine_text_poke() on all CPUs
      ktest: Check parent options for iterated tests

Rafael J. Wysocki (4):
      PCI / ACPI: Make acpiphp ignore root bridges using PCIe native hotplug
      PM / shmobile: Avoid restoring the INTCS state during initialization
      PM Sleep: Do not extend wakeup paths to devices with ignore_children set
      PM / shmobile: Fix build of sh7372_pm_init() for CONFIG_PM unset

Rafał Miłecki (2):
      b43: fill ctl1 word on all newer PHYs, fix PHY errors
      b43: HT-PHY: report signal to mac80211

Rakib Mullick (1):
      drm, i915: Fix memory leak in i915_gem_busy_ioctl().

Ralf Baechle (3):
      MIPS: NXP: Remove unused source files.
      MIPS: Fix build error due to missing inclusion of <linux/export.h>.
      MAINTAINERS: The MIPS git tree has moved.

Randy Dunlap (5):
      media/staging: fix allyesconfig build error
      platform/x86: fix dell-laptop function prototypes
      staging: slicoss depends on NET
      staging: et131x depends on NET
      staging: fix more ET131X build errors

Ricardo Ribalda (2):
      net/temac: FIX segfault when process old irqs
      net/ll_temac: FIX : Wait for indirect wait to end

Richard Weinberger (1):
      ext4: Remove kernel_lock annotations

Rob Herring (1):
      [libata] ahci_platform: fix DT probing

Robert Marklund (1):
      net/smsc911x: Always wait for the chip to be ready

Russell King (2):
      Revert "ARM: 7098/1: kdump: copy kernel relocation code at the
kexec prepare stage"
      ARM: wire up process_vm_writev and process_vm_readv syscalls

Rémi Denis-Courmont (1):
      f_phonet: fix page offset of first received fragment

Sage Weil (2):
      ceph: fix iput race when queueing inode work
      ceph: initialize root dentry

Sarah Sharp (1):
      xhci: Set slot and ep0 flags for address command.

Sasha Levin (1):
      virtio-mmio: Correct the name of the guest features selector

Sebastian Andrzej Siewior (1):
      usb: dwc3: gadget: initialize max_streams

Shaohua Li (2):
      block: avoid unnecessary plug list flush
      block: add missed trace_block_plug

Shaohui Xie (1):
      powerpc/usb: fix type cast for address of ioremap to compatible
with 64-bit

Shubhrajyoti D (1):
      i2c: Make i2cdev_notifier_call static

Srinivas Kandagatla (2):
      stmmac: fix advertising 1000Base capabilties for non GMII iface
      stmmac: remove spin_lock in stmmac_ioctl.

Srivatsa S. Bhat (2):
      PM / Hibernate: Fix the early termination of test modes
      PM / Suspend: Fix bug in suspend statistics update

Stanislav Kinsbursky (1):
      SUNRPC: destroy freshly allocated transport in case of sockaddr init error

Steffen Klassert (1):
      ipv4: Fix inetpeer expire time information

Stephen Boyd (1):
      tty: hvc_dcc: Fix duplicate character inputs

Stephen Hemminger (1):
      MAINTAINERS: change email address for shemminger

Stephen M. Cameron (1):
      cciss: auto engage SCSI mid layer at driver load time

Stephen Rothwell (1):
      include/linux/bio.h: use a static inline function for
bio_integrity_clone()

Steven Miao (1):
      wireless: libertas: fix unaligned le64 accesses

Stratos Psomadakis (1):
      libceph: Allocate larger oid buffer in request msgs

Suzuki Poulose (1):
      powerpc/4xx: Fix typos in kexec config dependencies

Takashi Iwai (3):
      ALSA: hda - Update URLs in document
      ALSA: hda - Fix the connection selection of ADCs on Cirrus codecs
      drm/i915: Fix inconsistent backlight level during disabled

Tejun Heo (1):
      block: Revert "[SCSI] genhd: add a new attribute "alias" in gendisk"

Theodore Ts'o (1):
      ext4: ignore journalled data options on remount if fs has no journal

Thomas Gleixner (1):
      drm: Remove utterly bogus preempt_disable() sections

Thomas Hellstrom (1):
      ttm: Don't return the bo reserved on error path

Thomas Jarosch (1):
      MIPS: Yosemite, Emma: Fix off-by-two in arcs_cmdline buffer size check

Thomas Poussevin (1):
      USB: EHCI: fix HUB TT scheduling issue with iso transfer

Tomas Miljenović (1):
      Input: i8042 - add HP Pavilion dv4s to 'notimeout' and 'nomux' blacklists

Tomoya MORINAGA (10):
      USB: pch_udc: Support new device LAPIS Semiconductor ML7831 IOH
      USB: pch_udc: Change company name OKI SEMICONDUCTOR to LAPIS Semiconductor
      pch_phub: Support new device LAPIS Semiconductor ML7831 IOH
      pch_phub: Change company name OKI SEMICONDUCTOR to LAPIS Semiconductor
      pch_phub: Improve ADE(Address Decode Enable) control
      pch_phub: Fix MAC address writing issue for LAPIS ML7831
      pch_uart: Fix hw-flow control issue
      pch_uart: Support new device LAPIS Semiconductor ML7831 IOH
      pch_uart: Change company name OKI SEMICONDUCTOR to LAPIS Semiconductor
      pch_uart: Fix DMA resource leak issue

Tony Luck (3):
      x86/mce: Make mce_chrdev_ops 'static const'
      random: Fix handing of arch_get_random_long in get_random_bytes()
      fix typo/thinko in get_random_bytes()

Trond Myklebust (2):
      NFS: Fix a regression in the referral code
      NFS: Revert pnfs ugliness from the generic NFS read code path

Tyler Hicks (3):
      eCryptfs: Prevent file create race condition
      eCryptfs: Flush file in vma close
      eCryptfs: Extend array bounds for all filename chars

Ulf Hansson (1):
      ARM: 7149/1: spi/pl022: Enable clock in probe

Ursula Braun (2):
      qeth: return with -EPERM if sniffing is not enabled
      netiucv: reinsert dev_alloc_name for device naming

VU Tuan Duc (1):
      USB: option: add id for 3G dongle Model VT1000 of Viettel

Vasily Averin (1):
      [SCSI] aacraid: controller hangs if kernel uses non-default ASPM policy

Veaceslav Falico (1):
      bonding: Don't allow mode change via sysfs with slaves present

Venkat Subbiah (1):
      MIPS: Octeon: Mark SMP-IPI interrupt as IRQF_NO_THREAD

Wen-chien Jesse Sung (1):
      Bluetooth: Add support for Broadcom BCM20702A0

Will Deacon (2):
      ARM: 7160/1: setup: avoid overflowing {elf,arch}_name from proc_info_list
      powerpc/signal32: Fix sigset_t conversion when copying to user

      watchdog: adx_wdt.c: remove driver

Wu Fengguang (5):
      ALSA: hda - fix ELD memory leak
      ALSA: hda - delayed ELD repoll
      ALSA: hda - move eld->spk_alloc fixup to hdmi_update_eld()
      writeback: hard throttle 1000+ dd on a slow USB stick
      writeback: remove vm_dirties and task->dirties

Xi Wang (1):
      drm: integer overflow in drm_mode_dirtyfb_ioctl()

Yevgeny Petrilin (1):
      mlx4_en: Remove FCS bytes from packet length.

Yinghai Lu (1):
      PCI: pciehp: Retrieve link speed after link is trained

Yongqiang Yang (1):
      ext4: fix up a undefined error in ext4_free_blocks in debugging code

Yoshihiro Shimoda (2):
      usb: gadget: r8a66597-udc: fix for udc-newstyle
      usb: gadget: r8a66597-udc: fix flush fifo handling

Zhenzhong Duan (1):
      xen:pvhvm: enable PVHVM VCPU placement when using more than 32 CPUs.

david decotigny (1):
      forcedeth: fix stats on hardware without extended stats support

hayeswang (1):
      r8169: increase the delay parameter of pm_schedule_suspend

oftedal (1):
      sunhme: Allow usage on SBI based SBus systems

sordna (1):
      USB: quirks: adding more quirky webcams to avoid squeaky audio

stephen hemminger (9):
      bridge: correct IPv6 checksum after pull
      sky2: fix hang on shutdown (and other irq issues)
      sky2: pci posting issues
      sky2: rename up/down functions
      sky2: reduce default Tx ring size
      sky2: used fixed RSS key
      sky2: version 1.30
      sky2: enforce minimum ring size
      sky2: fix hang in napi_disable

wangyanqing (1):
      USB: serial: pl2303: rm duplicate id

wanzongshun (2):
      ARM: 7157/1: fix a building WARNING for nuc900
      ARM: 7158/1: add new MFP implement for NUC900

zheng.zhijian@zte.com.cn (1):
      USB: option: release new PID for ZTE 3G modem
