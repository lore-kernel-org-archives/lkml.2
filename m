Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab2HaQsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:48:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49389 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab2HaQsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:48:20 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH] fat: remove redundent call to fat_detach in vfat_unlink
Date: Fri, 31 Aug 2012 12:48:07 -0400
Message-Id: <1346431688-3544-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As after file is removed fat_evict_inode will be called and fat_detach will be called from that place. So, fat_detach can be removed from vfat_unlink

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
---
 fs/fat/namei_vfat.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index e535dd7..37be82e 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -852,7 +852,6 @@ static int vfat_unlink(struct inode *dir, struct dentry *dentry)
 		goto out;
 	clear_nlink(inode);
 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
-	fat_detach(inode);
 out:
 	unlock_super(sb);
 
-- 
1.7.9.5

