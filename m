Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab1HVUXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:23:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753246Ab1HVUXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:23:08 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 22 Aug 2011 13:22:43 -0700
Message-ID: <CA+55aFw0JF2crMpEM1tZfKk7YRq-PfqQC=B91nQ7zbjkx35Uew@mail.gmail.com>
Subject: Linux 3.1-rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a day late - I was just too hungry tired after the DM class to
release it yesterday. But there it is, all fresh and new.

And a few thank-yous are in order: things are looking good. The
diffstat looks reasonable (the one big addition is in Documentation),
and while I could have wished for even less churn, I'm pretty happy.
The rc2 to rc3 shortlog is appended, and I think it mostly looks
pretty reasonable and short. Which is not to say that I'm not hoping
that things will calm down even further in the later rc's, but at
least so far I don't think I've had much reason to complain.

Another thank-you goes to Intel: this release has been full of travel
(happily now all completed), first due to a week of vacation during
the merge window, and then for my DM class weekends and LinuxCon. And
the new laptop made it much less painful to do even "allmodconfig"
builds while on the road.

So go out and test.

                                Linus

---


Alan Cox (1):
      gma500: kill MIPI interface types

Alex Deucher (4):
      drm/radeon/kms: don't enable connectors that are off in the
hotplug handler
      drm/radeon/kms: fix regression is handling >2 heads on cedar/caicos
      drm/radeon/kms: make some watermark messages debug only
      drm/radeon/kms: don't try to be smart in the hpd handler

Andrew Morton (1):
      drivers/cdrom/cdrom.c: relax check on dvd manufacturer value

Arnaldo Carvalho de Melo (1):
      perf top browser: Remove spurious helpline update

Arnaud Patard (1):
      ata: Add iMX pata support

Axel Lin (1):
      block: swim3: fix unterminated of_device_id table

Bernd Schubert (1):
      IPoIB: Fix possible NULL dereference in ipoib_start_xmit()

Boaz Harrosh (2):
      pnfs-obj: Bug when we are running out of bio
      pnfs-obj: Fix the comp_index != 0 case

Chris Mason (1):
      Btrfs: force unplugs when switching from high to regular priority bios

Curt Wohlgemuth (1):
      ext4: Fix ext4_should_writeback_data() for no-journal mode

Dan Carpenter (2):
      btrfs: memory leak in btrfs_add_inode_defrag()
      btrfs: unlock on error in btrfs_file_llseek()

Daniel Mack (1):
      ALSA: snd_usb_caiaq: track submitted output urbs

Daniel T Chen (1):
      ALSA: ac97: Add HP Compaq dc5100 SFF(PT003AW) to Headphone Jack
Sense whitelist

Dave Kleikamp (1):
      jfs: flush journal completely before releasing metadata inodes

David Daney (1):
      PCI: OF: Don't crash when bridge parent is NULL.

David S. Miller (1):
      sparc64: Set HAVE_C_RECORDMCOUNT

Geunsik Lim (1):
      MAINTAINERS: Fix list of perf events source files

H Hartley Sweeten (1):
      drivers/block/drbd/drbd_nl.c: use bitmap_parse instead of __bitmap_parse

Heiko Carstens (1):
      nfs: add missing prefetch.h include

Herbert Poetzl (1):
      block/genhd.c: remove useless cast in diskstats_show()

Ian Campbell (3):
      mm: make HASHED_PAGE_VIRTUAL page_address' struct page argument const.
      mm: fix __page_to_pfn for a const struct page argument
      sparc: fix array bounds error setting up PCIC NMI trap

Jan Beulich (1):
      xen/x86: replace order-based range checking of M2P table by linear one

Jeff Garzik (1):
      [libata] sata_sil: fix used-uninit warning

Jeff Layton (1):
      cifs: demote cERROR in build_path_from_dentry to cFYI

Jeff Mahoney (1):
      btrfs: btrfs_permission's RO check shouldn't apply to device nodes

Jeff Moyer (2):
      allow blk_flush_policy to return REQ_FSEQ_DATA independent of *FLUSH
      block: fix flush machinery for stacking drivers with differring
flush flags

Jens Axboe (2):
      bsg-lib: add module.h include
      Revert "cfq: Remove special treatment for metadata rqs."

Jeremy Fitzhardinge (1):
      xen/tracing: Fix tracing config option properly

Jesse Barnes (3):
      drm/i915: show interrupt info on IVB
      drm/i915: split out PCH refclk update code
      drm/i915: set GFX_MODE to pre-Ivybridge default value even on Ivybridge

Jiaying Zhang (2):
      ext4: call ext4_ioend_wait and ext4_flush_completed_IO in ext4_evict_inode
      ext4: flush any pending end_io requests before DIO reads w/dioread_nolock

Jiri Olsa (1):
      perf report: Use properly build_id kernel binaries

Jon Mason (2):
      PCI: Set PCI-E Max Payload Size on fabric
      PCI: export pcie_bus_configure_settings symbol

Jonas Aberg (1):
      fat: fix build warning

Josef Bacik (3):
      Btrfs: detect wether a device supports discard
      Btrfs: set i_size properly when fallocating and we already
      Btrfs: fix 64 bit divide problem

Josh Boyer (1):
      perf tools: Fix build against newer glibc

Julia Lawall (2):
      drivers/ata/sata_dwc_460ex.c: add missing kfree
      ALSA: sound/aoa/fabrics/layout.c: remove unneeded kfree

Kay Sievers (4):
      loop: replace linked list of allocated devices with an idr index
      loop: add management interface for on-demand device allocation
      loop: add BLK_DEV_LOOP_MIN_COUNT=%i to allow distros 0
pre-allocated loop devices
      loop: fix deadlock when sysfs and LOOP_CLR_FD race against each other

Keith Packard (6):
      drm/i915: Wait for LVDS panel power sequence
      drm/i915: Leave LVDS registers unlocked
      drm/i915: Fix PCH port pipe select in CPT disable paths
      drm/i915: Remove unused 'reg' argument to dp_pipe_enabled
      drm/i915: Can't do accurate vblank timestamps with UMS
      drm/i915: Cannot set clock gating under UMS

Konrad Rzeszutek Wilk (1):
      xen/blkback: Make description more obvious.

Li Zefan (1):
      Btrfs: use plain page_address() in header fields setget functions

Lin Ming (1):
      perf tools: Add group event scheduling option to perf record/stat

Linus Torvalds (1):
      Linux 3.1-rc3

Mark Brown (1):
      regmap: Fix bulk reads

Masami Hiramatsu (9):
      perf probe: Fix a memory leak for scopes array
      perf probe: Fix line walker to check CU correctly
      perf probe: Fix to search nested inlined functions in CU
      perf probe: Fix to walk all inline instances
      perf probe: Warn when more than one line are given
      perf probe: Fix to search local variables in appropriate scope
      perf probe: Avoid searching variables in intermediate scopes
      perf probe: Search concrete out-of-line instances
      perf probe: Filter out redundant inline-instances

Mathias Krause (1):
      i7core_edac: fixed typo in error count calculation

Matthew Garrett (3):
      drm/radeon: Allow panel preferred EDID to override BIOS native mode
      drm/radeon: re-POST the asic on Apple hardware when booted via EFI
      Not all systems expose a firmware or platform mechanism for
changing the backlight intensity on i915, so add native driver
support.

Matthew Wilcox (1):
      Move some REQ flags to the common bio/request area

Miao Xie (2):
      Btrfs: fix wrong free space information
      Btrfs: fix uninitialized sync_pending

Michael Witten (16):
      Docs: MSI-HOWTO: Use the subjunctive, and change `can' to `may'
      Docs: MSI-HOWTO: Use present tense and streamline some wording
      Docs: MSI-HOWTO: `asked for' -> `requested'
      Docs: MSI-HOWTO: Streamline some wording
      Docs: MSI-HOWTO: Put the `because' subordinate clause first
      Docs: MSI-HOWTO: Offset modifier with a comma, and insert `yet'
for emphasis
      Docs: MSI-HOWTO: Insert `that'
      Docs: MSI-HOWTO: Move a sentence to another paragraph
      Docs: MSI-HOWTO: , -> ;
      Docs: MSI-HOWTO: API -> function
      Docs: MSI-HOWTO: Insert a comma
      Docs: MSI-HOWTO: may -> might
      Docs: MSI-HOWTO: Use `unknown ...' rather than `... know about.'
      Docs: MSI-HOWTO: can -> could
      Docs: MSI-HOWTO: Insert a comma
      Docs: MSI-HOWTO: MSI -> MSIs

Mihai Moldovan (1):
      fat: fix utf8 iocharset warning message

Mikael Pettersson (2):
      sparc64: remove unnecessary macros from spinlock_64.h
      sparc32: unbreak arch_write_unlock()

Mike Christie (1):
      block: add bsg helper library

Namhyung Kim (1):
      blktrace: add FLUSH/FUA support

Namjae Jeon (1):
      fat: fat16 support maximum 4GB file/vol size as WinXP or 7.

Or Gerlitz (2):
      IBiser: Fix wrong mask when sizeof (dma_addr_t) > sizeof (unsigned long)
      IB/iser: Support iSCSI PDU padding

Peter Zijlstra (1):
      lockdep: Fix wrong assumption in match_held_lock

Rafael J. Wysocki (1):
      PM / Domains: Fix build for CONFIG_PM_RUNTIME unset

Ram Pai (3):
      PCI : ability to relocate assigned pci-resources
      PCI: make cardbus-bridge resources optional
      PCI: code and comments cleanup

Randy Dunlap (7):
      KVM: fix TASK_DELAY_ACCT kconfig warning
      xen: xen-selfballoon.c needs more header files
      x86: fix mm/fault.c build
      xen: self-balloon needs module.h
      KVM: uses TASKSTATS, depends on NET
      irqdesc: fix new kernel-doc warning
      pci: fix new kernel-doc warning in pci.c

Rusty Russell (2):
      virtio: Add text copy of spec to Documentation/virtual.
      lguest: allow booting guest with CONFIG_RELOCATABLE=y

Sage Weil (1):
      Btrfs: truncate pages from clone ioctl target range

Sebastian Andrzej Siewior (2):
      irq: Always set IRQF_ONESHOT if no primary handler is specified
      irq: Track the owner of irq descriptor

Shaohua Li (2):
      blk-throttle: correctly determine sync bio
      block: improve rq_affinity placement

Shirish Pargaonkar (1):
      cifs: Do not set cifs/ntfs acl using a file handle (try #4)

Stefan Bader (2):
      xen-blkfront: Drop name and minor adjustments for emulated scsi devices
      xen-blkfront: Fix one off warning about name clash

Stefan Richter (3):
      firewire: cdev: fix 32 bit userland on 64 bit kernel compat corner cases
      firewire: ohci: fix DMA unmapping in an error path
      firewire: core: handle ack_busy when fetching the Config ROM

Stefano Stabellini (1):
      xen: Do not enable PV IPIs when vector callback not present

Stephane Eranian (3):
      perf list: Fix exit value
      perf evlist: Fix missing event name init for default event
      perf tools: Fix error handling of unknown events

Stephen Rothwell (1):
      regmap: using module facilities requires module.h

Stephen Warren (1):
      regmap: Specify a module license

Steve French (3):
      [CIFS] Cleanup use of CONFIG_CIFS_STATS2 ifdef to make transport
routines more readable
      [CIFS] possible memory corruption on mount
      update cifs version to 1.75

Takashi Iwai (5):
      ALSA: hda - Fix duplicated capture-volume creation for ALC268 models
      ALSA: hda - Add "PCM" volume to vmaster slave list
      ALSA: usb-audio - Fix missing mixer dB information
      ALSA: hda - Don't spew too many ELD errors
      ALSA: hda - Fix error check from snd_hda_get_conn_index() in
patch_cirrus.c

Tao Ma (2):
      block: Make rq_affinity = 1 work as expected
      ext4: Resolve the hang of direct i/o read in handling
EXT4_IO_END_UNWRITTEN.

Tejun Heo (1):
      pata_via: disable ATAPI DMA on AVERATEC 3200

Theodore Ts'o (1):
      ext4: fix nomblk_io_submit option so it correctly converts uninit blocks

Thomas Gleixner (3):
      rtc: Handle errors correctly in rtc_irq_set_state()
      rtc: Fix hrtimer deadlock
      rtc: Limit RTC PIE frequency

Timo Warns (1):
      befs: Validate length of long symbolic links.

Tony Luck (1):
      [IA64] fix "allnoconfig" build

Trond Myklebust (2):
      NFSv4.1: Fix the callback 'highest_used_slotid' behaviour
      NFSv4.1: Return NFS4ERR_BADSESSION to callbacks during session resets

Tsutomu Itoh (1):
      Btrfs: forced readonly when btrfs_drop_snapshot() fails

Vasiliy Kulikov (1):
      perf: fix temporary file ownership check

Vivek Goyal (2):
      cfq-iosched: Reduce linked group count upon group destruction
      cfq-iosched: Add documentation about idling

Yinghai Lu (2):
      PCI: honor child buses add_size in hot plug configuration
      PCI: make SRIOV resources optional

jhbird.choi@samsung.com (1):
      genirq: Fix wrong bit operation

liubo (3):
      Btrfs: fix an oops of log replay
      Btrfs: fix a bug of balance on full multi-disk partitions
      Btrfs: check if there is enough space for balancing smarter
