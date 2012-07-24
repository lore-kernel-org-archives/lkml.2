Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab2GXWbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 18:31:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126Ab2GXWbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 18:31:19 -0400
Date: Wed, 25 Jul 2012 00:31:17 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: [PULL REQUEST] UDF, ext3, isofs fixes for 3.6-rc1
Message-ID: <20120724223117.GA9508@quack.suse.cz>
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

To get assorted, mostly trivial fixes, for udf, ext2, ext3, and isofs. I'm
on vacation and scarcely checking email since we are expecting baby any day
now but these fixes should be safe to go in and I don't want to delay them
unnecessarily.

Top of the tree is 0143fc5. The full shortlog is:

Artem Bityutskiy (1):
      udf: stop using s_dirt

Ashish Sangwan (1):
      UDF: Remove unnecessary variable "offset" from udf_fill_inode

Eric Sandeen (1):
      ext3: force ro mount if ext3_setup_super() fails

Jan Kara (5):
      udf: Fix memory leak when mounting
      udf: Do not decrement i_blocks when freeing indirect extent block
      jbd: Check return value of blkdev_issue_flush()
      ext3: Check return value of blkdev_issue_flush()
      udf: Improve table length check to avoid possible overflow

Jeff Liu (1):
      quota: fix checkpatch.pl warning by replacing <asm/uaccess.h> with <linux/uaccess.h>

Mathias Krause (2):
      isofs: avoid info leak on export
      udf: avoid info leak on export

Wanlong Gao (1):
      ext2: cleanup the confused goto label

The diffstat is

 fs/ext2/super.c   |    6 +-
 fs/ext3/fsync.c   |    9 +++-
 fs/ext3/super.c   |    3 +-
 fs/isofs/export.c |    1 +
 fs/jbd/recovery.c |    7 ++-
 fs/quota/dquot.c  |    2 +-
 fs/quota/quota.c  |    2 +-
 fs/udf/inode.c    |    4 --
 fs/udf/namei.c    |    1 +
 fs/udf/super.c    |  130 ++++++++++++++++++++++++++--------------------------
 fs/udf/truncate.c |    4 +-
 fs/udf/udfdecl.h  |    1 -
 12 files changed, 88 insertions(+), 82 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
