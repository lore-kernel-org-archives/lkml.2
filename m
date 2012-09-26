Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab2IZLir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 07:38:47 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:42913 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab2IZLip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 07:38:45 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] fs/block_dev.c: need not to check inode->i_bdev in bd_forget()
Date: Wed, 26 Sep 2012 19:38:28 +0800
Message-Id: <1348659510-9059-1-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its only caller evict() has promised a non-NULL inode->i_bdev.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 fs/block_dev.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 38e721b..9bdbd9b 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -669,11 +669,9 @@ void bd_forget(struct inode *inode)
 	struct block_device *bdev = NULL;
 
 	spin_lock(&bdev_lock);
-	if (inode->i_bdev) {
-		if (!sb_is_blkdev_sb(inode->i_sb))
-			bdev = inode->i_bdev;
-		__bd_forget(inode);
-	}
+	if (!sb_is_blkdev_sb(inode->i_sb))
+		bdev = inode->i_bdev;
+	__bd_forget(inode);
 	spin_unlock(&bdev_lock);
 
 	if (bdev)
-- 
1.7.9.5

