Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab1FTRKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:10:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55784 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab1FTRKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:10:45 -0400
Date: Mon, 20 Jun 2011 18:10:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] more vfs/fs patches
Message-ID: <20110620171043.GX11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan's fix for ubifs breakage + removal of a bunch of really dumb
detritus from ->permission() instances + fix for long-standing
stupidity in devcgroups_inode_permission() (the thing is a
no-op for non-devices and that check definitely ought to be
taken to inline wrapper).  Please, pull from the usual place
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ #for-linus

Shortlog:

Al Viro (11):
      bad_inode_permission() is safe from RCU mode
      cifs_permission() doesn't need to bail out in RCU mode
      coda_ioctl_permission() is safe in RCU mode
      logfs doesn't need ->permission() at all
      nilfs2_permission() doesn't need to bail out in RCU mode
      proc_fd_permission() is doesn't need to bail out in RCU mode
      reiserfs_permission() doesn't need to bail out in RCU mode
      proc_sys_permission() is OK in RCU mode
      kill obsolete comment for follow_down()
      fix comment in generic_permission()
      devcgroup_inode_permission: take "is it a device node" checks to inlined wrapper

Dan Carpenter (1):
      ubifs: dereferencing an ERR_PTR in ubifs_mount()

Diffstat:

 fs/bad_inode.c                |    3 ---
 fs/cifs/cifsfs.c              |    3 ---
 fs/coda/pioctl.c              |    2 --
 fs/logfs/dir.c                |    8 --------
 fs/namei.c                    |    6 ++----
 fs/nilfs2/inode.c             |    7 +------
 fs/proc/base.c                |    6 +-----
 fs/proc/proc_sysctl.c         |    3 ---
 fs/reiserfs/xattr.c           |    2 --
 fs/ubifs/super.c              |    1 +
 include/linux/device_cgroup.h |   10 +++++++++-
 security/device_cgroup.c      |    8 +-------
 12 files changed, 15 insertions(+), 44 deletions(-)
