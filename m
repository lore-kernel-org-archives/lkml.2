Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab2LTQmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 11:42:44 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37725 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab2LTQmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 11:42:38 -0500
From: Ravishankar N <cyberax82@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ravishankar N <cyberax82@gmail.com>,
        Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH RESEND 1/1] fat:fix incorrect function comment
Date: Thu, 20 Dec 2012 21:41:36 +0530
Message-Id: <1356019896-22655-1-git-send-email-cyberax82@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fat_search_long() returns 0 on success, -ENOENT/ENOMEM on failure.Change
the function comment accordingly.

While at it, fix some trivial typos.

v2 changes:add a FIXME note according to review comment.
	modified:   fs/fat/dir.c
	modified:   fs/fat/inode.c
	modified:   fs/fat/misc.c

Signed-off-by: Ravishankar N <cyberax82@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/fat/dir.c   |    5 ++---
 fs/fat/inode.c |    2 +-
 fs/fat/misc.c  |    4 ++++
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 2a18234..58bf744 100644
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
index 5eb600d..359d307 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -135,6 +135,10 @@ int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster)
 		}
 		if (ret < 0)
 			return ret;
+		/*
+		 * FIXME:Although we can add this cache, fat_cache_add() is
+		 * assuming to be called after linear search with fat_cache_id.
+		 */
 //		fat_cache_add(inode, new_fclus, new_dclus);
 	} else {
 		MSDOS_I(inode)->i_start = new_dclus;
-- 
1.7.7

