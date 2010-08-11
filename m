Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374Ab0HLApb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:45:31 -0400
Received: from kroah.org ([198.145.64.141]:40031 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758689Ab0HKX53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:57:29 -0400
Date: Wed, 11 Aug 2010 16:56:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/111] 2.6.32.19 -stable review
Message-ID: <20100811235623.GA24440@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.32.19 release.
There are 111 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, August 13, 2010, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.19-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                    |    2 +-
 arch/arm/Kconfig                            |   12 +
 arch/arm/include/asm/tlbflush.h             |    8 +
 arch/arm/plat-mxc/include/mach/gpio.h       |    1 +
 arch/ia64/hp/common/sba_iommu.c             |   38 ++-
 arch/ia64/kernel/time.c                     |    4 +-
 arch/powerpc/Makefile                       |   16 +-
 arch/powerpc/include/asm/ppc-pci.h          |    5 +
 arch/powerpc/kernel/time.c                  |    5 +-
 arch/powerpc/platforms/pseries/eeh.c        |    4 +-
 arch/powerpc/platforms/pseries/eeh_driver.c |    4 +-
 arch/powerpc/platforms/pseries/eeh_event.c  |    2 +-
 arch/s390/include/asm/cputime.h             |    8 +
 arch/s390/kernel/s390_ext.c                 |    2 +
 arch/s390/kernel/time.c                     |    3 +-
 arch/s390/kernel/vtime.c                    |    2 +
 arch/x86/include/asm/cmpxchg_32.h           |   86 ++--
 arch/x86/include/asm/cmpxchg_64.h           |   88 ++--
 arch/x86/kernel/apic/io_apic.c              |   28 +-
 arch/x86/kernel/cpu/vmware.c                |   10 +-
 arch/x86/kernel/vsyscall_64.c               |    5 +-
 arch/x86/mm/init_64.c                       |   19 +
 crypto/testmgr.c                            |   84 +++
 drivers/acpi/processor_perflib.c            |    6 +-
 drivers/ata/ata_piix.c                      |    8 +
 drivers/atm/solos-pci.c                     |    7 +-
 drivers/block/loop.c                        |    2 +
 drivers/bluetooth/btusb.c                   |    3 +
 drivers/char/nvram.c                        |   14 +-
 drivers/gpu/drm/drm_edid.c                  |    4 +-
 drivers/gpu/drm/i915/dvo_tfp410.c           |    2 +-
 drivers/ide/ide-cd.c                        |   14 +-
 drivers/md/bitmap.c                         |    4 +-
 drivers/md/bitmap.h                         |    3 +
 drivers/md/raid1.c                          |   25 +-
 drivers/md/raid10.c                         |   18 +
 drivers/net/smsc911x.c                      |   92 ++--
 drivers/net/xen-netfront.c                  |    1 +
 drivers/pci/quirks.c                        |    4 +
 drivers/s390/cio/cio.c                      |    1 +
 drivers/scsi/aic7xxx/aic79xx_core.c         |   53 ++-
 drivers/scsi/ibmvscsi/ibmvfc.c              |    8 +-
 drivers/scsi/ibmvscsi/ibmvfc.h              |    1 +
 drivers/staging/line6/Kconfig               |    1 +
 drivers/staging/panel/panel.c               |    2 +
 drivers/usb/core/hub.c                      |    6 +-
 drivers/usb/core/quirks.c                   |    3 +
 drivers/usb/core/urb.c                      |   50 +--
 drivers/usb/misc/usbtest.c                  |    6 +-
 drivers/usb/mon/mon_bin.c                   |    2 +-
 drivers/usb/serial/cp210x.c                 |    4 +
 drivers/usb/serial/ftdi_sio.c               |    4 +
 drivers/usb/serial/ftdi_sio_ids.h           |   10 +
 drivers/usb/serial/option.c                 |   13 +
 drivers/video/w100fb.c                      |    4 +-
 drivers/xen/events.c                        |    1 +
 fs/block_dev.c                              |   10 +-
 fs/btrfs/acl.c                              |   36 +-
 fs/btrfs/btrfs_inode.h                      |    5 +-
 fs/btrfs/ctree.c                            |  229 ++++++---
 fs/btrfs/ctree.h                            |   40 +-
 fs/btrfs/dir-item.c                         |   19 +-
 fs/btrfs/disk-io.c                          |   40 ++-
 fs/btrfs/extent-tree.c                      |  112 +++--
 fs/btrfs/extent_io.c                        |    3 +-
 fs/btrfs/file.c                             |  729 ++++++++++++---------------
 fs/btrfs/inode.c                            |  624 ++++++++++++++----------
 fs/btrfs/ioctl.c                            |   34 +-
 fs/btrfs/ordered-data.c                     |  117 ++++-
 fs/btrfs/ordered-data.h                     |    5 +-
 fs/btrfs/relocation.c                       |   43 +-
 fs/btrfs/super.c                            |   20 +-
 fs/btrfs/transaction.c                      |   44 +-
 fs/btrfs/transaction.h                      |    6 +-
 fs/btrfs/tree-log.c                         |   86 ++--
 fs/btrfs/volumes.c                          |   19 +-
 fs/btrfs/xattr.c                            |   80 ++-
 fs/btrfs/xattr.h                            |    9 +-
 fs/dlm/ast.c                                |   74 +++-
 fs/dlm/ast.h                                |    4 +-
 fs/dlm/config.c                             |   24 +-
 fs/dlm/debug_fs.c                           |    2 +-
 fs/dlm/dir.c                                |    7 +-
 fs/dlm/dlm_internal.h                       |   11 +-
 fs/dlm/lock.c                               |  120 ++++--
 fs/dlm/lockspace.c                          |   15 +-
 fs/dlm/lowcomms.c                           |    6 +-
 fs/dlm/member.c                             |    8 +-
 fs/dlm/memory.c                             |    6 +-
 fs/dlm/netlink.c                            |    2 +-
 fs/dlm/plock.c                              |    6 +-
 fs/dlm/rcom.c                               |    2 +-
 fs/dlm/requestqueue.c                       |    2 +-
 fs/dlm/user.c                               |   22 +-
 fs/dlm/user.h                               |    4 +-
 fs/ecryptfs/file.c                          |   60 ++-
 fs/ecryptfs/inode.c                         |    5 +-
 fs/ext4/move_extent.c                       |    3 +
 fs/ext4/super.c                             |   27 +-
 fs/jfs/xattr.c                              |   87 ++--
 fs/ocfs2/alloc.c                            |   10 +-
 fs/ocfs2/alloc.h                            |    5 +
 fs/ocfs2/locks.c                            |    2 +-
 fs/ocfs2/refcounttree.c                     |  117 ++++-
 fs/ocfs2/super.c                            |    4 +
 fs/proc/array.c                             |    5 +-
 fs/reiserfs/journal.c                       |   15 +-
 fs/reiserfs/xattr_security.c                |    2 +-
 fs/signalfd.c                               |    2 +
 fs/splice.c                                 |   12 +-
 include/linux/clocksource.h                 |    6 +-
 include/linux/fs.h                          |    6 +-
 include/linux/interrupt.h                   |    7 +-
 include/linux/netdevice.h                   |    2 +
 include/linux/notifier.h                    |    1 +
 include/linux/reiserfs_xattr.h              |    5 +
 include/linux/sched.h                       |    4 +
 include/linux/tick.h                        |    3 +
 include/linux/usb/quirks.h                  |    4 +
 kernel/exit.c                               |   20 +-
 kernel/fork.c                               |    3 +
 kernel/irq/manage.c                         |    2 +-
 kernel/sched.c                              |   71 +++-
 kernel/sys.c                                |   18 +-
 kernel/time/tick-sched.c                    |   75 ++--
 kernel/time/timekeeping.c                   |    6 +-
 mm/memory-failure.c                         |   21 +-
 mm/swapfile.c                               |    6 +-
 net/ipv4/devinet.c                          |    1 +
 net/sched/sch_generic.c                     |   18 +
 130 files changed, 2521 insertions(+), 1551 deletions(-)
