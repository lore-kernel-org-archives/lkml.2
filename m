Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab0E0UnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:43:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:39444 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab0E0Um7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:42:59 -0400
Date: Thu, 27 May 2010 22:42:44 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PULL REQUEST] Quota mount handling and various fixes
Message-ID: <20100527204244.GF3576@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hello Linus,

  this changeset contains Christoph's quota mount handling reorg series,
removal of dead quota code from UDF, UFS, pohmelfs and a couple of fixes.
The tree has now sustained some xfsqa runs for ext2, ext3, ext4, and
reiserfs so hopefully no new bugs are introduced.
  Could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  to get:

Christoph Hellwig (6):
      quota: move remount handling into the filesystem
      quota: kill the vfs_dq_off and vfs_dq_quota_on_remount wrappers
      quota: move unmount handling into the filesystem
      quota: drop remount argument to ->quota_on and ->quota_off
      quota: explicitly set ->dq_op and ->s_qcop
      quota: rename default quotactl methods to dquot_

Dmitry Monakhov (2):
      pohmelfs: Remove dead quota code
      quota: Convert quota statistics to generic percpu_counter

Jan Kara (5):
      ocfs2: Fix use after free on remount read-only
      udf: Remove dead quota code
      ufs: Remove dead quota code
      reiserfs: Fix resuming of quotas on remount read-write
      quota: Fixup dquot_transfer

Venkatesh Pallipadi (1):
      ext3 uses rb_node = NULL; to zero rb_root.

The diffstat is

 drivers/staging/pohmelfs/inode.c |    8 --
 fs/ext2/super.c                  |   20 ++++
 fs/ext3/dir.c                    |    2 +-
 fs/ext3/super.c                  |   38 +++++---
 fs/ext4/super.c                  |   37 +++++---
 fs/jfs/super.c                   |   16 +++
 fs/ocfs2/super.c                 |   50 +++++------
 fs/quota/dquot.c                 |  190 ++++++++++++++++----------------------
 fs/quota/quota.c                 |    4 +-
 fs/reiserfs/super.c              |   48 ++++++----
 fs/super.c                       |   13 +--
 fs/udf/balloc.c                  |   43 +--------
 fs/udf/file.c                    |   26 +-----
 fs/udf/ialloc.c                  |   21 +----
 fs/udf/inode.c                   |    5 -
 fs/udf/namei.c                   |   20 ----
 fs/udf/super.c                   |   13 ++-
 fs/udf/udfdecl.h                 |    1 -
 fs/ufs/balloc.c                  |   24 -----
 fs/ufs/file.c                    |    3 +-
 fs/ufs/ialloc.c                  |   13 ---
 fs/ufs/inode.c                   |    4 -
 fs/ufs/namei.c                   |   16 ---
 fs/ufs/super.c                   |  110 +----------------------
 fs/ufs/truncate.c                |   10 --
 include/linux/quota.h            |   20 +---
 include/linux/quotaops.h         |   79 +++++++---------
 27 files changed, 274 insertions(+), 560 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
