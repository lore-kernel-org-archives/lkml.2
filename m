Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab0EaQjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 12:39:24 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:60450 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab0EaQjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 12:39:23 -0400
X-Auth-Info: xSeICaLnEREZF91X9q9bOqN0g4jJiaeleFIz8Mc5NhA=
From: Anatolij Gustschin <agust@denx.de>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
       Anatolij Gustschin <agust@denx.de>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] dma: mpc512x_dma.c: Fix build failures
Date: Mon, 31 May 2010 18:39:13 +0200
Message-Id: <1275323953-15782-1-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes build errors caused by the:
 - OF device_node pointer being moved into struct device
 - removal of the match_table field from struct of_platform_driver

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/dma/mpc512x_dma.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index 201e6e1..14a8c0f 100644
--- a/drivers/dma/mpc512x_dma.c
+++ b/drivers/dma/mpc512x_dma.c
@@ -630,7 +630,7 @@ mpc_dma_prep_memcpy(struct dma_chan *chan, dma_addr_t dst, dma_addr_t src,
 static int __devinit mpc_dma_probe(struct of_device *op,
 					const struct of_device_id *match)
 {
-	struct device_node *dn = op->node;
+	struct device_node *dn = op->dev.of_node;
 	struct device *dev = &op->dev;
 	struct dma_device *dma;
 	struct mpc_dma *mdma;
@@ -771,12 +771,12 @@ static struct of_device_id mpc_dma_match[] = {
 };
 
 static struct of_platform_driver mpc_dma_driver = {
-	.match_table	= mpc_dma_match,
 	.probe		= mpc_dma_probe,
 	.remove		= __devexit_p(mpc_dma_remove),
-	.driver		= {
-		.name	= DRV_NAME,
-		.owner	= THIS_MODULE,
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table	= mpc_dma_match,
 	},
 };
 
-- 
1.7.0.4

