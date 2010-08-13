Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab0HMV0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:26:21 -0400
Received: from kroah.org ([198.145.64.141]:41129 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab0HMV0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:26:19 -0400
Date: Fri, 13 Aug 2010 14:24:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.19
Message-ID: <20100813212447.GE22102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.19 kernel.

All users of the 2.6.32 kernel series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 arch/arm/Kconfig                            |   12 
 arch/arm/include/asm/tlbflush.h             |    8 
 arch/arm/plat-mxc/include/mach/gpio.h       |    1 
 arch/ia64/hp/common/sba_iommu.c             |   38 +
 arch/ia64/kernel/time.c                     |    4 
 arch/powerpc/Makefile                       |   16 
 arch/powerpc/include/asm/ppc-pci.h          |    5 
 arch/powerpc/kernel/time.c                  |    5 
 arch/powerpc/platforms/pseries/eeh.c        |    4 
 arch/powerpc/platforms/pseries/eeh_driver.c |    4 
 arch/powerpc/platforms/pseries/eeh_event.c  |    2 
 arch/s390/include/asm/cputime.h             |    8 
 arch/s390/kernel/s390_ext.c                 |    2 
 arch/s390/kernel/time.c                     |    3 
 arch/s390/kernel/vtime.c                    |    2 
 arch/x86/include/asm/cmpxchg_32.h           |   86 +--
 arch/x86/include/asm/cmpxchg_64.h           |   88 +--
 arch/x86/kernel/apic/io_apic.c              |   28 -
 arch/x86/kernel/cpu/vmware.c                |   10 
 arch/x86/kernel/vsyscall_64.c               |    5 
 arch/x86/mm/fault.c                         |    4 
 arch/x86/mm/init_64.c                       |   19 
 crypto/testmgr.c                            |   84 +++
 drivers/acpi/processor_perflib.c            |    6 
 drivers/ata/ata_piix.c                      |    8 
 drivers/atm/solos-pci.c                     |    7 
 drivers/block/loop.c                        |    2 
 drivers/bluetooth/btusb.c                   |    3 
 drivers/char/nvram.c                        |   14 
 drivers/gpu/drm/drm_edid.c                  |    4 
 drivers/gpu/drm/i915/dvo_tfp410.c           |    2 
 drivers/ide/ide-cd.c                        |   14 
 drivers/md/bitmap.c                         |    4 
 drivers/md/bitmap.h                         |    3 
 drivers/md/raid1.c                          |   25 
 drivers/md/raid10.c                         |   18 
 drivers/net/smsc911x.c                      |   92 +--
 drivers/net/xen-netfront.c                  |    1 
 drivers/pci/quirks.c                        |    4 
 drivers/s390/cio/cio.c                      |    1 
 drivers/scsi/aic7xxx/aic79xx_core.c         |   53 +-
 drivers/scsi/ibmvscsi/ibmvfc.c              |    8 
 drivers/scsi/ibmvscsi/ibmvfc.h              |    1 
 drivers/staging/line6/Kconfig               |    1 
 drivers/staging/panel/panel.c               |    2 
 drivers/usb/core/hub.c                      |    6 
 drivers/usb/core/quirks.c                   |    3 
 drivers/usb/core/urb.c                      |   50 -
 drivers/usb/misc/usbtest.c                  |    6 
 drivers/usb/mon/mon_bin.c                   |    2 
 drivers/usb/serial/cp210x.c                 |    4 
 drivers/usb/serial/ftdi_sio.c               |    4 
 drivers/usb/serial/ftdi_sio_ids.h           |   10 
 drivers/usb/serial/option.c                 |   13 
 drivers/video/w100fb.c                      |    4 
 drivers/xen/events.c                        |    1 
 fs/block_dev.c                              |   10 
 fs/btrfs/acl.c                              |   36 -
 fs/btrfs/btrfs_inode.h                      |    5 
 fs/btrfs/ctree.c                            |  229 +++++---
 fs/btrfs/ctree.h                            |   40 +
 fs/btrfs/dir-item.c                         |   19 
 fs/btrfs/disk-io.c                          |   40 +
 fs/btrfs/extent-tree.c                      |  112 ++--
 fs/btrfs/extent_io.c                        |    3 
 fs/btrfs/file.c                             |  729 ++++++++++++----------------
 fs/btrfs/inode.c                            |  624 ++++++++++++++---------
 fs/btrfs/ioctl.c                            |   34 -
 fs/btrfs/ordered-data.c                     |  117 +++-
 fs/btrfs/ordered-data.h                     |    5 
 fs/btrfs/relocation.c                       |   43 +
 fs/btrfs/super.c                            |   20 
 fs/btrfs/transaction.c                      |   44 -
 fs/btrfs/transaction.h                      |    6 
 fs/btrfs/tree-log.c                         |   86 +--
 fs/btrfs/volumes.c                          |   19 
 fs/btrfs/xattr.c                            |   80 ++-
 fs/btrfs/xattr.h                            |    9 
 fs/dlm/ast.c                                |   74 ++
 fs/dlm/ast.h                                |    4 
 fs/dlm/config.c                             |   24 
 fs/dlm/debug_fs.c                           |    2 
 fs/dlm/dir.c                                |    7 
 fs/dlm/dlm_internal.h                       |   11 
 fs/dlm/lock.c                               |  120 +++-
 fs/dlm/lockspace.c                          |   15 
 fs/dlm/lowcomms.c                           |    6 
 fs/dlm/member.c                             |    8 
 fs/dlm/memory.c                             |    6 
 fs/dlm/netlink.c                            |    2 
 fs/dlm/plock.c                              |    6 
 fs/dlm/rcom.c                               |    2 
 fs/dlm/requestqueue.c                       |    2 
 fs/dlm/user.c                               |   22 
 fs/dlm/user.h                               |    4 
 fs/ecryptfs/file.c                          |   60 +-
 fs/ecryptfs/inode.c                         |    5 
 fs/ext4/move_extent.c                       |    3 
 fs/ext4/super.c                             |   27 -
 fs/jfs/xattr.c                              |   87 +--
 fs/ocfs2/alloc.c                            |   10 
 fs/ocfs2/alloc.h                            |    5 
 fs/ocfs2/locks.c                            |    2 
 fs/ocfs2/refcounttree.c                     |  117 ++++
 fs/ocfs2/super.c                            |    4 
 fs/proc/array.c                             |    5 
 fs/reiserfs/journal.c                       |   15 
 fs/reiserfs/xattr_security.c                |    2 
 fs/signalfd.c                               |    2 
 fs/splice.c                                 |   12 
 include/linux/clocksource.h                 |    6 
 include/linux/fs.h                          |    6 
 include/linux/interrupt.h                   |    7 
 include/linux/netdevice.h                   |    2 
 include/linux/notifier.h                    |    1 
 include/linux/reiserfs_xattr.h              |    5 
 include/linux/sched.h                       |    4 
 include/linux/tick.h                        |    3 
 include/linux/usb/quirks.h                  |    4 
 kernel/exit.c                               |   20 
 kernel/fork.c                               |    3 
 kernel/irq/manage.c                         |    2 
 kernel/sched.c                              |   71 ++
 kernel/sys.c                                |   18 
 kernel/time/tick-sched.c                    |   75 +-
 kernel/time/timekeeping.c                   |    6 
 mm/memory-failure.c                         |   21 
 mm/memory.c                                 |   25 
 mm/swapfile.c                               |    6 
 net/ipv4/devinet.c                          |    1 
 net/sched/sch_generic.c                     |   18 
 132 files changed, 2549 insertions(+), 1552 deletions(-)


Adam Jackson (1):
      drm/edid: Fix the HDTV hack sync adjustment

Alessio Igor Bogani (1):
      USB: cp210x: Add four new device IDs

Alok Kataria (1):
      x86, vmware: Preset lpj values when on VMware.

Andrew Bird (1):
      USB: option: add huawei k3765 k4505 devices to work properly

Aneesh Kumar K.V (2):
      Btrfs: Use correct values when updating inode i_size on fallocate
      Btrfs: apply updated fallocate i_size fix

Benjamin Herrenschmidt (1):
      mutex: Don't spin when the owner CPU is offline or other weird cases

Borislav Petkov (1):
      ide-cd: Do not access completed requests in the irq handler

Breno Leitao (1):
      powerpc/eeh: Fix a bug when pci structure is null

Brian King (2):
      ibmvfc: Fix command completion handling
      ibmvfc: Reduce error recovery timeout

Catalin Marinas (1):
      smsc911x: Add spinlocks around registers access

Chris Mason (2):
      Btrfs: make sure fallocate properly starts a transaction
      Btrfs: deal with NULL acl sent to btrfs_set_acl

Chris Wright (1):
      blkdev: cgroup whitelist permission fix

Christian Lamparter (1):
      USB: fix thread-unsafe anchor utiliy routines

Cyril Lacoux (1):
      Bluetooth: Added support for controller shipped with iMac i5

Darrick J. Wong (1):
      ACPI: Fix regression where _PPC is not read at boot even when ignore_ppc=0

Dave Kleikamp (1):
      jfs: don't allow os2 xattr namespace overlap with others

Dave Müller (1):
      drm/i915: Use RSEN instead of HTPLG for tfp410 monitor detection.

David S. Miller (1):
      net: Fix NETDEV_NOTIFY_PEERS to not conflict with NETDEV_BONDING_DESLAVE.

David Teigland (3):
      dlm: always use GFP_NOFS
      dlm: fix ordering of bast and cast
      dlm: send reply before bast

David Woodhouse (1):
      solos-pci: Fix race condition in tasklet RX handling

Eric Sandeen (2):
      ext4: fix freeze deadlock under IO
      ext4: Fix optional-arg mount options

Eric W. Biederman (1):
      x86: Fix out of order of gsi

FUJITA Tomonori (1):
      fix SBA IOMMU to handle allocation failure properly

Greg Kroah-Hartman (1):
      Linux 2.6.32.19

H. Peter Anvin (2):
      nvram: Fix write beyond end condition; prove to gcc copy is safe
      x86: Add memory modify constraints to xchg() and cmpxchg()

Hannes Reinecke (1):
      aic79xx: check for non-NULL scb in ahd_handle_nonpkt_busfree

Hidetoshi Seto (2):
      sched: Fix granularity of task_u/stime()
      sched, cputime: Introduce thread_group_times()

Ian Campbell (4):
      arp_notify: allow drivers to explicitly request a notification event.
      xen: netfront: explicitly generate arp_notify event after migration.
      irq: Add new IRQ flag IRQF_NO_SUSPEND
      xen: Do not suspend IPI IRQs.

Jan Engelhardt (1):
      btrfs: fix missing last-entry in readdir(3)

Jan Kara (1):
      ocfs2: Set MS_POSIXACL on remount

Jeff Mahoney (2):
      reiserfs: properly honor read-only devices
      reiserfs: fix oops while creating privroot with selinux enabled

Jiri Slaby (1):
      Btrfs, fix memory leaks in error paths

John G. Rogers (1):
      USB: serial: enabling support for Segway RMP in ftdi_sio

Josef Bacik (9):
      Btrfs: make metadata chunks smaller
      Btrfs: fix regression in orphan cleanup
      Btrfs: fix possible panic on unmount
      Btrfs: run orphan cleanup on default fs root
      Btrfs: do not mark the chunk as readonly if in degraded mode
      Btrfs: check return value of open_bdev_exclusive properly
      Btrfs: check total number of devices when removing missing
      Btrfs: do not try and lookup the file extent when finishing ordered io
      Btrfs: kfree correct pointer during mount option parsing

Julia Lawall (1):
      fs/ecryptfs/file.c: introduce missing free

KAMEZAWA Hiroyuki (1):
      mm: fix corruption of hibernation caused by reusing swap during image saving

Lin Ming (1):
      timekeeping: Fix clock_gettime vsyscall time warp

Lino Sanfilippo (1):
      ecryptfs: release reference to lower mount if interpose fails

Linus Torvalds (3):
      mm: keep a guard page below a grow-down stack segment
      mm: fix missing page table unmap for stack guard page failure case
      x86: don't send SIGBUS for kernel page faults

Martin Schwidefsky (2):
      nohz: Introduce arch_needs_cpu
      nohz: Reuse ktime in sub-functions of tick_check_idle.

Matthew Wilcox (1):
      Btrfs: Show discard option in /proc/mounts

Miao Xie (1):
      Btrfs: remove BUG_ON() due to mounting bad filesystem

Miklos Szeredi (1):
      splice: fix misuse of SPLICE_F_NONBLOCK

Ming Lei (1):
      USB: usbtest: avoid to free coherent buffer in atomic context

Nathan Lynch (1):
      signalfd: fill in ssi_int for posix timers and message queues

NeilBrown (2):
      md/raid10: fix deadlock with unaligned read during resync
      md/raid1: delay reads that could overtake behind-writes.

Nikanth Karthikesan (1):
      loop: Update mtime when writing using aops

Pavel Kazlou (1):
      USB: option: Huawei ETS 1220 support added

Peter Huewe (2):
      Staging: panel: Prevent double-calling of parport_release - fix oops.
      drivers/video/w100fb.c: ignore void return value / fix build failure

Phil Dibowitz (1):
      USB delay init quirk for logitech Harmony 700-series devices

Rafael J. Wysocki (1):
      PCI: Do not run NVidia quirks related to MSI with MSI disabled

Randy Dunlap (1):
      Staging: line6: needs to select SND_PCM

Roel Kluin (1):
      Btrfs: make error return negative in btrfs_sync_file()

Sachin Prabhu (1):
      Skip check for mandatory locks when unlocking

Sage Weil (1):
      Btrfs: fail mount on bad mount options

Sam Ravnborg (1):
      powerpc: fix build with make 3.82

Shaohua Li (1):
      Btrfs: btrfs_mark_extent_written uses the wrong slot

Shaohui Zheng (1):
      memory hotplug: fix a bug on /dev/mem for 64-bit kernels

Song Youquan (1):
      crypto: testmgr - Fix complain about lack test for internal used algorithm

Steven Robertson (1):
      USB: resizing usbmon binary interface buffer causes protection faults

TARUISI Hiroaki (1):
      Btrfs: deny sys_link across subvolumes.

Tao Ma (1):
      ocfs2: Find proper end cpos for a leaf refcount block.

Tejun Heo (3):
      ata_piix: fix locking around SIDPR access
      PCI: disable MSI on VIA K8M800
      bio, fs: update RWA_MASK, READA and SWRITE to match the corresponding BIO_RW_* bits

Theodore Ts'o (1):
      ext4: Make sure the MOVE_EXT ioctl can't overwrite append-only files

Tyler Hicks (1):
      eCryptfs: Handle ioctl calls with unlocked and compat functions

Uwe Kleine-König (1):
      ARM: 6280/1: imx: Fix build failure when including <mach/gpio.h> without <linux/spinlock.h>

Will Deacon (1):
      ARM: 6299/1: errata: TLBIASIDIS and TLBIMVAIS operations can broadcast a faulty ASID

Wu Fengguang (2):
      HWPOISON: remove the anonymous entry
      HWPOISON: abort on failed unmap

Yan, Zheng (17):
      Btrfs: Avoid superfluous tree-log writeout
      Btrfs: Add btrfs_duplicate_item
      Btrfs: Rewrite btrfs_drop_extents
      Btrfs: Fix disk_i_size update corner case
      Btrfs: Avoid orphan inodes cleanup while replaying log
      Btrfs: Avoid orphan inodes cleanup during committing transaction
      Btrfs: Make fallocate(2) more ENOSPC friendly
      Btrfs: Make truncate(2) more ENOSPC friendly
      Btrfs: Pass transaction handle to security and ACL initialization functions
      Btrfs: Add delayed iput
      Btrfs: Fix btrfs_drop_extent_cache for skip pinned case
      Btrfs: Fix per root used space accounting
      Btrfs: don't add extent 0 to the free space cache v2
      Btrfs: align offsets for btrfs_ordered_update_i_size
      Btrfs: Fix race in btrfs_mark_extent_written
      Btrfs: fix race between allocate and release extent buffer.
      Btrfs: Fix oopsen when dropping empty tree.

Yang Hongyang (1):
      Btrfs: fix a memory leak in btrfs_init_acl

dranch@trinnet.net (1):
      USB: ftdi_sio: device id for Navitator

