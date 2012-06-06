Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab2FFPzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:55:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:47640 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836Ab2FFPzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:55:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161755278"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/7] affs: remove useless superblock writeout on unmount
Date: Wed,  6 Jun 2012 18:56:52 +0300
Message-Id: <1338998217-5010-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338998217-5010-1-git-send-email-dedekind1@gmail.com>
References: <1338998217-5010-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

We do not need to write out the superblock from '->put_super()' because VFS has
already called '->sync_fs()' by this time and the superblock has already been
written out. Thus, remove the 'affs_commit_super()' infocation from
'affs_put_super()'.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/affs/super.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index 1d42e46..12b4f58 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -44,9 +44,6 @@ affs_put_super(struct super_block *sb)
 	struct affs_sb_info *sbi = AFFS_SB(sb);
 	pr_debug("AFFS: put_super()\n");
 
-	if (!(sb->s_flags & MS_RDONLY) && sb->s_dirt)
-		affs_commit_super(sb, 1);
-
 	kfree(sbi->s_prefix);
 	affs_free_bitmap(sb);
 	affs_brelse(sbi->s_root_bh);
-- 
1.7.7.6

