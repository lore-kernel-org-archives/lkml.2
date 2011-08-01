Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab1HASQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 14:16:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56339 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1HASQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 14:16:18 -0400
Date: Mon, 1 Aug 2011 19:16:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] assorted fixes
Message-ID: <20110801181615.GI2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Misc stuff from various sources; probably the most interesting in that pile
is Eric's series (lock reduction for pipes et.al.).  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git for-linus

Shortlog:
Al Viro (6):
      hppfs: missing include
      devtmpfs: missing initialialization in never-hit case
      switch posix_acl_create() to umode_t *
      switch posix_acl_equiv_mode() to umode_t *
      switch posix_acl_from_mode() to umode_t
      switch posix_acl_chmod() to umode_t

David Howells (4):
      VFS: Fix automount for negative autofs dentries
      VFS: Remove detached-dentry counter from shrink_dcache_for_umount_subtree()
      VFS: Remove dentry->d_lock locking from shrink_dcache_for_umount_subtree()
      VFS: Reorganise shrink_dcache_for_umount_subtree() after demise of dcache_lock

Eric Dumazet (3):
      vfs: conditionally call inode_wb_list_del()
      vfs: avoid taking inode_hash_lock on pipes and sockets
      vfs: avoid call to inode_lru_list_del() if possible

Josef Bacik (1):
      Btrfs: load the key from the dir item in readdir into a fake dentry

Lachlan McIlroy (1):
      block: initialise bd_super in bdget()

Markus Trippelsdorf (1):
      xfs: Fix build breakage in xfs_iops.c when CONFIG_FS_POSIX_ACL is not set


Diffstat:
 drivers/base/devtmpfs.c    |    2 +-
 fs/9p/acl.c                |    6 ++--
 fs/9p/acl.h                |    4 +-
 fs/9p/vfs_inode_dotl.c     |    6 ++--
 fs/block_dev.c             |    1 +
 fs/btrfs/acl.c             |   10 +-----
 fs/btrfs/inode.c           |   47 ++++++++++++++++++++++++++++-
 fs/dcache.c                |   69 +++++++++++++++++--------------------------
 fs/ext2/acl.c              |    8 +----
 fs/ext3/acl.c              |    9 +----
 fs/ext4/acl.c              |    9 +----
 fs/generic_acl.c           |   13 ++------
 fs/gfs2/acl.c              |    6 ++--
 fs/hppfs/hppfs.c           |    1 +
 fs/inode.c                 |   13 +++++---
 fs/jffs2/acl.c             |    4 +-
 fs/jffs2/acl.h             |    2 +-
 fs/jffs2/fs.c              |    2 +-
 fs/jffs2/os-linux.h        |    2 +-
 fs/jfs/acl.c               |    4 +--
 fs/jfs/xattr.c             |    4 +--
 fs/namei.c                 |   24 +++++++++------
 fs/nfs/nfs3acl.c           |    2 +-
 fs/nfs/nfs3proc.c          |    6 ++--
 fs/ocfs2/acl.c             |    4 +-
 fs/posix_acl.c             |   16 +++++-----
 fs/reiserfs/xattr_acl.c    |   10 +-----
 fs/xfs/linux-2.6/xfs_acl.c |    6 ++--
 fs/xfs/xfs_acl.h           |    5 ++-
 include/linux/fs.h         |    9 +++++-
 include/linux/nfs_fs.h     |    4 +-
 include/linux/posix_acl.h  |    8 ++--
 32 files changed, 165 insertions(+), 151 deletions(-)
