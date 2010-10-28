Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab0J1AlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 20:41:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:34233 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757576Ab0J1AlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 20:41:05 -0400
Date: Thu, 28 Oct 2010 02:41:02 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] Ext3 and quota fixes for 2.6.37
Message-ID: <20101028004102.GG4543@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  to get ext3 and quota fixes for 2.6.37. Shortlog is below:

Andrea Gelmini (2):
      ext2: fixed typo.
      jbd/2: fixed typos

Darrick J. Wong (1):
      ext3/jbd: Avoid WARN() messages when failing to write the superblock

Dmitry (1):
      quota: fix dquot_disable vs dquot_transfer race v2

Jan Kara (4):
      quota: Make QUOTACTL config be selected by its users
      ext3: Fix lost extented attributes for inode with ino == 11
      quota: Fix issuing of warnings from dquot_transfer
      quota: Fix possible oops in __dquot_initialize()

Namhyung Kim (16):
      ext2: fix comment on ext2_try_to_allocate()
      jbd: Move debug message into #ifdef area
      jbd: Use printk_ratelimited() in journal_alloc_journal_head()
      jbd: Remove unnecessary goto statement
      jbd: Use offset_in_page() instead of manual calculation
      jbd: Convert bitops to buffer fns
      ext3: Cleanup ext3_setup_super()
      ext3: Remove unnecessary casts on bh->b_data
      ext3: Return proper error code on ext3_fill_super()
      ext3: Use DIV_ROUND_UP() on group desc block counting
      jbd: Check return value of __getblk()
      jbd: Fix debug message in do_get_write_access()
      ext3: Remove misplaced BUFFER_TRACE() in ext3_truncate()
      jbd: Convert atomic_inc() to get_bh()
      ext3: Fix debug messages in ext3_group_extend()
      ext3: Update kernel-doc comments

The diffstat is

 fs/ext2/balloc.c     |    3 +--
 fs/ext2/inode.c      |    2 +-
 fs/ext3/balloc.c     |   17 ++++++++++-------
 fs/ext3/ialloc.c     |   11 ++++++++---
 fs/ext3/inode.c      |   20 ++++++++++++--------
 fs/ext3/resize.c     |   13 +++++++------
 fs/ext3/super.c      |   41 ++++++++++++++++++++++++++++++++---------
 fs/jbd/checkpoint.c  |    4 ++--
 fs/jbd/commit.c      |    8 ++++----
 fs/jbd/journal.c     |   44 +++++++++++++++++++++++++++++++++++---------
 fs/jbd/recovery.c    |    2 +-
 fs/jbd/transaction.c |    6 ++----
 fs/jbd2/journal.c    |    2 +-
 fs/quota/Kconfig     |    4 ++--
 fs/quota/dquot.c     |   30 +++++++++++++++++++-----------
 fs/xfs/Kconfig       |    1 +
 16 files changed, 138 insertions(+), 70 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
