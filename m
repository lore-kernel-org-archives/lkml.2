Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab2LVDQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 22:16:24 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:60022 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab2LVDQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 22:16:19 -0500
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2012 22:16:18 EST
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 5/5] f2fs: remove unneeded variable from f2fs_sync_fs
Date: Sat, 22 Dec 2012 12:10:27 +0900
Message-Id: <1356145828-20083-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

We can directly return '0' from the function, instead of introducing a
'ret' variable.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 86f8549..39ba11a 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -119,7 +119,6 @@ static void f2fs_put_super(struct super_block *sb)
 int f2fs_sync_fs(struct super_block *sb, int sync)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
-	int ret = 0;
 
 	if (!sbi->s_dirty && !get_pages(sbi, F2FS_DIRTY_NODES))
 		return 0;
@@ -127,7 +126,7 @@ int f2fs_sync_fs(struct super_block *sb, int sync)
 	if (sync)
 		write_checkpoint(sbi, false, false);
 
-	return ret;
+	return 0;
 }
 
 static int f2fs_statfs(struct dentry *dentry, struct kstatfs *buf)
-- 
1.7.9.5

