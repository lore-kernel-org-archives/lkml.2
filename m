Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2FFM0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 08:26:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57973 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2FFM0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 08:26:14 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] hfsplus: use -ENOMEM when kzalloc failed
Date: Wed,  6 Jun 2012 08:26:01 -0400
Message-Id: <1338985561-9842-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use -ENOMEM return value instead of -EINVAL when kzalloc failed

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/hfsplus/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index a9bca4b..4336d28 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -347,7 +347,7 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 	u64 last_fs_block, last_fs_page;
 	int err;
 
-	err = -EINVAL;
+	err = -ENOMEM;
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto out;
-- 
1.7.9.5

