Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1CPOzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 10:55:38 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2287 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab1CPOzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 10:55:31 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Mar 2011 10:55:31 EDT
From: Maarten ter Huurne <maarten@treewalker.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: [PATCH] mtd: nand: Fixed null pointer dereference.
Date: Wed, 16 Mar 2011 15:47:55 +0100
Message-Id: <1300286875-21426-1-git-send-email-maarten@treewalker.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "bd" argument of verify_bbt_descr() was dereferenced before it was checked for NULL.

Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
---
 drivers/mtd/nand/nand_bbt.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/nand_bbt.c b/drivers/mtd/nand/nand_bbt.c
index 6ebd869..fc05f51 100644
--- a/drivers/mtd/nand/nand_bbt.c
+++ b/drivers/mtd/nand/nand_bbt.c
@@ -1101,12 +1101,14 @@ static void mark_bbt_region(struct mtd_info *mtd, struct nand_bbt_descr *td)
 static void verify_bbt_descr(struct mtd_info *mtd, struct nand_bbt_descr *bd)
 {
 	struct nand_chip *this = mtd->priv;
-	u32 pattern_len = bd->len;
-	u32 bits = bd->options & NAND_BBT_NRBITS_MSK;
-	u32 table_size;
+	u32 pattern_len, bits, table_size;
 
 	if (!bd)
 		return;
+
+	pattern_len = bd->len;
+	bits = bd->options & NAND_BBT_NRBITS_MSK;
+
 	BUG_ON((this->options & NAND_USE_FLASH_BBT_NO_OOB) &&
 			!(this->options & NAND_USE_FLASH_BBT));
 	BUG_ON(!bits);
-- 
1.7.1

