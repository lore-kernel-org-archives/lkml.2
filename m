Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052Ab2FEL2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:28:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:50403 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab2FEL1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:27:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="151777558"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] affs: remove useless superblock writeout on unmount
Date: Tue,  5 Jun 2012 14:28:10 +0300
Message-Id: <1338895695-10362-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338895695-10362-1-git-send-email-dedekind1@gmail.com>
References: <1338895695-10362-1-git-send-email-dedekind1@gmail.com>
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
index 698282a..db184c0 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -45,9 +45,6 @@ affs_put_super(struct super_block *sb)
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

