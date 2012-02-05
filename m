Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab2BEWZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:25:59 -0500
Received: from 1wt.eu ([62.212.114.60]:61760 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab2BEWZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:25:58 -0500
Message-Id: <20120205220949.424749720@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:09:49 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 00/91] 2.6.27.60-longterm review
Message-ID: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.27.60 release.
All patches will be posted as a response to this one.  If anyone has any
issues with these being applied, please let me know.  If anyone is a
maintainer of the proper subsystem, and wants to add a Signed-off-by:
line to the patch, please respond with it.

These patches have been picked out of 647 patches that were merged between
2.6.32.39 and 2.6.32.56. A number of driver-specific patches which cannot be
tested without proper hardware have *not* been merged to keep the list low.
If you're having an issue with a specific driver with the 2.6.27 series and
you know the 2.6.32 series is OK, please report it to me, a fix might exist.

Responses should be made within 72 hours. Anything received after that
time might be too late.

Please note that the whole -rc patch is not provided anymore, only individual
patches are provided so that their authors and subsystem maintainers can spot
issues. The new release process does not make it as easy as before to upload
pre-release patches, and experience shows that release candidates are almost
never built for old kernels, users only build the final patch, so that's not
worth the pain. If this is a problem for you, please manifest yourself so that
we find a solution.

The diffstat is appened below.

 Documentation/kbuild/makefiles.txt         |   12 ++++++
 MAINTAINERS                                |    2 +-
 Makefile                                   |    5 ++-
 arch/alpha/kernel/osf_sys.c                |   11 +++--
 arch/arm/kernel/sys_oabi-compat.c          |    2 +-
 arch/parisc/mm/init.c                      |    4 +-
 arch/powerpc/kernel/crash.c                |    6 +--
 arch/powerpc/kernel/prom_init.c            |    6 +-
 arch/powerpc/oprofile/op_model_power4.c    |   24 +++++++++++-
 arch/powerpc/platforms/pseries/hvconsole.c |    2 +-
 arch/powerpc/platforms/pseries/lpar.c      |    2 +-
 arch/s390/kvm/kvm-s390.c                   |   14 +++++--
 arch/um/drivers/ubd_kern.c                 |   31 +++++++++++++++-
 arch/x86/kernel/amd_iommu_init.c           |    8 ++--
 arch/x86/kernel/reboot.c                   |    8 ++++
 arch/x86/lib/copy_user_64.S                |    4 +-
 arch/x86/mm/gup.c                          |   56 ++++++++++++++++++++++++++++
 arch/x86/mm/mmap.c                         |    4 +-
 arch/x86/oprofile/backtrace.c              |   46 +++++++++++++++++++++--
 arch/x86/oprofile/init.c                   |    7 ++-
 arch/x86/xen/smp.c                         |   10 +++++
 block/cfq-iosched.c                        |    8 +++-
 block/elevator.c                           |    3 +-
 block/scsi_ioctl.c                         |   40 ++++++++++++++++++++
 drivers/ata/libata-scsi.c                  |   24 +++++++++---
 drivers/ata/sata_via.c                     |   15 +++++++
 drivers/block/ub.c                         |    4 ++
 drivers/block/virtio_blk.c                 |    6 +++
 drivers/char/agp/generic.c                 |   19 +++++++--
 drivers/char/i8k.c                         |   11 +++--
 drivers/char/tpm/tpm.c                     |    9 ++++-
 drivers/ide/ide-floppy.c                   |    9 +++-
 drivers/md/dm-linear.c                     |   10 ++++-
 drivers/md/dm-mpath.c                      |    6 +++
 drivers/md/md.c                            |    2 +-
 drivers/media/video/uvc/uvc_queue.c        |    2 +
 drivers/mmc/host/sdhci-pci.c               |    1 +
 drivers/mmc/host/sdhci.c                   |    9 ++++-
 drivers/mtd/ubi/cdev.c                     |    3 +
 drivers/net/bonding/bond_3ad.c             |    7 +++
 drivers/net/bonding/bond_alb.c             |    7 +++
 drivers/net/bonding/bond_main.c            |    4 ++
 drivers/net/rionet.c                       |    4 +-
 drivers/net/wireless/libertas/cmd.c        |    6 ++-
 drivers/scsi/aacraid/commsup.c             |    2 +
 drivers/scsi/device_handler/scsi_dh.c      |    7 +++-
 drivers/scsi/hosts.c                       |    9 +++-
 drivers/scsi/libsas/sas_expander.c         |   13 ++++--
 drivers/scsi/scsi_lib.c                    |   15 ++++++-
 drivers/scsi/scsi_sysfs.c                  |   16 ++++----
 drivers/scsi/sd.c                          |   11 ++++-
 drivers/scsi/sym53c8xx_2/sym_glue.c        |    4 ++
 drivers/usb/musb/musb_core.c               |    1 +
 drivers/usb/serial/ftdi_sio.c              |   14 +++++-
 drivers/usb/storage/usb.c                  |    1 +
 drivers/video/carminefb.c                  |    6 +-
 drivers/video/offb.c                       |   52 ++++++++++++--------------
 fs/cifs/cifssmb.c                          |    3 +-
 fs/ext3/namei.c                            |   13 +++++-
 fs/ext3/xattr.c                            |   12 +++++-
 fs/ext4/extents.c                          |    1 +
 fs/ext4/inode.c                            |    2 +-
 fs/hfs/btree.c                             |   15 +++++++
 fs/hfs/trans.c                             |    2 +
 fs/jbd/journal.c                           |    8 ++++
 fs/jbd2/journal.c                          |    8 ++++
 fs/lockd/clntproc.c                        |    8 +++-
 fs/nfsd/export.c                           |    2 +-
 fs/nfsd/vfs.c                              |    9 ++++-
 fs/partitions/efi.c                        |    6 +++
 fs/partitions/ldm.c                        |   21 ++++++++--
 fs/partitions/osf.c                        |   12 +++++-
 fs/ubifs/recovery.c                        |   26 +++++++++++++
 include/asm-x86/uaccess.h                  |    2 +-
 include/linux/blkdev.h                     |    1 +
 include/linux/if_packet.h                  |    2 +
 include/linux/mm.h                         |    6 +++
 include/linux/seqlock.h                    |    4 +-
 include/linux/sunrpc/sched.h               |    4 +-
 init/Kconfig                               |    1 +
 kernel/taskstats.c                         |    1 +
 kernel/time/timekeeping.c                  |   11 ++++-
 mm/util.c                                  |   13 ++++++
 net/bluetooth/l2cap.c                      |    2 +-
 net/ipv4/af_inet.c                         |    3 +
 net/packet/af_packet.c                     |    2 +
 net/sched/sch_api.c                        |   14 +++---
 net/sunrpc/clnt.c                          |    3 +
 net/sunrpc/rpcb_clnt.c                     |    2 +-
 net/sunrpc/sched.c                         |    1 +
 net/sunrpc/svc.c                           |    3 +
 net/sunrpc/svc_xprt.c                      |   11 +++--
 net/sunrpc/xprtsock.c                      |   28 +++++++++++---
 net/unix/af_unix.c                         |   16 +++++++-
 scripts/Kbuild.include                     |    5 ++
 sound/core/timer.c                         |    2 +
 sound/pci/ice1712/amp.c                    |    7 ++-
 97 files changed, 751 insertions(+), 165 deletions(-)


