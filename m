Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab2H2ODD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 10:03:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49016 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab2H2ODC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 10:03:02 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 1/2] fat : no need to reset EOF in ent_put for FAT32
Date: Wed, 29 Aug 2012 10:02:50 -0400
Message-Id: <1346248970-3213-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

#define FAT_ENT_EOF(EOF_FAT32)

there is no need to reset value of 'new' for FAT32 as the values is
already correct

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 fs/fat/fatent.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 31f08ab..8d9cf87 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -186,9 +186,6 @@ static void fat16_ent_put(struct fat_entry *fatent, int new)
 
 static void fat32_ent_put(struct fat_entry *fatent, int new)
 {
-	if (new == FAT_ENT_EOF)
-		new = EOF_FAT32;
-
 	WARN_ON(new & 0xf0000000);
 	new |= le32_to_cpu(*fatent->u.ent32_p) & ~0x0fffffff;
 	*fatent->u.ent32_p = cpu_to_le32(new);
-- 
1.7.9.5

