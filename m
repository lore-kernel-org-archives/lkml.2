Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab1AMFf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 00:35:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38851 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab1AMFf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 00:35:56 -0500
Date: Thu, 13 Jan 2011 05:35:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs pile 1
Message-ID: <20110113053554.GQ19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Contains: d_op series on top of Nick's pile, a few other patches
from various folks.  More tomorrow; there's a huge pending pile here.

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Note: d_set_d_op() is still there, but most of the callers are gone.
FWIW, there are only 3 non-trivial bunches:
	* procfs - as expected, we have shitloads of ->d_op there
	* autofs4 - tomorrow will be fun; automount series needs to be
dealt with to sort that out
	* ceph - I'd rather deal with that on top of ceph tree.

	Shortlog:
Al Viro (31):
      per-superblock default ->d_op
      fix isofs d_op handling
      switch fat to ->s_d_op, close exportfs races there
      switch jfs to ->s_d_op, close exportfs races
      pohmelfs: double-free and leak
      switch fuse
      switch sysv
      minixfs: kill dead code
      switch hfs
      switch hfsplus
      switch adfs
      switch nfs to ->s_d_op
      switch cifs
      switch gfs2, close races
      switch ocfs2, close races
      switch btrfs, close races
      switch cgroup
      switch hpfs
      convert smbfs
      switch coda
      take coda-private headers out of include/linux
      switch configfs
      switch affs
      switch hostfs
      pass default dentry_operations to mount_pseudo()
      switch 9p
      switch ncpfs
      move internal-only parts of ncpfs headers to fs/ncpfs
      switch afs
      sanitize ecryptfs ->mount()
      fix signedness mess in rw_verify_area() on 64bit architectures

Jeff Layton (1):
      vfs: pass struct file to do_truncate on O_TRUNC opens (try #2)

Josef Bacik (7):
      fs: add hole punching to fallocate
      XFS: handle hole punching via fallocate properly
      Ocfs2: handle hole punching via fallocate properly
      Ext4: fail if we try to use hole punch
      Btrfs: fail if we try to use hole punch
      Gfs2: fail if we try to use hole punch
      fs: add documentation on fallocate hole punching

Randy Dunlap (2):
      fs: fix kernel-doc for dcache::d_validate
      fs: fix kernel-doc for dcache::prepend_path

Diffstat:
 Documentation/filesystems/porting       |    9 ++
 Documentation/magic-number.txt          |    2 +-
 arch/ia64/kernel/perfmon.c              |    6 +-
 drivers/mtd/mtdchar.c                   |    2 +-
 drivers/staging/pohmelfs/net.c          |    2 +-
 drivers/staging/smbfs/dir.c             |   13 ---
 drivers/staging/smbfs/inode.c           |    4 +
 drivers/staging/smbfs/proto.h           |    2 +
 fs/9p/v9fs_vfs.h                        |    1 -
 fs/9p/vfs_dentry.c                      |    2 +-
 fs/9p/vfs_inode.c                       |    5 -
 fs/9p/vfs_super.c                       |    8 +-
 fs/adfs/dir.c                           |    1 -
 fs/adfs/super.c                         |    4 +-
 fs/affs/affs.h                          |    1 +
 fs/affs/namei.c                         |    3 +-
 fs/affs/super.c                         |    6 +-
 fs/afs/dir.c                            |    4 +-
 fs/afs/internal.h                       |    1 +
 fs/afs/super.c                          |    1 +
 fs/anon_inodes.c                        |   21 ++--
 fs/block_dev.c                          |    2 +-
 fs/btrfs/export.c                       |   12 +--
 fs/btrfs/inode.c                        |    6 +-
 fs/btrfs/super.c                        |    1 +
 fs/cifs/cifsfs.c                        |    6 +
 fs/cifs/dir.c                           |   25 +-----
 fs/cifs/inode.c                         |    8 --
 fs/cifs/link.c                          |    4 -
 fs/cifs/readdir.c                       |    5 -
 fs/coda/cache.c                         |    5 +-
 fs/coda/cnode.c                         |    3 +-
 {include/linux => fs/coda}/coda_cache.h |    0 
 {include/linux => fs/coda}/coda_fs_i.h  |    0 
 fs/coda/coda_linux.c                    |    3 +-
 {include/linux => fs/coda}/coda_linux.h |    4 +-
 fs/coda/dir.c                           |    9 +-
 fs/coda/file.c                          |    3 +-
 fs/coda/inode.c                         |    6 +-
 fs/coda/pioctl.c                        |    4 +-
 fs/coda/psdev.c                         |    4 +-
 fs/coda/symlink.c                       |    4 +-
 fs/coda/upcall.c                        |    5 +-
 fs/configfs/configfs_internal.h         |    1 +
 fs/configfs/dir.c                       |    6 +-
 fs/configfs/mount.c                     |    1 +
 fs/dcache.c                             |    9 +-
 fs/ecryptfs/inode.c                     |    1 -
 fs/ecryptfs/main.c                      |  155 ++++++++++++++-----------------
 fs/ext4/extents.c                       |    4 +
 fs/fat/fat.h                            |    3 +-
 fs/fat/inode.c                          |   13 +--
 fs/fat/namei_msdos.c                    |   27 ++----
 fs/fat/namei_vfat.c                     |   27 ++----
 fs/fuse/dir.c                           |    1 -
 fs/fuse/inode.c                         |   10 +-
 fs/gfs2/export.c                        |   13 +--
 fs/gfs2/ops_fstype.c                    |    2 +-
 fs/gfs2/ops_inode.c                     |    6 +-
 fs/hfs/dir.c                            |    2 -
 fs/hfs/super.c                          |    3 +-
 fs/hfsplus/dir.c                        |    1 -
 fs/hfsplus/super.c                      |    2 +-
 fs/hostfs/hostfs_kern.c                 |    2 +-
 fs/hpfs/dentry.c                        |    7 +-
 fs/hpfs/dir.c                           |    1 -
 fs/hpfs/hpfs_fn.h                       |    2 +-
 fs/hpfs/super.c                         |    2 +-
 fs/isofs/inode.c                        |   13 ++-
 fs/isofs/namei.c                        |    2 -
 fs/jfs/namei.c                          |   10 +--
 fs/jfs/super.c                          |    6 +-
 fs/libfs.c                              |    4 +-
 fs/minix/namei.c                        |    2 -
 fs/namei.c                              |    7 +-
 fs/ncpfs/dir.c                          |   19 +---
 fs/ncpfs/file.c                         |    3 +-
 fs/ncpfs/inode.c                        |    6 +-
 fs/ncpfs/ioctl.c                        |    4 +-
 fs/ncpfs/mmap.c                         |    4 +-
 fs/ncpfs/ncp_fs.h                       |   98 +++++++++++++++++++
 {include/linux => fs/ncpfs}/ncp_fs_i.h  |    0 
 {include/linux => fs/ncpfs}/ncp_fs_sb.h |   24 ++++-
 fs/ncpfs/ncplib_kernel.c                |    2 +-
 fs/ncpfs/ncplib_kernel.h                |    2 -
 fs/ncpfs/ncpsign_kernel.c               |    1 +
 fs/ncpfs/ncpsign_kernel.h               |    2 -
 fs/ncpfs/sock.c                         |    2 +-
 fs/ncpfs/symlink.c                      |    4 +-
 fs/nfs/dir.c                            |    4 -
 fs/nfs/getroot.c                        |    6 -
 fs/nfs/super.c                          |    1 +
 fs/ocfs2/export.c                       |    6 +-
 fs/ocfs2/file.c                         |    8 +-
 fs/ocfs2/namei.c                        |    5 -
 fs/ocfs2/super.c                        |    1 +
 fs/open.c                               |    7 +-
 fs/pipe.c                               |    4 +-
 fs/read_write.c                         |   27 ++---
 fs/sysv/namei.c                         |    1 -
 fs/sysv/super.c                         |    8 +-
 fs/xfs/linux-2.6/xfs_iops.c             |    7 +-
 include/linux/falloc.h                  |    1 +
 include/linux/fs.h                      |    5 +-
 include/linux/ncp_fs.h                  |  100 --------------------
 include/linux/ncp_mount.h               |   22 -----
 kernel/cgroup.c                         |   30 ++-----
 net/socket.c                            |   30 +++---
 108 files changed, 424 insertions(+), 582 deletions(-)
