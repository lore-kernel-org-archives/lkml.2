Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0LOQlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:41:24 -0500
Received: from mail.atmel.fr ([81.80.104.162]:46017 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521Ab0LOQlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:41:19 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] dmaengine: at_hdmac: use dma_address to program DMA hardware
Date: Wed, 15 Dec 2010 18:50:16 +0100
Message-Id: <1292435416-16927-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In atc_prep_slave_sg() function we use dma_address field of scatterlist with
sg_dma_address() macro instead of sg_phys(). DMA address is already computed
by dma_map_sg() or another mapping function in calling driver.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index ea0ee81..ee7dacd 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -670,7 +670,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			if (!desc)
 				goto err_desc_get;
 
-			mem = sg_phys(sg);
+			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 			mem_width = 2;
 			if (unlikely(mem & 3 || len & 3))
@@ -712,7 +712,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			if (!desc)
 				goto err_desc_get;
 
-			mem = sg_phys(sg);
+			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 			mem_width = 2;
 			if (unlikely(mem & 3 || len & 3))
-- 
1.7.3

