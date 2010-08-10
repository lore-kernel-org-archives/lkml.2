Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab0HJDfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 23:35:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37678 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab0HJDfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 23:35:40 -0400
Date: Tue, 10 Aug 2010 04:35:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs series, part 1
Message-ID: <20100810033536.GA31363@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Assorted work from the last cycle; among other things, there's
a filesystem API change (->evict_inode() series), a lot of truncate
rework stuff (mostly by Chris) and a bunch of fixes.

	This is _not_ all; in particular, there's pending freeze/thaw
locking rework and I would really like to see inode_lock splitup
series separated and posted.  Along with vfsmount_lock and files_lock
work.  Nick, could you do that ASAP, please?

	Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

	Shortlog:
Al Viro (69):
      Deal with missing exports for hostfs
      missing include in hppfs
      Fix reiserfs_file_release()
      fix leak in __logfs_create()
      jffs2: don't open-code iget_failed()
      get rid of file_fsync()
      simplify checks for I_CLEAR/I_FREEING
      unify fs/inode.c callers of clear_inode()
      New method - evict_inode()
      switch hugetlbfs to ->evict_inode()
      generic_detach_inode() can be static now
      Take ->i_bdev/->i_cdev handling out of clear_inode()
      new helper: end_writeback()
      switch hypfs to ->evict_inode()
      simplify get_cramfs_inode()
      switch procfs to ->evict_inode()
      switch sysfs to ->evict_inode()
      switch minix to ->evict_inode(), fix write_inode/delete_inode race
      ext2: switch to dquot_free_block_nodirty()
      Take dirtying the inode to callers of ext2_free_blocks()
      Don't dirty the victim in ext2_xattr_delete_inode()
      merge ext2 delete_inode and clear_inode, switch to ->evict_inode()
      switch mqueue to ->evict_inode()
      switch shmem.c to ->evice_inode()
      switch sysv to ->evict_inode()
      switch smbfs to evict_inode()
      covert fatfs to ->evict_inode()
      switch ufs to ->evict_inode()
      spufs conversion to ->evict_inode()
      convert ext3 to ->evict_inode()
      switch bfs to ->evict_inode(), clean up
      switch omfs to ->evict_inode()
      switch affs to ->evict_inode()
      stop icache pollution in hostfs, switch to ->evict_inode()
      hostfs: don't keep a field in each inode when we are using it only in root
      get rid of hostfs_read_inode()
      hostfs: pass pathname to init_inode()
      switch stat_file() to passing a single struct rather than fsckloads of pointers
      hostfs: get rid of file_type(), fold init_inode()
      hostfs: get rid of inode_dentry_name()
      hostfs: sanitize symlinks
      new helper: __dentry_path()
      hostfs: fix races in dentry_name() and inode_name()
      leak in hostfs_unlink()
      try to get rid of races in hostfs open()
      switch hppfs to ->evict_inode()
      switch hpfs to ->evict_inode()
      switch jfs to ->evict_inode()
      switch ubifs to ->evict_inode()
      switch udf to ->evict_inode()
      switch ncpfs to ->evict_inode()
      convert ocfs2 to ->evict_inode()
      switch gfs2 to ->evict_inode()
      convert btrfs to ->evict_inode()
      convert reiserfs to ->evict_inode()
      convert exofs to ->evict_inode()
      convert nilfs2 to ->evict_inode()
      logfs: get rid of magical inodes
      convert logfs to ->evict_inode()
      convert ext4 to ->evict_inode()
      ->delete_inode() is gone
      fs/inode.c:evict() doesn't care about delete vs. non-delete paths now
      fs/inode.c:clear_inode() is gone
      Make ->drop_inode() just return whether inode needs to be dropped
      convert remaining ->clear_inode() to ->evict_inode()
      All filesystems that need invalidate_inode_buffers() are doing that explicitly
      update VFS documentation for method changes.
      Fix sget() race with failing mount
      no need for list_for_each_entry_safe()/resetting with superblock list

Andreas Gruenbacher (2):
      mbcache: Remove unused features
      mbcache: fix shrinker function return value

Artem Bityutskiy (6):
      AFFS: clean up dirty flag usage
      AFFS: wait for sb synchronization when needed
      BFS: clean up the superblock usage
      btrfs: remove junk sb_dirt change
      sysv: do not mark superblock dirty on mount
      sysv: do not mark superblock dirty on remount

Boaz Harrosh (1):
      exofs: New truncate sequence

Christoph Hellwig (17):
      sort out blockdev_direct_IO variants
      get rid of nobh_write_begin_newtrunc
      get rid of cont_write_begin_newtrunc
      clean up write_begin usage for directories in pagecache
      introduce __block_write_begin
      get rid of block_write_begin_newtrunc
      add missing setattr methods
      rename generic_setattr
      default to simple_setattr
      remove inode_setattr
      always call inode_change_ok early in ->setattr
      check ATTR_SIZE contraints in inode_change_ok
      update documentation for the new truncate sequence
      xfs: new truncate sequence
      pass a struct path to vfs_statfs
      add f_flags to struct statfs(64)
      cifs: truncate fallout

Tejun Heo (1):
      vfs: don't hold s_umount over close_bdev_exclusive() call

Diffstat:
 Documentation/filesystems/Locking         |   22 +-
 Documentation/filesystems/porting         |   45 +++
 arch/alpha/kernel/osf_sys.c               |    8 +-
 arch/mips/include/asm/statfs.h            |   12 +-
 arch/parisc/hpux/sys_hpux.c               |   10 +-
 arch/powerpc/platforms/cell/spufs/inode.c |   12 +-
 arch/s390/hypfs/inode.c                   |    6 +-
 arch/s390/include/asm/statfs.h            |    9 +-
 arch/um/include/shared/os.h               |    3 +
 arch/um/kernel/ksyms.c                    |    3 +
 arch/um/os-Linux/file.c                   |   15 +
 arch/um/os-Linux/user_syms.c              |    4 +
 drivers/staging/pohmelfs/inode.c          |   18 +-
 fs/9p/v9fs_vfs.h                          |    2 +-
 fs/9p/vfs_inode.c                         |   19 +-
 fs/9p/vfs_super.c                         |    4 +-
 fs/adfs/inode.c                           |   16 +-
 fs/affs/affs.h                            |    3 +-
 fs/affs/file.c                            |   11 +-
 fs/affs/inode.c                           |   38 ++-
 fs/affs/super.c                           |   32 +--
 fs/afs/inode.c                            |    5 +-
 fs/afs/internal.h                         |    2 +-
 fs/afs/super.c                            |    2 +-
 fs/attr.c                                 |   88 +++---
 fs/bfs/bfs.h                              |    1 -
 fs/bfs/file.c                             |   17 +-
 fs/bfs/inode.c                            |  116 +++-----
 fs/binfmt_misc.c                          |    5 +-
 fs/block_dev.c                            |   17 +-
 fs/btrfs/ctree.h                          |    4 +-
 fs/btrfs/inode.c                          |   34 ++-
 fs/btrfs/super.c                          |    2 +-
 fs/buffer.c                               |  180 ++--------
 fs/cachefiles/bind.c                      |    2 +-
 fs/cachefiles/daemon.c                    |    6 +-
 fs/cifs/cifsfs.c                          |   15 +-
 fs/cifs/inode.c                           |   86 +++---
 fs/coda/inode.c                           |    8 +-
 fs/compat.c                               |   10 +-
 fs/cramfs/inode.c                         |   88 +++---
 fs/dcache.c                               |   39 ++-
 fs/direct-io.c                            |   74 ++---
 fs/drop_caches.c                          |    2 +-
 fs/ecryptfs/inode.c                       |   18 +-
 fs/ecryptfs/super.c                       |   14 +-
 fs/exofs/exofs.h                          |    3 +-
 fs/exofs/file.c                           |    1 -
 fs/exofs/inode.c                          |  127 +++----
 fs/exofs/super.c                          |    2 +-
 fs/ext2/balloc.c                          |   11 +-
 fs/ext2/dir.c                             |   23 +-
 fs/ext2/ext2.h                            |    5 +-
 fs/ext2/ialloc.c                          |   13 +-
 fs/ext2/inode.c                           |   87 +++---
 fs/ext2/super.c                           |   14 +-
 fs/ext2/xattr.c                           |   25 +-
 fs/ext3/ialloc.c                          |   12 -
 fs/ext3/inode.c                           |   63 +++-
 fs/ext3/super.c                           |   14 +-
 fs/ext3/xattr.c                           |   12 +-
 fs/ext4/ext4.h                            |    3 +-
 fs/ext4/ialloc.c                          |    2 +-
 fs/ext4/inode.c                           |   53 ++-
 fs/ext4/super.c                           |   10 +-
 fs/ext4/xattr.c                           |   12 +-
 fs/fat/fat.h                              |    1 -
 fs/fat/file.c                             |   49 +--
 fs/fat/inode.c                            |   26 +-
 fs/freevxfs/vxfs_extern.h                 |    2 +-
 fs/freevxfs/vxfs_inode.c                  |    8 +-
 fs/freevxfs/vxfs_super.c                  |    2 +-
 fs/fs-writeback.c                         |    8 +-
 fs/fuse/dir.c                             |   17 +-
 fs/fuse/inode.c                           |    6 +-
 fs/gfs2/aops.c                            |   10 +-
 fs/gfs2/inode.c                           |   27 +-
 fs/gfs2/ops_inode.c                       |   18 +-
 fs/gfs2/super.c                           |   43 +--
 fs/gfs2/xattr.c                           |   24 +-
 fs/hfs/hfs_fs.h                           |    2 +-
 fs/hfs/inode.c                            |   70 ++++-
 fs/hfs/super.c                            |    2 +-
 fs/hfsplus/hfsplus_fs.h                   |    1 +
 fs/hfsplus/inode.c                        |   77 ++++-
 fs/hfsplus/super.c                        |   10 +-
 fs/hostfs/hostfs.h                        |   22 +-
 fs/hostfs/hostfs_kern.c                   |  517 +++++++++++++----------------
 fs/hostfs/hostfs_user.c                   |  112 ++-----
 fs/hpfs/file.c                            |   11 +-
 fs/hpfs/hpfs_fn.h                         |    2 +-
 fs/hpfs/inode.c                           |   24 +-
 fs/hpfs/super.c                           |    2 +-
 fs/hppfs/hppfs.c                          |    8 +-
 fs/hugetlbfs/inode.c                      |   41 +--
 fs/inode.c                                |  177 ++++-------
 fs/jffs2/dir.c                            |   16 +-
 fs/jffs2/fs.c                             |   10 +-
 fs/jffs2/os-linux.h                       |    2 +-
 fs/jffs2/super.c                          |    2 +-
 fs/jffs2/xattr.c                          |    2 +-
 fs/jfs/file.c                             |   14 +-
 fs/jfs/inode.c                            |   63 +++-
 fs/jfs/jfs_inode.h                        |    2 +-
 fs/jfs/super.c                            |    8 +-
 fs/libfs.c                                |   70 +---
 fs/logfs/dir.c                            |    5 +-
 fs/logfs/file.c                           |   18 +-
 fs/logfs/inode.c                          |   51 +--
 fs/logfs/journal.c                        |    2 -
 fs/logfs/logfs.h                          |    4 +-
 fs/logfs/readwrite.c                      |   62 ++--
 fs/logfs/segment.c                        |    1 -
 fs/logfs/super.c                          |   23 +-
 fs/mbcache.c                              |  168 +++-------
 fs/minix/bitmap.c                         |    6 +-
 fs/minix/dir.c                            |   21 +-
 fs/minix/file.c                           |   22 ++
 fs/minix/inode.c                          |   35 ++-
 fs/minix/minix.h                          |    4 +-
 fs/namespace.c                            |    2 +-
 fs/ncpfs/inode.c                          |   36 +-
 fs/nfs/inode.c                            |   13 +-
 fs/nfs/internal.h                         |    4 +-
 fs/nfs/super.c                            |    4 +-
 fs/nfsd/nfs4xdr.c                         |    6 +-
 fs/nfsd/vfs.c                             |   10 +-
 fs/nilfs2/dir.c                           |   25 +-
 fs/nilfs2/gcdat.c                         |    2 +-
 fs/nilfs2/inode.c                         |   78 ++++-
 fs/nilfs2/nilfs.h                         |    2 +-
 fs/nilfs2/recovery.c                      |   11 +-
 fs/nilfs2/super.c                         |   20 +-
 fs/notify/inode_mark.c                    |    6 +-
 fs/notify/inotify/inotify.c               |    7 +-
 fs/ntfs/inode.c                           |   10 +-
 fs/ntfs/inode.h                           |    2 +-
 fs/ntfs/super.c                           |    2 +-
 fs/ocfs2/aops.c                           |    9 +-
 fs/ocfs2/dlmfs/dlmfs.c                    |   15 +-
 fs/ocfs2/file.c                           |   22 +-
 fs/ocfs2/inode.c                          |   29 +-
 fs/ocfs2/inode.h                          |    5 +-
 fs/ocfs2/super.c                          |    3 +-
 fs/omfs/file.c                            |   36 ++-
 fs/omfs/inode.c                           |    9 +-
 fs/proc/base.c                            |   16 +-
 fs/proc/generic.c                         |   18 +-
 fs/proc/inode.c                           |    6 +-
 fs/proc/proc_sysctl.c                     |   15 +-
 fs/qnx4/inode.c                           |   11 +-
 fs/quota/dquot.c                          |    2 +-
 fs/ramfs/file-nommu.c                     |    7 +-
 fs/reiserfs/file.c                        |   50 ++--
 fs/reiserfs/inode.c                       |  134 +++++---
 fs/reiserfs/super.c                       |   10 +-
 fs/smbfs/inode.c                          |   12 +-
 fs/statfs.c                               |   95 ++++--
 fs/super.c                                |   51 ++-
 fs/sync.c                                 |   25 --
 fs/sysfs/inode.c                          |    8 +-
 fs/sysfs/mount.c                          |    2 +-
 fs/sysfs/sysfs.h                          |    2 +-
 fs/sysv/dir.c                             |   21 +-
 fs/sysv/file.c                            |   22 ++
 fs/sysv/ialloc.c                          |    1 -
 fs/sysv/inode.c                           |   19 +-
 fs/sysv/itree.c                           |   19 +-
 fs/sysv/super.c                           |    1 -
 fs/sysv/sysv.h                            |    4 +-
 fs/ubifs/file.c                           |   23 +-
 fs/ubifs/super.c                          |   12 +-
 fs/ubifs/ubifs.h                          |    2 +-
 fs/udf/file.c                             |   22 ++
 fs/udf/ialloc.c                           |    2 -
 fs/udf/inode.c                            |   61 ++--
 fs/udf/super.c                            |    3 +-
 fs/udf/udfdecl.h                          |    3 +-
 fs/ufs/dir.c                              |   13 +-
 fs/ufs/ialloc.c                           |    2 -
 fs/ufs/inode.c                            |   63 +++--
 fs/ufs/super.c                            |    2 +-
 fs/ufs/truncate.c                         |   16 +-
 fs/ufs/ufs.h                              |    2 +-
 fs/ufs/util.h                             |    4 +-
 fs/xfs/linux-2.6/xfs_aops.c               |   62 +++-
 fs/xfs/linux-2.6/xfs_iops.c               |   20 +-
 fs/xfs/linux-2.6/xfs_linux.h              |    2 -
 fs/xfs/linux-2.6/xfs_super.c              |    8 +-
 fs/xfs/linux-2.6/xfs_trace.h              |    2 +-
 fs/xfs/xfs_vnodeops.c                     |   38 ++-
 include/asm-generic/statfs.h              |    9 +-
 include/linux/buffer_head.h               |   20 +-
 include/linux/dcache.h                    |    1 +
 include/linux/ext3_fs.h                   |    2 +-
 include/linux/fs.h                        |   66 +---
 include/linux/mbcache.h                   |   20 +-
 include/linux/mm.h                        |    1 +
 include/linux/reiserfs_fs.h               |    2 +-
 include/linux/reiserfs_fs_i.h             |    4 +-
 include/linux/statfs.h                    |   25 ++-
 ipc/mqueue.c                              |   16 +-
 kernel/acct.c                             |    2 +-
 mm/shmem.c                                |   23 +-
 mm/truncate.c                             |   38 ++-
 205 files changed, 2584 insertions(+), 2475 deletions(-)
