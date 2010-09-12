Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab0ILXuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 19:50:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754092Ab0ILXuV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 19:50:21 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 12 Sep 2010 16:49:27 -0700
Message-ID: <AANLkTinKgW2LAxQ1OC8s_MUo7UdYoGgitUUA3TwRKiCc@mail.gmail.com>
Subject: Linux 2.6.36-rc4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So due to travel, it's been two weeks rather than the usual one, but
2.6.36-rc4 is out there now.

Nothing in particular stands out, although there's been more noise in
GPU development than I'd like at this point (both Radeon and i915).
But that should hopefully all be just stabilization. There's also been
some PCIe/firmware interaction changes, that should fix way more
issues than it breaks.

Other than that - and some ocfs2 updates - it's really pretty random
and a lot of the diffstat is single-line changes in various places.
Nothing really exciting that stands out (famous last words).

One thing worth mentioning has nothing to do with this particular
release, but came up this week as part of an unrelated thread: it
would be good if people who create patches would try to acknowledge
the person who reported the issue that caused the patch. We have a
fair number of "Reported-by:" taglines in our logs, but we really
almost certainly should have many more of those. Remembering to give
appropriate credit to all the people who do testing or otherwise
notice problems would be a great thing. Sometimes the fix is trivial,
and the real work was in noticing and figuring out that a problem
exists in the first place, and reporting it.

Shortlog appended,

                       Linus

---

A E Lawrence (1):
      USB: cp210x usb driver: add USB_DEVICE for Pirelli DP-L10 mobile.

Ajit Khaparde (3):
      be2net: fix net-snmp error because of wrong packet stats
      be2net: fix a bug in UE detection logic
      be2net: remove a BUG_ON in be_cmds.c

Alan Stern (1):
      [SCSI] sd: fix medium-removal bug

Alex Deucher (9):
      drm/radeon/kms: use tracked values for sclk and mclk
      drm/radeon/kms: fix a regression on r7xx AGP due to the HDP flush fix
      drm/radeon/kms: remove useless clock code
      drm/radeon/kms: force legacy pll algo for RV515 LVDS
      drm/radeon/kms: fix tv module parameter
      drm/radeon/kms: properly set crtc high base on r7xx
      drm/radeon/kms/evergreen: work around bad data in some i2c tables
      drm/radeon/kms/evergreen: fix gpu hangs in userspace accel code
      drm/radeon/kms: fix tv-out on avivo asics

Alexander Graf (1):
      powerpc/85xx: Fix compilation of mpc85xx_mds.c

Andi Kleen (1):
      gcc-4.6: kernel/*: Fix unused but set warnings

Andrea Arcangeli (2):
      mm: fix swapin race condition
      mm: avoid warning when COMPACTION is selected

Andreas Bombe (1):
      staging: comedi das08_cs.c: Fix io_req_t conversion

Andreas Herrmann (1):
      x86, mcheck: Avoid duplicate sysfs links/files for thresholding banks

Andrew Morton (2):
      fs/bio-integrity.c: return -ENOMEM on kmalloc failure
      drivers/gpu/drm/i915/intel_overlay.c needs seq_file.h

Anton Vorontsov (1):
      powerpc/85xx: Add P1021 PCI IDs and quirks

Arkadiusz Mi?kiewicz (1):
      xfs: Disallow 32bit project quota id

Arnd Bergmann (1):
      Input: use PIT_TICK_RATE in vt beep ioctl

Arnd Hannemann (2):
      ARM: mach-shmobile: AP4EVB: use gpio-leds for leds.
      ARM: mach-shmobile: ap4evb: fix write protect for SDHI1

Artem Bityutskiy (3):
      writeback: do not lose wakeup events when forking bdi threads
      UBI: fix forward compatibility
      UBI: do not oops when erroneous PEB is scheduled for scrubbing

Arun Easi (2):
      [SCSI] qla2xxx: Fix vport delete issues
      [SCSI] qla2xxx: make rport deletions explicit during vport removal

Atsushi Nemoto (1):
      rtc: m41t80: do not use rtc_valid_tm in m41t80_rtc_read_alarm

Avi Kivity (2):
      KVM: x86 emulator: fix regression with cmpxchg8b on i386 hosts
      KVM: fix i8259 oops when no vcpus are online

Axel Lin (1):
      ARM: pxa: fix CI_HSYNC and CI_VSYNC MFP defines for pxa300

Ben Hutchings (4):
      3c59x: Remove incorrect locking; correct documented lock hierarchy
      Staging: rt2870sta: Add more device IDs from vendor drivers
      3c59x: Fix deadlock in vortex_error()
      niu: Fix kernel buffer overflow for ETHTOOL_GRXCLSRLALL

Bill Pemberton (1):
      USB: ssu100: turn off debug flag

Breno Leitao (1):
      MAINTAINERS: Add ehea driver as Supported

Brian Austin (1):
      ALSA: hda - Add errata initverb sequence for CS42xx codecs

Brian King (1):
      block: Range check cpu in blk_cpu_to_group

Catalin Marinas (1):
      ARM: 6344/1: Mark CPU_32v6K as depended on CPU_V7

Chien Tung (1):
      RDMA/nes: Write correct register write to set TX pause param

Chris Wilson (19):
      drm/kms: Add a module parameter to disable polling
      drm: Do not force 1024x768 modes on unknown connectors
      Revert "drm/i915: Unreference object not handle on creation"
      drm/i915: Clear the vblank status bit before polling for the next vblank
      agp/intel: Promote warning about failure to setup flush to error.
      drm/i915: Include a generation number in the device info
      drm/i915: Fix offset page-flips on i965+
      drm/i915: Re-use set_base_atomic to share setting of the display registers
      drm/i915/dp: Boost timeout for enabling transcoder to 100ms
      drm/i915/sdvo: Restore guess of the DDC bus in absence of VBIOS
      drm/i915/dp: Really try 5 times before giving up.
      drm/i915: Allocate the PCI resource for the MCHBAR
      drm/i915: Tightly scope intel_encoder to prevent invalid use
      drm/i915: Avoid use of uninitialised values when disabling panel-fitter
      drm/i915: Prevent double dpms on
      Revert "drm/i915: Enable RC6 on Ironlake."
      Revert "drm/i915: Allow LVDS on pipe A on gen4+"
      Revert "drm/i915: Warn if we run out of FIFO space for a mode"
      drm/i915: Double check that the wait_request is not pending before warning

Chris Wright (1):
      tracing: t_start: reset FTRACE_ITER_HASH in case of seek/pread

Christian Lamparter (1):
      p54: fix tx feedback status flag check

Christoph Hellwig (1):
      swap: do not send discards as barriers

Christoph Lameter (1):
      mm: page allocator: calculate a better estimate of NR_FREE_PAGES
when memory is low and kswapd is awake

Ciju Rajan K (1):
      blkio: Fix return code for mkdir calls

Clemens Ladisch (3):
      ALSA: usb-audio: fix detection of vendor-specific device protocol settings
      ALSA: virtuoso: work around missing reset in the Xonar DS Windows driver
      ALSA: virtuoso: fix setting of Xonar DS line-in/mic-in controls

Colin Cross (1):
      PM: Prevent waiting forever on asynchronous resume after failing suspend

Craig Shelley (1):
      USB: CP210x Add new device ID

Dan Carpenter (8):
      cciss: handle allocation failure
      9p: potential ERR_PTR() dereference
      sysfs: checking for NULL instead of ERR_PTR
      USB: ehci-ppc-of: problems in unwind
      i915: return -EFAULT if copy_to_user fails
      i915: return -EFAULT if copy_to_user fails
      irda: off by one
      ALSA: rawmidi: fix the get next midi device ioctl

Dan Rosenberg (1):
      xfs: prevent reading uninitialized stack memory

Dan Williams (2):
      md: don't clear MD_CHANGE_CLEAN in md_update_sb() for external arrays
      ipheth: remove incorrect devtype to WWAN

Daniel Mack (1):
      ALSA: usb-audio: Assume first control interface is for audio

Daniel Vetter (1):
      drm/i915: overlay on gen2 can't address above 1G

Dave Airlie (1):
      PCI: provide stub pci_domain_nr function for !CONFIG_PCI configs

Dave Chinner (3):
      xfs: improve buffer cache hash scalability
      xfs: prevent 32bit overflow in space reservation
      xfs: log IO completion workqueue is a high priority queue

Dave Ludlow (2):
      usb: serial: mos7840: Add USB ID to support the B&B Electronics
USOPTL4-2P.
      usb: serial: mos7840: Add USB IDs to support more B&B USB/RS485
converters.

David Brownell (1):
      gpio: doc updates

David Henningsson (1):
      ALSA: hda - Add a new hp-laptop model for Conexant 5066, tested on HP G60

David Howells (5):
      h8300: IRQ flags should be stored in an unsigned long
      h8300: Fix die()
      h8300: Fix missing consts in kernel_execve()
      KEYS: Fix RCU no-lock warning in keyctl_session_to_parent()
      KEYS: Fix bug in keyctl_session_to_parent() if parent has no
session keyring

David Miller (1):
      [SCSI] sd, sym53c8xx: Remove warnings after vsprintf %pV introducation.

David Rientjes (1):
      bio-integrity.c: remove dependency on __GFP_NOFAIL

David S. Miller (7):
      irda: Correctly clean up self->ias_obj on irda_bind() failure.
      netlink: Make NETLINK_USERSOCK work again.
      bridge: Clear INET control block of SKBs passed into ip_fragment().
      Revert "sky2: don't do GRO on second port"
      ipv4: Fix reverse path filtering with multipath routing.
      via-velocity: Turn scatter-gather support back off.
      sparc: Kill all BKL usage.

David Vrabel (1):
      mmc: avoid getting CID on SDIO-only cards

Denis Kirjanov (1):
      pxa168_eth: fix a mdiobus leak

Dirk De Schepper (1):
      USB: option: fix incorrect novatel entries

Dmitry Torokhov (1):
      Input: i8042 - fix device removal on unload

Don Zickus (2):
      lockup_detector: Sync touch_*_watchdog back to old semantics
      perf, x86: Fix accidentally ack'ing a second event on intel perf counter

Eric Bénard (1):
      eukrea-baseboards: fix the merge in one file

Eric Dumazet (4):
      vhost: stop worker only if created
      gro: fix different skb headrooms
      udp: add rehash on connect()
      KS8851: Correct RX packet allocation

Eric Miao (1):
      ARM: pxa: remove __init from cpufreq_driver->init()

Erik Gilling (1):
      [ARM] tegra: Add ZRELADDR default for ARCH_TEGRA

Ethan Du (1):
      omap hsmmc: fix a racing case between kmmcd and omap_hsmmc_suspend

FUJITA Tomonori (1):
      alpha: remove homegrown L1_CACHE_ALIGN macro

Fabian Godehardt (1):
      AT91: SAM9G45 - add a separate clock entry for every single TC block

Faisal Latif (3):
      RDMA/nes: Fix double CLOSE event indication crash
      RDMA/nes: Change state to closing after FIN
      RDMA/nes: Fix hang with modified FIN handling on A0 cards

Francisco Jerez (5):
      drm/nouveau: Take fence spinlock before reading the last sequence.
      drm/nouveau: Don't take struct_mutex around the pushbuf IOCTL.
      vt: Fix console corruption on driver hand-over.
      x86: Fix the address space annotations of iomap_atomic_prot_pfn()
      io-mapping: Fix the address space annotations

Frederic Weisbecker (1):
      perf: Initialize callchains roots's childen hits

Gary King (1):
      bounce: call flush_dcache_page() after bounce_copy_vec()

Geert Uytterhoeven (1):
      staging: spectra needs <linux/slab.h>

Giridhar Malavali (2):
      [SCSI] qla2xxx: Correctly set fw hung and complete only waiting mbx.
      [SCSI] qla2xxx: Check for empty slot in request queue before
posting Command type 6 request.

Giuseppe Cavallaro (1):
      stmmac: fix sleep inside atomic

Gleb Natapov (1):
      KVM: i8259: fix migration

Greg Ungerer (1):
      m68knommu: fix missing linker segments

Gregory Bean (1):
      gpio: sx150x: correct and refine reset-on-probe behavior

Guennadi Liakhovetski (3):
      ARM: mach-shmobile: add clock definitions for CEU and CSI2
      ARM: mach-shmobile: do not enable the PLLC2 clock on init
      mmc: fix the use of kunmap_atomic() in tmio_mmc.h

Gwendal Grignou (1):
      libata-sff: Reenable Port Multiplier after libata-sff remodeling.

Haiyang Zhang (2):
      staging: hv: Fix missing functions for net_device_ops
      staging: hv: Fixed the value of the 64bit-hole inside ring buffer

Hank Janssen (3):
      staging: hv: Fixed bounce kmap problem by using correct index
      staging: hv: Increased storvsc ringbuffer and max_io_requests
      staging: hv: Fixed lockup problem with bounce_buffer scatter list

Hans J. Koch (1):
      mx35: Fix boot ROM hang in internal boot mode

Helmut Schaa (1):
      net: fix tx queue selection for bridged devices implementing select_queue

Henrik Kretzschmar (1):
      USB: rndis: section mismatch fix

Henrik Rydberg (2):
      Input: MT - initialize slots to unused
      Input: bcm5974 - adjust major/minor to scale

Herbert Xu (3):
      crypto: testmgr - Fix test disabling option
      crypto: testmgr - Default to no tests
      Revert "hwrng: n2-drv - remove casts from void*"

Huang Shijie (1):
      percpu: fix a memory leak in pcpu_extend_area_map()

Huang Ying (1):
      kfifo: add parenthesis for macro parameter reference

Hugh Dickins (4):
      x86, mm: Fix CONFIG_VMSPLIT_1G and 2G_OPT trampoline
      swap: revert special hibernation allocation
      swap: prevent reuse during hibernation
      swap: discard while swapping only if SWAP_FLAG_DISCARD

Ira W. Snyder (1):
      arch/powerpc/include/asm/fsldma.h needs slab.h

J. Bruce Fields (2):
      writeback: Fix lost wake-up shutting down writeback thread
      nfsd4: mask out non-access bits in nfs4_access_to_omode

James Bottomley (2):
      [SCSI] fix use-after-free in scsi_init_io()
      vfs: take O_NONBLOCK out of the O_* uniqueness test

Jan Kara (2):
      ocfs2: Flush drive's caches on fdatasync
      ocfs2: Fix deadlock when allocating page

Jan Sembera (1):
      binfmt_misc: fix binfmt_misc priority

Jarek Poplawski (3):
      pkt_sched: Fix lockdep warning on est_tree_lock in gen_estimator
      gro: Re-fix different skb headrooms
      ipv4: Suppress lockdep-RCU false positive in FIB trie (3)

Jason Baron (1):
      workqueue: Add a workqueue chapter to the tracepoint docbook

Jason Detring (1):
      USB: cp210x: Add B&G H3000 link cable ID

Jason Wang (3):
      mxc/tzic: add base address when accessing TZIC registers
      mx5/clock: fix clear bit fields issue in _clk_ccgr_disable function
      ARM: imx: set cache line size to 64 bytes for i.MX5

Jayamohan Kallickal (1):
      [SCSI] be2iscsi: Fix for Login failure

Jean Delvare (1):
      pata_artop: Fix device ID parity check

Jean Sacren (1):
      [SCSI] Fix warning: zero-length gnu_printf format string

Jeff Mahoney (2):
      net sched: fix kernel leak in act_police
      Staging: spectra: depend on X86_MRST

Jeff Moyer (1):
      O_DIRECT: fix the splitting up of contiguous I/O

Jeffrey Carlyle (1):
      scatterlist: prevent invalid free when alloc fails

Jens Axboe (2):
      block: add function call to switch the IO scheduler from a driver
      block: switch s390 tape_block and mg_disk to elevator_change()

Jerome Marchand (1):
      kernel/groups.c: fix integer overflow in groups_search

Jesse Barnes (2):
      x86/PCI: only define pci_domain_nr if PCI and PCI_DOMAINS are set
      drm/i915: don't enable self-refresh on Ironlake

Jianzhao Wang (1):
      net: blackhole route should always be recalculated

Jiri Bohac (1):
      bonding: Fix jiffies overflow problems (again)

Jiri Pinkava (1):
      ARM: SAMSUNG: MMC: fix build error when both DMA and PIO mode selected

Jiri Slaby (4):
      BLOCK: fix bio.bi_rw handling
      [SCSI] fix bio.bi_rw handling
      MAINTAINERS: orphan isicom
      MAINTAINERS: remove drivers/char/hpet.c

Joe Perches (2):
      sctp: fix test for end of loop
      MAINTAINERS: Add CAIF

Johannes Berg (4):
      mac80211: delete work timer
      wireless extensions: fix kernel heap content leak
      kernel-doc: ignore case when stripping attributes
      docbook: warn on unused doc entries

John Johansen (4):
      AppArmor: Drop hack to remove appended " (deleted)" string
      AppArmor: Fix security_task_setrlimit logic for 2.6.36 changes
      AppArmor: Fix splitting an fqname into separate namespace and
profile names
      AppArmor: Fix locking from removal of profile namespace

John W. Linville (3):
      ath5k: check return value of ieee80211_get_tx_rate
      MAINTAINERS: change broken url for prism54
      wireless: register wiphy rfkill w/o holding cfg80211_mutex

Jonathan Corbet (1):
      lglock: make lg_lock_global() actually lock globally

Jorge Boncompte [DTI2] (1):
      minix: fix regression in minix_mkdir()

Jovi Zhang (1):
      perf symbols: Fix multiple initialization of symbol system

Juergen Beisert (1):
      clock-imx35: Calculate the base clock rate for the IPU unit

Julia Lawall (4):
      UBI: eliminate update of list_for_each_entry loop cursor
      arch/powerpc/platforms/83xx/mpc837x_mds.c: Add missing iounmap
      arch/powerpc/sysdev/qe_lib/qe.c: Add of_node_put to avoid memory leak
      drivers/mmc/host/imxmmc.c: adjust confusing if indentation

Julian Anastasov (2):
      ipvs: avoid oops for passive FTP
      ipvs: fix active FTP

KAMEZAWA Hiroyuki (2):
      memory hotplug: fix next block calculation in is_removable
      vmstat: update zone stat threshold when onlining a cpu

Karl Relton (1):
      Staging: wlan-ng: Explicitly set some fields in cfg80211 interface

Ken Kawasaki (1):
      pcnet_cs: add new_id

Kenji Kaneshige (1):
      PCI: PCIe: Remove the port driver module exit routine

Kumar Gala (1):
      powerpc/85xx: Fix compile issue with p1022_ds due to lmb rename
to memblock

Kuninori Morimoto (1):
      ARM: mach-shmobile: ap4evb: modify FSI2 ID

Lalit Chandivade (2):
      [SCSI] qla2xxx: Reset seconds_since_last_heartbeat correctly.
      [SCSI] qla2xxx: Cover UNDERRUN case where SCSI status is set.

Li Yang (1):
      fsl_rio: fix compile errors

Li Zefan (3):
      tracing: Fix a race in function profile
      cls_cgroup: Fix rcu lockdep warning
      perf, trace: Fix module leak

Linus Torvalds (1):
      Linux 2.6.36-rc4

Linus Walleij (1):
      drivers/rtc/rtc-pl031.c: do not mark PL031 IRQ as shared

Luis R. Rodriguez (2):
      ath9k_hw: Fix EEPROM uncompress block reading on AR9003
      ath9k_hw: fix parsing of HT40 5 GHz CTLs

Luke Lowrey (1):
      USB: ftdi_sio: Added custom PIDs for ChamSys products

Madhuranath Iyengar (1):
      [SCSI] qla2xxx: Update version number to 8.03.04-k0.

Magnus Damm (2):
      ARM: mach-shmobile: Runtime PM V3
      ARM: mach-shmobile: Clock framework comment fix

Marc Kleine-Budde (3):
      clock-imx35: fix divider if ahb is source for ipg_per
      clock-imx35: correct arm and ahb clock calculation
      mmc: at91_mci: add missing linux/highmem.h include

Marcin Slusarz (1):
      drm/nv50: initialize ramht_refs list for faked 0 channel

Marek Vasut (1):
      ARM: pxa168fb: fix section mismatch

Mark Fasheh (6):
      ocfs2: properly set and use inode group alloc hint
      ocfs2: split out inode alloc code from ocfs2_mknod_locked
      ocfs2: use ocfs2_alloc_dinode_update_counts() instead of open coding
      ocfs2: allow return of new inode block location before
allocation of the inode
      ocfs2: split out ocfs2_prepare_orphan_dir() into locking and
prep functions
      ocfs2: Fix orphan add in ocfs2_create_inode_in_orphan

Mark Lord (1):
      PATCH: b44 Handle RX FIFO overflow better (simplified)

Masami Hiramatsu (5):
      tracing/kprobe: Fix a memory leak in error case
      perf probe: Fix return probe support
      perf probe: Fix handling of arguments names
      tracing/kprobes: Fix handling of argument names
      tracing/kprobe: Fix handling of C-unlike argument names

Matthew McClintock (1):
      powerpc/kexec: Adds correct calling convention for kexec purgatory

Maurus Cuelenaere (1):
      USB: s3c-hsotg: Remove DEBUG define

Maxim Osipov (1):
      USB: Fix kernel oops with g_ether and Windows

Mel Gorman (2):
      mm: page allocator: update free page counters after pages are
placed on the free list
      mm: page allocator: drain per-cpu lists after direct reclaim
allocation fails

Michael Cree (2):
      alpha: convert perf_event to use local_t
      alpha: Fix printk format errors

Michael Neuling (1):
      powerpc: Don't use kernel stack with translation off

Michael S. Tsirkin (4):
      cgroups: fix API thinko
      vhost: fix attach to cgroups regression
      vhost: error handling fix
      cgroups: fix API thinko

Michal Soltys (1):
      net/sched/sch_hfsc.c: initialize parent's cl_cfmin properly in init_vf()

Mika Westerberg (1):
      ARM: 6359/1: ep93xx: move clock initialization earlier

Mikael Pettersson (1):
      ARM: 6343/1: wire up fanotify and prlimit64 syscalls on ARM

Mike Auty (1):
      Input: wacom - fix mousewheel handling for old wacom tablets

Mike Frysinger (2):
      rtc-bfin: fix inverted logic in suspend path
      rtc-bfin: fix state restoration when resuming

Mike Rapoport (1):
      libertas: if_sdio: fix buffer alignment in struct if_sdio_card

Miklos Szeredi (2):
      fuse: flush background queue on connection close
      fuse: fix lock annotations

Mimi Zohar (1):
      ima: always maintain counters

Minchan Kim (1):
      mm: compaction: handle active and inactive fairly in too_many_isolated

Morten H. Larsen (1):
      Fix call to replaced SuperIO functions

Namhyung Kim (5):
      percpu: handle __percpu notations in UP accessors
      percpu: add __percpu notations to UP allocator
      workqueue: annotate lock context change
      workqueue: mark lock acquisition on worker_maybe_bind_and_lock()
      percpu: fix a mismatch between code and comment

Nathael Pajani (1):
      tty: fix tty_line must not be equal to number of allocated tty
pointers in tty driver

Nathan Fontenot (1):
      powerpc/pseries: Correct rtas_data_buf locking in dlpar code

NeilBrown (2):
      Move .gitignore from drivers/md to lib/raid6
      md: resolve confusion of MD_CHANGE_CLEAN

Nicolas Dichtel (4):
      xfrm_user: avoid a warning with some compiler
      ipv4: minor fix about RPF in help of Kconfig
      ipv6: discard overlapping fragment
      netfilter: discard overlapping IPv6 fragment

Nicolas Ferre (5):
      AT91: change dma resource index
      AT91: clock: peripheral clocks can have other parent than mck
      AT91: dm9000 initialization update
      AT91: at91sam9261ek board: remove warnings related to use of SPI or SD/MMC
      AT91: at91sam9261ek: remove C99 comments but keep information

Paul E. McKenney (2):
      MAINTAINERS: Add RCU's public git tree
      pid: make setpgid() system call use RCU read-side critical section

Paul Mackerras (1):
      powerpc/perf_event: Reduce latency of calling perf_event_do_pending

Paul Mundt (1):
      ARM: mach-shmobile: Fix up gpio-leds pdata definition.

Pavel Roskin (1):
      i915: revert some checks added by commit 32aad86f

Pekka Enberg (1):
      i915: Fix spurious TV detection after 9d0498a2bf + 9559fcdbff

Peter Oberparleiter (1):
      gcov: fix null-pointer dereference for certain module types

Peter Zijlstra (4):
      perf, x86: Fix handle_irq return values
      perf: Fix CPU hotplug
      x86, tsc: Fix a preemption leak in restore_sched_clock_state()
      x86, tsc: Fix a preemption leak in restore_sched_clock_state()

Philippe Corbes (1):
      USB: cdc-acm: Add pseudo modem without AT command capabilities

Philippe Langlais (1):
      serial: fix port type conflict between NS16550A & U6_16550A

Rafael J. Wysocki (11):
      PCI: PCIe AER: Introduce pci_aer_available()
      PCI: PCIe: Introduce commad line switch for disabling port services
      ACPI/PCI: Reorder checks in acpi_pci_osc_control_set()
      ACPI/PCI: Make acpi_pci_query_osc() return control bits
      ACPI/PCI: Do not preserve _OSC control bits returned by a query
      ACPI/PCI: Negotiate _OSC control bits before requesting them
      PCI: PCIe: Ask BIOS for control of all native services at once
      PCI: PCIe: Disable PCIe port services during port initialization
      PCI: PCIe: Move PCIe PME code to the pcie directory
      PCI hotplug: Fix build with CONFIG_ACPI unset
      PM / Hibernate: Avoid hitting OOM during preallocation of memory

Randy Dunlap (4):
      UBI: fix kconfig unmet dependency
      mutex: Fix annotations to include it in kernel-locking docbook
      Staging: octeon: depends on NETDEVICES
      docbook: skip files with no docs since they generate scary warnings

Robert Richter (4):
      oprofile: fix crash when accessing freed task structs
      oprofile, x86: fix init_sysfs error handling
      oprofile, x86: fix init_sysfs() function stub
      perf, x86: Try to handle unknown nmis with an enabled PMU

Roland McGrath (3):
      setup_arg_pages: diagnose excessive argument size
      execve: improve interactivity with large arguments
      execve: make responsive to SIGKILL with large arguments

Russell King (4):
      Revert "[ARM] pxa: remove now unnecessary dma_needs_bounce()"
      ARM: Ensure PTE modifications via dma_alloc_coherent are visible
      ARM: Partially revert "Auto calculate ZRELADDR and provide
option for exceptions"
      ARM: Update mach-types

Ryusuke Konishi (1):
      nilfs2: fix leak of shadow dat inode in error path of load_nilfs

Sascha Hauer (1):
      i.MX35: remove get_3_3_div helper function

Sergey Senozhatsky (1):
      x86, hwmon: Fix unsafe smp_processor_id() in thermal_throttle_add_dev

Sergio Aguirre (1):
      omap_hsmmc: remove unused local `state'

Seth Heasley (2):
      ata_piix: IDE Mode SATA patch for Intel Patsburg DeviceIDs
      ahci: AHCI and RAID mode SATA patch for Intel Patsburg DeviceIDs

Shahar Havivi (1):
      Staging: zram: free device memory when init fails

Simon Arlott (1):
      USB: cxacru: Use a bulk/int URB to access the command endpoint

Simon Farnsworth (1):
      drm/i915: Avoid pageflipping freeze when we miss the flip
prepare interrupt

Simon Horman (1):
      MAINTAINERS: kexec-tools has moved

Sonic Zhang (1):
      serial: bfin_sport_uart: restore transmit frame sync fix

Stefan Bader (1):
      mm: Move vma_stack_continue into mm.h

Stephane Eranian (1):
      perf_events: Fix time tracking for events with pid != -1 and cpu != -1

Stephen Hemminger (1):
      PCI: bus speed strings should be const

Stephen M. Cameron (3):
      cciss: disable doorbell reset on reset_devices
      cciss: fix reporting of max queue depth since init
      [SCSI] hpsa: disable doorbell reset on reset_devices

Steve Wise (1):
      RDMA/cxgb3: Don't exceed the max HW CQ depth

Steven Rostedt (1):
      tracing: Do not allow llseek to set_ftrace_filter

Sunil Mushran (2):
      ocfs2: Fix metaecc error messages
      ocfs2: Fix incorrect checksum validation error

Suresh Siddha (1):
      sched: Move sched_avg_update() to update_cpu_load()

Szilveszter Ördög (1):
      crypto: hash - Fix handling of small unaligned buffers

Takashi Iwai (8):
      ALSA: hda - Add quirk for Lenovo T400s
      ALSA: usb - Release capture substream URBs properly
      ALSA: hda - Enable PC-beep for EeePC with ALC269 codec
      ALSA: msnd-classic: Fix invalid cfg parameter
      ALSA: seq/oss - Fix double-free at error path of snd_seq_oss_open()
      ALSA: hda - Fix wrong HP pin detection in snd_hda_parse_pin_def_config()
      hp_accel: add quirks for HP ProBook 532x and HP Mini 5102
      proc: export uncached bit properly in /proc/kpageflags

Tao Ma (3):
      xfs: Make fiemap work with sparse files
      ocfs2: make __ocfs2_page_mkwrite handle file end properly.
      ocfs2: Use the right group in nfs sync check.

Tejun Heo (7):
      workqueue: improve destroy_workqueue() debuggability
      workqueue: fix cwq->nr_active underflow
      workqueue: fix GCWQ_DISASSOCIATED initialization
      workqueue: use zalloc_cpumask_var() for gcwq->mayday_mask
      ahci: fix hang on failed softreset
      libata,pata_via: revert ata_wait_idle() removal from ata_sff/via_tf_load()
      libata: skip EH autopsy and recovery during suspend

Tetsuo Handa (1):
      UNIX: Do not loop forever at unix_autobind().

Thadeu Lima de Souza Cascardo (1):
      usb: allow drivers to use allocated bandwidth until unbound

Thomas Gleixner (1):
      semaphore: Add DEFINE_SEMAPHORE

Toby Gray (2):
      USB: cdc-acm: Adding second ACM channel support for various
Nokia and one Samsung phones
      USB: cdc-acm: Fixing crash when ACM probing interfaces with no
endpoint descriptors.

Tristan Ye (1):
      Ocfs2: Fix a regression bug from mainline
commit(6b933c8e6f1a2f3118082c455eef25f9b1ac7b45).

Uwe Kleine-König (1):
      ARM: pxa: Make id const in pwm_probe()

Valerie Aurora (1):
      VFS: Sanity check mount flags passed to change_mnt_propagation()

Vivek Goyal (5):
      cfq-iosched: Do not idle if slice_idle=0
      cfq-iosched: Do group share accounting in IOPS when slice_idle=0
      cfq-iosched: Implement tunable group_idle
      cfq-iosched: blktrace print per slice sector stats
      cfq-iosched: Documentation help for new tunables

Will Deacon (2):
      ARM: 6330/1: perf: reword comments relating to perf_event_do_pending
      ARM: 6352/1: perf: fix event validation

Wolfram Sang (1):
      MAINTAINERS: correct entry for legacy RTC-driver

Xiaotian Feng (2):
      workqueue: free rescuer on destroy_workqueue
      block: put dev->kobj in blk_register_queue fail path

Yusuke Goda (1):
      tmio_mmc: don't clear unhandled pending interrupts

Zachary Amsden (1):
      KVM: x86: Perform hardware_enable in CPU_STARTING callback

Zhenyu Wang (5):
      agp/intel: fix physical address mask bits for sandybridge
      agp/intel: use #ifdef idiom for intel-agp.h
      agp/intel: Fix cache control for Sandybridge
      drm/i915: Enable MI_FLUSH on Sandybridge
      intel_agp,i915: Add more sandybridge graphics device ids

mark gross (1):
      PM QoS: Correct pr_debug() misuse and improve parameter checks

stephen hemminger (1):
      sky2: don't do GRO on second port
