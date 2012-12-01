Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab2LABzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 20:55:54 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:39596 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2LABzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 20:55:53 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 3/6] f2fs: remove unneeded memset from init_once
Date: Sat,  1 Dec 2012 10:55:45 +0900
Message-Id: <1354326945-6724-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Since, __GFP_ZERO is used while f2fs inode allocation, so we do not
need memset for f2fs_inode_info, as this is already zeroed out.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/super.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index c72e517..41ed943 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -57,7 +57,6 @@ static void init_once(void *foo)
 {
 	struct f2fs_inode_info *fi = (struct f2fs_inode_info *) foo;
 
-	memset(fi, 0, sizeof(*fi));
 	inode_init_once(&fi->vfs_inode);
 }
 
-- 
1.7.9.5

