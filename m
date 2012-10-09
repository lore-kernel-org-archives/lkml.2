Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab2JIPKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:10:04 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60577 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab2JIPJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:09:55 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: [PATCH 4/6] udf: remove un-needed variable from inode_getblk
Date: Wed, 10 Oct 2012 00:09:44 +0900
Message-Id: <1349795384-6461-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

The variable last_block is not needed.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/udf/inode.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 76a1f57..6fd9dc5 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -587,7 +587,6 @@ out:
 static sector_t inode_getblk(struct inode *inode, sector_t block,
 			     int *err, int *new)
 {
-	static sector_t last_block;
 	struct kernel_long_ad laarr[EXTENT_MERGE_SIZE];
 	struct extent_position prev_epos, cur_epos, next_epos;
 	int count = 0, startnum = 0, endnum = 0;
@@ -677,7 +676,6 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
 		return newblock;
 	}
 
-	last_block = block;
 	/* Are we beyond EOF? */
 	if (etype == -1) {
 		int ret;
@@ -719,7 +717,6 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
 			memset(&laarr[c].extLocation, 0x00,
 				sizeof(struct kernel_lb_addr));
 			count++;
-			endnum++;
 		}
 		endnum = c + 1;
 		lastblock = 1;
-- 
1.7.9.5

