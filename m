Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab2AaWmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 17:42:51 -0500
Received: from [206.117.179.246] ([206.117.179.246]:54032 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753671Ab2AaWmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 17:42:49 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org
Subject: [PATCH 3/4] reiserfs: Remove unnecessary OOM messages
Date: Tue, 31 Jan 2012 14:42:09 -0800
Message-Id: <834c12e42fb10a1c6587c51c48d85698fe339db7.1328049542.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1328049542.git.joe@perches.com>
References: <cover.1328049542.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per call site OOM messages are unnecessary.
k.alloc and v.alloc failures use dump_stack().

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/reiserfs/journal.c |    8 ++------
 fs/reiserfs/resize.c  |    1 -
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index c3cf54f..66bdea8 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -293,8 +293,6 @@ int reiserfs_allocate_list_bitmaps(struct super_block *sb,
 		jb->journal_list = NULL;
 		jb->bitmaps = vzalloc(mem);
 		if (!jb->bitmaps) {
-			reiserfs_warning(sb, "clm-2000", "unable to "
-					 "allocate bitmaps for journal lists");
 			failed = 1;
 			break;
 		}
@@ -2679,11 +2677,9 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
 	int ret;
 
 	journal = SB_JOURNAL(sb) = vzalloc(sizeof(struct reiserfs_journal));
-	if (!journal) {
-		reiserfs_warning(sb, "journal-1256",
-				 "unable to get memory for journal structure");
+	if (!journal)
 		return 1;
-	}
+
 	INIT_LIST_HEAD(&journal->j_bitmap_nodes);
 	INIT_LIST_HEAD(&journal->j_prealloc_list);
 	INIT_LIST_HEAD(&journal->j_working_list);
diff --git a/fs/reiserfs/resize.c b/fs/reiserfs/resize.c
index 7483279..d688aea 100644
--- a/fs/reiserfs/resize.c
+++ b/fs/reiserfs/resize.c
@@ -115,7 +115,6 @@ int reiserfs_resize(struct super_block *s, unsigned long block_count_new)
 		if (!bitmap) {
 			/* Journal bitmaps are still supersized, but the memory isn't
 			 * leaked, so I guess it's ok */
-			printk("reiserfs_resize: unable to allocate memory.\n");
 			return -ENOMEM;
 		}
 		for (i = 0; i < bmap_nr; i++)
-- 
1.7.8.111.gad25c.dirty

