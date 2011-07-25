Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab1GYS4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 14:56:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35912 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab1GYS4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 14:56:52 -0400
Date: Mon, 25 Jul 2011 19:56:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs pile 1.5
Message-ID: <20110725185649.GA22133@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regression fixes (devtmpfs race, cifs ->d_revalidate() breakage, fsync
fallout), ACL stuff (me/Linus/Christoph), fixes for bugs found while
wading through the mode_t handling.  There'll be another pull request
with assorted stuff from over the last cycle.

Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:

Al Viro (11):
      ocfs2_init_acl(): fix a leak
      9p: close ACL leaks
      fix jffs2 ACLs on big-endian with 16bit mode_t
      asus-wmi: ->is_visible() can't return negative
      get rid of create_proc_entry() abuses - proc_mkdir() is there for purpose
      caam: don't pass bogus S_IFCHR to debugfs_create_...()
      fix devtmpfs race
      kill boilerplate around posix_acl_chmod_masq()
      generic_acl: no need to clone acl just to push it to set_cached_acl()
      kill boilerplates around posix_acl_create_masq()
      bury posix_acl_..._masq() variants

Christoph Hellwig (4):
      9p: do no return 0 from ->check_acl without actually checking
      xfs: cache negative ACLs if there is no attribute fork
      reiserfs: cache negative ACLs for v1 stat format
      fs: take the ACL checks to common code

Linus Torvalds (1):
      vfs: move ACL cache lookup into generic code

Markus Trippelsdorf (1):
      xfs: Fix wrong return value of xfs_file_aio_write

Pavel Shilovsky (1):
      CIFS: Fix oops while mounting with prefixpath

Tim Chen (1):
      VFS : mount lock scalability for internal mounts

Diffstat:
 Documentation/filesystems/Locking                  |    4 +-
 Documentation/filesystems/porting                  |    7 +-
 Documentation/filesystems/vfs.txt                  |    2 +-
 arch/arm/mach-bcmring/dma.c                        |    2 +-
 drivers/base/devtmpfs.c                            |    3 +-
 drivers/crypto/caam/ctrl.c                         |   26 +++---
 drivers/mtd/mtdchar.c                              |    2 +-
 drivers/platform/x86/asus-wmi.c                    |    2 +-
 drivers/staging/rtl8187se/r8180_core.c             |    2 +-
 .../staging/rtl8192e/ieee80211/ieee80211_module.c  |    2 +-
 drivers/staging/rtl8192e/r8192E_core.c             |    6 +-
 .../staging/rtl8192u/ieee80211/ieee80211_module.c  |    2 +-
 drivers/staging/rtl8192u/r8192U_core.c             |    6 +-
 fs/9p/acl.c                                        |   68 +++++---------
 fs/9p/acl.h                                        |   10 +-
 fs/9p/vfs_inode_dotl.c                             |   13 ++-
 fs/anon_inodes.c                                   |    2 +-
 fs/btrfs/acl.c                                     |   63 +++----------
 fs/btrfs/ctree.h                                   |    4 +-
 fs/btrfs/inode.c                                   |   10 +-
 fs/cifs/dir.c                                      |    2 +-
 fs/ext2/acl.c                                      |   63 +++----------
 fs/ext2/acl.h                                      |    4 +-
 fs/ext2/file.c                                     |    2 +-
 fs/ext2/namei.c                                    |    4 +-
 fs/ext3/acl.c                                      |   94 ++++++-------------
 fs/ext3/acl.h                                      |    4 +-
 fs/ext3/file.c                                     |    2 +-
 fs/ext3/namei.c                                    |    4 +-
 fs/ext4/acl.c                                      |   95 ++++++-------------
 fs/ext4/acl.h                                      |    4 +-
 fs/ext4/file.c                                     |    2 +-
 fs/ext4/namei.c                                    |    4 +-
 fs/generic_acl.c                                   |   62 +++----------
 fs/gfs2/acl.c                                      |   75 ++++------------
 fs/gfs2/acl.h                                      |    2 +-
 fs/gfs2/inode.c                                    |    6 +-
 fs/hugetlbfs/inode.c                               |    1 +
 fs/jffs2/acl.c                                     |   49 +++--------
 fs/jffs2/acl.h                                     |    6 +-
 fs/jffs2/dir.c                                     |    2 +-
 fs/jffs2/file.c                                    |    2 +-
 fs/jffs2/fs.c                                      |    2 +-
 fs/jffs2/os-linux.h                                |    2 +-
 fs/jffs2/symlink.c                                 |    2 +-
 fs/jfs/acl.c                                       |   75 +++++-----------
 fs/jfs/file.c                                      |    2 +-
 fs/jfs/jfs_acl.h                                   |    2 +-
 fs/jfs/namei.c                                     |    2 +-
 fs/namei.c                                         |   54 +++++++++++-
 fs/namespace.c                                     |   21 ++++-
 fs/nfs/nfs3acl.c                                   |   10 +--
 fs/ocfs2/acl.c                                     |   77 ++++++-----------
 fs/ocfs2/acl.h                                     |    2 +-
 fs/ocfs2/file.c                                    |    4 +-
 fs/ocfs2/namei.c                                   |    2 +-
 fs/pipe.c                                          |    2 +-
 fs/posix_acl.c                                     |   48 ++++++++--
 fs/reiserfs/file.c                                 |    2 +-
 fs/reiserfs/inode.c                                |    5 +
 fs/reiserfs/namei.c                                |    6 +-
 fs/reiserfs/xattr.c                                |   27 ------
 fs/reiserfs/xattr_acl.c                            |   71 +++++----------
 fs/xfs/linux-2.6/xfs_acl.c                         |   80 ++++-------------
 fs/xfs/linux-2.6/xfs_file.c                        |    5 +-
 fs/xfs/linux-2.6/xfs_iops.c                        |   14 ++-
 fs/xfs/linux-2.6/xfs_trace.h                       |    2 +-
 fs/xfs/xfs_acl.h                                   |    2 -
 include/linux/fs.h                                 |    3 +-
 include/linux/generic_acl.h                        |    1 -
 include/linux/posix_acl.h                          |    5 +-
 include/linux/reiserfs_acl.h                       |    6 +-
 include/linux/reiserfs_xattr.h                     |    2 -
 mm/shmem.c                                         |    6 --
 security/selinux/selinuxfs.c                       |    1 +
 sound/core/info.c                                  |    2 +-
 76 files changed, 477 insertions(+), 795 deletions(-)
