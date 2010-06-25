Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab0FYTF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:05:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab0FYTFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:05:55 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 00/38] Union mounts - multiple layers and submounts
Date: Fri, 25 Jun 2010 12:04:50 -0700
Message-Id: <1277492728-11446-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version of union mounts adds support for more than one read-only
layer and submounts in the read-only layers.  It replaces the clumsy
array of vfsmounts in the topmost superblock with a pointer to the
root of a cloned vfsmount tree of all the read-only mounts to be
unioned.

This branch is named "submounts" and is in the usual git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/val/linux-2.6.git

FYI, I'll be on vacation for the next two weeks and not reading email.

-VAL

Felix Fietkau (2):
  whiteout: jffs2 whiteout support
  fallthru: jffs2 fallthru support

Jan Blunck (11):
  VFS: Make lookup_hash() return a struct path
  autofs4: Save autofs trigger's vfsmount in super block info
  whiteout/NFSD: Don't return information about whiteouts to userspace
  whiteout: Add vfs_whiteout() and whiteout inode operation
  whiteout: Set S_OPAQUE inode flag when creating directories
  whiteout: Allow removal of a directory with whiteouts
  whiteout: tmpfs whiteout support
  whiteout: Split of ext2_append_link() from ext2_add_link()
  whiteout: ext2 whiteout support
  union-mount: Introduce MNT_UNION and MS_UNION flags
  union-mount: Call do_whiteout() on unlink and rmdir in unions

Valerie Aurora (25):
  VFS: Comment follow_mount() and friends
  VFS: Add read-only users count to superblock
  fallthru: Basic fallthru definitions
  fallthru: ext2 fallthru support
  fallthru: tmpfs fallthru support
  union-mount: Union mounts documentation
  union-mount: Introduce union_dir structure and basic operations
  union-mount: Free union dirs on removal from dcache
  union-mount: Support for mounting union mount file systems
  union-mount: Implement union lookup
  union-mount: Copy up directory entries on first readdir()
  VFS: Split inode_permission() and create path_permission()
  VFS: Create user_path_nd() to lookup both parent and target
  union-mount: In-kernel file copyup routines
  union-mount: Implement union-aware access()/faccessat()
  union-mount: Implement union-aware link()
  union-mount: Implement union-aware rename()
  union-mount: Implement union-aware writable open()
  union-mount: Implement union-aware chown()
  union-mount: Implement union-aware truncate()
  union-mount: Implement union-aware chmod()/fchmodat()
  union-mount: Implement union-aware lchown()
  union-mount: Implement union-aware utimensat()
  union-mount: Implement union-aware setxattr()
  union-mount: Implement union-aware lsetxattr()

 Documentation/filesystems/union-mounts.txt |  752 +++++++++++++++++++++++++++
 Documentation/filesystems/vfs.txt          |   16 +-
 fs/Kconfig                                 |   13 +
 fs/Makefile                                |    1 +
 fs/autofs4/autofs_i.h                      |    1 +
 fs/autofs4/init.c                          |   11 +-
 fs/autofs4/root.c                          |    6 +
 fs/compat.c                                |    9 +
 fs/dcache.c                                |   32 ++-
 fs/ext2/dir.c                              |  248 +++++++++-
 fs/ext2/ext2.h                             |    4 +
 fs/ext2/inode.c                            |   11 +-
 fs/ext2/namei.c                            |   89 ++++-
 fs/ext2/super.c                            |    6 +
 fs/jffs2/dir.c                             |  104 ++++-
 fs/jffs2/fs.c                              |    4 +
 fs/jffs2/super.c                           |    2 +-
 fs/libfs.c                                 |   21 +-
 fs/namei.c                                 |  754 ++++++++++++++++++++++++----
 fs/namespace.c                             |  279 ++++++++++-
 fs/nfsd/nfs3xdr.c                          |    5 +
 fs/nfsd/nfs4xdr.c                          |    5 +
 fs/nfsd/nfsxdr.c                           |    4 +
 fs/open.c                                  |  116 ++++-
 fs/readdir.c                               |   18 +
 fs/super.c                                 |   24 +
 fs/union.c                                 |  692 +++++++++++++++++++++++++
 fs/union.h                                 |   80 +++
 fs/utimes.c                                |   14 +-
 fs/xattr.c                                 |   65 ++-
 include/linux/dcache.h                     |   16 +-
 include/linux/ext2_fs.h                    |    5 +
 include/linux/fs.h                         |   23 +
 include/linux/jffs2.h                      |    8 +
 include/linux/mount.h                      |    6 +-
 include/linux/namei.h                      |    2 +
 mm/shmem.c                                 |  195 +++++++-
 37 files changed, 3459 insertions(+), 182 deletions(-)
 create mode 100644 Documentation/filesystems/union-mounts.txt
 create mode 100644 fs/union.c
 create mode 100644 fs/union.h

