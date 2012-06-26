Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab2FZODt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 10:03:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52963 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830Ab2FZODs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 10:03:48 -0400
From: Ashish Sangwan <ashishsangwan2@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ashish Sangwan <ashish.sangwan2@gmail.com>,
        Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] UDF: Remove unnecessary variable "offset" from udf_fill_inode
Date: Tue, 26 Jun 2012 19:33:11 +0530
Message-Id: <1340719391-3081-1-git-send-email-ashish.sangwan2@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable "offset" is not needed. Remove it.

Signed-off-by: Ashish Sangwan <ashish.sangwan2@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/udf/inode.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 873e1ba..fafaad7 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1247,7 +1247,6 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 {
 	struct fileEntry *fe;
 	struct extendedFileEntry *efe;
-	int offset;
 	struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
 	struct udf_inode_info *iinfo = UDF_I(inode);
 	unsigned int link_count;
@@ -1359,7 +1358,6 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 		iinfo->i_lenEAttr = le32_to_cpu(fe->lengthExtendedAttr);
 		iinfo->i_lenAlloc = le32_to_cpu(fe->lengthAllocDescs);
 		iinfo->i_checkpoint = le32_to_cpu(fe->checkpoint);
-		offset = sizeof(struct fileEntry) + iinfo->i_lenEAttr;
 	} else {
 		inode->i_blocks = le64_to_cpu(efe->logicalBlocksRecorded) <<
 		    (inode->i_sb->s_blocksize_bits - 9);
@@ -1381,8 +1379,6 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 		iinfo->i_lenEAttr = le32_to_cpu(efe->lengthExtendedAttr);
 		iinfo->i_lenAlloc = le32_to_cpu(efe->lengthAllocDescs);
 		iinfo->i_checkpoint = le32_to_cpu(efe->checkpoint);
-		offset = sizeof(struct extendedFileEntry) +
-							iinfo->i_lenEAttr;
 	}
 
 	switch (fe->icbTag.fileType) {
-- 
1.7.2.3

