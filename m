Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab1F2PeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:34:06 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:36513 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab1F2PeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:34:04 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, hong.xu@atmel.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] MTD: atmel_nand: fix wrong use of 0 as NULL
Date: Wed, 29 Jun 2011 18:41:16 +0200
Message-Id: <1309365676-19210-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing this error:
atmel_nand.c:718:20: warning: Using plain integer as NULL pointer

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/mtd/nand/atmel_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index b300705..bbdf062 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -593,7 +593,7 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 
 		dma_cap_zero(mask);
 		dma_cap_set(DMA_MEMCPY, mask);
-		host->dma_chan = dma_request_channel(mask, 0, NULL);
+		host->dma_chan = dma_request_channel(mask, NULL, NULL);
 		if (!host->dma_chan) {
 			dev_err(host->dev, "Failed to request DMA channel\n");
 			use_dma = 0;
-- 
1.7.3

