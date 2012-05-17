Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761861Ab2EQMwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:52:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761778Ab2EQMsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:37 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/24] GFS2: Change variable blk to biblk
Date: Thu, 17 May 2012 13:23:15 +0100
Message-Id: <1337257411-3173-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

In the resource group code, we have no less than three different
kinds of block references: block relative to the file system (u64),
block relative to the rgrp (u32), and block relative to the bitmap.
This is a small step to making the code more readable; it renames
variable blk to biblk to solidify in my mind that it's relative to
the bitmap and nothing else.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 5968eae..7a1cf67 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1297,7 +1297,7 @@ static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal, unsigned char state,
 {
 	struct gfs2_bitmap *bi = NULL;
 	const u32 length = rgd->rd_length;
-	u32 blk = BFITNOENT;
+	u32 biblk = BFITNOENT;
 	unsigned int buf, x;
 	const u8 *buffer = NULL;
 
@@ -1334,8 +1334,8 @@ do_search:
 		if (state != GFS2_BLKST_UNLINKED && bi->bi_clone)
 			buffer = bi->bi_clone + bi->bi_offset;
 
-		blk = gfs2_bitfit(buffer, bi->bi_len, goal, state);
-		if (blk != BFITNOENT)
+		biblk = gfs2_bitfit(buffer, bi->bi_len, goal, state);
+		if (biblk != BFITNOENT)
 			break;
 
 		if ((goal == 0) && (state == GFS2_BLKST_FREE))
@@ -1348,10 +1348,10 @@ skip:
 		goal = 0;
 	}
 
-	if (blk != BFITNOENT)
+	if (biblk != BFITNOENT)
 		*rbi = bi;
 
-	return blk;
+	return biblk;
 }
 
 /**
-- 
1.7.4

