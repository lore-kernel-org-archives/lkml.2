Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab0HKEzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 00:55:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51768 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab0HKEzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 00:55:14 -0400
Date: Wed, 11 Aug 2010 05:55:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] more vfs stuff
Message-ID: <20100811045512.GF31363@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Misc stuff missed in the previous pile (including fixup for 9p
breakage).  The last part in sysvfs series replaced with akpm's version
(with its whitespace fixes) with bogus include _not_ added.  Freeze
stuff still pending; unfortunately, I've found a hole in my variant ;-/
I know how to fix that, but I'd rather not send an untested locking change.
It *is* needed in this cycle, since the current variant is simply broken -
for example, try Alt-Sysrq-Emergency Thaw and it'll reliably deadlock ;-/

Please, pull from usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

More to follow...

Shortlog:

Jan Andres (1):
      isofs: Fix lseek() to position beyond 4 GB

Lubomir Rintel (3):
      Add v7 alias
      V7: Adjust sanity checks for some volumes
      fs/sysv/super.c: add support for non-PDP11 v7 filesystems

Miklos Szeredi (8):
      cachefiles: use path_get instead of lone dget
      vfs: add helpers to get root and pwd
      ia64: perfmon: add d_dname method
      vfs: __d_path: dont prepend the name of the root dentry
      vfs: add prepend_path() helper
      vfs: only add " (deleted)" where necessary
      vfs: show unreachable paths in getcwd and proc
      vfs: remove unused MNT_STRICTATIME

Stephen Rothwell (1):
      v9fs: fixup for inode_setattr being removed

Diffstat:
 arch/ia64/kernel/perfmon.c |   15 ++--
 fs/9p/vfs_inode.c          |   15 +++-
 fs/cachefiles/daemon.c     |   32 +++-----
 fs/dcache.c                |  188 +++++++++++++++++++++++++++++++-------------
 fs/fs_struct.c             |    7 +--
 fs/isofs/inode.c           |    7 ++-
 fs/namei.c                 |   15 +---
 fs/namespace.c             |    6 +-
 fs/proc/base.c             |   24 +++---
 fs/sysv/super.c            |   73 ++++++++++++-----
 include/linux/dcache.h     |    1 +
 include/linux/fs_struct.h  |   27 ++++++
 include/linux/mount.h      |    1 -
 include/linux/path.h       |    5 +
 include/linux/sysv_fs.h    |   11 +++
 kernel/auditsc.c           |    9 +--
 16 files changed, 285 insertions(+), 151 deletions(-)
