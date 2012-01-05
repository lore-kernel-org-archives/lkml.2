Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab2AECX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 21:23:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47679 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757779Ab2AECXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 21:23:20 -0500
Date: Thu, 5 Jan 2012 02:23:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs pile 1
Message-ID: <20120105022318.GG23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's pile 1 out of at least 4; this one is mostly vfsmount gutting.  The
next one will be umode_t stuff...  Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (73):
      pull manipulations of rpc_cred inside alloc_nfs_open_context()
      trim fs/internal.h
      switch a bunch of places to mnt_want_write_file()
      new helpers: fh_{want,drop}_write()
      vfs: kill pointless helpers in namespace.c
      vfs: new internal helper: mnt_has_parent(mnt)
      vfs: more mnt_parent cleanups
      vfs: add missing parens in pnode.h macros
      unexport put_mnt_ns(), make create_mnt_ns() static outright
      vfs: dentry_reset_mounted() doesn't use vfsmount argument
      tomoyo: stop including hell knows what
      btrfs, nfs, apparmor: don't pull mnt_namespace.h for no reason...
      vfs: kill ->mnt_devname use in afs printks
      make nfs_follow_remote_path() handle ERR_PTR() passed as root_mnt
      vfs: convert fs_supers to hlist
      vfs: make do_kern_mount() static
      constify seq_file stuff
      vfs: mnt_drop_write_file()
      vfs: fix the stupidity with i_dentry in inode destructors
      vfs: pipe.c is really non-modular
      get rid of timer in kern/acct.c
      vfs: for usbfs, etc. internal vfsmounts ->mnt_sb->s_root == ->mnt_root
      vfs: live vfsmounts never have NULL ->mnt_sb
      vfs: new helper - vfs_ustat()
      vfs: fix the rest of sget() races
      vfs: start hiding vfsmount guts series
      vfs: spread struct mount - __lookup_mnt() result
      vfs: spread struct mount - __propagate_umount() argument
      vfs: spread struct mount - namespace.c internal iterators
      vfs: spread struct mount - attach_mnt/detach_mnt
      vfs: spread struct mount - commit_tree
      vfs: spread struct mount - mount group id handling
      vfs: spread struct mount - attach_recursive_mnt
      vfs: spread struct mount - tree_contains_unbindable
      vfs: spread struct mount - alloc_vfsmnt/free_vfsmnt/mnt_alloc_id/mnt_free_id
      vfs: spread struct mount - change_mnt_propagation/set_mnt_shared
      vfs: spread struct mount - clone_mnt/copy_tree result
      vfs: spread struct mount to remaining users of ->mnt_hash
      vfs: the first spoils - mnt_hash moved
      vfs: spread struct mount - umount_tree argument
      vfs: spread struct mount - shrink_submounts/select_submounts
      vfs: spread struct mount - clone_mnt/copy_tree argument
      vfs: spread struct mount mnt_set_mountpoint child argument
      vfs: spread struct mount - do_umount/propagate_mount_busy
      vfs: spread struct mount - mnt_has_parent
      vfs: spread struct mount - is_path_reachable
      vfs: mnt_parent moved to struct mount
      vfs: now it can be done - make mnt_parent point to struct mount
      vfs: move mnt_mountpoint to struct mount
      vfs: spread struct mount - work with counters
      vfs: all counters taken to struct mount
      vfs: take mnt_child/mnt_mounts to struct mount
      vfs: spread struct mount - get_dominating_id / do_make_slave
      vfs: spread struct mount - shared subtree iterators
      vfs: spread struct mount - propagate_mnt()
      vfs: spread struct mount - remaining argument of mnt_set_mountpoint()
      vfs: take mnt_master to struct mount
      vfs: and now we can make ->mnt_master point to struct mount
      vfs: take mnt_share/mnt_slave/mnt_slave_list and mnt_expire to struct mount
      vfs: spread struct mount - do_add_mount and graft_tree
      vfs: spread struct mount - mntput_no_expire
      vfs: mnt_ns moved to struct mount
      vfs: mnt_id/mnt_group_id moved
      vfs: move the rest of int fields to struct mount
      vfs: switch pnode.h macros to struct mount *
      vfs: move mnt_list to struct mount
      vfs: move mnt_devname
      vfs: move fsnotify junk to struct mount
      vfs: spread struct mount - remaining argument of next_mnt()
      vfs: opencode mntget() mnt_set_mountpoint()
      vfs: take /proc/*/mounts and friends to fs/proc_namespace.c
      switch mnt_namespace ->root to struct mount
      vfs: trim includes a bit

Diffstat:
 arch/ia64/kernel/perfmon.c                |    2 +-
 arch/parisc/hpux/sys_hpux.c               |    9 +-
 arch/powerpc/platforms/cell/spufs/inode.c |    1 -
 drivers/staging/pohmelfs/inode.c          |    1 -
 drivers/usb/core/inode.c                  |   11 +-
 fs/9p/vfs_inode.c                         |    1 -
 fs/Makefile                               |    2 +
 fs/affs/super.c                           |    1 -
 fs/afs/mntpt.c                            |    4 +-
 fs/afs/super.c                            |    1 -
 fs/befs/linuxvfs.c                        |    1 -
 fs/bfs/inode.c                            |    1 -
 fs/block_dev.c                            |    8 +-
 fs/btrfs/inode.c                          |    1 -
 fs/btrfs/ioctl.c                          |   22 +-
 fs/btrfs/super.c                          |    1 -
 fs/ceph/inode.c                           |    1 -
 fs/coda/inode.c                           |    1 -
 fs/compat.c                               |    9 +-
 fs/configfs/dir.c                         |    4 +-
 fs/dcache.c                               |   37 +--
 fs/debugfs/inode.c                        |    2 +-
 fs/ecryptfs/super.c                       |    1 -
 fs/efs/super.c                            |    1 -
 fs/exec.c                                 |    2 +-
 fs/exofs/super.c                          |    1 -
 fs/ext2/ioctl.c                           |   12 +-
 fs/ext2/super.c                           |    1 -
 fs/ext3/ioctl.c                           |   20 +-
 fs/ext3/super.c                           |    1 -
 fs/ext4/ioctl.c                           |   28 +-
 fs/ext4/super.c                           |    1 -
 fs/fat/file.c                             |    4 +-
 fs/fat/inode.c                            |    1 -
 fs/fhandle.c                              |    4 +-
 fs/filesystems.c                          |    1 -
 fs/freevxfs/vxfs_inode.c                  |    1 -
 fs/fuse/inode.c                           |    1 -
 fs/gfs2/file.c                            |    4 +-
 fs/gfs2/super.c                           |    1 -
 fs/hfs/super.c                            |    1 -
 fs/hfsplus/ioctl.c                        |    4 +-
 fs/hfsplus/super.c                        |    1 -
 fs/hostfs/hostfs_kern.c                   |    1 -
 fs/hpfs/super.c                           |    1 -
 fs/hppfs/hppfs.c                          |    3 +-
 fs/hugetlbfs/inode.c                      |    1 -
 fs/inode.c                                |    5 +-
 fs/internal.h                             |   27 +-
 fs/isofs/inode.c                          |    1 -
 fs/jffs2/super.c                          |    1 -
 fs/jfs/ioctl.c                            |    4 +-
 fs/jfs/super.c                            |    1 -
 fs/logfs/inode.c                          |    1 -
 fs/minix/inode.c                          |    1 -
 fs/mount.h                                |   75 +++
 fs/namei.c                                |   37 +-
 fs/namespace.c                            |  773 +++++++++++------------------
 fs/ncpfs/inode.c                          |    1 -
 fs/ncpfs/ioctl.c                          |    2 +-
 fs/nfs/dir.c                              |   13 +-
 fs/nfs/inode.c                            |   41 +-
 fs/nfs/super.c                            |   19 +-
 fs/nfsd/nfs4proc.c                        |    4 +-
 fs/nfsd/nfs4recover.c                     |   12 +-
 fs/nfsd/vfs.c                             |   34 +-
 fs/nfsd/vfs.h                             |   10 +
 fs/nilfs2/ioctl.c                         |   22 +-
 fs/nilfs2/super.c                         |    2 -
 fs/notify/fanotify/fanotify_user.c        |    6 +-
 fs/notify/fsnotify.c                      |    9 +-
 fs/notify/vfsmount_mark.c                 |   19 +-
 fs/ntfs/inode.c                           |    1 -
 fs/ocfs2/dlmfs/dlmfs.c                    |    1 -
 fs/ocfs2/ioctl.c                          |    4 +-
 fs/ocfs2/move_extents.c                   |    4 +-
 fs/ocfs2/super.c                          |    1 -
 fs/open.c                                 |    2 +-
 fs/openpromfs/inode.c                     |    1 -
 fs/pipe.c                                 |    7 -
 fs/pnode.c                                |  120 ++---
 fs/pnode.h                                |   36 +-
 fs/proc/base.c                            |  114 -----
 fs/proc/inode.c                           |    1 -
 fs/proc/namespaces.c                      |    1 -
 fs/proc_namespace.c                       |  331 ++++++++++++
 fs/qnx4/inode.c                           |    1 -
 fs/reiserfs/ioctl.c                       |    8 +-
 fs/reiserfs/super.c                       |    1 -
 fs/romfs/super.c                          |    1 -
 fs/seq_file.c                             |   10 +-
 fs/squashfs/super.c                       |    1 -
 fs/statfs.c                               |   21 +-
 fs/super.c                                |   50 ++-
 fs/sysv/inode.c                           |    1 -
 fs/ubifs/ioctl.c                          |    4 +-
 fs/ubifs/super.c                          |    1 -
 fs/udf/super.c                            |    1 -
 fs/ufs/super.c                            |    1 -
 fs/xattr.c                                |    4 +-
 fs/xfs/xfs_iget.c                         |    1 -
 fs/xfs/xfs_ioctl.c                        |    8 +-
 fs/xfs/xfs_ioctl32.c                      |    8 +-
 include/linux/fs.h                        |    7 +-
 include/linux/mnt_namespace.h             |   31 +-
 include/linux/mount.h                     |   39 +--
 include/linux/nfs_fs.h                    |    2 +-
 include/linux/seq_file.h                  |   10 +-
 ipc/mqueue.c                              |    1 -
 kernel/acct.c                             |   40 +--
 mm/shmem.c                                |    1 -
 net/sunrpc/rpc_pipe.c                     |    1 -
 security/apparmor/path.c                  |    1 -
 security/inode.c                          |    2 +-
 security/tomoyo/realpath.c                |    9 +-
 115 files changed, 1067 insertions(+), 1161 deletions(-)
 create mode 100644 fs/mount.h
 create mode 100644 fs/proc_namespace.c
