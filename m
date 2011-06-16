Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab1FPRKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 13:10:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39804 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758165Ab1FPRKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 13:10:46 -0400
Date: Thu, 16 Jun 2011 18:10:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs patches for -rc4
Message-ID: <20110616171044.GM11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted fixes, including an automount race that had been around since late
January - dhowells had finally narrowed it down to vfsmount refcounting
problem around lock_mount().  Please, pull from
git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (6):
      fix leak in proc_set_super()
      ubifs: split allocation of ubifs_info into a separate function
      ubifs: fix sget races
      afs: fix sget() races, close leak on umount
      Delay struct net freeing while there's a sysfs instance refering to it
      VFS: Fix vfsmount overput on simultaneous automount

Anton Blanchard (1):
      afs: afs_fill_page reads too much, or wrong data

David Howells (2):
      AFS: Set s_id in the superblock to the volume name
      AFS: Use i_generation not i_version for the vnode uniquifier

Jan Kara (1):
      vfs: Fix data corruption after failed write in __block_write_begin()

Török Edwin (1):
      fix wrong iput on d_inode introduced by e6bc45d65d

Diffstat:
 fs/afs/dir.c                |    8 +-
 fs/afs/fsclient.c           |    3 +-
 fs/afs/inode.c              |   10 ++--
 fs/afs/super.c              |   74 ++++++++++-------------
 fs/afs/write.c              |   21 +++----
 fs/buffer.c                 |    4 +-
 fs/namei.c                  |   28 ++++++---
 fs/proc/root.c              |   11 ++--
 fs/sysfs/mount.c            |   37 ++++--------
 fs/sysfs/sysfs.h            |    2 +-
 fs/ubifs/super.c            |  137 ++++++++++++++++++++++++-------------------
 include/linux/kobject_ns.h  |   10 ++-
 include/linux/sysfs.h       |    7 --
 include/net/net_namespace.h |   10 +++-
 lib/kobject.c               |   26 +++-----
 net/core/net-sysfs.c        |   23 +++-----
 net/core/net_namespace.c    |   12 +++-
 17 files changed, 210 insertions(+), 213 deletions(-)
