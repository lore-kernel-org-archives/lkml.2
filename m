Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab2LAB4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 20:56:24 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54054 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab2LAB4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 20:56:21 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 5/6] f2fs: remove unneeded initialization
Date: Sat,  1 Dec 2012 10:56:13 +0900
Message-Id: <1354326973-6792-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

No need to initialize  "struct f2fs_gc_kthread *gc_th = NULL",
as gc_th = NULL, will be taken care by the return values of kmalloc().
And fix codes in other places.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/gc.c      |    2 +-
 fs/f2fs/segment.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 3271be4..644aa38 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -89,7 +89,7 @@ static int gc_thread_func(void *data)
 
 int start_gc_thread(struct f2fs_sb_info *sbi)
 {
-	struct f2fs_gc_kthread *gc_th = NULL;
+	struct f2fs_gc_kthread *gc_th;
 
 	gc_th = kmalloc(sizeof(struct f2fs_gc_kthread), GFP_KERNEL);
 	if (!gc_th)
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index a177eb3..969df1a 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1489,7 +1489,7 @@ static int build_free_segmap(struct f2fs_sb_info *sbi)
 
 static int build_curseg(struct f2fs_sb_info *sbi)
 {
-	struct curseg_info *array = NULL;
+	struct curseg_info *array;
 	int i;
 
 	array = kzalloc(sizeof(*array) * NR_CURSEG_TYPE, GFP_KERNEL);
@@ -1656,7 +1656,7 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
 {
 	struct f2fs_super_block *raw_super = F2FS_RAW_SUPER(sbi);
 	struct f2fs_checkpoint *ckpt = F2FS_CKPT(sbi);
-	struct f2fs_sm_info *sm_info = NULL;
+	struct f2fs_sm_info *sm_info;
 	int err;
 
 	sm_info = kzalloc(sizeof(struct f2fs_sm_info), GFP_KERNEL);
-- 
1.7.9.5

