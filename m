Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab0KEDJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:09:11 -0400
Received: from mail.perches.com ([173.55.12.10]:4176 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab0KEDJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:09:06 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 40/49] fs/udf: Use vzalloc
Date: Thu,  4 Nov 2010 20:08:04 -0700
Message-Id: <a47fec6f62a102773e28984b86f34525fd42b540.1288925425.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/udf/super.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 4a5c7c6..6e07d99 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -959,9 +959,9 @@ static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, u32 index)
 		(sizeof(struct buffer_head *) * nr_groups);
 
 	if (size <= PAGE_SIZE)
-		bitmap = kmalloc(size, GFP_KERNEL);
+		bitmap = kzalloc(size, GFP_KERNEL);
 	else
-		bitmap = vmalloc(size); /* TODO: get rid of vmalloc */
+		bitmap = vzalloc(size); /* TODO: get rid of vmalloc */
 
 	if (bitmap == NULL) {
 		udf_error(sb, __func__,
@@ -970,7 +970,6 @@ static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, u32 index)
 		return NULL;
 	}
 
-	memset(bitmap, 0x00, size);
 	bitmap->s_block_bitmap = (struct buffer_head **)(bitmap + 1);
 	bitmap->s_nr_groups = nr_groups;
 	return bitmap;
-- 
1.7.3.1.g432b3.dirty

