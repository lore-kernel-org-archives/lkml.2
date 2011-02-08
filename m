Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1BHAYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 19:24:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755401Ab1BHAYU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 19:24:20 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 7 Feb 2011 16:23:37 -0800
Message-ID: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
Subject: Linux 2.6.38-rc4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No travel or cyclone-dodging this time, so as promised, the -rc's are
now back to the usual weekly schedule.

There's nothing much that stands out here. Some arch updates (arm and
powerpc), the usual driver updates: dri (radeon/i915), network cards,
sound, media, scisi, some filesystem updates (cifs, btrfs), and some
random stuff to round it all out (networking, watchpoints,
tracepoints, etc).

Pretty small, all in all. I'd obviously prefer it to be even smaller,
and I actually dropped a pull request or two, but for being -rc4 this
is by no means horrible. As long as it keeps shrinking, I'll be happy.

                             Linus

---

Aaro Koskinen (3):
      arm: mach-omap2: voltage: debugfs: fix memory leak
      arm: mach-omap2: board-rm680: fix rm680_vemmc regulator constraints
      arm: mach-omap2: mux: free allocated memory on error exit

Ajit Khaparde (3):
      be2net: fix a crash seen during insmod/rmmod test
      be2net: remove netif_stop_queue being called before register_netdev.
      MAINTAINERS: update email ids of the be2net driver maintainers.

Akinobu Mita (1):
      [S390] use asm-generic/cacheflush.h

Alan Cox (1):
      depca: Fix warnings

Alex Deucher (10):
      drm/radeon/kms: rv6xx+ thermal sensor fixes
      drm/radeon/kms: switch back to min->max pll post divider iteration
      drm/radeon/kms: add pll debugging output
      drm/radeon/kms: add new pll algo for avivo asics
      drm/radeon/kms: Enable new pll calculation for avivo+ asics
      drm/radeon: remove 0x4243 pci id
      drm/radeon/kms: add updated ib_execute function for evergreen
      drm/radeon/kms/evergreen: always set certain VGT regs at CP init
      drm/radeon/kms: fix s/r issues with bios scratch regs
      drm/radeon/kms: dynamically allocate power state space

Alexey Charkov (1):
      btrfs: Drop __exit attribute on btrfs_exit_compress

Amerigo Wang (1):
      sound: silent echo'ed messages in Makefile

Andrea Arcangeli (1):
      mm: when migrate_pages returns 0, all pages must have been released

Andy Gospodarek (1):
      gro: reset skb_iif on reuse

Andy Robinson (1):
      ALSA: HDA: cxt5066 - Use asus model for Asus U50F, select
correct SPDIF output

Anton Blanchard (6):
      powerpc/numa: Only use active VPHN count fields
      powerpc/numa: Check for all VPHN changes
      powerpc/numa: Add length when creating OF properties via VPHN
      powerpc/numa: Disable VPHN on dedicated processor partitions
      powerpc/numa: Fix bug in unmap_cpu_from_node
      powerpc: Fix hcall tracepoint recursion

Arnaldo Carvalho de Melo (1):
      perf stat: Fix aggreate counter reading accounting

Ben Dooks (3):
      MAINTAINERS: move s3c2410 drivers to ARM/SAMSUNG ARM
      MAINTAINERS: fixup file entries for "SIMTEC EB2410ITX (BAST)"
      MAINTAINERS: fixup Simtec support email entries

Ben Hutchings (1):
      arm/ixp4xx: Rename FREQ macro to avoid collisions

Ben Skeggs (1):
      drm/nv50: fix display on 0x50

Benjamin Herrenschmidt (2):
      powerpc: Pass the right cpu_spec to ->setup_cpu() on 64-bit
      powerpc: Fix some 6xx/7xxx CPU setup functions

Boaz Harrosh (1):
      Revert "exofs: Set i_mapping->backing_dev_info anyway"

Bob Copeland (2):
      ath5k: fix error handling in ath5k_hw_dma_stop
      ath5k: correct endianness of frame duration

Chaoming Li (1):
      rtlwifi: Fix firmware upload errors

Chris Mason (2):
      Btrfs: catch errors from btrfs_sync_log
      Btrfs: avoid uninit variable warnings in ordered-data.c

Chris Wilson (10):
      drm/i915/sdvo: If at first we don't succeed in reading the response, wait
      drm: Add an interface to reset the device
      drm/i915: Reset state after a GPU reset or resume
      drm/i915/crt: Force the initial probe after reset
      drm/i915: Reset crtc after resume
      drm: Don't switch fb when disabling an output
      drm: Simplify and defend later checks when disabling a crtc
      drm: Avoid leak of adjusted mode along quick set_mode paths
      drm/i915: Suppress spurious vblank interrupts
      drm/i915: Only bind to function 0 of the PCI device

Christoph Hellwig (2):
      hfsplus: fix failed mount handling
      hfsplus: fix up a comparism in hfsplus_file_extend

Chuck Ebbert (4):
      CAN: softing driver depends on IOMEM
      atl1c: Add missing PCI device ID
      hfsplus: do not leak buffer on error
      hfsplus: fix two memory leaks in wrapper.c

Clemens Ladisch (1):
      ALSA: oxygen: fix output routing on Xonar DG

David Dillow (1):
      [SCSI] fix incorrect value of SCSI_MAX_SG_CHAIN_SEGMENTS due to
include file ordering

David Henningsson (3):
      ALSA: HDA: Refactor some redundant code for Conexant 5066/205xx
      ALSA: HDA: Add a new model "asus" for Conexant 5066/205xx
      ALSA: HDA: Fix microphone(s) on Lenovo Edge 13

David S. Miller (5):
      ipv6: Remove route peer binding assertions.
      niu: Fix races between up/down and get_stats.
      net: Fix bug in compat SIOCGETSGCNT handling.
      net: Support compat SIOCGETVIFCNT ioctl in ipv4.
      net: Provide compat support for SIOCGETMIFCNT_IN6 and SIOCGETSGCNT_IN6.

Eric Dumazet (4):
      perf: Fix alloc_callchain_buffers()
      econet: remove compiler warnings
      net: add kmemcheck annotation in __alloc_skb()
      epoll: epoll_wait() should not use timespec_add_ns()

Eric W. Biederman (3):
      net: Fix ip link add netns oops
      net: Add compat ioctl support for the ipv4 multicast ioctl SIOCGETSGCNT
      net: Fix ipv6 neighbour unregister_sysctl_table warning

Fabio Estevam (2):
      ARM: imx: Add VPR200 and MX51_3DS entries to uncompress.h
      ARM: mach-imx/mach-mx25_3ds: Fix section type

Francois Romieu (2):
      r8169: RxFIFO overflow oddities with 8168 chipsets.
      r8169: prevent RxFIFO induced loops in the irq handler.

Frank Blaschka (1):
      qeth: add more strict MTU checking

H. Peter Anvin (2):
      x86-32: Make sure the stack is set up before we use it
      x86, nx: Mark the ACPI resume trampoline code as +x

Heiko Carstens (1):
      [S390] tlb: fix build error caused by THP

Herbert Xu (1):
      gro: Reset dev pointer on reuse

Huang Weiyi (1):
      omap1: remove duplicated #include

Ian Campbell (1):
      xen: netfront: handle incoming GSO SKBs which are not CHECKSUM_PARTIAL

Ian Kent (1):
      Btrfs: Fix memory leak on finding existing super

Ivan Vecera (1):
      r8169: use RxFIFO overflow workaround for 8168c chipset.

James Bottomley (1):
      [SCSI] libsas: fix runaway error handler problem

Jan Glauber (1):
      [S390] qdio: prevent compile warning under CONFIG_32BIT

Janusz Krzysztofik (2):
      ASoC: Amstrad Delta: fix const related build error
      ASoC: CX20442: fix NULL pointer dereference

Jarkko Nikula (1):
      ASoC: Fix module refcount for auxiliary devices

Jarod Wilson (8):
      [media] rc/mce: add mappings for missing keys
      [media] hdpvr: fix up i2c device registration
      [media] lirc_zilog: z8 on usb doesn't like back-to-back i2c_master_send
      [media] ir-kbd-i2c: improve remote behavior with z8 behind usb
      [media] rc/ir-lirc-codec: add back debug spew
      [media] rc: use time unit conversion macros correctly
      [media] mceusb: really fix remaining keybounce issues
      [media] rc/streamzap: fix reporting response times

Javi Merino (1):
      sched, docs: Update schedstats documentation to version 15

Jean-François Moine (3):
      [media] gspca - zc3xx: Bad delay when given by a table
      [media] gspca - zc3xx: Fix bad images with the sensor hv7131r
      [media] gspca - zc3xx: Discard the partial frames

Jeff Layton (13):
      cifs: fix two compiler warning about uninitialized vars
      cifs: handle cancelled requests better
      cifs: send an NT_CANCEL request when a process is signalled
      cifs: simplify SMB header check routine
      cifs: don't pop a printk when sending on a socket is interrupted
      cifs: force a reconnect if there are too many MIDs in flight
      cifs: make CIFS depend on CRYPTO_MD4
      cifs: clean up some compiler warnings
      cifs: fix length checks in checkSMB
      cifs: fix length vs. total_read confusion in cifs_demultiplex_thread
      cifs: enable signing flag in SMB header when server has it on
      cifs: don't send an echo request unless NegProt has been done
      cifs: remove checks for ses->status == CifsExiting

Jesse Larrew (3):
      powerpc/pseries: Fix typo in VPHN comments
      powerpc/pseries: Fix brace placement in numa.c
      powerpc/pseries: Remove unnecessary variable initializations in numa.c

Jin Dongming (3):
      thp: fix splitting of hwpoisoned hugepages
      thp: fix the wrong reported address of hwpoisoned hugepages
      thp: fix unsuitable behavior for hwpoisoned tail page

Johannes Weiner (3):
      memcg: prevent endless loop when charging huge pages
      memcg: prevent endless loop when charging huge pages to near-limit group
      memcg: never OOM when charging huge pages

Josef Bacik (9):
      Btrfs: fix check_path_shared so it returns the right value
      Btrfs: do not release more reserved bytes to the
global_block_rsv than we need
      Btrfs: use the global block reserve if we cannot reserve space
      Btrfs: do error checking in btrfs_del_csums
      Btrfs: handle no memory properly in prepare_pages
      Btrfs: make shrink_delalloc a little friendlier
      fs: make block fiemap mapping length at least blocksize long
      Btrfs: make sure search_bitmap finds something in remove_from_bitmap
      Btrfs: exclude super blocks when we read in block groups

Julia Lawall (3):
      OMAP: PM: SmartReflex: Add missing IS_ERR test
      fs/btrfs/inode.c: Add missing IS_ERR test
      include/net/genetlink.h: Allow genlmsg_cancel to accept a NULL argument

KAMEZAWA Hiroyuki (1):
      memcg: fix event counting breakage from recent THP update

Kashyap, Desai (6):
      [SCSI] mpt2sas: Fix device removal handshake for zoned devices
      [SCSI] mpt2sas: fix internal device reset for older firmware
prior to MPI Rev K
      [SCSI] mpt2sas: Correct resizing calculation for max_queue_depth
      [SCSI] mpt2sas: Fix the race between broadcast asyn event and
scsi command completion
      [SCSI] mpt2sas: Kernel Panic during Large Topology discovery
      [SCSI] mpt2sas: fix Integrated Raid unsynced on shutdown problem

Keith Packard (1):
      drm: Only set DPMS ON when actually configuring a mode

Ken Kawasaki (1):
      axnet_cs: reduce delay time at ei_rx_overrun

Kevin Hilman (1):
      OMAP3: PM: fix save secure RAM to restore MPU power state

Krzysztof Hałasa (1):
      IXP4xx: Fix qmgr_release_queue() flushing unexpected queue entries.

Kurt Van Dijck (1):
      net: fix validate_link_af in rtnetlink core

Li Zefan (8):
      btrfs: Fix threshold calculation for block groups smaller than 1GB
      btrfs: Add helper function free_bitmap()
      btrfs: Free fully occupied bitmap in cluster
      btrfs: Update stats when allocating from a cluster
      btrfs: Add a helper try_merge_free_space()
      btrfs: Check mergeable free space when removing a cluster
      Btrfs: Fix memory leak at umount
      Btrfs: Fix file clone when source offset is not 0

Linus Lüssing (1):
      batman-adv: Fix kernel panic when fetching vis data on a vis server

Linus Torvalds (1):
      Linux 2.6.38-rc4

Lucas Stach (1):
      drm/nouveau: correctly pair hwmon_init and hwmon_fini

Luciano Coelho (1):
      MAINTAINERS: update information for the wl12xx driver

Manjunathappa, Prakash (1):
      ASoC: DaVinci: fix kernel panic due to uninitialized platform_data

Marcelo Roberto Jimenez (1):
      RTC: Prevents a division by zero in kernel code.

Marcin Slusarz (3):
      watchdog: Fix broken nowatchdog logic
      watchdog: Fix sysctl consistency
      watchdog: Don't change watchdog state on read of sysctl

Marek Vasut (1):
      OMAP1: Fix non-working LCD on OMAP310

Martin Schwidefsky (2):
      [S390] pgtable_list corruption
      [S390] missing sacf in uaccess

Mathias Krause (1):
      wl12xx: fix use after free

Mathieu Desnoyers (1):
      tracepoints: Fix section alignment using pointer array

Matt Turner (2):
      amd-k7-agp: remove non-x86 code
      Revert "agp: AMD AGP is used on UP1100 & UP1500 alpha boxen"

Matthieu CASTET (1):
      x86, nx: Don't force pages RW when setting NX bits

Miao Xie (2):
      Btrfs: Don't return acl info when mounting with noacl option
      Btrfs: Fix memory leak in writepage fixup work

Michael S. Tsirkin (1):
      vhost: rcu annotation fixup

Michal Hocko (2):
      memsw: handle swapaccount kernel parameter correctly
      memsw: deprecate noswapaccount kernel parameter and schedule it
for removal

Michal Simek (3):
      microblaze: Fix DTB passing from bootloader
      microblaze: Fix unaligned issue on MMU system with BS=0 DIV=1
      microblaze: Fix ASM optimized code for LE

Michel Lespinasse (1):
      mlock: operate on any regions with protection != PROT_NONE

Mika Westerberg (1):
      ARM: 6652/1: ep93xx: correct the end address of the AC97 memory resource

Minchan Kim (1):
      mm/migration: fix page corruption during hugepage migration

Ming Lei (1):
      arm: omap4: panda: remove usb_nop_xceiv_register(v1)

Mitko Haralanov (1):
      IB/qib: Hold link for TX SERDES settings

Mohammed Shafi Shajakhan (1):
      ath9k: Fix memory leak due to failed PAPRD frames

Namhyung Kim (2):
      vfs: sparse: remove a warning on OPEN_FMODE()
      vfs: sparse: add __FMODE_EXEC

NickCheng (1):
      [SCSI] arcmsr: Fix the issue of system hangup after commands
timeout on ARC-1200

Oliver Hartkopp (1):
      slcan: fix referenced website in Kconfig help text

Pablo Neira Ayuso (3):
      netfilter: ctnetlink: fix missing refcount increment during dumps
      netfilter: arpt_mangle: fix return values of checkentry
      netfilter: ecache: always set events bits, filter them later

Pavel Emelyanov (1):
      bridge: Don't put partly initialized fdb into hash

Pavel Shilovsky (1):
      CIFS: Fix variable types in cifs_iovec_read/write (try #2)

Peter Chubb (1):
      tcp_ecn is an integer not a boolean

Peter Zijlstra (3):
      perf: Fix reading in perf_event_read()
      sched: Fix update_curr_rt()
      lockdep, timer: Fix del_timer_sync() annotation

Rajkumar Manoharan (2):
      ath9k_hw: Fix system hang when resuming from S3/S4
      ath9k: Fix power save usage count imbalance on deinit

Ralf Thielow (1):
      RDMA/amso1100: Fix compile warnings

Randy Dunlap (2):
      gpu/stub: fix acpi_video build error, fix stub kconfig dependencies
      gpu/stub: fix acpi_video build error, fix stub kconfig dependencies

Roland Dreier (1):
      net: Add default_mtu() methods to blackhole dst_ops

Russell King (3):
      [media] fix saa7111 non-detection
      ARM: Update mach-types
      ALSA: AACI: allow writes to MAINCR to take effect

Sascha Hauer (4):
      ARM i.MX28: fix bit operation
      ARM i.MX28: use correct register for setting the rate
      ARM i.MX23/28: remove secondary field from struct clk. It's unused
      ARM i.MX23: use correct register for setting the rate

Scott Wood (2):
      powerpc: Fix pfn_valid() when memory starts at a non-zero address
      powerpc/book3e: Protect complex macro args in mmu-book3e.h

Sebastian Ott (1):
      [S390] reset default for CONFIG_CHSC_SCH

Shawn Guo (1):
      ARM: mxs: fix clock base address missing

Shirish Pargaonkar (2):
      cifs: No need to check crypto blockcipher allocation
      cifs: Possible slab memory corruption while updating extended
stats (repost)

Stanislav Fomichev (1):
      cifs: add check for kmalloc in parse_dacl

Stanislaw Gruszka (3):
      ath9k: fix race conditions when stop device
      ath9k_htc: fix race conditions when stop device
      dl2k: nulify fraginfo after unmap

Stefan Haberland (1):
      [S390] dasd: prevent panic with unresumed devices

Stefan Weil (8):
      drm/radeon: Fix wrong boolean operator
      OMAP: PM: SmartReflex: Fix possible memory leak
      OMAP: PM: SmartReflex: Fix possible null pointer read access
      enc28j60: Fix reading of transmit status vector
      vxge: Fix wrong boolean operator
      isdn: icn: Fix potentially wrong string handling
      s390: Fix wrong size in memcmp (netiucv)
      s390: Fix possibly wrong size in strncmp (smsgiucv)

Stephane Eranian (1):
      perf: Fix Pentium4 raw event validation

Stephen Kitt (1):
      agp: ensure GART has an address before enabling it

Stephen Warren (1):
      ASoC: Fix mask/val_mask confusion snd_soc_dapm_put_volsw()

Steve French (1):
      [CIFS] Update cifs minor version

Steve Wise (3):
      RDMA/cxgb4: Limit MAXBURST EQ context field to 256B
      RDMA/cxgb4: Set the correct device physical function for iWARP connections
      RDMA/ucma: Copy iWARP route information on queries

Steven Rostedt (2):
      tracing: Replace trace_event struct array with pointer array
      tracing: Replace syscall_meta_data struct array with pointer array

Suresh Siddha (2):
      x86, mtrr: Avoid MTRR reprogramming on BP during boot on UP platforms
      x86, mm: avoid possible bogus tlb entries by clearing prev
mm_cpumask after switching mm

Sven Eckelmann (3):
      batman-adv: Remove vis info on hashing errors
      batman-adv: Remove vis info element in free_info
      batman-adv: Make vis info stack traversal threadsafe

Takashi Iwai (2):
      ALSA: hda - Fix memory leaks in conexant jack arrays
      ALSA: use linux/io.h to fix compile warnings

Tejun Heo (1):
      RDMA: Update missed conversion of flush_scheduled_work()

Tero Roponen (1):
      Btrfs: Free correct pointer after using strsep

Tetsuo Handa (3):
      CRED: Fix kernel panic upon security_file_alloc() failure.
      CRED: Fix BUG() upon security_cred_alloc_blank() failure
      CRED: Fix memory and refcount leaks upon security_prepare_creds() failure

Thomas Gleixner (3):
      genirq: Prevent irq storm on migration
      genirq: Add missing status flags to modification mask
      m32r: Fixup last __do_IRQ leftover

Thomas Jacob (1):
      netfilter: xt_iprange: Incorrect xt_iprange boundary check for IPv6

Thomas Weber (1):
      OMAP3: Devkit8000: Change lcd power pin

Tom Herbert (1):
      net: Check rps_flow_table when RPS map length is 1

Tsutomu Itoh (5):
      btrfs: fix return value check of btrfs_join_transaction()
      btrfs: check return value of btrfs_start_ioctl_transaction() properly
      btrfs: checking NULL or not in some functions
      btrfs: fix return value check of btrfs_start_transaction()
      btrfs: cleanup error handling in btrfs_unlink_inode()

Ursula Braun (3):
      qeth: show new mac-address if its setting fails
      qeth: allow HiperSockets framesize change in suspend
      qeth: allow OSA CHPARM change in suspend state

Uwe Kleine-König (2):
      ARM: mxs: acknowledge gpio irq
      ARM: mxs/imx28: remove now unused clock lookup "fec.0"

Vasiliy Kulikov (2):
      net: can: at91_can: world-writable sysfs files
      net: can: janz-ican3: world-writable sysfs termination file

Vladislav Zolotarov (1):
      bnx2x: multicasts in NPAR mode

Yan, Zheng (1):
      Btrfs: Fix page count calculation

Yaniv Rosner (5):
      bnx2x: Remove setting XAUI low-power for BCM8073
      bnx2x: Fix LED blink rate on BCM84823
      bnx2x: Fix port swap for BCM8073
      bnx2x: Fix potential link loss in multi-function mode
      bnx2x: Update bnx2x version to 1.62.00-5

Yevgeny Petrilin (1):
      mlx4_core: Add ConnectX-3 device IDs

liubo (3):
      btrfs: fix uncheck memory allocation in btrfs_submit_compressed_read
      btrfs: fix several uncheck memory allocations
      btrfs: fix missing break in switch phrase

sjur.brandeland@stericsson.com (1):
      caif: bugfix - add caif headers for userspace usage.
