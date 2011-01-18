Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab1ARGuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 01:50:32 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39060 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab1ARGub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 01:50:31 -0500
Date: Tue, 18 Jan 2011 06:50:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] more autofs bits
Message-ID: <20110118065028.GL22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Contains: fix for leak in do_loopback(), a couple of autofs
fixes from Ian and a bunch of autofs cleanups (some from a year ago ;-/)
I'd finally got around to.  Again, this is not all - there'll be one
more later tonight.  This one is just autofs bits.  Please, pull from

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (8):
      autofs4: keep symlink body in inode->i_private
      autofs4: autofs4_mkroot() is not different from autofs4_init_ino()
      autofs4: pass mode to autofs4_get_inode() explicitly
      autofs4: kill ->size in autofs_info
      autofs4: autofs4_get_inode() doesn't need autofs_info * argument anymore
      autofs4: mkdir and symlink always get a dentry that had passed lookup
      autofs4: split autofs4_init_ino()
      autofs4: clean ->d_release() and autofs4_free_ino() up

Ian Kent (3):
      autofs4 - fix get_next_positive_dentry()
      vfs - fix dentry ref count in do_lookup()
      autofs4 - fix debug print in autofs4_lookup()

Diffstat:
 fs/autofs4/autofs_i.h |   14 ++------
 fs/autofs4/expire.c   |    4 +-
 fs/autofs4/inode.c    |   88 ++++++++++++------------------------------------
 fs/autofs4/root.c     |   74 +++++++++++++++++++---------------------
 fs/autofs4/symlink.c  |    3 +-
 fs/namei.c            |    4 ++-
 6 files changed, 66 insertions(+), 121 deletions(-)
