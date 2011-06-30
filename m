Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab1F3Ngf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 09:36:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34360 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1F3Nga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 09:36:30 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        Riku Voipio <riku.voipio@iki.fi>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] leds: pca9532: change driver name to be unique
Date: Thu, 30 Jun 2011 15:36:21 +0200
Message-Id: <1309440981-18861-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.5.4
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver handles the variants pca9530-pca9533, so it chose the name
"pca953x". However, there is a gpio driver which decided on the same
name. As a result, those two can't be loaded at the same time. Add a
subsystem prefix to make the driver name unique. Device matching will
not suffer, because both are I2C drivers which match using a
i2c_device_id-table which is not altered.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/leds/leds-pca9532.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index d8d3a1e..a2c8746 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -88,7 +88,7 @@ static const struct pca9532_chip_info pca9532_chip_info_tbl[] = {
 
 static struct i2c_driver pca9532_driver = {
 	.driver = {
-		.name = "pca953x",
+		.name = "leds-pca953x",
 	},
 	.probe = pca9532_probe,
 	.remove = pca9532_remove,
-- 
1.7.5.4

