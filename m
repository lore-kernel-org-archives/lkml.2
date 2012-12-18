Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab2LRQw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 11:52:29 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46647 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab2LRQw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 11:52:28 -0500
From: Ravishankar N <cyberax82@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ravishankar N <cyberax82@gmail.com>,
        Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 1/1] fat:fix incorrect function comment
Date: Tue, 18 Dec 2012 22:20:19 +0530
Message-Id: <1355849419-26403-1-git-send-email-cyberax82@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fat_search_long() returns 0 on success, -ENOENT/ENOMEM on failure.Change
the function comment accordingly.

While at it, fix some trivial typos.
	modified:   fs/fat/dir.c
	modified:   fs/fat/inode.c
	modified:   fs/fat/misc.c

Signed-off-by: Ravishankar N <cyberax82@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/fat/dir.c   |    7 +++----
 fs/fat/inode.c |    2 +-
 fs/fat/misc.c  |    1 -
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 2a18234..b56e61a 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -461,8 +461,7 @@ static int fat_parse_short(struct super_block *sb,
 }
 
 /*
- * Return values: negative -> error, 0 -> not found, positive -> found,
- * value is the total amount of slots, including the shortname entry.
+ * Return values: negative -> error/not found, 0 -> found.
  */
 int fat_search_long(struct inode *inode, const unsigned char *name,
 		    int name_len, struct fat_slot_info *sinfo)
@@ -1176,7 +1175,7 @@ static int fat_add_new_entries(struct inode *dir, void *slots, int nr_slots,
 
 	/*
 	 * The minimum cluster size is 512bytes, and maximum entry
-	 * size is 32*slots (672bytes).  So, iff the cluster size is
+	 * size is 32*slots (672bytes).  So, if the cluster size is
 	 * 512bytes, we may need two clusters.
 	 */
 	size = nr_slots * sizeof(struct msdos_dir_entry);
@@ -1255,7 +1254,7 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 
 	sinfo->nr_slots = nr_slots;
 
-	/* First stage: search free direcotry entries */
+	/* First stage: search free directory entries */
 	free_slots = nr_bhs = 0;
 	bh = prev = NULL;
 	pos = 0;
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 3580681..f8f4916 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1344,7 +1344,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 	sbi->dir_entries = get_unaligned_le16(&b->dir_entries);
 	if (sbi->dir_entries & (sbi->dir_per_block - 1)) {
 		if (!silent)
-			fat_msg(sb, KERN_ERR, "bogus directroy-entries per block"
+			fat_msg(sb, KERN_ERR, "bogus directory-entries per block"
 			       " (%u)", sbi->dir_entries);
 		brelse(bh);
 		goto out_invalid;
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 5eb600d..e29ec41 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -135,7 +135,6 @@ int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster)
 		}
 		if (ret < 0)
 			return ret;
-//		fat_cache_add(inode, new_fclus, new_dclus);
 	} else {
 		MSDOS_I(inode)->i_start = new_dclus;
 		MSDOS_I(inode)->i_logstart = new_dclus;
-- 
1.7.7

