Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab1F3NgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 09:36:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34343 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab1F3NgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 09:36:12 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] gpio: pca953x: change driver name to be unique
Date: Thu, 30 Jun 2011 15:35:59 +0200
Message-Id: <1309440959-18692-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.5.4
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver handles the variants pca9534-pca9539, so it chose the name
"pca953x". However, there is a led driver which decided on the same
name. As a result, those two can't be loaded at the same time. Add a
subsystem prefix to make the driver name unique. Device matching will
not suffer, because both are I2C drivers which match using a
i2c_device_id-table which is not altered.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/gpio/pca953x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index 0451d7a..b30dd0b 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -742,7 +742,7 @@ static int pca953x_remove(struct i2c_client *client)
 
 static struct i2c_driver pca953x_driver = {
 	.driver = {
-		.name	= "pca953x",
+		.name	= "gpio-pca953x",
 	},
 	.probe		= pca953x_probe,
 	.remove		= pca953x_remove,
-- 
1.7.5.4

