Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab1AKMqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:46:08 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45082 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab1AKMoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:44:46 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, Vincent Sanders <support@simtec.co.uk>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 12/16] mtd: mpc5121_nfc: don't treat NULL clk as an error
Date: Tue, 11 Jan 2011 12:43:49 +0000
Message-Id: <1294749833-32019-13-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns a struct clk cookie to the driver and some platforms
may return NULL if they only support a single clock.  clk_get() has only
failed if it returns a ERR_PTR() encoded pointer.

Cc: Vincent Sanders <support@simtec.co.uk>
Cc: linux-mtd@lists.infradead.org
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/mtd/nand/mpc5121_nfc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nfc.c
index 469e649..ddaf001 100644
--- a/drivers/mtd/nand/mpc5121_nfc.c
+++ b/drivers/mtd/nand/mpc5121_nfc.c
@@ -29,6 +29,7 @@
 #include <linux/clk.h>
 #include <linux/gfp.h>
 #include <linux/delay.h>
+#include <linux/err.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -758,9 +759,9 @@ static int __devinit mpc5121_nfc_probe(struct platform_device *op,
 
 	/* Enable NFC clock */
 	prv->clk = clk_get(dev, "nfc_clk");
-	if (!prv->clk) {
+	if (IS_ERR(prv->clk)) {
 		dev_err(dev, "Unable to acquire NFC clock!\n");
-		retval = -ENODEV;
+		retval = PTR_ERR(prv->clk);
 		goto error;
 	}
 
-- 
1.7.3.4

