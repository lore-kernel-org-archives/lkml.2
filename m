Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab2LHFya (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 00:54:30 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:53124 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2LHFy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 00:54:28 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 2/5] f2fs: make use of GFP_F2FS_ZERO for setting gfp_mask
Date: Sat,  8 Dec 2012 14:54:18 +0900
Message-Id: <1354946058-7584-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Since, GFP_NOFS and __GFP_ZERO is being used to set gfp_mask.
We can instead make use of already predefined macro GFP_F2FS_ZERO.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 2d720ca..89b7675 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -293,7 +293,7 @@ static int f2fs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	inode->i_op = &f2fs_dir_inode_operations;
 	inode->i_fop = &f2fs_dir_operations;
 	inode->i_mapping->a_ops = &f2fs_dblock_aops;
-	mapping_set_gfp_mask(inode->i_mapping, GFP_NOFS | __GFP_ZERO);
+	mapping_set_gfp_mask(inode->i_mapping, GFP_F2FS_ZERO);
 
 	set_inode_flag(F2FS_I(inode), FI_INC_LINK);
 	err = f2fs_add_link(dentry, inode);
-- 
1.7.9.5

