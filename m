Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab2C0Jpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 05:45:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757895Ab2C0Jpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 05:45:50 -0400
Date: Tue, 27 Mar 2012 11:45:38 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] ext3, UDF, and quota fixes
Message-ID: <20120327094538.GC5020@quack.suse.cz>
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

to get a couple of ext3 & UDF fixes and also one improvement in quota locking.
Top of the tree is e703c20. The full shortlog is:

Jan Kara (3):
      quota: Make quota code not call tty layer with dqptr_sem held
      udf: Fix handling of i_blocks
      udf: Fix deadlock in udf_release_file()

Joe Perches (1):
      udf: Remove unnecessary OOM messages

Kazuya Mio (2):
      ext3: Don't call dquot_free_block() if we don't update anything
      ext3: Update ctime in ext3_splice_branch() only when needed

Lukas Czerner (1):
      ext3: fix start and len arguments handling in ext3_trim_fs()

Steve Nickel (2):
      udf: Init/maintain file entry checkpoint field
      udf: Fix file entry logicalBlocksRecorded

The diffstat is

 fs/ext3/balloc.c |   84 +++++++++++++-----------
 fs/ext3/inode.c  |    9 ++-
 fs/quota/dquot.c |  189 ++++++++++++++++++++++++++++++++----------------------
 fs/udf/balloc.c  |   84 +++++++++++++-----------
 fs/udf/file.c    |    2 -
 fs/udf/ialloc.c  |    1 +
 fs/udf/inode.c   |   20 ++++--
 fs/udf/super.c   |    5 +-
 fs/udf/udf_i.h   |    1 +
 9 files changed, 226 insertions(+), 169 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
