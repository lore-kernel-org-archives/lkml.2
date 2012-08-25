Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2HYRnH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 13:43:07 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:45587 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831Ab2HYRls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 13:41:48 -0400
X-IronPort-AV: E=Sophos;i="4.80,311,1344204000"; 
   d="scan'208";a="170801702"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "Jean Delvare (PC drivers core)" <khali@linux-fr.org>
Cc: kernel-janitors@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] i2c: ibm_iic: use devm_ functions
Date: Sat, 25 Aug 2012 19:41:35 +0200
Message-Id: <1345916499-6657-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not compiled.

 drivers/i2c/busses/i2c-ibm_iic.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-ibm_iic.c b/drivers/i2c/busses/i2c-ibm_iic.c
index 806e225..76435c2 100644
--- a/drivers/i2c/busses/i2c-ibm_iic.c
+++ b/drivers/i2c/busses/i2c-ibm_iic.c
@@ -699,7 +699,7 @@ static int __devinit iic_probe(struct platform_device *ofdev)
 	const u32 *freq;
 	int ret;
 
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	dev = devm_kzalloc(&ofdev->dev, sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
 		dev_err(&ofdev->dev, "failed to allocate device data\n");
 		return -ENOMEM;
@@ -774,7 +774,6 @@ error_cleanup:
 		iounmap(dev->vaddr);
 
 	dev_set_drvdata(&ofdev->dev, NULL);
-	kfree(dev);
 	return ret;
 }
 
@@ -795,7 +794,6 @@ static int __devexit iic_remove(struct platform_device *ofdev)
 	}
 
 	iounmap(dev->vaddr);
-	kfree(dev);
 
 	return 0;
 }

