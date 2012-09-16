Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab2IPMWi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 08:22:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46740 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab2IPMWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 08:22:37 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v3 2/5] fat: allocate persistent inode numbers
Date: Sun, 16 Sep 2012 08:22:28 -0400
Message-Id: <1347798148-2660-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

All the files on a FAT partition have an on-disk directory entry.
The location of these entries, i_pos, is unique and is constructed by
the fat_make_i_pos() function.We can use this as the inode number making
it persistent across remounts.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/inode.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 2689ef5..c3dad9b 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -458,7 +458,10 @@ struct inode *fat_build_inode(struct super_block *sb,
 		inode = ERR_PTR(-ENOMEM);
 		goto out;
 	}
-	inode->i_ino = iunique(sb, MSDOS_ROOT_INO);
+	if (MSDOS_SB(sb)->options.nfs == FAT_NFS_LIMITED)
+		inode->i_ino = i_pos;
+	else
+		inode->i_ino = iunique(sb, MSDOS_ROOT_INO);
 	inode->i_version = 1;
 	err = fat_fill_inode(inode, de);
 	if (err) {
-- 
1.7.9.5

