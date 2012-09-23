Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab2IWNbQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 09:31:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45367 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab2IWNbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 09:31:14 -0400
Date: Sun, 23 Sep 2012 09:33:58 -0400
From: "Maxin B. John" <maxin.john@gmail.com>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
Subject: [PATCH 2/2] i2c: busses: i2c-ocores: switch to
 devm_request_and_ioremap
Message-ID: <20120923133358.GA22861@linux-3ix0.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This drops a few lines of code and allows common APIs to handle those for us.

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index bffd550..740a89b 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -283,18 +283,9 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
 	if (!i2c)
 		return -ENOMEM;
 
-	if (!devm_request_mem_region(&pdev->dev, res->start,
-				     resource_size(res), pdev->name)) {
-		dev_err(&pdev->dev, "Memory region busy\n");
+	i2c->base = devm_request_and_ioremap(&pdev->dev, res);
+	if (!i2c->base)
 		return -EBUSY;
-	}
-
-	i2c->base = devm_ioremap_nocache(&pdev->dev, res->start,
-					 resource_size(res));
-	if (!i2c->base) {
-		dev_err(&pdev->dev, "Unable to map registers\n");
-		return -EIO;
-	}
 
 	pdata = pdev->dev.platform_data;
 	if (pdata) {
