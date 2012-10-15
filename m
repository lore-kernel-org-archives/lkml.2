Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab2JNPo6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:44:58 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65183 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab2JNPo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 11:44:57 -0400
From: Huang Shijie <shijie8@gmail.com>
To: dwmw2@infradead.org
Cc: dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Huang Shijie <shijie8@gmail.com>
Subject: [PATCH] mtd: use the NAND_STATUS_FAIL to replace the hardcode
Date: Sun, 14 Oct 2012 23:47:24 -0400
Message-Id: <1350272844-21866-1-git-send-email-shijie8@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the NAND_STATUS_FAIL to replace the hardcode "0x01",
which make the code more readable.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 drivers/mtd/nand/nand_base.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index d5ece6e..4569174 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -899,7 +899,7 @@ static int __nand_unlock(struct mtd_info *mtd, loff_t ofs,
 	/* Call wait ready function */
 	status = chip->waitfunc(mtd, chip);
 	/* See if device thinks it succeeded */
-	if (status & 0x01) {
+	if (status & NAND_STATUS_FAIL) {
 		pr_debug("%s: error status = 0x%08x\n",
 					__func__, status);
 		ret = -EIO;
@@ -1004,7 +1004,7 @@ int nand_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 	/* Call wait ready function */
 	status = chip->waitfunc(mtd, chip);
 	/* See if device thinks it succeeded */
-	if (status & 0x01) {
+	if (status & NAND_STATUS_FAIL) {
 		pr_debug("%s: error status = 0x%08x\n",
 					__func__, status);
 		ret = -EIO;
-- 
1.7.4.4

