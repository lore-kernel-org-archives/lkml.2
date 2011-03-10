Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab1CJLJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 06:09:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55630 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1CJLJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 06:09:33 -0500
Date: Thu, 10 Mar 2011 11:09:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] more vfs fixes for final
Message-ID: <20110310110931.GF22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Fix for misplaced include in sysctl.h, fixes for ->d_revalidate()
(a bunch of filesystems are unusable with nfsd at the moment; the real fix
is to make ->d_revalidate() take flags directly and forget about dereferencing
nameidata in most of the instances, but that's obviously for the next window
and oopsen really need to be fixed for -final), missing checks in fallocate()
and Bruce's patch for inode (temporary) leaks with nfsd.  Please, pull from

git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:

Al Viro (8):
      /proc/self is never going to be invalidated...
      reiserfs xattr ->d_revalidate() shouldn't care about RCU
      ceph: fix d_revalidate oopsen on NFS exports
      fuse: fix d_revalidate oopsen on NFS exports
      gfs2: fix d_revalidate oopsen on NFS exports
      ocfs2: fix d_revalidate oopsen on NFS exports
      jfs: fix d_revalidate oopsen on NFS exports
      fat: fix d_revalidate oopsen on NFS exports

J. Bruce Fields (1):
      fs/dcache: allow d_obtain_alias() to return unhashed dentries

Marco Stornelli (1):
      Check for immutable/append flag in fallocate path

Stephen Rothwell (1):
      sysctl: the include of rcupdate.h is only needed in the kernel

Diffstat:
 fs/ceph/dir.c          |    2 +-
 fs/dcache.c            |   26 ++++++++++++++++++++++++--
 fs/fat/namei_vfat.c    |    4 ++--
 fs/fuse/dir.c          |    2 +-
 fs/gfs2/dentry.c       |    2 +-
 fs/jfs/namei.c         |    2 +-
 fs/ocfs2/dcache.c      |    2 +-
 fs/open.c              |    8 ++++++++
 fs/proc/base.c         |   30 ------------------------------
 fs/reiserfs/xattr.c    |    2 --
 include/linux/sysctl.h |    2 +-
 11 files changed, 40 insertions(+), 42 deletions(-)
