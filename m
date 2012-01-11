Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab2AKFXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 00:23:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47328 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab2AKFXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 00:23:44 -0500
Date: Wed, 11 Jan 2012 05:23:40 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] more vfs fixes
Message-ID: <20120111052340.GG23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted bug fixes (probably all of that should be -stable fodder, with
the exception of kmemleak cosmetical one).  The usual place,

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (7):
      securityfs: fix object creation races
      coda: deal correctly with allocation failure from coda_cnode_makectl()
      coda: switch coda_cnode_make() to sane API as well, clean coda_lookup()
      hfsplus: creation of hidden dir on mount can fail
      autofs4: autofs4_wait() vs. autofs4_catatonic_mode() race
      autofs4: catatonic_mode vs. notify_daemon race
      autofs4: deal with autofs4_write/autofs4_write races

Miklos Szeredi (1):
      fix shrink_dcache_parent() livelock

Sergey Senozhatsky (1):
      block_dev: Suppress bdev_cache_init() kmemleak warninig

Diffstat:
 fs/autofs4/autofs_i.h  |    1 +
 fs/autofs4/inode.c     |    1 +
 fs/autofs4/waitq.c     |   40 ++++++----
 fs/block_dev.c         |   10 +--
 fs/coda/cnode.c        |   38 ++++------
 fs/coda/coda_fs_i.h    |    4 +-
 fs/coda/dir.c          |   29 +++----
 fs/coda/inode.c        |   10 ++-
 fs/dcache.c            |   15 +++-
 fs/hfsplus/super.c     |   11 ++-
 include/linux/dcache.h |    1 +
 security/inode.c       |  191 +++++++++++++-----------------------------------
 12 files changed, 137 insertions(+), 214 deletions(-)

