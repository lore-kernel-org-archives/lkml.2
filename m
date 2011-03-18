Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab1CRPzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:55:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42405 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab1CRPy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:54:56 -0400
Date: Fri, 18 Mar 2011 15:54:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] more vfs stuff
Message-ID: <20110318155455.GL22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Mostly vfsmount-related stuff; some leftovers from mnt_devname
(not all, BTW - there's more pending cleanups around nfs/super.c) plus
pstore fix plus deadlock fix in pivot_root().  The really neat thing is
that now we have no blocking on fs locks under namespace_sem - the only
blocking stuff under it now is kmalloc(), which makes things much more
robust.  Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

More to follow tonight - I hoped to push assorted patches accumulated
during the last cycle in this pile, but that'll have to wait until the
next push.

Shortlog:
Al Viro (6):
      kill simple_set_mnt()
      vfs: split off vfsmount-related parts of vfs_kern_mount()
      fix deadlock in pivot_root()
      change the locking order for namespace_sem
      don't pass 'mounting_here' flag to follow_down()
      lose 'mounting_here' argument in ->d_manage()

Josef Bacik (1):
      fs: call security_d_instantiate in d_obtain_alias V2

Tony Luck (1):
      Some fixes for pstore

Diffstat:
 Documentation/filesystems/vfs.txt |    6 +-
 fs/autofs4/root.c                 |    6 +-
 fs/dcache.c                       |    3 +
 fs/internal.h                     |    5 +-
 fs/namei.c                        |    9 +-
 fs/namespace.c                    |  292 +++++++++++++++++++++++--------------
 fs/nfsd/vfs.c                     |    2 +-
 fs/pstore/inode.c                 |  116 +++++++--------
 fs/super.c                        |   96 ++----------
 include/linux/dcache.h            |    2 +-
 include/linux/fs.h                |    1 -
 include/linux/namei.h             |    2 +-
 12 files changed, 271 insertions(+), 269 deletions(-)

