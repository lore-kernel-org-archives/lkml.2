Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab1H3LqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:46:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41469 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab1H3LqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:46:21 -0400
MIME-Version: 1.0
Date: Tue, 30 Aug 2011 19:46:20 +0800
Message-ID: <CAFNq8R4Fbnuk_PnEKxCrNgnVA9w6H+LcSUNLWTqPcsiLquKLcA@mail.gmail.com>
Subject: [PATCH] fix the outdated comment in ext2_nfs_get_inode()
From: Li Haifeng <omycle@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Li Haifeng <omycle@gmail.com>
---
 fs/ext2/super.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 1dd62ed..bda10cf 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -327,10 +327,9 @@ static struct inode *ext2_nfs_get_inode(struct
super_block *sb,
    if (ino > le32_to_cpu(EXT2_SB(sb)->s_es->s_inodes_count))
        return ERR_PTR(-ESTALE);

-   /* iget isn't really right if the inode is currently unallocated!!
-    * ext2_read_inode currently does appropriate checks, but
-    * it might be "neater" to call ext2_get_inode first and check
-    * if the inode is valid.....
+   /*
+    * ext2_iget isn't really right if the inode is currently unallocated!!
+    * And it also does appropriate checks to handle the stale inode.
     */
    inode = ext2_iget(sb, ino);
    if (IS_ERR(inode))
-- 
1.7.4.1
