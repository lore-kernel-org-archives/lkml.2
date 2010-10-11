Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab0JKKiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 06:38:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42902 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab0JKKit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 06:38:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ud3Ns2zHAhSScTEGyiZ0891w453xrJq6KDW/NHTAUDo5LLBy3GMyoElKgvoX4jdl07
         qvkxbYrGs+UXhd6P+b06jDvyV0bfYw6Xw569vABLrAffFqdM+aFLmRDlT47p5fUcD4Vw
         bc8rl2xzf0Bay3nxuEcyO9xQhKkSFVG/pbYVs=
From: Namhyung Kim <namhyung@gmail.com>
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext3: Use DIV_ROUND_UP() on group desc block counting
Date: Mon, 11 Oct 2010 19:38:39 +0900
Message-Id: <1286793519-3774-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ext3/super.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 75bbf77..3fce402 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1864,8 +1864,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	sbi->s_groups_count = ((le32_to_cpu(es->s_blocks_count) -
 			       le32_to_cpu(es->s_first_data_block) - 1)
 				       / EXT3_BLOCKS_PER_GROUP(sb)) + 1;
-	db_count = (sbi->s_groups_count + EXT3_DESC_PER_BLOCK(sb) - 1) /
-		   EXT3_DESC_PER_BLOCK(sb);
+	db_count = DIV_ROUND_UP(sbi->s_groups_count, EXT3_DESC_PER_BLOCK(sb));
 	sbi->s_group_desc = kmalloc(db_count * sizeof (struct buffer_head *),
 				    GFP_KERNEL);
 	if (sbi->s_group_desc == NULL) {
-- 
1.7.0.4

