Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab2JIPJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:09:10 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36739 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab2JIPJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:09:06 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: [PATCH 1/6] udf: fix memory leak while allocating blocks during write
Date: Wed, 10 Oct 2012 00:08:56 +0900
Message-Id: <1349795336-6353-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Need to brelse the buffer_head stored in cur_epos and next_epos.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/udf/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index df88b95..2b77593 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -765,6 +765,8 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
 				goal, err);
 		if (!newblocknum) {
 			brelse(prev_epos.bh);
+			brelse(cur_epos.bh);
+			brelse(next_epos.bh);
 			*err = -ENOSPC;
 			return 0;
 		}
@@ -795,6 +797,8 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
 	udf_update_extents(inode, laarr, startnum, endnum, &prev_epos);
 
 	brelse(prev_epos.bh);
+	brelse(cur_epos.bh);
+	brelse(next_epos.bh);
 
 	newblock = udf_get_pblock(inode->i_sb, newblocknum,
 				iinfo->i_location.partitionReferenceNum, 0);
-- 
1.7.9.5

