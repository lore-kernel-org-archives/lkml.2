Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab2KKN6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 08:58:39 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64380 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab2KKN6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 08:58:37 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 3/3] fat: remove unneeded compare condition for __fat_write_inode
Date: Sun, 11 Nov 2012 22:58:24 +0900
Message-Id: <1352642304-2766-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In calling of __fat_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL),
expression "wbc->sync_mode == WB_SYNC_ALL" will always be equivalent to value
of wbc->sync_mode. So, remove this additional compare condition from function
arguments.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
---
 fs/fat/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 7b186a5..aa0138b 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -678,7 +678,7 @@ static int fat_write_inode(struct inode *inode, struct writeback_control *wbc)
 		err = fat_clusters_flush(sb);
 		mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	} else
-		err = __fat_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
+		err = __fat_write_inode(inode, wbc->sync_mode);
 
 	return err;
 }
-- 
1.7.9.5

