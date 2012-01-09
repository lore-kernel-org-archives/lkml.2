Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2AINSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 08:18:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab2AINSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 08:18:46 -0500
Date: Mon, 9 Jan 2012 14:18:44 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PULL REQUEST] ext3, udf, and reiserfs fixes for 3.3-rc1
Message-ID: <20120109131844.GA18898@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

to get couple of ext3 fixes (mostly minor stuff, the most interesting is
probably that we got rid of j_barrier mutex which was held when we were
exiting to userspace from FIFREEZE ioctl), some UDF fixes, and also two
reiserfs fixes (I decided to merge these because of lack of reiserfs
maintainer).

Top of the tree is 302bf2f. The full shortlog is:

Dan Carpenter (1):
      ext3: NULL dereference in ext3_evict_inode()

Djalal Harouni (1):
      ext{3,4}: Fix potential race when setversion ioctl updates inode

Eryu Guan (1):
      ext3: call ext3_mark_recovery_complete() when recovery is really needed

Jan Kara (9):
      ext3: Fix error handling on inode bitmap corruption
      ext2: Fix error handling on inode bitmap corruption
      udf: Cleanup calling convention of inode_getblk()
      udf: Fix deadlock when converting file from in-ICB one to normal one
      udf: Treat symlink component of type 2 as /
      reiserfs: Fix quota mount option parsing
      jbd: Remove j_barrier mutex
      ext3: Don't warn from writepage when readonly inode is spotted after error
      udf: Mark LVID buffer as uptodate before marking it dirty

Jeff Mahoney (1):
      reiserfs: Force inode evictions before umount to avoid crash

Paul Gortmaker (1):
      ext2/3/4: delete unneeded includes of module.h

Yongqiang Yang (1):
      jbd: clear revoked flag on buffers before a new transaction started

Zheng Liu (1):
      ext3: replace ll_rw_block with other functions

The diffstat is

 fs/ext2/ialloc.c         |    7 ++++-
 fs/ext2/inode.c          |    5 ----
 fs/ext2/super.c          |    3 ++
 fs/ext2/xattr.c          |    1 -
 fs/ext2/xattr_security.c |    1 -
 fs/ext2/xattr_trusted.c  |    1 -
 fs/ext2/xattr_user.c     |    1 -
 fs/ext3/ialloc.c         |    8 +++++-
 fs/ext3/inode.c          |   43 +++++++++++++++++++++++++---------
 fs/ext3/ioctl.c          |    6 ++++-
 fs/ext3/namei.c          |    9 +++++--
 fs/ext3/super.c          |   15 ++++++-----
 fs/ext3/xattr_security.c |    1 -
 fs/ext3/xattr_trusted.c  |    1 -
 fs/ext3/xattr_user.c     |    1 -
 fs/ext4/block_validity.c |    1 -
 fs/ext4/extents.c        |    1 -
 fs/ext4/indirect.c       |    1 -
 fs/ext4/inode.c          |    1 -
 fs/ext4/ioctl.c          |    6 ++++-
 fs/ext4/migrate.c        |    1 -
 fs/ext4/page-io.c        |    1 -
 fs/ext4/xattr_security.c |    1 -
 fs/ext4/xattr_trusted.c  |    1 -
 fs/ext4/xattr_user.c     |    1 -
 fs/jbd/commit.c          |    6 +++++
 fs/jbd/journal.c         |    1 -
 fs/jbd/revoke.c          |   34 +++++++++++++++++++++++++++
 fs/jbd/transaction.c     |   36 +++++++++++++++++------------
 fs/reiserfs/super.c      |   27 +++++++++++++---------
 fs/udf/file.c            |    6 ++--
 fs/udf/inode.c           |   57 ++++++++++++++++++++++++++-------------------
 fs/udf/super.c           |    6 +++++
 fs/udf/symlink.c         |   14 ++++++++---
 include/linux/jbd.h      |    5 +---
 35 files changed, 200 insertions(+), 110 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
