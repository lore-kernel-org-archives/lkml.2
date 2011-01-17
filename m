Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1AQNho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 08:37:44 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52585 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1AQNhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 08:37:43 -0500
Date: Mon, 17 Jan 2011 13:37:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs misc bits
Message-ID: <20110117133741.GI22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Assorted bits and pieces.  There will be one more pile, but this one
is just sweeping the misc stuff.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (3):
      Take the completion of automount into new helper
      don't drop newmnt on error in do_add_mount()
      tidy up around finish_automount()

Christoph Hellwig (2):
      make the feature checks in ->fallocate future proof
      fallocate should be a file operation

Dr. David Alan Gilbert (1):
      hpfs_setattr error case avoids unlock_kernel

Namhyung Kim (5):
      compat: remove unnecessary assignment in compat_rw_copy_check_uvector()
      compat: update comment of compat statfs syscalls
      compat: copy missing fields in compat_statfs64 to user
      aio: check return value of create_workqueue()
      fs: fix address space warnings in ioctl_fiemap()

Randy Dunlap (1):
      fs: FS_POSIX_ACL does not depend on BLOCK

Steven Rostedt (2):
      fs: Remove unlikely() from fput_light()
      fs: Remove unlikely() from fget_light()

Yang Ruirui (1):
      staging: smbfs building fix

Diffstat:
 Documentation/filesystems/Locking |    3 +-
 drivers/staging/smbfs/dir.c       |    4 +-
 fs/Kconfig                        |   17 +--
 fs/aio.c                          |    2 +-
 fs/btrfs/file.c                   |  113 ++++++++++++++++
 fs/btrfs/inode.c                  |  111 ----------------
 fs/compat.c                       |   10 +-
 fs/ext4/ext4.h                    |    2 +-
 fs/ext4/extents.c                 |   11 +-
 fs/ext4/file.c                    |    2 +-
 fs/file_table.c                   |    2 +-
 fs/gfs2/file.c                    |  258 +++++++++++++++++++++++++++++++++++++
 fs/gfs2/ops_inode.c               |  258 -------------------------------------
 fs/hpfs/inode.c                   |    2 +-
 fs/internal.h                     |    3 +-
 fs/ioctl.c                        |   10 +-
 fs/namei.c                        |   31 +----
 fs/namespace.c                    |   63 ++++++----
 fs/ocfs2/file.c                   |   10 +-
 fs/open.c                         |    4 +-
 fs/xfs/linux-2.6/xfs_file.c       |   56 ++++++++
 fs/xfs/linux-2.6/xfs_iops.c       |   57 --------
 include/linux/file.h              |    2 +-
 include/linux/fs.h                |    8 +-
 24 files changed, 515 insertions(+), 524 deletions(-)
