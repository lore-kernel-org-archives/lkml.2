Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab1APS5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 13:57:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42576 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab1APS5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 13:57:47 -0500
Date: Sun, 16 Jan 2011 18:57:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs pile 2 (automount work)
Message-ID: <20110116185745.GB22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This pile consists mostly automount patchset by dhowells plus
fixes for related mainline bugs.  There's more, but I'd rather keep
pull requests separate; I'll send another one tonight and there will
be more on Monday.  Please, pull from

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (3):
      do_lookup() fix
      fix old umount_tree() breakage
      sanitize vfsmount refcounting changes

David Howells (11):
      Add a dentry op to handle automounting rather than abusing follow_link()
      Add a dentry op to allow processes to be held during pathwalk transit
      Add an AT_NO_AUTOMOUNT flag to suppress terminal automount
      AFS: Use d_automount() rather than abusing follow_link()
      NFS: Use d_automount() rather than abusing follow_link()
      CIFS: Use d_automount() rather than abusing follow_link()
      Remove the automount through follow_link() kludge code from pathwalk
      Remove a further kludge from __do_follow_link()
      Allow d_manage() to be used in RCU-walk mode
      Unexport do_add_mount() and add in follow_automount(), not ->d_automount()
      autofs4: Merge the remaining dentry ops tables

Ian Kent (9):
      autofs4: Add d_automount() dentry operation
      autofs4: Add d_manage() dentry operation
      autofs4: Remove unused code
      autofs4: Clean up inode operations
      autofs4: Clean up dentry operations
      autofs4: Clean up autofs4_free_ino()
      autofs4: Fix wait validation
      autofs4: Add v4 pseudo direct mount support
      autofs4: Bump version

Diffstat:
 Documentation/filesystems/Locking |    4 +
 Documentation/filesystems/vfs.txt |   43 +++
 drivers/mtd/mtdchar.c             |    2 +-
 drivers/staging/autofs/dirhash.c  |    5 +-
 fs/afs/dir.c                      |    1 +
 fs/afs/inode.c                    |    3 +-
 fs/afs/internal.h                 |    1 +
 fs/afs/mntpt.c                    |   56 +---
 fs/anon_inodes.c                  |    2 +-
 fs/autofs4/autofs_i.h             |   99 ++++--
 fs/autofs4/dev-ioctl.c            |    2 +-
 fs/autofs4/expire.c               |   51 ++--
 fs/autofs4/inode.c                |   26 +--
 fs/autofs4/root.c                 |  673 ++++++++++++++++---------------------
 fs/autofs4/waitq.c                |   17 +-
 fs/cifs/cifs_dfs_ref.c            |  120 +++----
 fs/cifs/cifsfs.h                  |    6 +
 fs/cifs/dir.c                     |    2 +
 fs/cifs/inode.c                   |    8 +-
 fs/dcache.c                       |    5 +-
 fs/fs_struct.c                    |   35 ++-
 fs/internal.h                     |    5 +
 fs/namei.c                        |  379 +++++++++++++++------
 fs/namespace.c                    |  179 +++++-----
 fs/nfs/dir.c                      |    4 +-
 fs/nfs/inode.c                    |    4 +-
 fs/nfs/internal.h                 |    1 +
 fs/nfs/namespace.c                |   79 ++---
 fs/nfsd/vfs.c                     |    5 +-
 fs/pipe.c                         |    2 +-
 fs/stat.c                         |    4 +-
 fs/super.c                        |    2 +-
 include/linux/auto_fs4.h          |    2 +-
 include/linux/dcache.h            |   16 +-
 include/linux/fcntl.h             |    1 +
 include/linux/fs.h                |    2 +
 include/linux/mount.h             |   11 +-
 include/linux/namei.h             |    5 +-
 include/linux/nfs_fs.h            |    1 -
 include/linux/path.h              |    2 -
 40 files changed, 1010 insertions(+), 855 deletions(-)
