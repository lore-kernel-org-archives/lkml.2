Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1FFJce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:32:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755038Ab1FFJcc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:32:32 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 Jun 2011 18:32:08 +0900
Message-ID: <BANLkTinrbh7Xi27an3uY7pDWrNKhJRYmEA@mail.gmail.com>
Subject: Linux 3.0-rc2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You all know the drill by now: another week, another -rc.

It's been reasonably quiet, although the btrfs update is bigger than I
was hoping for. Other than that, it's mostly driver fixes, some ubifs
updates too, and a few reverts for the early regressions.

But -rc2 is already small enough that it easily fits as an appended
shortlog, and hopefully things will stay calm. Of course, part of that
may be due to other people also havin been busy traveling, so let's
see (and hope for the best). And I haven't been super-eager to pull,
so there is a couple of pending requests still in my mail queue.

                   Linus

---
Adrian Chadd (1):
      ath9k: Fix AR9287 calibration

Al Viro (1):
      autofs4: bogus dentry_unhash() added in ->unlink()

Alex Williamson (2):
      intel-iommu: Flush unmaps at domain_exit
      intel-iommu: Only unlink device domains from iommu

Alexey Khoroshilov (1):
      drivers/net/usb/catc.c: Fix potential deadlock in catc_ctrl_run()

Andreas Gruenbacher (1):
      block: improve the bio_add_page() and bio_add_pc_page() descriptions

Arne Jansen (3):
      btrfs: scrub: don't reuse bios and pages
      btrfs: false BUG_ON when degraded
      btrfs: scrub: add explicit plugging

Artem Bityutskiy (7):
      UBIFS: supress false error messages
      UBIFS: introduce a "grouped" journal head flag
      UBIFS: amend ubifs_recover_leb interface
      UBIFS: fix recovery broken by the previous recovery fix
      UBIFS: fix shrinker object count reports
      UBIFS: fix memory leak on error path
      UBIFS: fix clean znode counter corruption in error cases

Avi Kivity (1):
      x86: Fix mwait_play_dead() faulting on mwait-incapable cpus

Ben Gardiner (3):
      UBIFS: assert no fixup when writing a node
      UBIFS: intialize LPT earlier
      UBIFS: fix-up free space earlier

Ben Greear (1):
      af-packet: Add flag to distinguish VID 0 from no-vlan.

Benjamin Herrenschmidt (1):
      powerpc/pmac: Don't register pmac PIC syscore ops when HW not present

Borislav Petkov (1):
      x86 idle: Fix mwait deprecation warning message

Chris Mason (3):
      Btrfs: fix uninit variable in the delayed inode code
      Btrfs: make sure we don't overflow the free space cache crc page
      Btrfs: add mount -o inode_cache

Chris Metcalf (3):
      ip_options_compile: properly handle unaligned pointer
      tile: enable CONFIG_BUGVERBOSE
      asm-generic/unistd.h: support sendmmsg syscall

Chris Wright (2):
      intel-iommu: Check for identity mapping candidate using system dma mask
      intel-iommu: Dont cache iova above 32bit

Christoph Hellwig (1):
      virtio_blk: allow re-reading config space at runtime

Damian Hobson-Garcia (1):
      sh_mobile_meram: MERAM platform data for LCDC

Dan Carpenter (2):
      xen/blkback: potential null dereference in error handling
      ALSA: fm801: add error handling if auto-detect fails

Daniel Drake (1):
      libertas: Set command sequence number later to ensure consistency

Daniel Halperin (1):
      ath9k: fix two more bugs in tx power

Dave Hansen (1):
      virtio balloon: kill tell-host-first logic

David S. Miller (1):
      Revert "net: fix section mismatches"

David Sterba (3):
      btrfs: use btrfs_ino to access inode number
      btrfs: add helper for fs_info->closing
      btrfs: fix uninitialized variable warning

David Woodhouse (1):
      intel-iommu: Fix off-by-one in RMRR setup

Dennis Aberilla (1):
      drivers/net: ks8842 Fix crash on received packet when in PIO mode.

Eliad Peller (2):
      mac80211: clear local->ps_data on disassoc
      cfg80211: don't drop p2p probe responses

Eric Lammerts (1):
      ALSA: usb - turn off de-emphasis in s/pdif for cm6206

Guennadi Liakhovetski (6):
      sh: switch ap325rxa to dynamically manage the platform camera
      sh: add MMCIF runtime PM support on ecovec
      sh: mark DMA slave ID 0 as invalid
      ARM: arch-shmobile: support SDHI card detection on mackerel, using a GPIO
      dmaengine: shdma: fix a regression: initialise DMA channels for memcpy
      ARM: mach-shmobile: add DMAC clock definitions on SH7372

Guenter Roeck (2):
      hwmon: (coretemp) Fix TjMax detection for older CPUs
      hwmon: (coretemp) Further relax temperature range checks

Hugh Dickins (1):
      mm: fix ENOSPC returned by handle_mm_fault()

James Bottomley (1):
      [SCSI] Fix oops caused by queue refcounting failure

Jan Kiszka (1):
      intel-iommu: Remove obsolete comment from detect_intel_iommu

Jean Delvare (1):
      hwmon: (coretemp) Relax target temperature range check

Jens Axboe (1):
      Revert "block: Remove extra discard_alignment from hd_struct."

Jesper Juhl (2):
      mac80211: Remove duplicate linux/slab.h include from net/mac80211/scan.c
      ALSA: 6fire: Don't leak firmware in error path

Joe Perches (1):
      ALSA: asihpi: Use angle brackets for system includes

Johannes Berg (1):
      bluetooth l2cap: fix locking in l2cap_global_chan_by_psm

Josef Bacik (15):
      Btrfs: make sure to use the delalloc reserve when filling delalloc
      Btrfs: take away the num_items argument from btrfs_join_transaction
      Btrfs: if we've already started a trans handle, use that one
      Btrfs: kill trans_mutex
      Btrfs: fix how we do space reservation for truncate
      Btrfs: set range_start to the right start in count_range_bits
      Btrfs: map the node block when looking for readahead targets
      Btrfs: don't look at the extent buffer level 3 times in a row
      Btrfs: kill BTRFS_I(inode)->block_group
      Btrfs: try not to sleep as much when doing slow caching
      Btrfs: don't always do readahead
      Btrfs: don't try to allocate from a block group that doesn't
have enough space
      Btrfs: check for duplicate entries in the free space cache
      Btrfs: leave spinning on lookup and map the leaf
      Btrfs: don't save the inode cache if we are deleting this root

Joseph Cihula (1):
      intel-iommu: fix VT-d PMR disable for TXT on S3 resume

Julia Lawall (2):
      drivers/net/davinci_emac.c: add missing clk_put
      drivers/net/can/flexcan.c: add missing clk_put

Jussi Kivilinna (1):
      zd1211rw: fix to work on OHCI

Kees Cook (1):
      AppArmor: fix oops in apparmor_setprocattr

Koki Sanagi (1):
      net: tracepoint of net_dev_xmit sees freed skb and causes panic

Kyungmin Park (1):
      CFQ: Fix typo and remove unnecessary semicolon

Larry Finger (2):
      rtlwifi: Fix kernel panic resulting from RX buffer allocation failure
      rtlwifi: Use order 2 RX buffer allocation only if necessary

Laszlo Ersek (1):
      xen/blkback: don't call vbd_size() if bd_disk is NULL

Linus Torvalds (5):
      block: fix mismerge of the DISK_EVENT_MEDIA_CHANGE removal
      Revert "mm: fail GFP_DMA allocations when ZONE_DMA is not configured"
      Revert "tty: make receive_buf() return the amout of bytes received"
      Revert "ASoC: Update cx20442 for TTY API change"
      Linux 3.0-rc2

Liu Yuan (1):
      drivers, block: virtio_blk: Replace cryptic number with the macro

Luciano Coelho (5):
      nl80211: fix check for valid SSID size in scan operations
      wl12xx: fix passive and radar channel generation for scheduled scan
      wl12xx: fix DFS channels handling in scheduled scan
      wl12xx: add separate config value for DFS dwell time on sched scan
      wl12xx: fix oops in sched_scan when forcing a passive scan

Marcus Meissner (1):
      net/ipv4: Check for mistakenly passed in non-IPv4 address

Mark Brown (2):
      ASoC: Fix wm_hubs input PGA ZC bits
      net: dm9000: Get the chip in a known good state before enabling interrupts

Matt Carlson (1):
      tg3: Fix tg3_skb_error_unmap()

Michael S. Tsirkin (7):
      virtio: event index interface
      virtio ring: inline function to check for events
      virtio_ring: support event idx feature
      vhost: support event index
      virtio_test: support event index
      virtio: add api for delayed callbacks
      virtio_net: delay TX callbacks

Mike Frysinger (1):
      kgdbts: only use new asm-generic/ptrace.h api when needed

Mike Habeck (1):
      intel-iommu: Add domain check in domain_remove_one_dev_info

Mike Travis (3):
      intel-iommu: Speed up processing of the identity_mapping function
      intel-iommu: Use coherent DMA mask when requested
      intel-iommu: Remove Host Bridge devices from identity mapping

Namhyung Kim (4):
      nbd: pass MSG_* flags to kernel_recvmsg()
      nbd: limit module parameters to a sane value
      nbd: adjust 'max_part' according to part_shift
      block: remove unwanted semicolons

Nobuhiro Iwamatsu (1):
      sh: asm/tlb.h needs linux/swap.h

Paul Bolle (2):
      cfq-iosched: Remove bogus check in queue_fail path
      block: Use hlist_entry() for io_context.cic_list.first

Paul Mundt (8):
      sh: arch/sh/kernel/process_32.c needs linux/prefetch.h.
      sh: Update shmin to reflect PIO dependency.
      sh64: asm/pgtable.h needs asm/mmu.h
      sh64: Move from P1SEG to CAC_ADDR for consistent sync.
      sh: Fix up asm-generic/ptrace.h fallout.
      Revert "clocksource: sh_tmu: Runtime PM support"
      Revert "clocksource: sh_cmt: Runtime PM support"
      dmaengine: shdma: Fix up fallout from runtime PM changes.

Per Dalen (1):
      hwmon: (max6642) Rename temp_fault sysfs attribute to temp2_fault

Per Dalén (1):
      hwmon: (max6642): Better chip detection schema

Peter Zijlstra (1):
      rcu: Cure load woes

Rafał Miłecki (1):
      b43: N-PHY: initialize last var in calibration function

Rajkumar Manoharan (4):
      ath9k: Reset chip on baseband hang
      ath9k_hw: disable phy restart on baseband panic caused by RXSM
      ath9k: set 40 Mhz rate only if hw is configured in ht40
      mac80211: stop queues before rate control updation

Randy Dunlap (1):
      mtd: fix physmap.h warnings

Raymond Yau (1):
      ALSA: hda - Check pin support EAPD in ad198x_power_eapd_write

Rusty Russell (5):
      lguest: fix timer interrupt setup
      lguest: fix up compilation after move
      lguest: remove support for VIRTIO_F_NOTIFY_ON_EMPTY.
      virtio console: don't manually set or finalize VIRTIO_CONSOLE_F_MULTIPORT.
      virtio: add full three-clause BSD text to headers.

Sage Weil (1):
      vfs: shrink_dcache_parent before rmdir, dir rename

Stanislaw Gruszka (2):
      iwl4965: fix 5GHz operation
      iwl4965: correctly validate temperature value

Stefan Metzmacher (1):
      usbnet/cdc_ncm: add missing .reset_resume hook

Stephen Warren (2):
      ASoC: Fix dapm_is_shared_kcontrol so everything isn't shared
      ARM: Tegra: Harmony: Fix conflicting GPIO numbering

Steven Miao (1):
      Blackfin: strncpy: fix handling of zero lengths

Steven Rostedt (4):
      x86: Put back -pg to tsc.o and add no GCOV to vread_tsc_64.o
      ktest: Fix off-by-one in config bisect result
      ktest: Fix result of rebooting the kernel
      ktest: Ignore unset values of the minconfig in config_bisect

Takashi Iwai (1):
      ALSA: hda - Fix HP and Front pins of ad1988/ad1989 in ad198x_power_eapd()

Tao Ma (1):
      wireless: Default to 'n' for 2 new added devices in Kconfig.

Tejun Heo (1):
      block: blkdev_get() should access ->bd_disk only after success

Tony Luck (1):
      [IA64] wire up sendmmsg() syscall for Itanium

Wei Yongjun (2):
      sctp: stop pending timers and purge queues when peer restart asoc
      vlan: fix typo in vlan_dev_hard_start_xmit()

Wey-Yi Guy (1):
      iwlagn: fix incorrect PCI subsystem id for 6150 devices

Yogesh Ashok Powar (1):
      mwifiex: correct event header length

Youquan Song (1):
      intel-iommu: Enable super page (2MiB, 1GiB, etc.) support

liubo (1):
      Btrfs: don't save the inode cache in non-FS roots

sjur.brandeland@stericsson.com (1):
      caif: Fix race when conditionally taking rtnl lock
