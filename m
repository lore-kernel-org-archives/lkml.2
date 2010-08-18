Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab0HRPfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:35:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47365 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab0HRPfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:35:30 -0400
Date: Wed, 18 Aug 2010 16:35:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs for rc2, part 1
Message-ID: <20100818153528.GO31363@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Assorted fixes + subset of Nick's series + few bits lost from the
last pile.  Please, pull from the usual place:

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/

	Tomorrow: freeze/thaw fixes and big code movement series (partitioning
and otherwise block-related)...

Shortlog:
Al Viro (2):
      hostfs: dumb (and usually harmless) tpyo - strncpy instead of strlcpy
      hostfs ->follow_link() braino

Alexander Shishkin (1):
      cramfs: only unlock new inodes

Andreas Gruenbacher (1):
      mbcache: Limit the maximum number of cache entries

Christoph Hellwig (2):
      kill BH_Ordered flag
      remove SWRITE* I/O types

Jan Kara (1):
      vfs: update ctime when changing the file's permission by setfacl

Nick Piggin (10):
      fs: fix do_lookup false negative
      fs: dentry allocation consolidation
      apparmor: use task path helpers
      fs: fs_struct rwlock to spinlock
      fs: remove extra lookup in __lookup_hash
      fs: cleanup files_lock locking
      tty: fix fu_list abuse
      lglock: introduce special lglock and brlock spin locks
      fs: scale files_lock
      fs: brlock vfsmount_lock

Sergey Senozhatsky (1):
      fix reiserfs_evict_inode end_writeback second call

Diffstat:
 drivers/char/pty.c                    |    4 +-
 drivers/char/tty_io.c                 |   92 ++++++++++++------
 drivers/staging/pohmelfs/path_entry.c |    8 +-
 fs/buffer.c                           |   69 +++++++------
 fs/cramfs/inode.c                     |    2 +-
 fs/dcache.c                           |   71 ++++++++------
 fs/exec.c                             |    4 +-
 fs/fat/misc.c                         |    4 +-
 fs/file_table.c                       |  124 ++++++++++++++++++------
 fs/fs_struct.c                        |   32 +++---
 fs/generic_acl.c                      |    1 +
 fs/hostfs/hostfs_kern.c               |    4 +-
 fs/internal.h                         |    7 +-
 fs/jbd/checkpoint.c                   |    4 +-
 fs/jbd/commit.c                       |   53 +++++-----
 fs/jbd/journal.c                      |    2 +-
 fs/jbd/revoke.c                       |    2 +-
 fs/jbd2/checkpoint.c                  |    4 +-
 fs/jbd2/commit.c                      |   41 +++-----
 fs/jbd2/journal.c                     |    2 +-
 fs/jbd2/revoke.c                      |    2 +-
 fs/mbcache.c                          |   30 +++++-
 fs/namei.c                            |  119 ++++++++++------------
 fs/namespace.c                        |  177 +++++++++++++++++++++------------
 fs/nilfs2/super.c                     |   28 +++---
 fs/open.c                             |    4 +-
 fs/pnode.c                            |   11 ++-
 fs/reiserfs/inode.c                   |    1 +
 fs/reiserfs/journal.c                 |    2 +-
 fs/super.c                            |   18 ++++
 fs/ufs/balloc.c                       |   24 ++---
 fs/ufs/ialloc.c                       |   18 +---
 fs/ufs/truncate.c                     |   18 +---
 fs/ufs/util.c                         |   20 ++---
 fs/ufs/util.h                         |    3 +-
 include/linux/buffer_head.h           |    4 +-
 include/linux/fs.h                    |   21 ++---
 include/linux/fs_struct.h             |   14 ++--
 include/linux/lglock.h                |  172 ++++++++++++++++++++++++++++++++
 include/linux/tty.h                   |    9 ++
 kernel/fork.c                         |   10 +-
 security/apparmor/path.c              |    9 +--
 security/selinux/hooks.c              |    9 +-
 43 files changed, 800 insertions(+), 453 deletions(-)
