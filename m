Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473Ab0J2NZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 09:25:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38373 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878Ab0J2NZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 09:25:48 -0400
Date: Fri, 29 Oct 2010 14:25:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs, pile 2
Message-ID: <20101029132545.GT19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Misc fixes + easy parts of ->mount() conversion (everything
sans ->mnt_devname work in NFS).  That's not all; I still hope to get
icache stuff done, for one thing.  Please, pull from
git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ #for-linus

Shortlog:
Al Viro (29):
      a couple of open-coded ihold() introduced by nfs merge
      fix open/umount race
      beginning of transtion: ->mount()
      new helper: mount_bdev()
      convert get_sb_mtd() users to ->mount()
      convert get_sb_single() users
      convert get_sb_nodev() users
      convert get_sb_pseudo() users
      convert ubifs
      convert v9fs
      logfs get_sb massage, part 1
      logfs get_sb, part 2
      logfs get_sb, part 3
      logfs: fix a leak in get_sb
      switch logfs to ->mount()
      convert nilfs
      convert cifs
      setting ->proc_mnt doesn't belong in proc_get_sb()
      switch procfs to ->mount()
      switch get_sb_ns() users
      convert cgroup and cpuset
      convert sysfs
      convert ecryptfs
      convert afs
      convert gfs2
      convert ceph
      convert btrfs
      convert simple cases of nfs-related ->get_sb() to ->mount()
      braino in internal.h

Diffstat:
 arch/ia64/kernel/perfmon.c                |    9 +--
 arch/powerpc/platforms/cell/spufs/inode.c |   10 ++--
 arch/s390/hypfs/inode.c                   |    8 +-
 drivers/base/devtmpfs.c                   |   18 +++---
 drivers/infiniband/hw/ipath/ipath_fs.c    |   14 ++--
 drivers/infiniband/hw/qib/qib_fs.c        |   14 ++--
 drivers/isdn/capi/capifs.c                |    8 +-
 drivers/misc/ibmasm/ibmasmfs.c            |    9 +--
 drivers/mtd/mtdchar.c                     |   10 +--
 drivers/mtd/mtdsuper.c                    |   54 ++++++--------
 drivers/oprofile/oprofilefs.c             |    8 +-
 drivers/staging/autofs/init.c             |    8 +-
 drivers/staging/pohmelfs/inode.c          |    9 +--
 drivers/staging/smbfs/inode.c             |    8 +-
 drivers/usb/core/inode.c                  |    8 +-
 drivers/usb/gadget/f_fs.c                 |   14 ++--
 drivers/usb/gadget/inode.c                |   10 ++--
 drivers/xen/xenfs/super.c                 |    8 +-
 fs/9p/vfs_super.c                         |   22 +++---
 fs/adfs/super.c                           |    9 +--
 fs/affs/super.c                           |    9 +--
 fs/afs/super.c                            |   19 ++---
 fs/anon_inodes.c                          |   10 +--
 fs/autofs4/init.c                         |    8 +-
 fs/befs/linuxvfs.c                        |   11 ++--
 fs/bfs/inode.c                            |    8 +-
 fs/binfmt_misc.c                          |    8 +-
 fs/block_dev.c                            |    8 +-
 fs/btrfs/super.c                          |   15 ++---
 fs/ceph/super.c                           |   50 +++++++------
 fs/cifs/cifsfs.c                          |   15 ++--
 fs/coda/inode.c                           |    8 +-
 fs/configfs/mount.c                       |    8 +-
 fs/cramfs/inode.c                         |    9 +--
 fs/debugfs/inode.c                        |    8 +-
 fs/devpts/inode.c                         |   32 ++++-----
 fs/ecryptfs/main.c                        |   12 ++--
 fs/efs/super.c                            |    8 +-
 fs/exofs/super.c                          |   10 ++--
 fs/ext2/super.c                           |    8 +-
 fs/ext3/super.c                           |    8 +-
 fs/ext4/super.c                           |   16 ++--
 fs/fat/namei_msdos.c                      |    9 +--
 fs/fat/namei_vfat.c                       |    9 +--
 fs/freevxfs/vxfs_super.c                  |    9 +--
 fs/fuse/control.c                         |   10 +--
 fs/fuse/inode.c                           |   17 ++---
 fs/gfs2/ops_fstype.c                      |   51 ++++++--------
 fs/hfs/super.c                            |    9 +--
 fs/hfsplus/super.c                        |   10 +--
 fs/hostfs/hostfs_kern.c                   |    8 +-
 fs/hpfs/super.c                           |    9 +--
 fs/hppfs/hppfs.c                          |    8 +-
 fs/hugetlbfs/inode.c                      |    8 +-
 fs/internal.h                             |    2 +-
 fs/isofs/inode.c                          |    9 +--
 fs/jffs2/super.c                          |    9 +--
 fs/jfs/super.c                            |    9 +--
 fs/libfs.c                                |   14 ++--
 fs/logfs/dev_bdev.c                       |   15 +++--
 fs/logfs/dev_mtd.c                        |   18 +++---
 fs/logfs/logfs.h                          |   22 +++---
 fs/logfs/super.c                          |   77 ++++++++++----------
 fs/minix/inode.c                          |    9 +--
 fs/namei.c                                |    2 +
 fs/ncpfs/inode.c                          |    8 +-
 fs/nfs/super.c                            |   96 ++++++++++++-------------
 fs/nfs/unlink.c                           |    4 +-
 fs/nfsd/nfsctl.c                          |    8 +-
 fs/nilfs2/super.c                         |   16 ++---
 fs/ntfs/super.c                           |    9 +--
 fs/ocfs2/dlmfs/dlmfs.c                    |    8 +-
 fs/ocfs2/super.c                          |   11 +--
 fs/omfs/inode.c                           |    9 +--
 fs/open.c                                 |    6 +-
 fs/openpromfs/inode.c                     |    8 +-
 fs/pipe.c                                 |    9 +--
 fs/proc/root.c                            |   16 ++--
 fs/qnx4/inode.c                           |    9 +--
 fs/ramfs/inode.c                          |   17 ++---
 fs/reiserfs/super.c                       |    9 +--
 fs/romfs/super.c                          |   17 ++---
 fs/squashfs/super.c                       |   10 +--
 fs/super.c                                |  111 +++++++++++++++++++++--------
 fs/sysfs/mount.c                          |   32 ++++-----
 fs/sysv/super.c                           |   17 ++---
 fs/ubifs/super.c                          |   13 ++--
 fs/udf/super.c                            |    9 +--
 fs/ufs/super.c                            |    8 +-
 fs/xfs/linux-2.6/xfs_super.c              |   12 ++--
 include/linux/fs.h                        |   21 ++++--
 include/linux/mtd/super.h                 |    5 +-
 include/linux/ramfs.h                     |    4 +-
 ipc/mqueue.c                              |    8 +-
 kernel/cgroup.c                           |   11 ++--
 kernel/cpuset.c                           |   13 ++--
 mm/shmem.c                                |   10 ++--
 net/socket.c                              |   10 +--
 net/sunrpc/rpc_pipe.c                     |   18 +++---
 security/inode.c                          |    8 +-
 security/selinux/selinuxfs.c              |    9 +--
 security/smack/smackfs.c                  |   12 ++--
 102 files changed, 731 insertions(+), 759 deletions(-)
