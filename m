Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab1DANdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 09:33:18 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:13771 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab1DANdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 09:33:17 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, hong.xu@atmel.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/3 v2] MTD: atmel_nand: modify test case for using DMA operations
Date: Fri,  1 Apr 2011 16:40:44 +0200
Message-Id: <1301668844-4500-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1301662188.2789.57.camel@localhost>
References: <1301662188.2789.57.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have better performances not using DMA for oob operations.
Modify size test so that it is using DMA for size greater than oobsize.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Artem,

Here is the v2 version with embedded comment as you suggested.

Best regards,

 drivers/mtd/nand/atmel_nand.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 6fae04b..5872f2a 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -280,7 +280,8 @@ static void atmel_read_buf(struct mtd_info *mtd, u8 *buf, int len)
 	struct nand_chip *chip = mtd->priv;
 	struct atmel_nand_host *host = chip->priv;
 
-	if (use_dma && len >= mtd->oobsize)
+	if (use_dma && len > mtd->oobsize)
+		/* only use DMA for bigger than oob size: better performances */
 		if (atmel_nand_dma_op(mtd, buf, len, 1) == 0)
 			return;
 
@@ -295,7 +296,8 @@ static void atmel_write_buf(struct mtd_info *mtd, const u8 *buf, int len)
 	struct nand_chip *chip = mtd->priv;
 	struct atmel_nand_host *host = chip->priv;
 
-	if (use_dma && len >= mtd->oobsize)
+	if (use_dma && len > mtd->oobsize)
+		/* only use DMA for bigger than oob size: better performances */
 		if (atmel_nand_dma_op(mtd, (void *)buf, len, 0) == 0)
 			return;
 
-- 
1.7.3

