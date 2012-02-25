Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab2BYUeq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 15:34:46 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:40779 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539Ab2BYUen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 15:34:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.8.164 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Feb 2012 12:34:20 -0800
X-Google-Sender-Auth: x9XfPU4klM2dPWLtwJ2Pp-MasK4
Message-ID: <CA+55aFytp=ZT++sj_P7nw9mNSKjPaqjB4srgSB6HYAAJW04-Pw@mail.gmail.com>
Subject: Linux 3.3-rc5
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, no delays this week.

And nothing really odd going on either. Maybe things are finally calming down.

Sure, I'd have liked it to be even calmer, and there's is movement in
various areas: btrfs updates along with scsi and media driver updates.
And various noise elsewhere. But on the whole it's been pretty boring,
which is just how I like it.

A couple of the fixes were directly linked to my -rc4 announcement,
where I told people they could use a 64-bit kernel to avoid the FP
state save/restore problem we used to have. That brought up some
fairly corner-case compatibility issues that could make that
impractical. So hopefully it's *true* this time around.

And while the FP state save problem is gone, if you have a 64-bit
capable CPU but are still running a 32-bit distro, it really would be
interesting to verify that a 64-bit kernel works for you without
problems. Because it always *should* have, but clearly that wasn't
always the case. It would be very interesting to hear from people who
have perhaps tried and failed before and perhaps didn't even bother to
report the failure? Maybe it's worth trying again?

                          Linus

---
Al Viro (2):
      vfs: fix compat_sys_stat() handling of overflows in st_nlink
      ocfs2: deal with wraparounds of i_nlink in ocfs2_rename()

Alan Stern (2):
      [SCSI] scsi_pm: Fix bug in the SCSI power management handler
      usb-storage: fix freezing of the scanning thread

Alex Deucher (1):
      drm/radeon/kms/atom: dpms bios scratch reg updates

Alexander Stein (2):
      m68k: Add shared bit to Coldfire kernel page entries
      m68k: Do not set global share for non-kernel shared pages

Alexey Khoroshilov (1):
      [SCSI] mpt2sas: Fix mismatch in
mpt2sas_base_hard_reset_handler() mutex lock-unlock

Andrew Lunn (1):
      USB: Serial: ti_usb_3410_5052: Add Abbot Diabetes Care cable id

Andrew Vasquez (4):
      [SCSI] qla2xxx: Add an "is reset active" helper.
      [SCSI] qla2xxx: Clear options-flags while issuing stop-firmware
mbx command.
      [SCSI] qla2xxx: Remove errant clearing of MBX_INTERRUPT flag
during CT-IOCB processing.
      [SCSI] qla2xxx: Correct out of bounds read of ISP2200 mailbox registers.

Anton Altaparmakov (1):
      Restore direct_io / truncate locking API

Anton Vorontsov (1):
      mm: memcg: Correct unregistring of events attached to the same eventfd

Arne Jansen (1):
      btrfs: don't check DUP chunks twice

Arun Easi (1):
      [SCSI] qla2xxx: Propagate up abort failures.

Ben Hutchings (1):
      builddeb: Don't create files in /tmp with predictable names

Benjamin Herrenschmidt (2):
      cpuidle: Default y on powerpc pSeries
      powerpc: Fix various issues with return to userspace

Bruno Thomsen (1):
      USB: Added Kamstrup VID/PIDs to cp210x serial driver.

Catalin Marinas (1):
      ARM: 7323/1: Do not allow ARM_LPAE on pre-ARMv7 architectures

Chad Dupuis (2):
      [SCSI] qla2xxx: Add check for null fcport references in
qla2xxx_queuecommand.
      [SCSI] qla2xxx: Update version number to 8.03.07.13-k.

Chris D Schimp (2):
      hwmon: (max6639) Fix FAN_FROM_REG calculation
      hwmon: (max6639) Fix PPR register initialization to set both channels

Chris Mason (6):
      Btrfs: don't reserve data with extents locked in btrfs_fallocate
      Btrfs: improve error handling for btrfs_insert_dir_item callers
      Btrfs: make sure we update latest_bdev
      Btrfs: add extra sanity checks on the path names in btrfs_mksubvol
      Btrfs: clear the extent uptodate bits during parent transid failures
      Btrfs: fix compiler warnings on 32 bit systems

Danny Kukawka (1):
      arch/arm/mach-shmobile/board-ag5evm.c: included linux/dma-mapping.h twice

Dave Jiang (1):
      [SCSI] isci: Fix NULL ptr dereference when no firmware is being loaded

David Howells (2):
      NOMMU: Lock i_mmap_mutex for access to the VMA prio list
      NOMMU: Don't need to clear vm_mm when deleting a VMA

David Sterba (2):
      btrfs: fix structs where bitfields and spinlock/atomic share 8B word
      btrfs: silence warning in raid array setup

Dimitri Sivanich (1):
      vfs: fix panic in __d_lookup() with high dentry hashtable counts

Dmitry Kasatkin (1):
      digsig: changed type of the timestamp

Doug Ledford (1):
      mlx4_core: Exported functions can't be static

Elric Fu (1):
      USB: Set hub depth after USB3 hub reset

Eric Paris (1):
      ARM/audit: include audit header and fix audit arch

Eugeni Dodonov (4):
      drm/i915: gen7: implement rczunit workaround
      drm/i915: gen7: Implement an L3 caching workaround.
      drm/i915: gen7: work around a system hang on IVB
      drm/i915: do not enable RC6p on Sandy Bridge

Florian Albrechtskirchinger (1):
      btrfs: honor umask when creating subvol root

Giridhar Malavali (2):
      [SCSI] qla2xxx: Complete mailbox command timedout to avoid
initialization failures during next reset cycle.
      [SCSI] qla2xxx: Proper detection of firmware abort error code for ISP82xx.

Greg Dietsche (1):
      coccicheck: change handling of C={1,2} when M= is set

Greg Ungerer (1):
      m68knommu: fix syscall tracing stuck process

Guennadi Liakhovetski (4):
      ARM: mach-shmobile: simplify MMCIF DMA configuration
      sh: sh7757lcr: update to the new MMCIF DMA configuration
      ARM: mach-shmobile: add GPIO-to-IRQ translation to sh7372
      sh: se7724: fix compile breakage

Guenter Roeck (2):
      hwmon: (ads1015) Fix file leak in probe function
      hwmon: (max34440) Fix resetting temperature history

Heiko Carstens (1):
      [S390] idle: avoid RCU usage in extended quiescent state

Hitoshi Mitake (1):
      asm-generic: architecture independent readq/writeq for 32bit environment

Huajun Li (1):
      [SCSI] scsi_scan: Fix 'Poison overwritten' warning caused by
using freed 'shost'

Ian Kent (1):
      autofs: work around unhappy compat problem on x86-64

Inki Dae (4):
      drm/exynos: added possible_clones setup function.
      drm/exynos: fixed page flip issue.
      drm/exynos: removed exynos_drm_fbdev_recreate function.
      drm/exynos: added postclose to release resource.

James Morris (1):
      maintainers: update my email address

Jan Kara (2):
      vfs: Provide function to get superblock and wait for it to thaw
      quota: Fix deadlock with suspend and quotas

Jan Schmidt (1):
      Btrfs: avoid positive number with ERR_PTR

Janne Grunau (1):
      [media] hdpvr: fix race conditon during start of streaming

Jarod Wilson (1):
      [media] imon: don't wedge hardware after early callbacks

Javi Merino (2):
      ARM: 7164/3: PL330: Fix the size of the dst_cache_ctrl field
      ARM: 7326/2: PL330: fix null pointer dereference in pl330_chan_ctrl()

Jeff Liu (1):
      Btrfs: return the internal error unchanged if
btrfs_get_extent_fiemap() call failed for SEEK_DATA/SEEK_HOLE inquiry

Jeff Mahoney (1):
      btrfs: delalloc for page dirtied out-of-band in fixup worker

Jerome Glisse (1):
      drm/radeon/kms: properly set accel working flag and bailout when false

Jesper Juhl (1):
      XFS: xfs_trans_add_item() - don't assign in ASSERT() when
compare is intended

Joonyoung Shim (2):
      drm/exynos: changed priority of mixer layers.
      drm/exynos: removed pageflip_event_list init code when closed.

Keith Mannthey (1):
      btrfs: Sector Size check during Mount

Kenneth Graunke (1):
      drm/i915: gen7: Disable the RHWO optimization as it can cause GPU hangs.

Kleber Sacilotto de Souza (1):
      [SCSI] ipr: fix eeh recovery for 64-bit adapters

Kuninori Morimoto (6):
      sh: clock-sh7724: fixup sh_fsi clock settings
      ARM: mach-shmobile: mackerel: use renesas_usbhs instead of r8a66597_hcd
      ARM: mach-shmobile: mackerel: add ak4642 amixer settings on comment
      ARM: mach-shmobile: clock-sh73a0: add DSIxPHY clock support
      sh: clkfwk: bugfix: use clk_reparent() for div6 clocks
      ASoC: ak4642: fixup HeadPhone L/R dapm settings

Kyle McMartin (1):
      MAINTAINERS: drop me from PA-RISC maintenance

Laurent Pinchart (1):
      [media] omap3isp: Fix crash caused by subdevs now having a
pointer to devnodes

Linus Torvalds (6):
      i387: fix up some fpu_counter confusion
      i387: use 'restore_fpu_checking()' directly in task switching code
      i387: support lazy restore of FPU state
      i387: export 'fpu_owner_task' per-cpu variable
      sys_poll: fix incorrect type for 'timeout' parameter
      Linux 3.3-rc5

Liu Bo (6):
      Btrfs: fix trim 0 bytes after a device delete
      Btrfs: skip states when they does not contain bits to clear
      Btrfs: kick out redundant stuff in convert_extent_bit
      Btrfs: fix a bug on overcommit stuff
      Btrfs: be less strict on finding next node in clear_extent_bit
      Btrfs: increase the global block reserve estimates

Lucas De Marchi (1):
      kbuild: do not check for ancient modutils tools

Magnus Damm (5):
      ARM: mach-shmobile: sh73a0 PINT IRQ base fix
      ARM: mach-shmobile: sh73a0 IRQ sparse alloc fix
      ARM: mach-shmobile: IRQ driven GPIO key support for Kota2
      ARM: mach-shmobile: sh73a0 PSTR 32-bit access fix
      ARM: mach-shmobile: r8a7779 PFC IPSR4 fix

Mark Brown (1):
      ASoC: wm8962: Fix sidetone enumeration texts

Mark Hills (1):
      ALSA: snd-usb-caiaq: Fix the return of XRUN

Martin Schwidefsky (3):
      [S390] incorrect PageTables counter for kvm page tables
      [S390] 3215 deadlock with tty_wakeup
      [S390] correct ktime to tod clock comparator conversion

Masanari Iida (2):
      drm/exynos: Fix typo in exynos_mixer.c
      sh: Fix typo in pci-sh7780.c

Miao Xie (1):
      Btrfs: fix deadlock on page lock when doing auto-defragment

Michael Christie (1):
      [SCSI] qla2xxx: Remove check for null fcport from host reset handler.

Michael Ellerman (1):
      powerpc: Fix program check handling when lockdep is enabled

Michel Dänzer (1):
      drm/radeon: Only create additional ring debugfs files on Cayman or newer.

Miklos Szeredi (1):
      vfs: fix d_inode_lookup() dentry ref leak

Mitsuo Hayasaka (2):
      xfs: change available ranges of softlimit and hardlimit in quota check
      xfs: make inode quota check more general

Moger, Babu (1):
      [SCSI] scsi_dh_rdac: Fix for unbalanced reference count

Myron Stowe (1):
      ARM/PCI: Remove ARM's duplicate definition of 'pcibios_max_latency'

Nikolaus Schulz (1):
      hwmon: (f75375s) Fix register write order when setting fans to full speed

Oleg Nesterov (2):
      epoll: introduce POLLFREE to flush ->signalfd_wqh before kfree()
      epoll: ep_unregister_pollwait() can use the freed pwq->whead

Olof Johansson (1):
      ARM: 7327/1: need to include asm/system.h in asm/processor.h

Paul Gortmaker (1):
      arm: fix compile failure in mach-shmobile/board-ag5evm.c

Paul Mundt (2):
      sh: Defer to asm-generic/device.h.
      video: pvr2fb: Fix up spurious section mismatch warnings.

Phil Edworthy (1):
      sh: Fix sh2a build error for CONFIG_CACHE_WRITETHROUGH

Rabin Vincent (1):
      ARM: 7325/1: fix v7 boot with lockdep enabled

Randy Dunlap (1):
      [media] wl128x: fix build errors when GPIOLIB is not enabled

Russell King (1):
      ARM: OMAP: fix voltage domain build errors with PM_OPP disabled

Rusty Russell (2):
      powerpc: Remove references to cpu_*_map
      arch/sh: remove references to cpu_*_map.

Santosh Shilimkar (1):
      ARM: 7336/1: smp_twd: Don't register CPUFREQ notifiers if local
timers are not initialised

Sarah Sharp (5):
      USB: Remove duplicate USB 3.0 hub feature #defines.
      xhci: Fix oops caused by more USB2 ports than USB3 ports.
      USB: Don't fail USB3 probe on missing legacy PCI IRQ.
      USB: Fix handoff when BIOS disables host PCI device.
      xhci: Fix encoding for HS bulk/control NAK rate.

Shimoda, Yoshihiro (4):
      sh: fix the sh_mmcif_plat_data in board-sh7757lcr
      sh: modify resource for SPI0 in setup-sh7757
      sh: add platform_device for SPI1 in setup-sh7757
      sh: modify a resource of sh_eth_giga1_resources in board-sh7757lcr

Shyam Sundar (1):
      [SCSI] qla2xxx: Remove resetting memory during device
initialization for ISP82xx.

Stephen Warren (1):
      Kbuild: Use dtc's -d (dependency) option

Steven Rostedt (1):
      autofs4 - fix lockdep splat in autofs

Takashi Iwai (2):
      ALSA: hda/realtek - Fix overflow of vol/sw check bitmap
      ALSA: hda/realtek - Fix surround output regression on Acer Aspire 5935

Taylor Ralph (1):
      [media] hdpvr: update picture controls to support firmware versions > 0.15

Tony Lindgren (1):
      ARM: 7324/1: modpost: Fix section warnings for ARM for many compilers

Trond Myklebust (3):
      NFSv4: Fix an Oops in the NFSv4 getacl code
      NFSv4: Ensure we throw out bad delegation stateids on NFS4ERR_BAD_STATEID
      NFSv4.1: Fix a NFSv4.1 session initialisation regression

Tsutomu Itoh (3):
      Btrfs: fix memory leak in load_free_space_cache()
      Btrfs: fix return value check of extent_io_ops
      Btrfs: check return value of lookup_extent_mapping() correctly

Weston Andros Adamson (1):
      NFSv4: fix server_scope memory leak

Xi Wang (1):
      ALSA: usb-audio: avoid integer overflow in create_fixed_stream_quirk()

li.rui27@zte.com.cn (1):
      USB: option: cleanup zte 3g-dongle's pid in option.c
