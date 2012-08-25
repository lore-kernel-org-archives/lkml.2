Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab2HYRls (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 13:41:48 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:45587 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748Ab2HYRlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 13:41:46 -0400
X-IronPort-AV: E=Sophos;i="4.80,311,1344204000"; 
   d="scan'208";a="170801701"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jochen Friedrich <jochen@scram.de>
Cc: kernel-janitors@vger.kernel.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        linuxppc-dev@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] i2c: cpm: use devm_ functions
Date: Sat, 25 Aug 2012 19:41:34 +0200
Message-Id: <1345916499-6657-1-git-send-email-Julia.Lawall@lip6.fr>
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

 drivers/i2c/busses/i2c-cpm.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-cpm.c b/drivers/i2c/busses/i2c-cpm.c
index c1e1096..ec97415 100644
--- a/drivers/i2c/busses/i2c-cpm.c
+++ b/drivers/i2c/busses/i2c-cpm.c
@@ -640,7 +640,7 @@ static int __devinit cpm_i2c_probe(struct platform_device *ofdev)
 	struct cpm_i2c *cpm;
 	const u32 *data;
 
-	cpm = kzalloc(sizeof(struct cpm_i2c), GFP_KERNEL);
+	cpm = devm_kzalloc(&ofdev->dev, sizeof(struct cpm_i2c), GFP_KERNEL);
 	if (!cpm)
 		return -ENOMEM;
 
@@ -683,7 +683,6 @@ out_shut:
 	cpm_i2c_shutdown(cpm);
 out_free:
 	dev_set_drvdata(&ofdev->dev, NULL);
-	kfree(cpm);
 
 	return result;
 }
@@ -697,7 +696,6 @@ static int __devexit cpm_i2c_remove(struct platform_device *ofdev)
 	cpm_i2c_shutdown(cpm);
 
 	dev_set_drvdata(&ofdev->dev, NULL);
-	kfree(cpm);
 
 	return 0;
 }

