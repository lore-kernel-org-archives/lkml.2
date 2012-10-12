Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab2JLBUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 21:20:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60333 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab2JLBT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 21:19:59 -0400
Date: Fri, 12 Oct 2012 02:19:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git, pile 2
Message-ID: <20121012011957.GH2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Stuff in this one - assorted fixes, lglock tidy-up, death to
lock_super().  There'll be a VFS pile tomorrow (with patches from Jeff Layton,
sanitizing getname() and related parts of audit and preparing for ESTALE
fixes), but I'd rather push the stuff in this one ASAP - some of the bugs
closed here are quite unpleasant.  Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (2):
      MAX_LFS_FILESIZE definition for 64bit needs LL...
      consitify do_mount() arguments

Arnd Bergmann (1):
      vfs: bogus warnings in fs/namei.c

Hugh Dickins (1):
      tmpfs,ceph,gfs2,isofs,reiserfs,xfs: fix fh_len checking

Lai Jiangshan (3):
      lglock: remove unused DEFINE_LGLOCK_LOCKDEP()
      lglock: make the per_cpu locks static
      lglock: add DEFINE_STATIC_LGLOCK()

Marco Stornelli (7):
      exofs: drop lock/unlock super
      ext3: drop lock/unlock super
      fat: drop lock/unlock super
      hpfs: drop lock/unlock super
      sysv: drop lock/unlock super
      ufs: drop lock/unlock super
      vfs: drop lock/unlock super

Richard W.M. Jones (1):
      dup3: Return an error when oldfd == newfd.

Sasha Levin (2):
      fs: prevent use after free in auditing when symlink following was denied
      fs: handle failed audit_log_start properly

Diffstat:
 fs/ceph/export.c           |   18 ++++++++++++++----
 fs/exofs/super.c           |    4 ----
 fs/ext3/super.c            |    6 ------
 fs/fat/dir.c               |    4 ++--
 fs/fat/fat.h               |    5 +++--
 fs/fat/inode.c             |    5 +++--
 fs/fat/namei_msdos.c       |   26 +++++++++++++-------------
 fs/fat/namei_vfat.c        |   30 +++++++++++++++---------------
 fs/file.c                  |    3 +++
 fs/file_table.c            |    2 +-
 fs/gfs2/export.c           |    4 ++++
 fs/hpfs/super.c            |    3 ---
 fs/isofs/export.c          |    2 +-
 fs/namei.c                 |    3 ++-
 fs/namespace.c             |   12 ++++++------
 fs/reiserfs/inode.c        |    6 +++++-
 fs/super.c                 |   23 -----------------------
 fs/sysv/balloc.c           |   18 +++++++++---------
 fs/sysv/ialloc.c           |   14 +++++++-------
 fs/sysv/inode.c            |    4 ++--
 fs/sysv/super.c            |    1 +
 fs/sysv/sysv.h             |    1 +
 fs/ufs/balloc.c            |   30 +++++++++++++++---------------
 fs/ufs/ialloc.c            |   16 ++++++++--------
 fs/ufs/super.c             |   21 +++++++++++----------
 fs/ufs/ufs.h               |    1 +
 fs/xfs/xfs_export.c        |    3 +++
 include/linux/fs.h         |    5 ++---
 include/linux/lglock.h     |   19 ++++++++-----------
 include/linux/security.h   |   12 ++++++------
 kernel/audit.c             |    2 ++
 mm/shmem.c                 |    6 ++++--
 security/capability.c      |    4 ++--
 security/security.c        |    4 ++--
 security/selinux/hooks.c   |    4 ++--
 security/smack/smack_lsm.c |    4 ++--
 security/tomoyo/common.h   |    2 +-
 security/tomoyo/mount.c    |    5 +++--
 security/tomoyo/tomoyo.c   |    4 ++--
 39 files changed, 166 insertions(+), 170 deletions(-)
