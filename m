Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab1LNHGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 02:06:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52003 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab1LNHG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 02:06:29 -0500
Date: Wed, 14 Dec 2011 07:06:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] assorted fs fixes
Message-ID: <20111214070627.GM2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Assorted fixes for moderately unpleasant bugs - a couple of leaks,
several hard to hit races, screwed up failure exit in ncpfs mount.

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (5):
      procfs: fix a vfsmount longterm reference leak
      ... and the same kind of leak for mqueue
      ubifs: too early register_filesystem()
      fuse: register_filesystem() called too early
      configfs: register_filesystem() called too early

Djalal Harouni (1):
      fs/ncpfs: fix error paths and goto statements in ncp_fill_super()

Diffstat:
 fs/configfs/inode.c |    2 +-
 fs/configfs/mount.c |   36 +++++++++++++++++-------------------
 fs/fuse/inode.c     |   24 ++++++++++++------------
 fs/ncpfs/inode.c    |    8 ++++----
 fs/proc/root.c      |    8 +++-----
 fs/ubifs/super.c    |   18 ++++++++----------
 ipc/mqueue.c        |    8 +++-----
 ipc/msgutil.c       |    5 -----
 8 files changed, 48 insertions(+), 61 deletions(-)

