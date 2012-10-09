Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab2JIPJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:09:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43808 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab2JIPJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:09:38 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: [PATCH 3/6] udf: update inode's iblock count when allocating new block
Date: Wed, 10 Oct 2012 00:09:28 +0900
Message-Id: <1349795368-6425-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Currently, du will show wrong block count. This patch fix it.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/udf/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 8266f2e..76a1f57 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -775,6 +775,8 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
 		if (isBeyondEOF)
 			iinfo->i_lenExtents += inode->i_sb->s_blocksize;
 	}
+	/* update inode's iblocks */
+	inode->i_blocks += (1 << (inode->i_sb->s_blocksize_bits - 9));
 
 	/* if the extent the requsted block is located in contains multiple
 	 * blocks, split the extent into at most three extents. blocks prior
-- 
1.7.9.5

