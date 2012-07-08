Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab2GHDBv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 23:01:51 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:42108 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2GHDBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 23:01:49 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 7 Jul 2012 20:01:27 -0700
X-Google-Sender-Auth: _sOV_KQVwf61T9JxInpQKnn5aj8
Message-ID: <CA+55aFxc-=khJiApyHsXGW71M-ZLpaZT0GAPGmDMHw+hAvx-7A@mail.gmail.com>
Subject: Linux 3.5-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc. And happily, another week of calming down.
Noticeably fewer commits in here than in -rc5, and I think we're
getting closer to a final release.

That said, it's also summer (our Australian co-developers may
disagree, but they are in the minority), and with that I also wanted
to talk about the next merge window. Because I suspect that especially
a lot of the European developers have either taken off for vacation or
are getting ready to do so.  August tends to be off-season for a lot
of people. I'm hoping summer plans not a huge part of the slowing down
of the rc patches, but I do suspect that the next merge window will
almost inevitably be completely overshadowed for some developers by
their vacation.

Which is fine, and I'm hoping that may just mean that 3.6 will be a
calmer release. I *would* ask that people who go on vacation do *not*
plan to send me their merge window stuff before leaving for vacation,
though. I'd really much rather see the merge delayed to 3.7 entirely
than have the developer push me the big changes, and then not be there
at all for the rc series.

Anyway, just keep that in mind, especially those of you planning on
taking all of August off.

Back to the -rc6 stuff: there's mainly some btrfs and md stuff in
here, with the normal driver changes, arm updates and some networking
changes. And a smattering of random stuff (including docs etc). None
of it looks very scary, it's all pretty small, and there aren't even
all that many of those small changes. Shortlog appended.

                      Linus

---
Alan Cox (1):
      qla2xxx: print the right array elements in qlt_async_event

Alex Deucher (1):
      drm/radeon: fix VM page table setup on SI

Alex Williamson (3):
      KVM: Pass kvm_irqfd to functions
      KVM: Add missing KVM_IRQFD API documentation
      KVM: Sanitize KVM_IRQFD flags

Alexander Block (1):
      Btrfs: use _IOR for BTRFS_IOC_SUBVOL_GETFLAGS

Alexander Holler (1):
      leds: heartbeat: fix bug on panic

Amitkumar Karwar (2):
      mwifiex: fix bugs in event handling code
      mwifiex: improve error path handling in usb.c

Andrew Lunn (1):
      ARM: Orion: Fix WDT compile for Dove and MV78xx0

Andy Lutomirski (3):
      security: document no_new_privs
      mm: Hold a file reference in madvise_remove
      security: Minor improvements to no_new_privs documentation

Anton Blanchard (1):
      powerpc/xmon: Use cpumask iterator to avoid warning

Asai Thambi S P (2):
      mtip32xx: Remove 'registers' and 'flags' from sysfs
      mtip32xx: Create debugfs entries for troubleshooting

Asias He (3):
      block: Avoid missed wakeup in request waitqueue
      block: Mitigate lock unbalance caused by lock switching
      block: Drop dead function blk_abort_queue()

Avinash Patil (1):
      mwifiex: fix memory leak associated with IE manamgement

Benoit Cousson (1):
      ARM: OMAP2+: hwmod data: Fix wrong McBSP clock alias on OMAP4

Bjørn Mork (1):
      net: qmi_wwan: fix Oops while disconnecting

Bruce Allan (1):
      e1000e: remove use of IP payload checksum

Chris Mason (1):
      Btrfs: run delayed directory updates during log replay

Claudiu Manoil (1):
      gianfar: Fix RXICr/TXICr programming for multi-queue mode

Dan Carpenter (1):
      mtd: cafe_nand: fix an & vs | mistake

Dan Rosenberg (1):
      NFC: Prevent multiple buffer overflows in NCI

Daniel Mack (1):
      davinci_cpdma: include linux/module.h

Daniel Vetter (1):
      drm/i915: kick any firmware framebuffers before claiming the gtt

David Brown (1):
      ARM: 7428/1: Prevent KALLSYM size mismatch on ARM.

Eliad Peller (1):
      mac80211: clear ifmgd->bssid only after building DELBA

Eric Dumazet (3):
      splice: fix racy pipe->buffers uses
      netfilter: ipvs: fix dst leak in __ip_vs_addr_is_local_v6
      NFC: Return from rawsock_release when sk is NULL

Fabio Estevam (6):
      dt: fsl-imx-cspi.txt: Fix comment about GPIOs used for chip selects
      dt: fsl-imx-esdhc.txt: Fix gpio number assignment
      dt: fsl-mma8450.txt: Add missing 'reg' description
      dt: fsl-fec.txt: Fix gpio number assignment
      dt: mc13xxx.txt: Fix gpio number assignment
      ARM: imx27_visstrim_m10: Do not include <asm/system.h>

Felix Fietkau (1):
      ath9k: fix dynamic WEP related regression

Florian Westphal (1):
      netfilter: ipset: fix interface comparision in hash-netiface sets

Hebbar, Gururaja (1):
      ASoC: tlv320aic3x: Fix codec pll configure bug

Ilya Dryomov (2):
      Btrfs: restore restriper state on all mounts
      Btrfs: resume balance on rw (re)mounts properly

Jan Kara (2):
      scsi: Silence unnecessary warnings about ioctl to partition
      ocfs2: Fix bogus error message from ocfs2_global_read_info

Jan Schmidt (7):
      Btrfs: avoid waiting for delayed refs when we must not
      Btrfs: support root level changes in __resolve_indirect_ref
      Btrfs: fix tree mod log for root replacements at leaf level
      Btrfs: always put insert_ptr modifications into the tree mod log
      Btrfs: leave critical region in btrfs_find_all_roots as soon as possible
      Btrfs: fix tree mod log rewind of ADD operations
      Btrfs: resolve tree mod log locking issue in btrfs_next_leaf

Jeff Layton (1):
      cifs: when server doesn't set CAP_LARGE_READ_X, cap default
rsize at MaxBufferSize

Jeff Liu (1):
      ocfs2: for SEEK_DATA/SEEK_HOLE, return internal error unchanged
if ocfs2_get_clusters_nocache() or ocfs2_inode_lock() call failed.

Jerome Glisse (1):
      drm/radeon: fix rare segfault

Joe Thornber (1):
      dm thin: commit metadata before creating metadata snapshot

Johannes Berg (2):
      iwlwifi: fix activating inactive stations
      mac80211: correct behaviour on unrecognised action frames

Josef Bacik (3):
      Btrfs: fix dio write vs buffered read race
      Btrfs: fix tree log remove space corner case
      Btrfs: hold a ref on the inode during writepages

Junxiao Bi (2):
      ocfs2: clear unaligned io flag when dio fails
      aio: make kiocb->private NUll in init_sync_kiocb()

Kailang Yang (1):
      ALSA: hda - Fix no sound from ALC662 after Windows reboot

Kevin Hilman (2):
      ARM: OMAP2: Overo: init I2C before MMC to fix MMC suspend/resume failure
      ARM: OMAP4: TWL6030: ensure sys_nirq1 is mux'd and wakeup enabled

Konrad Rzeszutek Wilk (2):
      xen/blkback: Copy id field when doing BLKIF_DISCARD.
      xen/blkfront: Add WARN to deal with misbehaving backends.

Larry Finger (1):
      rtlwifi: rtl8192cu: New USB IDs

Lars Ellenberg (3):
      drbd: fix access of unallocated pages and kernel panic
      drbd: fix list corruption by failing but already aborted reads
      drbd: fix null pointer dereference with on-congestion policy when diskless

Lars-Peter Clausen (1):
      Input: request threaded-only IRQs with IRQF_ONESHOT

Lauri Hintsala (1):
      ARM: apx4devkit: fix FEC enabling PHY clock

Linus Torvalds (3):
      floppy: cancel any pending fd_timeouts before adding a new one
      vfs: make O_PATH file descriptors usable for 'fchdir()'
      Linux 3.5-rc6

Liu Bo (1):
      Btrfs: fix wrong check during log recovery

Mark Brown (1):
      ASoC: wm2200: Add missing BCLK rate

Mark Rustad (1):
      tcm_fc: Resolve suspicious RCU usage warnings

Michael Neuling (1):
      powerpc/kvm: sldi should be sld

Mike Snitzer (3):
      dm persistent data: fix shadow_info_leak on dm_tm_destroy
      dm persistent data: handle space map checker creation failure
      dm persistent data: fix allocation failure in space map checker init

Milan Broz (1):
      dm: verity fix documentation

Mitch A Williams (1):
      igbvf: fix divide by zero

Neil Horman (1):
      sctp: be more restrictive in transport selection on bundled sacks

NeilBrown (9):
      md/raid10: Don't try to recovery unmatched (and unused) chunks.
      md/raid5: prefer replacing failed devices over want-replacement devices.
      md/raid5: fix refcount problem when blocked_rdev is set.
      md/raid10: fix failure when trying to repair a read error.
      md: make 'name' arg to md_register_thread non-optional.
      md/raid1: fix bug in read_balance introduced by hot-replace
      md: support re-add of recovering devices.
      md: fix up plugging (again).
      md/raid10: fix careless build error

Nicolas Pitre (1):
      ARM: 7438/1: fill possible PMD empty section gaps

Pablo Neira Ayuso (1):
      netfilter: update location of my trees

Panayiotis Karabassis (1):
      ath9k: enable serialize_regmode for non-PCIE AR9287

Paul Bolle (1):
      ARM: mmp: remove mach/gpio-pxa.h

Paul Mundt (1):
      security: Fix nommu build.

Paul Parsons (1):
      ARM: pxa: hx4700: Fix basic suspend/resume

Paul Walmsley (1):
      ARM: OMAP4: hwmod data: temporarily comment out data for the
usb_host_fs and aess IP blocks

Ping Cheng (2):
      Input: wacom - fix retrieving touch_max bug
      Input: wacom - don't retrieve touch_max when it is predefined

Rabin Vincent (1):
      ARM: 7440/1: kprobes: only test 'sub pc, pc, #1b-2b+8-2' on ARMv6

Rajendra Nayak (1):
      clk: fix parent validation in __clk_set_parent()

Randy Dunlap (2):
      Input: fix input.h kernel-doc warning
      wlcore: drop INET dependency

Russell King (4):
      ARM: fix mach-versatile/pci.c warning
      ARM: fix set_domain() macro
      ARM: fix warnings about atomic64_read
      ARM: fix warning caused by wrongly typed arm_dma_limit

Sachin Kamat (1):
      mtip32xx: Remove version.h header file inclusion

Shaohua Li (1):
      raid5: delayed stripe fix

Shmulik Ladkani (1):
      mtd: nand: initialize bitflip_threshold prior to BBT scanning

Srinivas Eeda (1):
      ocfs2: use spinlock irqsave for downconvert lock.patch

Stefan Behrens (1):
      Btrfs: don't count I/O statistic read errors for missing devices

Stephen Warren (1):
      of: export of_platform_populate()

Stone Piao (2):
      mwifiex: fix 11n rx packet drop issue
      mwifiex: fix WPS eapol handshake failure

Suresh Jayaraman (1):
      cifs: fix parsing of password mount option

Takashi Iwai (1):
      drm: edid: Don't add inferred modes with higher resolution

Tao Guo (1):
      umem: fix up unplugging

Tejun Heo (4):
      block: fix return value on cfq_init() failure
      block: blkcg_policy_cfq shouldn't be used if !CONFIG_CFQ_GROUP_IOSCHED
      blkcg: fix blkg_alloc() failure path
      blkcg: drop local variable @q from blkg_destroy()

Thierry Reding (2):
      of: Add Avionic Design vendor prefix
      of: match by compatible property first

Tom Hughes (1):
      ath9k: fix panic caused by returning a descriptor we have queued for reuse

Tomasz Bursztyka (2):
      netfilter: ipset: fix crash if IPSET_CMD_NONE command is sent
      netfilter: nfnetlink: fix missing rcu_read_unlock in nfnetlink_rcv_msg

Tyler Hicks (3):
      eCryptfs: Properly check for O_RDONLY flag before doing privileged open
      eCryptfs: Fix lockdep warning in miscdev operations
      eCryptfs: Gracefully refuse miscdev file ops on inherited/passed files

Uwe Kleine-König (1):
      ARM: imx: assert SCC gate stays enabled

Vinson Lee (1):
      net: Downgrade CAP_SYS_MODULE deprecated message from error to warning.

Will Deacon (3):
      ARM: 7442/1: Revert "remove unused restart trampoline"
      ARM: 7443/1: Revert "new way of handling ERESTART_RESTARTBLOCK"
      ARM: 7441/1: perf: return -EOPNOTSUPP if requested mode
exclusion is unavailable

Xiao Guangrong (2):
      KVM: fix fault page leak
      KVM: MMU: fix shrinking page from the empty mmu

majianpeng (4):
      md/raid5: Do not add data_offset before call to is_badblock
      md/raid5: In ops_run_io, inc nr_pending before calling
md_wait_for_blocked_rdev
      md:Add blk_plug in sync_thread.
      md/raid456: When read error cannot be recovered, record bad block

roel (1):
      ocfs2: Misplaced parens in unlikley
