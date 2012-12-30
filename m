Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab2L3FxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 00:53:21 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:52316 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2L3FxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 00:53:19 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 4/4] f2fs: remove unneeded INIT_LIST_HEAD at few places
Date: Sun, 30 Dec 2012 14:53:08 +0900
Message-Id: <1356846788-7746-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

While creating a new entry for addition to the list(orphan inode list
and fsync inode entry list), there is no need to call HEAD initialization
for these entries. So, remove that init part.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/checkpoint.c |    1 -
 fs/f2fs/recovery.c   |    1 -
 2 files changed, 2 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 6ef36c3..d75c86a 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -214,7 +214,6 @@ retry:
 		goto retry;
 	}
 	new->ino = ino;
-	INIT_LIST_HEAD(&new->list);
 
 	/* add new_oentry into list which is sorted by inode number */
 	if (orphan) {
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index b571fee..502c63d 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -151,7 +151,6 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 				goto out;
 			}
 
-			INIT_LIST_HEAD(&entry->list);
 			list_add_tail(&entry->list, head);
 			entry->blkaddr = blkaddr;
 		}
-- 
1.7.9.5

