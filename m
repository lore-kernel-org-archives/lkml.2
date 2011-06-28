Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab1F1DJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 23:09:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756327Ab1F1DIj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 23:08:39 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Jun 2011 20:08:14 -0700
Message-ID: <BANLkTinu_V2-iDoH1FX1mSs5jMMZYdUhNg@mail.gmail.com>
Subject: Linux 3.0-rc5
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing terribly exciting here.

The most noteworthy thing may be that only about a quarter of the
changes are in drivers, filesystem changes actually account for more
(40%): btrfs, cifs, ext4, jbd2, nfs are all present and accounted for.

On the driver side, there's some gpu updates, infiniband, mmc, sound
and some SCSI target fixes.

And the normal random smattering of changes all around. Like some
long-standing compile failure (admittedly you need to enable some
esoteric resource counting options and disable NUMA to trigger it, but
still). I think there's a few more lurking in staging, with fixes yet
to be merged.

The appended shortlog is fairly readable.

                        Linus

---
Adrian Hunter (4):
      mmc: block: switch card to User Data Area when removing the block driver
      mmc: core: make erase timeout calculation allow for gated clock
      mmc: queue: append partition subname to queue thread name
      mmc: queue: bring discard_granularity/alignment into line with SCSI

Al Viro (15):
      take bdi setup/destruction into cifs_mount/cifs_umount
      cifs: double free on mount failure
      cifs: don't leak nls on mount failure
      cifs: don't pass superblock to cifs_mount()
      cifs: leak on mount if we share superblock
      cifs: allocate mountdata earlier
      cifs: initialize ->tlink_tree in cifs_setup_cifs_sb()
      sanitize cifs_umount() prototype
      cifs: pull cifs_mount() call up
      cifs: move cifs_umount() call into ->kill_sb()
      cifs: pull freeing mountdata/dropping nls/freeing cifs_sb into
cifs_umount()
      cifs: close sget() races
      cifs: more breakage on mount failures
      cifs: tidy cifs_do_mount() up a bit
      cifs: propagate errors from cifs_get_root() to mount(2)

Alan Stern (2):
      PM: Rename dev_pm_info.in_suspend to is_prepared
      PM: Fix async resume following suspend failure

Alex Deucher (2):
      drm/radeon/kms: fix num_banks tiling config for fusion
      drm/radeon/kms: handle special cases for vddc

Alexey Charkov (1):
      rtc: vt8500: Fix build error & cleanup rtc_class_ops->update_irq_enable()

Anand Gadiyar (1):
      mmc: omap_hsmmc: fix ocr mask usage

Andrew Morton (1):
      drivers/tty/serial/8250_pci.c: fix warning

Andy Adamson (2):
      NFSv4.1: allow nfs_fhget to succeed with mounted on fileid
      NFSv4.1: allow zero fh array in filelayout decode layout

Arnaud Patard (2):
      ASoC: imx: Remove unused Kconfig SND_MXC_SOC_SSI entry
      ASoC: imx: add missing module informations

Ben Widawsky (1):
      drm/i915: save/resume forcewake lock fixes

Benjamin Tissoires (3):
      HID: hid-multitouch: ensure slots are initialized
      HID: hid-multitouch: correct VID for Stantum panels
      HID: hid-multitouch: add support for a new Lumio dual-touch panel

Benny Halevy (4):
      NFSv4.1: deprecate headerpadsz in CREATE_SESSION
      NFSv4.1: fix break condition in pnfs_find_lseg
      NFSv4.1: need to put_layout_hdr on _pnfs_return_layout error path
      NFSv4.1: file layout must consider pg_bsize for coalescing

Boaz Harrosh (1):
      pnfs-obj: No longer needed to take an extra ref at add_device

Bob Liu (1):
      romfs: fix romfs_get_unmapped_area() argument check

Bryan Schumaker (1):
      NFS: Fix decode_secinfo_maxsz

Chris Ball (1):
      mmc: vub300: fix null dereferences in error handling

Chris Mason (1):
      Btrfs: make sure to record the transid in new inodes

Chris Metcalf (1):
      include/linux/compat.h: declare compat_sys_sendmmsg()

Chris Wilson (1):
      drm/i915: Apply HWSTAM workaround for BSD ring on SandyBridge

Christian Borntraeger (3):
      [S390] kvm-s390: fix kconfig dependencies
      [S390] s390: enforce HW limits for the initial sampling rate
      [S390] hwsampler: Set a sane default sampling rate

Dan Carpenter (4):
      target: Fix ERR_PTR dereferencing bugs
      target: Drop bogus ERR_PTR usage in target_fabric_configfs_init
      target: Fix incorrect strlen() NULL terminator checks
      tcm_fc: Fix possible lock to unlock type deadlock

Daniel Drake (1):
      mmc: sdio: reset card during power_restore

Daniel Mack (1):
      ASoC: pxa-ssp: Correct check for stream presence

Dave Chinner (3):
      xfs: reset inode per-lifetime state when recycling it
      xfs: clear XFS_IDIRTY_RELEASE on truncate down
      xfs: prevent bogus assert when trying to remove non-existent attribute

Dave Kleikamp (4):
      jfs: old_agsize should be 64 bits in jfs_extendfs
      jfs: Update agstart when resizing volume
      JFS: Don't save agno in the inode
      jfs: agstart field must be 64 bits

Dave Martin (2):
      ARM: 6963/1: Thumb-2: Relax relocation requirements for
non-function symbols
      ARM: 6961/1: zImage: Add build-time check for correctly-sized
proc_type entries

David Henningsson (2):
      ALSA: HDA: Remove quirk for an HP device
      ALSA: HDA: Pinfix quirk for HP Z200 Workstation

David Howells (3):
      NFS: (d)printks should use %zd for ssize_t arguments
      MN10300: asm/uaccess.h needs to #include linux/kernel.h for might_sleep()
      KEYS: Fix error handling in construct_key_and_link()

David Rientjes (2):
      mm, hotplug: fix error handling in mem_online_node()
      mm, hotplug: protect zonelist building with zonelists_mutex

David S. Miller (1):
      PCI: Fix warning in drivers/pci/probe.c on sparc64

Eric Anholt (1):
      Revert "drm/i915: Kill GTT mappings when moving from GTT domain"

Fred Isaman (3):
      nfs4.1: fix several problems with _pnfs_return_layout
      nfs4.1: prevent race that allowed use of freed layout in
_pnfs_return_layout
      nfs4.1: mark layout as bad on error path in _pnfs_return_layout

Guennadi Liakhovetski (3):
      mmc: sdhi: fix module unloading
      mmc: tmio: fix regression in TMIO_MMC_WRPROTECT_DISABLE handling
      mmc: sdhi: DMA slave ID 0 is invalid

Hugh Dickins (8):
      mm: move vmtruncate_range to truncate.c
      mm: move shmem prototypes to shmem_fs.h
      tmpfs: take control of its truncate_range
      tmpfs: add shmem_read_mapping_page_gfp
      drm/ttm: use shmem_read_mapping_page
      drm/i915: use shmem_read_mapping_page
      drm/i915: use shmem_truncate_range
      drm/i915: more struct_mutex locking

Ilya Dryomov (1):
      Btrfs: fix type mismatch in find_free_extent()

James Hogan (1):
      mmc: cb710: fix #ifdef HAVE_EFFICIENT_UNALIGNED_ACCESS

Jan Glauber (1):
      [S390] allow setting of upper 32 bit in smp_ctl_set_bit

Jan Kara (2):
      jbd2: Fix oops in jbd2_journal_remove_journal_head()
      mm: fix assertion mapping->nrpages == 0 in end_writeback()

Jeff Layton (3):
      cifs: fix wsize negotiation to respect max buffer size and
active signing (try #4)
      cifs: free blkcipher in smbhash
      cifs: mark CONFIG_CIFS_NFSD_EXPORT as BROKEN

Jens Axboe (1):
      cfq-iosched: fix locking around ioc->ioc_data assignment

Jesper Juhl (2):
      ALSA: Remove unneeded version.h includes from sound/
      Remove unneeded version.h includes from fs/

Joe Perches (1):
      block: Add __attribute__((format(printf...) and fix fallout

John Stultz (2):
      alarmtimers: Handle late rtc module loading
      alarmtimers: Return -ENOTSUPP if no RTC device is present

Josef Bacik (1):
      Btrfs: make sure to update total_bitmaps when freeing cache V3

Josh Hunt (1):
      drivers/misc/lkdtm.c: fix race when crashpoint is hit multiple
times before checking count

Justin P. Mattock (1):
      drivers/ata/sata_dwc_460ex: Fix typo 'corrresponding'

KAMEZAWA Hiroyuki (2):
      Fix node_start/end_pfn() definition for mm/page_cgroup.c
      memcg: fix direct softlimit reclaim to be called in limit path

Keith Packard (1):
      drm/i915: Call intel_enable_plane from i9xx_crtc_mode_set (again)

Kevin Hilman (1):
      PM / Runtime: Update doc: usage count no longer incremented
across system PM

Kiran Patil (1):
      tcm_fc: Fix ft_send_tm LUN lookup OOPs

Linus Torvalds (1):
      Linux 3.0-rc5

Linus Walleij (2):
      ARM: 6962/1: mach-h720x: fix build error
      ARM: 6969/1: plat-iop: fix build error

Lukas Czerner (3):
      ext4: Fix max file size and logical block counting of extent format file
      ext4: use FIEMAP_EXTENT_LAST flag for last extent in fiemap
      ext4: fixed tracepoints cleanup

Lydia Wang (3):
      ALSA: VIA HDA: Modify initial verbs list for VT1718S.
      ALSA: VIA HDA: Mute/unmute mixer conncted to Headphone for VT1718S.
      ALSA: VIA HDA: Create a master amplifier control for VT1718S.

Magnus Damm (1):
      ARM: 6959/1: SMP build fix for entry-macro-multi.S

Manoj Iyer (1):
      mmc: Add PCI fixup quirks for Ricoh 1180:e823 reader

Mark Brown (1):
      ASoC: Remove unused and about to be broken SND_SOC_CUSTOM I/O bus

Miao Xie (1):
      btrfs: fix inconsonant inode information

Michal Kubecek (1):
      PM: Free memory bitmaps if opening /dev/snapshot fails

Mika Westerberg (1):
      serial: mrst_max3110: initialize waitqueue earlier

Mitko Haralanov (1):
      IB/qib: Ensure that LOS and DFE are being turned off

Márton Németh (1):
      x86/PCI/ACPI: fix type mismatch

Namhyung Kim (1):
      block: add REQ_SECURE to REQ_COMMON_MASK

Nicholas Bellinger (8):
      [SCSI] target: Fix multi task->task_sg[] chaining logic bug
      [SCSI] target: Fix interrupt context bug with stats_lock and
core_tmr_alloc_req
      [SCSI] target: Fix bug with task_sg chained
transport_free_dev_tasks release
      [SCSI] target: Fix task->task_execute_queue=1 clear bug + LUN_RESET OOPs
      [SCSI] target: Convert REPORT_LUNs to use int_to_scsilun
      [SCSI] target: Convert TASK_ATTR to scsi_tcq.h definitions
      target: Fix transport_get_lun_for_tmr failure cases
      tcm_fc: Fix conversion spec warning

Nishanth Aravamudan (1):
      libata/sas: only set FROZEN flag if new EH is supported

Ohad Ben-Cohen (1):
      mmc: sdio: fix runtime PM path during driver removal

Pavel Shilovsky (1):
      CIFS: Fix problem with 3.0-rc1 null user mount failure

Paweł Drewniak (1):
      pata_marvell: Add support for 88SE91A0, 88SE91A4

Peng Tao (1):
      NFS41: do not update isize if inode needs layoutcommit

Per Forlin (1):
      mmc: omap_hsmmc: use original sg_len for dma_unmap_sg

Peter Zijlstra (1):
      mm/memory-failure.c: fix spinlock vs mutex order

Priyanka Jain (1):
      drivers/rtc/rtc-ds1307.c: add support for RTC device pt7c4338

Rafael J. Wysocki (4):
      PM: Update documentation regarding sysdevs
      PM / Runtime: Handle clocks correctly if CONFIG_PM_RUNTIME is unset
      PM / Domains: Update documentation
      PCI / PM: Block races between runtime PM and system sleep

Ralf Baechle (3):
      drivers/leds/leds-lp5521.c: fix section mismatches
      drivers/leds/leds-lp5523.c: fix section mismatches
      drivers/misc/ioc4.c: fix section mismatch / race condition

Randy Dunlap (1):
      PCI: fix new kernel-doc warning

Richard Weinberger (1):
      um: add asm/percpu.h

Roland Dreier (1):
      target: Convert transport_deregister_session_configfs
nacl_sess_lock to save irq state

Russell King (4):
      ARM: SMP: wait for CPU to be marked active
      Fix CPU spinlock lockups on secondary CPU bringup
      ARM: pm: proc-v7: fix missing struct processor pointers for suspend code
      ARM: pm: ensure ARMv7 CPUs save and restore the TLS register

Steve Wise (3):
      RDMA/cxgb4: Don't exceed hw IQ depth limit for user CQs
      RDMA/cxgb4: Don't truncate MR lengths
      RDMA/cxgb4: Couple of abort fixes

Tao Ma (1):
      jbd2: Remove obsolete parameters in the comments for some jbd2 functions

Tejun Heo (5):
      block: don't use non-syncing event blocking in disk_check_events()
      block: remove non-syncing __disk_block_events() and fold it into
disk_block_events()
      block: make disk_block_events() properly wait for work cancellation
      block: use the passed in @bdev when claiming if partno is zero
      libata: apply NOSETXFER horkage to the affected Pioneer drives
  regardless of firmware revision

Tony Vroon (1):
      ALSA: hda - Remove ALC268 model override for CPR2000

Trond Myklebust (6):
      NLM: Don't hang forever on NLM unlock requests
      NFSv4.1: Fix a refcounting issue in the pNFS device id cache
      NFSv4: Fix a readdir regression
      SUNRPC: Ensure the RPC client only quits on fatal signals
      NFSv4.1: Fix some issues with pnfs_generic_pg_test
      NFSv4.1: Fix an off-by-one error in pnfs_generic_pg_test

Vasiliy Kulikov (1):
      taskstats: don't allow duplicate entries in listener mode

Vitaliy Ivanov (1):
      Fix some kernel-doc warnings

Wanlong Gao (1):
      mmc: of_mmc_spi: add NO_IRQ define to of_mmc_spi.c

Weston Andros Adamson (1):
      NFS: fix umount of pnfs filesystems

William Douglas (1):
      mrst_max3110: Change max missing message priority.

Yongqiang Yang (1):
      ext4: correct comments for ext4_free_blocks()
