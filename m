Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab2LAB4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 20:56:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36191 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab2LAB4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 20:56:32 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 6/6] f2fs: move error condition for mkdir at proper place
Date: Sat,  1 Dec 2012 10:56:25 +0900
Message-Id: <1354326985-6826-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

In function f2fs_mkdir, err is being initialized without even checking
if there was any error in new inode creation. So, instead check the
inode error and make use of error/return condition.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/namei.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 63efd77..2d720ca 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -287,9 +287,8 @@ static int f2fs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	int err;
 
 	inode = f2fs_new_inode(dir, S_IFDIR | mode);
-	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
-		return err;
+		return PTR_ERR(inode);
 
 	inode->i_op = &f2fs_dir_inode_operations;
 	inode->i_fop = &f2fs_dir_operations;
-- 
1.7.9.5

