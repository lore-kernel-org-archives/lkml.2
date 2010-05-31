Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab0EaQh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 12:37:27 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:57028 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab0EaQhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 12:37:25 -0400
X-Auth-Info: im3/e5eIzQI8HvGpMg/acykAA5osSFC9fryMDCiCSV4=
From: Anatolij Gustschin <agust@denx.de>
To: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>, Anatolij Gustschin <agust@denx.de>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] mtd: nand: mpc5121_nfc.c: Fix build failures
Date: Mon, 31 May 2010 18:37:15 +0200
Message-Id: <1275323836-15711-1-git-send-email-agust@denx.de>
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
 drivers/mtd/nand/mpc5121_nfc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nfc.c
index 3d0867d..0a130dc 100644
--- a/drivers/mtd/nand/mpc5121_nfc.c
+++ b/drivers/mtd/nand/mpc5121_nfc.c
@@ -650,7 +650,7 @@ static void mpc5121_nfc_free(struct device *dev, struct mtd_info *mtd)
 static int __devinit mpc5121_nfc_probe(struct of_device *op,
 					const struct of_device_id *match)
 {
-	struct device_node *rootnode, *dn = op->node;
+	struct device_node *rootnode, *dn = op->dev.of_node;
 	struct device *dev = &op->dev;
 	struct mpc5121_nfc_prv *prv;
 	struct resource res;
@@ -889,12 +889,12 @@ static struct of_device_id mpc5121_nfc_match[] __devinitdata = {
 };
 
 static struct of_platform_driver mpc5121_nfc_driver = {
-	.match_table	= mpc5121_nfc_match,
 	.probe		= mpc5121_nfc_probe,
 	.remove		= __devexit_p(mpc5121_nfc_remove),
 	.driver		= {
-		.name	= DRV_NAME,
-		.owner	= THIS_MODULE,
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = mpc5121_nfc_match,
 	},
 };
 
-- 
1.7.0.4

