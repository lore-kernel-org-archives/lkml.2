Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab2LHFyq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 00:54:46 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48155 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab2LHFyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 00:54:44 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 3/5] f2fs: remove redundant call to f2fs_put_page in delete entry
Date: Sat,  8 Dec 2012 14:54:35 +0900
Message-Id: <1354946075-7618-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Since, we anyway need to put the page after deleting entry. So, there is no
need to make same call under different conditions.
Move out the f2fs_put_page from the two conditions and call at once.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/dir.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 2a20c50..fc02d8b 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -514,10 +514,9 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 		ClearPageUptodate(page);
 		dec_page_count(sbi, F2FS_DIRTY_DENTS);
 		inode_dec_dirty_dents(dir);
-		f2fs_put_page(page, 1);
-	} else {
-		f2fs_put_page(page, 1);
 	}
+	f2fs_put_page(page, 1);
+
 	mutex_unlock_op(sbi, DENTRY_OPS);
 }
 
-- 
1.7.9.5

