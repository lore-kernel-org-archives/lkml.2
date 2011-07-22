Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab1GVDAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 23:00:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752117Ab1GVDAU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 23:00:20 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Jul 2011 19:59:53 -0700
Message-ID: <CA+55aFxakA2U+oMJ1T7awTYa+p6xp9N0aCbfrUqgkF7BJ8gnQw@mail.gmail.com>
Subject: Linux 3.0 release
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So there it is. Gone are the 2.6.<bignum> days, and 3.0 is out.

This obviously also opens the merge window for the next kernel, which
will be 3.1. The stable team will take the third digit, so 3.0.1 will
be the first stable release based on 3.0.

As already mentioned several times, there are no special landmark
features or incompatibilities related to the version number change,
it's simply a way to drop an inconvenient numbering system in honor of
twenty years of Linux. In fact, the 3.0 merge window was calmer than
most, and apart from some excitement from RCU I'd have called it
really smooth. Which is not to say that there may not be bugs, but if
anything, there are hopefully fewer than usual, rather than the normal
".0" problems.

And as I already mentioned yesterday, I'm hoping the 3.1 merge window
will be calm too, because due to the delays the latter half of the
merge window will fall into my vacation time. I briefly considered
simply waiting two extra weeks, but quite frankly, that wouldn't
really have solved anything (it would have made the merge window
instead fall into LinuxCon and my divemaster weekends).

So I'm going to try to keep to the normal two-week merge window, but
if it ends up being too busy for me to keep up, I may end up extending
the window just so that I can merge everything. However, even if that
happens, that will *not* mean that I will accept big pull requests for
longer, it just means that I may end up delaying things to catch up
with timely merge requests.

That said, judging by past experience, the summer merge windows often
tend to be quieter, so maybe I worry needlessly. Much of Europe is
starting to go on vacation, and parts of the US are being fried to a
crisp, so maybe 3.1 will be calm too.

Anyway, what has changed since -rc7 is mainly some RCU interactions
with the scheduler, and the RCU problems should hopefully be behind
us. The pathname lookup race is also fixed. There's a few DRI fixes
(i915 modesetting, and some Radeon fixes), and Al walked through some
more esoteric VFS d_lock issues. Other than that it's really pretty
small and random.

The shortlog from -rc7 is appended, the bigger "everything since
2.6.39" list is obviously unmanageable.

                                Linus

---

Akinobu Mita (1):
      fs/libfs.c: fix simple_attr_write() on 32bit machines

Al Viro (10):
      Fix ->d_lock locking order in unlazy_walk()
      fix loop checks in d_materialise_unique()
      cifs: build_path_from_dentry() race fix
      ceph analog of cifs build_path_from_dentry() race fix
      fix exofs ->get_parent()
      ufs should use d_splice_alias()
      cramfs: get_cramfs_inode() returns ERR_PTR() on failure
      hppfs: fix dentry leak
      hppfs_lookup(): don't open-code lookup_one_len()
      Fix cifs_get_root()

Alex Deucher (6):
      drm/radeon/kms: fix regression in hotplug
      drm/radeon/kms: fix backend map typo on juniper
      drm/radeon/kms: use correct BUS_CNTL reg on rs600
      drm/radeon/kms: fix typo in read_disabled vbios code
      drm/radeon/kms/evergreen: emit SQ_LDS_RESOURCE_MGMT for blits
      drm/radeon/kms: add new NI pci ids

Andy Adamson (1):
      NFSv4.1: update nfs4_fattr_bitmap_maxsz

Axel Lin (1):
      gpio: wm831x: add a missing break in wm831x_gpio_dbg_show

Ben Greear (1):
      SUNRPC: Fix use of static variable in rpcb_getport_async

Benjamin Herrenschmidt (2):
      mm: Move definition of MIN_MEMORY_BLOCK_SIZE to a header
      powerpc/mm: Fix memory_block_size_bytes() for non-pseries

Benjamin Marzinski (1):
      GFS2: force a log flush when invalidating the rindex glock

Boaz Harrosh (1):
      pnfs: write: Set mds_offset in the generic layer - it is needed by all LDs

Chris Wilson (3):
      drm/i915/ringbuffer: Idling requires waiting for the ring to be empty
      agp/intel: Fix typo in G4x_GMCH_SIZE_VT_2M
      drm/i915: Fix unfenced alignment on pre-G33 hardware

Christian Lamparter (1):
      carl9170: add NEC WL300NU-AG usbid

Dan Rosenberg (1):
      Bluetooth: Prevent buffer overflow in l2cap config request

Daniel J Blueman (1):
      x86: Make Dell Latitude E5420 use reboot=pci

Daniel Mack (1):
      ARM: pxa/raumfeld: fix device name for codec ak4104

Darren Hart (1):
      x86, doc only: Correct real-mode kernel header offset for init_size

David S. Miller (2):
      net: Fix default in docs for tcp_orphan_retries.
      pppoe: Must flush connections when MAC address changes too.

Devin Heitmueller (1):
      [media] dvb_frontend: fix race condition in stopping/starting frontend

Greg Kroah-Hartman (1):
      hso: fix a use after free condition

Guenter Roeck (2):
      hwmon: (pmbus) Use long variables for register to data conversions
      hwmon: (adm1275) Fix coefficients per datasheet revision B

Gustavo F. Padovan (2):
      Bluetooth: Fix regression with incoming L2CAP connections
      Bluetooth: Fix regression in L2CAP connection procedure

H. Peter Anvin (1):
      x86: Make Dell Latitude E6420 use reboot=pci

Huang Ying (1):
      ACPI, APEI, HEST, Detect duplicated hardware error source ID

Ido Yariv (1):
      arm: davinci: Fix low level gpio irq handlers' argument

Ilia Kolomisnky (1):
      Bluetooth: Fix crash with incoming L2CAP connections

Jan Beulich (1):
      FS-Cache: Fix __fscache_uncache_all_inode_pages()'s outer loop

Jarod Wilson (2):
      [media] Revert "V4L/DVB: cx23885: Enable Message Signaled Interrupts(MSI)"
      [media] nuvoton-cir: make idle timeout more sane

Jason Wessel (1):
      sparc,kgdbts: fix compile regression with kgdb test suite

Jean Delvare (2):
      net/natsemi: Fix module parameter permissions
      hwmon: (it87) Fix label group removal

Jesse Barnes (7):
      drm/i915/dp: retry link status read 3 times on failure
      drm/i915/dp: use DP DPCD defines when looking at DPCD values
      drm/i915/dp: read more receiver capability bits on hotplug
      drm/i915/dp: try to read receiver capabilities 3 times when detecting
      drm/i915/dp: remove DPMS mode tracking from DP
      drm/i915/dp: consolidate AUX retry code
      drm/i915/dp: manage sink power state if possible

Jim Cromie (1):
      natsemi: fix another dma-debug report

Joe Perches (1):
      tulip: dmfe: Remove old log spamming pr_debugs

Johannes Berg (1):
      mac80211: fix TKIP replay vulnerability

Jon Povey (1):
      davinci: DM365 EVM: fix video input mux bits

Jonathan Cameron (1):
      pcmcia: pxa2xx/vpac270: free gpios on exist rather than requesting

Keith Packard (3):
      drm/i915: Clean up i915_driver_load failure path
      Revert "drm/i915: enable rc6 by default"
      drm/i915: Add quirk to disable SSC on Lenovo U160 LVDS

Kenneth Graunke (1):
      drm/i915: Enable GPU reset on Ivybridge.

Kuninori Morimoto (3):
      ASoC: sh: fsi-ak4642: fixup snd_soc_card name
      ASoC: sh: fsi-da7210: fixup snd_soc_card name
      ASoC: sh: fsi-hdmi: fixup snd_soc_card name

Lei Wen (2):
      ARM: pxa910: correct nand pmu setting
      ARM: pxa168: correct nand pmu setting

Lin Ming (1):
      ACPI: Fixes device power states array overflow

Linus Torvalds (3):
      vfs: fix race in rcu lookup of pruned dentry
      vfs: drop conditional inode prefetch in __do_lookup_rcu
      Linux 3.0

Linus Walleij (1):
      ARM: pxa: fix gpio_to_chip() clash with gpiolib namespace

Luca Tettamanti (1):
      hwmon: (asus_atk0110) Fix memory leak

Luciano Coelho (2):
      cfg80211: fix deadlock with rfkill/sched_scan by adding new mutex
      mac80211: fix ie memory allocation for scheduled scans

Mark Brown (2):
      ASoC: Fix shift in WM8958 accessory detection default implementation
      ASoC: Correct WM8994 MICBIAS supply widget hookup

Matthias Rosenfelder (1):
      sparc32,leon: Added __init declaration to leon_flush_needed()

Matvejchikov Ilya (1):
      slip: fix wrong SLIP6 ifdef-endif placing

Mauro Carvalho Chehab (2):
      [media] tuner-core: fix a 2.6.39 regression with mt20xx
      si4713-i2c: avoid potential buffer overflow on si4713

Maxime Ripard (1):
      x86. reboot: Make Dell Latitude E6320 use reboot=pci

Michael Thalmeier (1):
      r6040: only disable RX interrupt if napi_schedule_prep is successful

Michal Marek (1):
      kbuild: Do not write to builddir in modules_install

Michał Mirosław (2):
      net: sctp: fix checksum marking for outgoing packets
      net: remove NETIF_F_ALL_TX_OFFLOADS

Olaf Hering (1):
      watchdog: fix hpwdt Kconfig regression in 3.0-rc

Paul E. McKenney (6):
      rcu: Prevent RCU callbacks from executing before scheduler initialized
      rcu: decrease rcu_report_exp_rnp coupling with scheduler
      rcu: Fix RCU_BOOST race handling current->rcu_read_unlock_special
      rcu: Streamline code produced by __rcu_read_unlock()
      rcu: protect __rcu_read_unlock() against scheduler-using irq handlers
      signal: align __lock_task_sighand() irq disabling and RCU

Paul Parsons (1):
      ARM: pxa: fix PGSR register address calculation

Pavel Herrmann (1):
      hwmon: (max1111) Fix race condition causing NULL pointer exception

Pavel Roskin (2):
      ath5k: fix incorrect use of drvdata in sysfs code
      ath5k: fix incorrect use of drvdata in PCI suspend/resume code

Pavel Shilovsky (1):
      CIFS: Fix wrong length in cifs_iovec_read

Peter Hurley (1):
      Bluetooth: Fix hidp disconnect deadlocks and lost wakeup

Peter Zijlstra (6):
      sched: Fix 32bit race
      sched: Break out cpu_power from the sched_group structure
      sched: Allow for overlapping sched_domain spans
      sched: Avoid creating superfluous NUMA domains on non-NUMA systems
      sched: Add irq_{enter,exit}() to scheduler_ipi()
      softirq,rcu: Inform RCU of irq_exit() activity

Philip Rakity (1):
      mmc: core: Bus width testing needs to handle suspend/resume

Rafael J. Wysocki (2):
      ACPI: Fix lockdep false positives in acpi_power_off()
      PM / MIPS: Convert i8259.c to using syscore_ops

Rafał Miłecki (1):
      ssb: fix init regression of hostmode PCI core

Rafi Rubin (2):
      [media] mceusb: Timeout unit corrections
      [media] mceusb: increase default timeout to 100ms

Rajkumar Manoharan (1):
      ath9k: Fix tx throughput drops for AR9003 chips with AES encryption

Ralf Baechle (1):
      [media] MEDIA: Fix non-ISA_DMA_API link failure of sound code

Randy Dunlap (2):
      [media] media: fix radio-sf16fmr2 build when SND is not enabled
      watchdog: hpwdt depends on PCI

Richard Cochran (1):
      ARM: fix regression in IXP4xx clocksource

Ryusuke Konishi (1):
      nilfs2: remove resize from unsupported features list

Sage Weil (1):
      ceph: fix file mode calculation

Sangwook Lee (1):
      ARM: SAMSUNG: DMA Cleanup as per sparse

Sebastian Pöhn (1):
      gianfar: rx parser

Shaohua Li (1):
      vmscan: fix a livelock in kswapd

Shirish Pargaonkar (1):
      cifs: Fix signing failure when server mandates signing for NTLMSSP

Simon Guinot (1):
      genirq: replace irq_gc_ack() with {set,clr}_bit variants (fwd)

Steve French (2):
      [CIFS] update limit for snprintf in cifs_construct_tcon
      [CIFS] update cifs to version 1.74

Steven Rostedt (1):
      sparc/irqs: Do not trace arch_local_{*,irq_*} functions

Steven Whitehouse (2):
      GFS2: Fix race during filesystem mount
      GFS2: Resolve inode eviction and ail list interaction bug

Sven Neumann (2):
      ARM: pxa/raumfeld: adapt to upcoming hardware change
      ARM: pxa/raumfeld: display initialisation fixes

Tejun Heo (1):
      x86: Disable AMD_NUMA for 32bit for now

Thomas Graf (2):
      sctp: Enforce retransmission limit during shutdown
      sctp: ABORT if receive, reassmbly, or reodering queue is not
empty while closing socket

Todd Poynor (2):
      ARM: SAMSUNG: Check NULL return from irq_alloc_generic_chip
      ARM: davinci: Check for NULL return from irq_alloc_generic_chip

Tomas Targownik (1):
      Bluetooth: Fix memory leak under page timeouts

Trond Myklebust (1):
      SUNRPC: Fix a race between work-queue and rpc_killall_tasks

Tushar Gohad (1):
      XFRM: Fix memory leak in xfrm_state_update

WANG Cong (1):
      include/linux/sdla.h: remove the prototype of sdla()

Will Simoneau (1):
      sparc: sun4m SMP: fix wrong shift instruction in IPI handler

Wolfram Sang (1):
      arm: mach-vt8500: add forgotten irq_data conversion

Yoann DI-RUZZA (1):
      rtlwifi: rtl8192cu: Add new USB ID for Netgear WNA1000M
