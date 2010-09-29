Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab0I2BUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 21:20:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754906Ab0I2BU3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 21:20:29 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Sep 2010 18:19:31 -0700
Message-ID: <AANLkTik85bCi5S=w7sk3EZ-oNK4CLME=+G0fEkSN0+c0@mail.gmail.com>
Subject: Linux 2.6.36-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know why I've started thinking that a week is eight days, but
there you have it - it's clearly some kind of odd mental deficiency of
mine. So once more the -rc release is a day late.

Nothing here strikes me as particularly interesting. I'd like
developers to take a look at Rafael's latest regression list (subject
line of "2.6.36-rc5-git7: Reported regressions from 2.6.35" on lkml
and various other mailing lists), as it's reasonably short. That said,
for some reason I don't have that "warm and fuzzy" feeling, possibly
because there's still been more commits in these -rc's than I'd really
like at this stage (and no, the one extra day isn't enough to account
for it).

But at the same time I don't have any _huge_ reasons to delay the
2.6.36 release much further. I do think I've failed to be as hardnosed
as I should have been, and I'll see how next week looks. I suspect
I'll do an -rc7, unless things really calm down, and I'll try to be
pretty strict about things.

So guys - regressions and majorly serious issues only, ok? Really.

                           Linus

---
Adam Jackson (1):
      intel-iommu: Use symbolic values instead of magic numbers in Lenovo w/a

Adrian Hunter (1):
      block: prevent merges of discard and write requests

Al Viro (15):
      powerpc: fix double syscall restarts
      m32r: fix rt_sigsuspend()
      make m32r handle multiple pending signals
      m32r: don't block signals if sigframe setup has failed
      m32r: hole in shifting pc back
      m32r: fix breakage from "m32r: use generic ptrace_resume code"
      alpha: fix hae_cache race in RESTORE_ALL
      alpha: fix usp value in multithreaded coredumps
      alpha: switch osf_sigprocmask() to use of sigprocmask()
      alpha: __get_user/__put_user results need to be checked...
      mn10300: avoid SIGSEGV delivery loop
      mn10300: prevent double syscall restarts
      mn10300: ->restart_block.fn needs to be reset on sigreturn
      mn10300: get rid of set_fs(USER_DS) in sigframe setup
      mn10300: check __get_user/__put_user results...

Alan Stern (2):
      USB: fix bug in initialization of interface minor numbers
      USB: update Kconfig help text for CONFIG_USB_SUSPEND

Alexander Chumachenko (1):
      x86: Avoid 'constant_test_bit()' misoptimization due to cast to
non-volatile

Amit Shah (1):
      virtio: console: Prevent userspace from submitting NULL buffers

Andrea Arcangeli (2):
      rmap: fix walk during fork
      mmap: call unlink_anon_vmas() in __split_vma() in case of error

Andrew Morton (1):
      drivers/pci/intel-iommu.c: fix build with older gcc's

Arnaud Patard (1):
      ARM: kirkwood: Unbreak PCIe I/O port

Arnd Bergmann (1):
      /proc/vmcore: fix seeking

Avi Kivity (1):
      KVM: Fix reboot on Intel hosts

Axel Lin (1):
      drivers/rtc/rtc-ab3100.c: add missing platform_set_drvdata() in
ab3100_rtc_probe()

Ben Hutchings (1):
      TOMOYO: Don't abuse sys_getpid(), sys_getppid()

Ben Skeggs (1):
      drm/nouveau: fix panels using straps-based mode detection

Benny Halevy (1):
      block: fix blk_rq_map_kern bio direction flag

Borislav Petkov (1):
      amd64_edac: Fix driver module removal

Bruce Allan (6):
      e1000e: 82577/8/9 issues with device in Sx
      e1000e: 82579 SMBus address and LEDs incorrect after device reset
      e1000e: 82566DC fails to get link
      e1000e: 82579 unaccounted missed packets
      e1000e: 82579 jumbo frame workaround causing CRC errors
      e1000e: 82579 do not gate auto config of PHY by hardware during
nominal use

Cam Macdonell (1):
      PCI: fix pci_resource_alignment prototype

Catalin Marinas (2):
      ARM: 6395/1: VExpress: Set bit 22 in the PL310 (cache
controller) AuxCtlr register
      ARM: 6383/1: Implement phys_mem_access_prot() to avoid attributes aliasing

Changli Gao (1):
      netfilter: fix ipt_REJECT TCP RST routing for indev == outdev

Chris Ball (1):
      mmc: MAINTAINERS: add myself as MMC maintainer

Chris Metcalf (1):
      arch/tile: remove dead code from intvec_32.S

Chris Wilson (8):
      drm/i915: Ensure that the crtcinfo is populated during mode_fixup()
      drm/i915/crt: Downgrade warnings for hotplug failures
      drm/i915: Fix Sandybridge fence registers
      drm/i915,agp/intel: Add second set of PCI-IDs for B43
      drm/i915: Hold a reference to the object whilst unbinding the
eviction list
      drm/i915: Fix 945GM regression in e259befd
      drm/i915/sdvo: Cleanup connector on error path
      drm/i915/sdvo: Handle unsupported GET_SUPPORTED_ENHANCEMENTS gracefully

Dan Carpenter (1):
      cciss: freeing uninitialized data on error path

Dan Rosenberg (4):
      Prevent freeing uninitialized pointer in compat_do_readv_writev
      drivers/video/sis/sis_main.c: prevent reading uninitialized stack memory
      ALSA: sound/pci/rme9652: prevent reading uninitialized stack memory
      Fix pktcdvd ioctl dev_minor range check

Daniel J Blueman (4):
      drm: ttm sparse fixes.
      drm: fix trivial coding errors
      drm: radeon cleanup fixes...
      vgaarb: trivial fix

Daniel Walker (1):
      ARM: 6398/1: add proc info for ARM11MPCore/Cortex-A9 from ARM

Dave Airlie (1):
      drm/radeon: don't allow device to be opened if powered down

David Howells (2):
      MN10300: Default config choice GDBSTUB_TTYSM0 should be GDBSTUB_ON_TTYSM0
      MN10300: Handle missing sys_cacheflush() when caching disabled

David Rientjes (2):
      oom: always return a badness score of non-zero for eligible tasks
      oom: filter unkillable tasks from tasklist dump

David S. Miller (6):
      sparc64: Support RAW perf events.
      rose: Fix signedness issues wrt. digi count.
      sparc64: Fix race in signal instruction flushing.
      sparc: Don't mask signal when we can't setup signal frame.
      sparc: Prevent no-handler signal syscall restart recursion.
      tcp: Fix >4GB writes on 64-bit.

David Woodhouse (1):
      intel-iommu: Abort IOMMU setup for igfx if BIOS gave no shadow GTT space

Davidlohr Bueso (1):
      net/9p: fix memory handling/allocation in rdma_request()

Dimitris Papastamos (1):
      ASoC: Fix soc-cache buffer overflow bug

Dmitry Torokhov (1):
      vmware balloon: rename module

Dominik Brodowski (1):
      pcmcia: preserve configuration information if request_io fails partly

Eric Dumazet (8):
      qlcnic: dont assume NET_IP_ALIGN is 2
      ip_gre: CONFIG_IPV6_MODULE support
      qlcnic: dont set skb->truesize
      netxen: dont set skb->truesize
      ip: fix truesize mismatch in ip fragmentation
      netfilter: tproxy: nf_tproxy_assign_sock() can handle tw sockets
      netfilter: fix a race in nf_ct_ext_create()
      net: fix a lockdep splat

Eric Miao (2):
      ARM: dove: fix __io() definition to use bus based offset
      ARM: pxa: fix cpu_is_pxa*() not expanding to zero when not configured

Erik J. Staab (1):
      ALSA: oxygen: fix analog capture on Claro halo cards

FUJITA Tomonori (1):
      arm: fix "arm: fix pci_set_consistent_dma_mask for dmabounce devices"

Francisco Jerez (1):
      drm/ttm: Clear the ghost cpu_writers flag on ttm_buffer_object_transfer.

Frederic Weisbecker (1):
      x86: Fix instruction breakpoint encoding

Guennadi Liakhovetski (1):
      ASoC: fix clkdev API usage in sh/migor.c

Guenter Roeck (2):
      MAINTAINERS: Update hwmon entry
      hwmon (coretemp): Fix build breakage if SMP is undefined

Hans de Goede (1):
      virtio: console: Fix poll blocking even though there is data to read

Hans-Christian Egtvedt (1):
      MAINTAINERS: change AVR32 and AT32AP maintainer

Haojian Zhuang (1):
      ARM: pxa168fb: clear enable bit when not active

Henrique de Moraes Holschuh (1):
      thinkpad-acpi: avoid keymap pitfall

Jan Beulich (8):
      x86/hwmon: fix module init for hotplug-but-no-device-found case
      x86/hwmon: avoid deadlock on CPU removal in pkgtemp
      x86/hwmon: don't leak device attribute file from pkgtemp_probe()
and pkgtemp_remove()
      x86/hwmon: fix initialization of coretemp
      x86/hwmon: fix initialization of pkgtemp
      x86/hwmon: register alternate sibling upon CPU removal
      x86/hwmon: pkgtemp has no dependency on PCI
      3c59x: fix regression from patch "Add ethtool WOL support"

Jan Kara (4):
      bdi: Initialize noop_backing_dev_info properly
      char: Mark /dev/zero and /dev/kmem as not capable of writeback
      bdi: Fix warnings in __mark_inode_dirty for /dev/zero and friends
      aio: do not return ERESTARTSYS as a result of AIO

Jarek Poplawski (1):
      fbcon: fix lockdep warning from fbcon_deinit()

Jeremy Fitzhardinge (1):
      tracing/x86: Don't use mcount in pvclock.c

Jiri Olsa (1):
      netfilter: nf_conntrack_defrag: check socket type before
touching nodefrag flag

Joe Perches (1):
      ARM: pxa: remove pr_<level> uses of KERN_<level>

Joerg Roedel (3):
      x86/amd-iommu: Set iommu configuration flags in enable-loop
      x86/amd-iommu: Work around S3 BIOS bug
      x86/amd-iommu: Fix rounding-bug in __unmap_single

Johannes Berg (1):
      wext: fix potential private ioctl memory content leak

KOSAKI Motohiro (1):
      /proc/pid/smaps: fix dirty pages accounting

Karl Hiramoto (1):
      br2684: fix scheduling while atomic

Kulikov Vasiliy (3):
      ibm_newemac: use free_netdev(netdev) instead of kfree()
      rionet: use free_netdev(netdev) instead of kfree()
      sgiseeq: use free_netdev(netdev) instead of kfree()

Larry Woodman (1):
      Avoid pgoff overflow in remap_file_pages

Lee, Chun-Yi (1):
      Change MSI LAPTOP driver maintainer to Lee, Chun-Yi

Linus Torvalds (3):
      fremap: get rid of broken 'end' variable
      alpha: fix compile problem in arch/alpha/kernel/signal.c
      Linux 2.6.36-rc6

Linus Walleij (3):
      ARM: 6375/1: plat-nomadik: MTU timer trivial bug fix
      ARM: 6376/1: plat-nomadik: MTU: Change prescaler limit and comment updates
      ARM: 6377/1: supply _cansleep gpio function to U300

Luca Tettamanti (2):
      atl1: fix resume
      atl1: zero out CMB and SBM in atl1_free_ring_resources

Luke Macken (1):
      efifb: support the EFI framebuffer on more Apple hardware

Luke Yelavich (1):
      ALSA: hda - Add Dell Latitude E6400 model quirk

Marek Szyprowski (2):
      mmc: sdhci-s3c: fix incorrect spinlock usage after merge
      mmc: sdhci-s3c: fix NULL ptr access in sdhci_s3c_remove

Marek Vasut (2):
      ARM: pxa: Fix Vpac270 gpio_power for MMC
      ARM: pxa: Use PIO for PI2C communication on Palm27x

Mark Brown (1):
      ASoC: Fix multi-componentism

Mark F. Brown (1):
      ARM: pxa168: fix corrected reset vector

Mark Salter (3):
      MN10300: Fix endianess of ext2 bitops
      MN10300: Fix SIGRTMAX
      MN10300: Arch doesn't support HAVE_ARCH_TRACEHOOK

Masami Hiramatsu (1):
      kprobes: Fix Kconfig dependency

Mathias Nyman (1):
      i2c-omap: Make sure i2c bus is free before setting it to idle

Matt Helsley (1):
      hw breakpoints: Fix pid namespace bug

Michael S. Tsirkin (3):
      vhost-net: fix range checking in mrg bufs case
      vhost: fix log ctx signalling
      KVM: fix irqfd assign/deassign race

Minchan Kim (1):
      vmscan: check all_unreclaimable in direct reclaim path

Ming Lei (6):
      usb: musb: gadget: fix kernel panic if using out ep with FIFO_TXRX style
      usb: musb: gadget: fix bulk IN infinit hangs in double buffer case
      usb: musb: gadget: enable autoclear for OUT transfer in both DMA
0 and DMA 1
      usb: musb: gadget: fix DMA length for OUT transfer
      usb: musb: gadget: complete request only if data is transfered over
      usb: musb: gadget: fix dma length in txstate

Naoya Horiguchi (4):
      hugetlb, rmap: always use anon_vma root pointer
      hugetlb, rmap: use hugepage_add_new_anon_rmap() in hugetlb_cow()
      hugetlb, rmap: fix confusing page locking in hugetlb_cow()
      hugetlb, rmap: add BUG_ON(!PageLocked) in hugetlb_add_anon_rmap()

Neil Horman (1):
      ipv6: add a missing unregister_pernet_subsys call

Nicolas Pitre (1):
      ARM: 6401/1: plug a race in the alignment trap handler

Ollie Wild (1):
      net: Move "struct net" declaration inside the __KERNEL__ macro guard

Ondrej Zary (4):
      de2104x: disable autonegotiation on broken hardware
      de2104x: fix power management
      de2104x: fix TP link detection
      de2104x: fix ethtool

Patrick McHardy (1):
      netfilter: nf_nat_snmp: fix checksum calculation (v4)

Patrick Simmons (1):
      oprofile: Add Support for Intel CPU Family 6 / Model 22 (Intel
Celeron 540)

Pavan Savoy (1):
      Staging: ti-st: remove st_get_plat_device

Peter Jones (1):
      efifb: check that the base address is plausible on pci systems

Peter Korsgaard (2):
      ARM: 6400/1: at91: fix arch_gettimeoffset fallout
      ARM: 6406/1: at91sam9g45: fix i2c bus speed

Rahul Ruikar (1):
      pcmcia: pd6729: Fix error path

Richard Weinberger (1):
      uml: fix compile warning

Robert Richter (1):
      perf, x86: Catch spurious interrupts after disabling counters

Russell King (2):
      ARM: prevent multiple syscall restarts
      ARM: Fix build error when using KCONFIG_CONFIG

Rusty Russell (1):
      lguest: update comments to reflect LHCALL_LOAD_GDT_ENTRY.

Sage Weil (11):
      ceph: fix null pointer deref on anon root dentry release
      ceph: fix reconnect encoding for old servers
      ceph: fix file offset wrapping at 4GB on 32-bit archs
      ceph: fix dn offset during readdir_prepopulate
      ceph: correctly set 'follows' in flushsnap messages
      ceph: stop sending FLUSHSNAPs when we hit a dirty capsnap
      ceph: fix cap_snap and realm split
      ceph: only send one flushsnap per cap_snap per mds session
      ceph: check mapping to determine if FILE_CACHE cap is used
      ceph: select CRYPTO
      fs: {lock,unlock}_flocks() stubs to prepare for BKL removal

Santosh Shilimkar (4):
      usb: musb: host: Issue a memory barrier before starting DMA
      ARM: 6407/1: mmu: Setup MT_MEMORY and MT_MEMORY_NONCACHED L1 entries
      ARM: 6408/1: omap: Map only available sram memory
      ARM: 6409/1: davinci: map sram using MT_MEMORY_NONCACHED instead
of MT_DEVICE

Sergei Shtylyov (1):
      usb: musb: gadget: restart request on clearing endpoint halt

Simon Guinot (2):
      dmaengine: fix interrupt clearing for mv_xor
      leds: leds-ns2: fix locking

Simon Horman (1):
      netfilter: nf_ct_sip: default to NF_ACCEPT in sip_help_tcp()

Srinivas Eeda (1):
      o2dlm: force free mles during dlm exit

Stanislaw Gruszka (1):
      sched: Fix user time incorrectly accounted as system time on 32-bit

Steve Wise (1):
      RDMA/cxgb3: Turn off RX coalescing for iWARP connections

Steven Rostedt (1):
      tracing/x86: Don't use mcount in kvmclock.c

Suresh Siddha (1):
      sched: Fix nohz balance kick

Sven Eckelmann (1):
      net/9p: Mount only matching virtio channels

Takashi Iwai (2):
      ALSA: hda - Fix auto-parse of SPDIF input of Realtek codecs
      hwmon: (lis3) Fix Oops with NULL platform data

Tao Ma (6):
      ocfs2/lockdep: Move ip_xattr_sem out of ocfs2_xattr_get_nolock.
      ocfs2: Fix lockdep warning in reflink.
      ocfs2: update ctime when changing the file's permission by setfacl
      ocfs2: Use cpu_to_le16 for e_leaf_clusters in
ocfs2_bg_discontig_add_extent.
      ocfs2: Move 'wanted' into parens of ocfs2_resmap_resv_bits.
      ocfs2: Sync inode flags with ext2.

Tejun Heo (2):
      percpu: fix pcpu_last_unit_cpu
      ahci: fix module refcount breakage introduced by libahci split

Thomas Egerer (1):
      xfrm: Allow different selector family in temporary state

Tom Herbert (1):
      net: reset skb queue mapping when rx'ing over tunnel

Tom Marshall (1):
      tcp: Fix race in tcp_poll

Tristan Ye (2):
      Ocfs2: Re-access the journal after ocfs2_insert_extent() in dxdir codes.
      Ocfs2: Handle empty list in lockres_seq_start() for dlmdebug.c

Ulrich Weber (3):
      xfrm4: strip ECN bits from tos field
      ipv6: add IPv6 to neighbour table overflow warning
      tproxy: check for transparent flag in ip_route_newports

Vasiliy Kulikov (1):
      s390: use free_netdev(netdev) instead of kfree()

Vincent Stehlé (1):
      smsc911x: Add MODULE_ALIAS()

Vivek Goyal (1):
      cfq-iosched: fix a kernel OOPs when usb key is inserted

Vladimir Zapolskiy (1):
      rtc: s3c: balance state changes of wakeup flag

Wey-Yi Guy (1):
      iwlwifi: do not perferm force reset while doing scan

Will Deacon (4):
      ARM: 6387/1: errata: check primary part ID in proc-v7.S
      ARM: 6388/1: errata: DMB operation may be faulty
      ARM: 6389/1: errata: incorrect hazard handling in the SCU may
lead to data corruption
      ARM: 6411/1: vexpress: set RAM latencies to 1 cycle for PL310 on
ct-ca9x4 tile

Wu Fengguang (1):
      ocfs2/net: fix uninitialized ret in o2net_send_message_vec()

Yehuda Sadeh (1):
      ceph: fix pagelist kunmap tail

Yinghai Lu (4):
      x86, setup: Fix earlyprintk=serial,ttyS0,115200
      x86, setup: Fix earlyprintk=serial,0x3f8,115200
      ipmi: fix acpi probe print
      ipmi: fix hardcoded ipmi device exit path warning

Yuchung Cheng (1):
      tcp: fix TSO FACK loss marking in tcp_mark_head_lost
