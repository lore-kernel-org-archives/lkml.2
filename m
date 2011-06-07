Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab1FGNBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:01:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55886 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab1FGNB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:01:29 -0400
Date: Tue, 7 Jun 2011 14:01:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs/fs fixes for -rc3
Message-ID: <20110607130126.GQ11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Contains the set that was in the previous pull request (as the matter
of fact, for-linus-2 is a couple of commits on top of for-linus).  New bits:
jfs fix (yet another -PTR_ERR() bug) and Ted's sanitizing of ENOENT/EROFS on
unlink() and rmdir() to match the behaviour of rename(), behaviour of the
unlink()/rmdir() in old kernels *and* what POSIX asks for.
	Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus-2

Shortlog:

Al Viro (2):
      more conservative S_NOSEC handling
      lmLogOpen() broken failure exit

Sage Weil (1):
      usb: remove bad dput after dentry_unhash

Theodore Ts'o (1):
      vfs: make unlink() and rmdir() return ENOENT in preference to EROFS

Diffstat:

 drivers/usb/core/inode.c |    1 -
 fs/btrfs/super.c         |    2 +-
 fs/fuse/inode.c          |    2 ++
 fs/jfs/jfs_logmgr.c      |    2 +-
 fs/namei.c               |   11 +++++++----
 fs/ocfs2/super.c         |    2 +-
 fs/super.c               |    2 +-
 include/linux/fs.h       |    3 ++-
 mm/filemap.c             |    2 +-
 9 files changed, 16 insertions(+), 11 deletions(-)
