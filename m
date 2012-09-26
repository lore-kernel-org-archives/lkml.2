Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab2IZLiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 07:38:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65507 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952Ab2IZLiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 07:38:52 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 3/3] fs/fs-writeback.c: remove unneccesary parameter of __writeback_single_inode()
Date: Wed, 26 Sep 2012 19:38:30 +0800
Message-Id: <1348659510-9059-3-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348659510-9059-1-git-send-email-clouds.yan@gmail.com>
References: <1348659510-9059-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parameter 'wb' is never used in this function.

Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 fs/fs-writeback.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index be3efc4..da746e8 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -438,8 +438,7 @@ static void requeue_inode(struct inode *inode, struct bdi_writeback *wb,
  * setting I_SYNC flag and calling inode_sync_complete() to clear it.
  */
 static int
-__writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
-			 struct writeback_control *wbc)
+__writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct address_space *mapping = inode->i_mapping;
 	long nr_to_write = wbc->nr_to_write;
@@ -526,7 +525,7 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 	inode->i_state |= I_SYNC;
 	spin_unlock(&inode->i_lock);
 
-	ret = __writeback_single_inode(inode, wb, wbc);
+	ret = __writeback_single_inode(inode, wbc);
 
 	spin_lock(&wb->list_lock);
 	spin_lock(&inode->i_lock);
@@ -673,7 +672,7 @@ static long writeback_sb_inodes(struct super_block *sb,
 		 * We use I_SYNC to pin the inode in memory. While it is set
 		 * evict_inode() will wait so the inode cannot be freed.
 		 */
-		__writeback_single_inode(inode, wb, &wbc);
+		__writeback_single_inode(inode, &wbc);
 
 		work->nr_pages -= write_chunk - wbc.nr_to_write;
 		wrote += write_chunk - wbc.nr_to_write;
-- 
1.7.9.5

