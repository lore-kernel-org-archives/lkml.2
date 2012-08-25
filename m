Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2HYIYz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 04:24:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44867 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab2HYIX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 04:23:56 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 3/3] fat: simplify writeback_inode function.
Date: Sat, 25 Aug 2012 04:23:46 -0400
Message-Id: <1345883026-6297-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify writeback_inode function.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
---
 fs/fat/inode.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 973296b..4bbb24e 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1457,18 +1457,14 @@ static int writeback_inode(struct inode *inode)
 {
 
 	int ret;
-	struct address_space *mapping = inode->i_mapping;
-	struct writeback_control wbc = {
-	       .sync_mode = WB_SYNC_NONE,
-	      .nr_to_write = 0,
-	};
-	/* if we used WB_SYNC_ALL, sync_inode waits for the io for the
-	* inode to finish.  So WB_SYNC_NONE is sent down to sync_inode
+
+	/* if we used wait=1, sync_inode_metadata waits for the io for the
+	* inode to finish.  So wait=0 is sent down to sync_inode_metadata
 	* and filemap_fdatawrite is used for the data blocks
 	*/
-	ret = sync_inode(inode, &wbc);
+	ret = sync_inode_metadata(inode, 0);
 	if (!ret)
-	       ret = filemap_fdatawrite(mapping);
+	       ret = filemap_fdatawrite(inode->i_mapping);
 	return ret;
 }
 
-- 
1.7.9.5

