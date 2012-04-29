Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab2D2WsR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 18:48:17 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40464 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab2D2WsO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 18:48:14 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 29 Apr 2012 15:47:52 -0700
X-Google-Sender-Auth: yZJ_3tvxmqlbQFB_BFuhQi4NZrk
Message-ID: <CA+55aFwozW9aM_E8qo0CT_5SBVJM2ye+cwnc=ekL6JXimbaC2g@mail.gmail.com>
Subject: Linux 3.4-rc5
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc. Techically it's eight days - I delayed it
for a day waiting for some testing.

And like -rc4, quite a bit of the changes came in on Friday (with some
more coming in yesterday). And we haven't been calming down, quite the
reverse. -rc5 has almost 50% more commits than -rc4 had. Not good.

That said, I don't think there is anything hugely scary there.
Annoying, yes (by now I really detest the nasty autofs ABI issues I
was fighting the last few days, for example), and I'd be happier if
things had been quieter, but much of this is really pretty small and
trivial. It's fairly spread out: ~50% drivers, 20% arch, 15% fs
(mainly btrfs and nfs), 5% networking, and random noise.

The shortlog probably describes it best, because it really is just a
collection of fairly random fixes.

                       Linus

---
Adam Jackson (1):
      intel_ips: Hush the i915 symbols message

Alan Stern (3):
      USB: gadget: storage gadgets send wrong error code for unknown commands
      USB: EHCI: fix crash during suspend on ASUS computers
      usb: gadget: udc-core: fix incompatibility with dummy-hcd

Alex Deucher (2):
      drm/radeon/kms: use frac fb div on APUs
      drm/radeon/kms: need to set up ss on DP bridges as well

Alexander Duyck (1):
      ixgbe: Identify FCoE rings earlier to resolve memory corruption w/ FCoE

Amitkumar Karwar (1):
      libertas: fix signedness bug in lbs_auth_to_authtype()

Anatolij Gustschin (1):
      drivers/rtc/rtc-ds1307.c: fix BUG shown with lock debugging enabled

Andreas Herrmann (4):
      x86, microcode: Fix sysfs warning during module unload on unsupported CPUs
      x86, microcode: Ensure that module is only loaded on supported AMD CPUs
      x86/amd: Remove broken links from comment and kernel message
      x86/platform: Remove incorrect error message in x86_default_fixup_cpu_id()

Aneesh Kumar K.V (1):
      hugetlbfs: lockdep annotate root inode properly

Arend van Spriel (1):
      brcm80211: smac: resume transmit fifo upon receiving frames

Arnd Bergmann (1):
      ARM: mini2440_defconfig: Fix build error

Arne Jansen (3):
      btrfs: fix race in reada
      btrfs: don't add both copies of DUP to reada extent tree
      btrfs: don't return EINTR

Baruch Siach (1):
      powerpc: fix build when CONFIG_BOOKE_WDT is enabled

Benjamin Herrenschmidt (4):
      powerpc/pmac: Don't add_timer() twice
      powerpc/mpic: Fix confusion between hw_irq and virq
      irq: Add IRQ_TYPE_DEFAULT for use by PIC drivers
      powerpc/mpic: Properly set default triggers

Benjamin Poirier (1):
      ixgbe: add missing rtnl_lock in PM resume path

Bing Zhao (1):
      mwifiex: update pcie8766 scratch register addresses

Bjørn Mork (1):
      net: qmi_wwan: support Sierra Wireless MC77xx devices in QMI mode

Bob Peterson (1):
      GFS2: Instruct DLM to avoid queue convert slowdown

Bojan Smojver (1):
      PM / Hibernate: fix the number of pages used for hibernate/thaw buffering

Bruce Allan (1):
      e1000e: issues in Sx on 82577/8/9

Bryan O'Donoghue (1):
      x86, apic: APIC code touches invalid MSR on P5 class machines

Carlos Chinea (6):
      HSI: hsi: Rework hsi_controller release
      HSI: hsi: Fix error path cleanup on client registration
      HSI: hsi: Remove controllers and ports from the bus
      HSI: hsi: Rework hsi_event interface
      HSI: hsi_char: Remove max_data_size from sysfs
      HSI: Add HSI ABI documentation

Chris Mason (2):
      Btrfs: avoid deadlocks from GFP_KERNEL allocations during
btrfs_real_readdir
      Btrfs: reduce lock contention during extent insertion

Chris Metcalf (2):
      init: fix bug where environment vars can't be passed via boot args
      arch/tile: fix a couple of functions that should be __init

Christian Riesch (1):
      davinci_mdio: Fix MDIO timeout check

Clay Carpenter (1):
      acerhdf: add support for Aspire 1410 BIOS v1.3314

Dan Carpenter (3):
      Btrfs: double unlock bug in error handling
      ksz884x: don't copy too much in netdev_set_mac_address()
      bnx2x: off by one in bnx2x_ets_e3b0_sp_pri_to_cos_set()

Daniel J Blueman (2):
      Btrfs: Prevent root_list corruption
      Btrfs: Fix space checking during fs resize

Daniel Vetter (2):
      drm/i915: fixup load-detect on enabled, but not active pipe
      drm/i915: handle input/output sdvo timings separately in mode_set

David Ahern (1):
      perf report: Fix crash showing warning related to kernel maps

David Brown (1):
      ARM: msm: Fix gic irqdomain support

David Henningsson (1):
      ALSA: HDA: Add external mic quirk for Asus Zenbook UX31E

David Miller (2):
      Fix modpost failures in fedora 17
      mm: nobootmem: Correct alloc_bootmem semantics.

David Sterba (1):
      btrfs: add missing unlocks to transaction abort paths

David Teigland (1):
      dlm: fix QUECVT when convert queue is empty

David Vrabel (1):
      xen: correctly check for pending events when restoring irq flags

David Ward (2):
      net_sched: gred: Fix oops in gred_dump() in WRED mode
      net_sched: red: Make minor corrections to comments

David Woodhouse (1):
      ppp: Fix race condition with queue start/stop

Davide Ciminaghi (2):
      net/ethernet: ks8851_mll fix rx frame buffer overflow
      dmaengine/amba-pl08x : reset phychan_hold on terminate all

Dmitry Artamonow (1):
      arm/sa1100: fix sa1100-rtc memory resource

Don Skidmore (1):
      ixgbe: fix WoL issue with fiber

Eldad Zack (1):
      super.c: unused variable warning without CONFIG_QUOTA

Eric Dumazet (3):
      tcp: fix tcp_grow_window() for large incoming frames
      tcp: fix retransmit of partially acked frames
      drop_monitor: allow more events per second

Eric W. Biederman (3):
      net: In unregister_netdevice_notifier unregister the netdevices.
      phonet: Sort out initiailziation and cleanup code.
      net ax25: Reorder ax25_exit to remove races.

Felipe Balbi (3):
      usb: musb: drop __deprecated flag
      usb: gadget: dummy: do not call pullup() on udc_stop()
      usb: gadget: udc-core: fix wrong call order

Felix Fietkau (3):
      ath9k: wake up the hardware from full sleep when idle is turned off
      mac80211: fix truncated packets in cooked monitor rx
      mac80211: fix logic error in ibss channel type check

Florian Fainelli (3):
      spi/bcm63xx: convert to the pump message infrastructure
      spi/bcm63xx: don't use the stopping state
      spi/bcm63xx: set master driver mode_bits.

Fred Isaman (3):
      NFS: check for req==NULL in nfs_try_to_update_request cleanup
      NFS: put open context on error in nfs_pagein_multi
      NFS: put open context on error in nfs_flush_multi

Gao feng (1):
      ipv6: fix problem with expired dst cache

Gavin Shan (1):
      powerpc/eeh: Fix crash caused by null eeh_dev

Giuseppe CAVALLARO (1):
      icplus: fix interrupt for IC+ 101A/G and 1001LF

Glauber Costa (1):
      fs/buffer.c: remove BUG() in possible but rare condition

Gleb Natapov (1):
      perf tools: Add 'G' and 'H' modifiers to event parsing

Greg Pearson (1):
      x86/apic: Use x2apic physical mode based on FADT setting

Guenter Roeck (2):
      hwmon: (ad7314) Fix build warning
      hwmon: (fam15h_power) Fix pci_device_id array

H Hartley Sweeten (2):
      x86/mrst: Quiet sparse noise about plain integer as NULL pointer
      spi/spi-ep93xx.c: use dma_transfer_direction instead of dma_data_direction

H. Peter Anvin (2):
      asm-generic: Allow overriding clock_t and add attributes to siginfo_t
      x32, siginfo: Provide proper overrides for x32 siginfo_t

H.J. Lu (1):
      x32: Check __ILP32__ instead of __LP64__ for x32

Hauke Mehrtens (1):
      bcma: use fallback sprom if no on chip sprom is available

Heiko Stübner (1):
      usb: otg: gpio_vbus: Add otg transceiver events and notifiers

Hiroaki SHIMODA (1):
      dummy: Add ndo_uninit().

Hugh Dickins (1):
      mm: fix s390 BUG by __set_page_dirty_no_writeback on swap

Igor Grinberg (2):
      ARM: PXA2xx: MFP: fix bug with MFP_LPM_KEEP_OUTPUT
      ARM: PXA2xx: MFP: fix potential direction bug

Ilija Hadzic (1):
      drm/radeon: add a missing entry to encoder_names

Ilya Dryomov (1):
      Btrfs: fix max chunk size check in chunk allocator

Imre Kaloz (1):
      staging: octeon-ethernet: fix build errors by including interrupt.h

Inki Dae (3):
      drm/exynos: fixed duplicatd memory allocation bug.
      drm/exynos: fixed exynos_drm_gem_map_pages bug.
      drm/exynos: added missed vm area region mapping type.

Jack Morgenstein (2):
      IB/mad: Set 'D' bit in response for unhandled MADs
      IB/mad: Don't send response for failed MADs

James Chapman (2):
      l2tp: fix refcount leak in l2tp_ip sockets
      l2tp: don't overwrite source address in l2tp_ip_bind()

Jan Kara (1):
      nfs: Enclose hostname in brackets when needed in nfs_do_root_mount

Jan Schmidt (3):
      Btrfs: don't call free_extent_buffer twice in iterate_irefs
      Btrfs: add missing read locks in backref.c
      Btrfs: fix repair code for RAID10

Jason Baron (1):
      epoll: clear the tfile_check_list on -ELOOP

Jason Wang (1):
      8139cp: set intr mask after its handler is registered

Jeff Layton (2):
      cifs: fix offset handling in cifs_iovec_write
      keys: update the documentation with info about "logon" keys

Jesper Juhl (4):
      ASoC: cs42l73: don't use negative array index
      can: usb: PCAN-USB Pro: fix mem leaks in pcan_usb_pro_init() on
error paths
      Btrfs: Make free_ipath() deal gracefully with NULL pointers
      IB/mlx4: Fix memory leaks in ib_link_query_port()

Jiri Bohac (2):
      ipv6: fix rt6_update_expires
      ipv6: clean up rt6_clean_expires

Jiri Kosina (1):
      arcnet: rimi: Fix device name in debug output

Jiri Olsa (1):
      perf symbols: Read plt symbols from proper symtab_type binary

Johannes Weiner (1):
      mm: memcg: move pc lookup point to commit_charge()

Jonathan Bither (2):
      ath5k: fix undefined 'THIS_MODULE'
      ath5k: unmap io memory on probe failure

Jonathan Brassow (1):
      DM RAID: Use safe version of rdev_for_each

Josef Bacik (2):
      Btrfs: always store the mirror we read the eb from
      Btrfs: do not start delalloc inodes during sync

Julia Lawall (4):
      net/key/af_key.c: add missing kfree_skb
      drivers/net/wan/farsync.c: add missing iounmap
      usb: musb: davinci.c: add missing unregister
      fs/btrfs/volumes.c: add missing free_fs_devices

Julian Anastasov (1):
      netns: do not leak net_generic data on failed init

Kenneth Graunke (1):
      drm/i915: Set the Stencil Cache eviction policy to non-LRA mode.

Kim Lilliestierna XX (1):
      caif_hsi: use dev_dbg not dev_err for reporting

Konrad Rzeszutek Wilk (5):
      ACPI: Convert wake_sleep_flags to a value instead of function
      x86, acpi: Call acpi_enter_sleep_state via an asmlinkage C
function from assembler
      xen/enlighten: Disable MWAIT_LEAF so that acpi-pad won't be loaded.
      xen/smp: Fix crash when booting with ACPI hotplug CPUs.
      xen/acpi: Workaround broken BIOSes exporting non-existing C-states.

Konstantin Khlebnikov (1):
      mm/hugetlb: fix warning in alloc_huge_page/dequeue_huge_page_vma

Kukjin Kim (2):
      ARM: S3C24XX: Fix build warning for S3C2410_PM
      ARM: EXYNOS: Fix resource on dev-dwmci.c

Laurent Pinchart (1):
      usb gadget: uvc: uvc_request_data::length field must be signed

Lee Jones (1):
      drivers/net: Do not free an IRQ if its request failed

Li Zefan (3):
      Btrfs: avoid setting ->d_op twice
      Btrfs: retrurn void from clear_state_bit
      Btrfs: avoid possible use-after-free in clear_extent_bit()

Liam Girdwood (1):
      ASoC: core: Fix card RTD count for deferred probe.

Linus Torvalds (4):
      Revert "autofs: work around unhappy compat problem on x86-64"
      pipes: add a "packetized pipe" mode for writing
      autofs: make the autofsv5 packet file descriptor use a packetized pipe
      Linux 3.4-rc5

Linus Walleij (3):
      ARM: u300: bump all IRQ numbers by one
      dma/ste_dma40: explicitly include regulator consumer header
      dma/ste_dma40: fix erroneous comparison

Liu Bo (1):
      Btrfs: do not mount when we have a sectorsize unequal to PAGE_SIZE

Lukasz Kucharczyk (1):
      cfg80211: fix interface combinations check.

Marcos Paulo de Souza (1):
      PM / Freezer / Docs: Update documentation about freezing of tasks

Marek Szyprowski (1):
      ARM: SAMSUNG: add missing MMC_CAP2_BROKEN_VOLTAGE capability

Mark Brown (4):
      ASoC: dapm: Ensure power gets managed for line widgets
      tracing: Fix build breakage without CONFIG_PERF_EVENTS (again)
      ARM: ux300: Fix unimplementable regulation constraints
      ASoC: wm8994: Improve sequencing of AIF channel enables

Martin Nyhus (1):
      dell-laptop: Terminate quirks list properly

Matt Fleming (1):
      x86, efi: Add dedicated EFI stub entry point

Matt Renzelmann (2):
      ks8851: Fix missing mutex_lock/unlock
      ks8851: Fix request_irq/free_irq mismatch

Michael Ellerman (1):
      perf: Fix perf_event_for_each() to use sibling

Michael S. Tsirkin (1):
      skbuff: struct ubuf_info callback type safety

Michal Simek (1):
      drivers/net/ethernet/xilinx/axi ethernet: Correct Copyright

Mingarelli, Thomas (1):
      hpwdt: Only BYTE reads/writes to WD Timer port 0x72

Mingkai Hu (4):
      powerpc/mpic_msgr: fix compile error when SMP disabled
      powerpc/mpic_msgr: add lock for MPIC message global variable
      powerpc/mpic_msgr: fix offset error when setting mer register
      powerpc/mpc85xx: add MPIC message dts node

Narayanan G (1):
      dma40: Improve the logic of stopping logical chan

Neal Cardwell (1):
      tcp: fix TCP_MAXSEG for established IPv6 passive sockets

NeilBrown (2):
      md: don't call ->add_disk unless there is good reason.
      md: fix possible corruption of array metadata on shutdown.

Nicolas Ferre (1):
      dmaengine: at_hdmac: remove clear-on-read in atc_dostart()

Nobuhiro Iwamatsu (1):
      sh: Fix up tracepoint build fallout from static key introduction.

Oleg Nesterov (1):
      i387: ptrace breaks the lazy-fpu-restore logic

Oliver Neukum (1):
      USB: cdc-wdm: fix race leading leading to memory corruption

Olof Johansson (1):
      dma: pl330: fix a couple of compilation warnings

Omar Ramirez Luna (1):
      staging: tidspbridge: remove usage of OMAP2_L4_IO_ADDRESS

Otavio Salvador (1):
      perf tools: Drop CROSS_COMPILE from flex and bison calls

Paul E. McKenney (1):
      rcu: Permit call_rcu() from CPU_DYING notifiers

Paul Gortmaker (8):
      powerpc: fix system.h fallout in sysdev/scom.c [chroma_defconfig]
      xtensa: fix build failure in xtensa/kernel/signal.c
      xtensa: fix build error in xtensa/include/asm/io.h
      irq: hide debug macros so they don't collide with others.
      pci: frv architecture needs generic setup-bus infrastructure
      blackfin: fix compile error in bfin-lq035q1-fb.c
      blackfin: fix ifdef fustercluck in mach-bf538/boards/ezkit.c
      xtensa: fix build fail on undefined ack_bad_irq

Paul Mundt (1):
      ASoC: fsi: update for dmaengine prep_slave_sg fallout.

Peter Feuerer (2):
      acerhdf: add support for new hardware
      acerhdf: lowered default temp fanon/fanoff values

Peter Zijlstra (1):
      sched: Fix more load-balancing fallout

Randy Dunlap (2):
      net/sock.h: fix sk_peek_off kernel-doc warning
      spi: fix spi.h kernel-doc warning

Richard Kuo (3):
      Hexagon: misc compile warning/error cleanup due to missing headers
      hexagon:  use renamed tick_nohz_idle_* functions
      hexagon: add missing cpu.h include

Robert Jarzmik (1):
      ARM: pxa: fix gpio wakeup setting

Rupesh Gujare (1):
      staging: ozwpan: Fix bug where kfree is called twice.

Russell King (1):
      Revert "ARM: 7359/2: smp_twd: Only wait for reprogramming on active cpus"

Sachin Prabhu (2):
      CIFS: Show backupuid/gid in /proc/mounts
      Use correct conversion specifiers in cifs_show_options

Sasha Levin (2):
      mm: fix NULL ptr dereference in migrate_pages
      mm: fix NULL ptr dereference in move_pages

Scott Jiang (6):
      spi/bfin5xx: rename config macro name for bfin5xx spi controller driver
      spi/spi-bfin-sport: move word length setup to transfer handler
      spi/bfin_spi: drop bits_per_word from client data
      spi/spi_bfin_sport: drop bits_per_word from client data
      spi/spi-bfin5xx: fix reversed if condition in interrupt mode
      spi/spi-bfin5xx: Fix flush of last bit after each spi transfer

Sergei Trofimovich (1):
      btrfs: fix early abort in 'remount'

Seth Jennings (1):
      staging: zcache: fix Kconfig crypto dependency

Shaohua Li (1):
      jbd2: use GFP_NOFS for blkdev_issue_flush

Shawn Guo (1):
      dma: mxs-dma: enable channel in device_issue_pending call

Srivatsa S. Bhat (2):
      x86, intel_cacheinfo: Fix error return code in amd_set_l3_disable_slot()
      hexagon/CPU hotplug: Add missing call to notify_cpu_starting()

Stanislav Kinsbursky (1):
      SUNRPC: register PipeFS file system after pernet sybsystem

Stefan Behrens (4):
      Btrfs: fix btrfs_ioctl_dev_info() crash on missing device
      Btrfs: don't count CRC or header errors twice while scrubbing
      Btrfs: fix that check_int_data mount option was ignored
      Btrfs: fix block_rsv and space_info lock ordering

Stefano Stabellini (1):
      xen: use the pirq number to check the pirq_eoi_map

Stephane Fillod (1):
      net: usb: smsc75xx: fix mtu

Stephen Boyd (1):
      ks8851: Fix mutex deadlock in ks8851_net_stop()

Steven Rostedt (2):
      tracing: Fix regression with tracing_on
      tracing: Fix stacktrace of latency tracers (irqsoff and friends)

Stuart Menefy (1):
      sh: Fix error synchronising kernel page tables

Sujith Manoharan (1):
      ath9k: Fix TX fragmentation

Suresh Siddha (1):
      tick: Fix the spurious broadcast timer ticks after resume

      tick: Ensure that the broadcast device is initialized

Timur Tabi (1):
      powerpc/85xx: don't call of_platform_bus_probe() twice

Tomasz Gregorek (1):
      caif: Fix memory leakage in the chnl_net.c.

Tony Zelenoff (1):
      atl1: fix kernel panic in case of DMA errors

Torsten Kaiser (1):
      net: Fix misplaced parenthesis in virtio_net.c

Trond Myklebust (6):
      NFSv4: Ensure that the LOCK code sets exception->inode
      NFSv4: Ensure that we check lock exclusive/shared type against open modes
      NFSv4: Fix open(O_TRUNC) and ftruncate() error handling
      NFSv4: Ensure we do not reuse open owner names
      NFSv4: Ensure that we don't drop a state owner more than once
      NFSv4: Keep dropped state owners on the LRU list for a while

Tushar Behera (1):
      ARM: EXYNOS: Fix compilation error when CONFIG_OF is not defined

Vasiliy Kulikov (1):
      arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file

Vinit Shenoy (1):
      spi/pl022: Fix range checking for bits per word

Vinod Koul (1):
      dmaengine: imx-dma: dont complete descriptor for cyclic dma

Viresh Kumar (2):
      spi/pl022: Fix calculate_effective_freq()
      spi/pl022: Allow request for higher frequency than maximum possible

Wenqi Ma (1):
      net/hyperv: Adding cancellation to ensure rndis filter is closed

Wey-Yi Guy (1):
      MAINTAINERS: Add maintainer for iwlwifi

Will Deacon (2):
      net: smsc911x: fix skb handling in receive path
      revert "proc: clear_refs: do not clear reserved pages"

Xi Wang (2):
      drm/i915: fix integer overflow in i915_gem_execbuffer2()
      drm/i915: fix integer overflow in i915_gem_do_execbuffer()

Ying Han (1):
      mm: fix up the vmscan stat in vmstat

he, bo (1):
      sched: Fix OOPS when build_sched_domains() percpu allocation fails

sjur.brandeland@stericsson.com (1):
      caif-hsi: Free flip_buffer at shutdown
