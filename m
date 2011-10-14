Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab1JNNcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 09:32:12 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49043 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744Ab1JNNcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 09:32:11 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 1/2] gpio: pca953x: remove unneeded check for chip type
Date: Fri, 14 Oct 2011 15:31:59 +0200
Message-Id: <1318599120-413-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.6.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can assume our own device_id table is correct, so remove checking if
the chip type is valid. (The check was bogus anyway: If it found an
invalid entry, it returned with 0!) This is in preparation for further
cleanups.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/gpio/gpio-pca953x.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index c43b8ff..45de6a4 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -673,10 +673,8 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 
 	if (chip->chip_type == PCA953X_TYPE)
 		device_pca953x_init(chip, invert);
-	else if (chip->chip_type == PCA957X_TYPE)
-		device_pca957x_init(chip, invert);
 	else
-		goto out_failed;
+		device_pca957x_init(chip, invert);
 
 	ret = pca953x_irq_setup(chip, id, irq_base);
 	if (ret)
-- 
1.7.6.3

