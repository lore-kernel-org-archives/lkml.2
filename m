Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab2HLJpv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 05:45:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64222 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2HLJpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 05:45:22 -0400
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 7/7] fs/fat: Fix checkpatch issues in fatent.c
Date: Sun, 12 Aug 2012 19:44:47 +1000
Message-Id: <1344764687-4155-8-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344764687-4155-1-git-send-email-cruzjbishop@gmail.com>
References: <1344764687-4155-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does the following:

	1: Stops any lines going over 80 characters
	2: Removes a blank line before EXPORT_SYMBOL_GPL

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 fs/fat/fatent.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 31f08ab..67fd237 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -203,15 +203,18 @@ static int fat12_ent_next(struct fat_entry *fatent)
 
 	fatent->entry++;
 	if (fatent->nr_bhs == 1) {
-		WARN_ON(ent12_p[0] > (u8 *)(bhs[0]->b_data + (bhs[0]->b_size - 2)));
-		WARN_ON(ent12_p[1] > (u8 *)(bhs[0]->b_data + (bhs[0]->b_size - 1)));
+		WARN_ON(ent12_p[0] > (u8 *)(bhs[0]->b_data +
+							(bhs[0]->b_size - 2)));
+		WARN_ON(ent12_p[1] > (u8 *)(bhs[0]->b_data +
+							(bhs[0]->b_size - 1)));
 		if (nextp < (u8 *)(bhs[0]->b_data + (bhs[0]->b_size - 1))) {
 			ent12_p[0] = nextp - 1;
 			ent12_p[1] = nextp;
 			return 1;
 		}
 	} else {
-		WARN_ON(ent12_p[0] != (u8 *)(bhs[0]->b_data + (bhs[0]->b_size - 1)));
+		WARN_ON(ent12_p[0] != (u8 *)(bhs[0]->b_data +
+							(bhs[0]->b_size - 1)));
 		WARN_ON(ent12_p[1] != (u8 *)bhs[1]->b_data);
 		ent12_p[0] = nextp - 1;
 		ent12_p[1] = nextp;
@@ -631,7 +634,6 @@ error:
 
 	return err;
 }
-
 EXPORT_SYMBOL_GPL(fat_free_clusters);
 
 /* 128kb is the whole sectors for FAT12 and FAT16 */
-- 
1.7.9.5

