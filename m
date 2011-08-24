Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1HXNb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:31:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53707 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab1HXNb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:31:56 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>, Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        lm-sensors@lm-sensors.org
Date: Wed, 24 Aug 2011 15:28:24 +0200
Message-Id: <1314192505-23499-5-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1314192505-23499-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20110824132740.GA28197@pengutronix.de>
 <1314192505-23499-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH 5/6] hwmon/mc13783-adc: convert to mc13xxx API
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mc13783_... functions are going to be removed, so switch to the
more generic API.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/hwmon/mc13783-adc.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/mc13783-adc.c b/drivers/hwmon/mc13783-adc.c
index d5226c9..ef65ab5 100644
--- a/drivers/hwmon/mc13783-adc.c
+++ b/drivers/hwmon/mc13783-adc.c
@@ -31,7 +31,7 @@
 #define MC13783_ADC_NAME	"mc13783-adc"
 
 struct mc13783_adc_priv {
-	struct mc13783 *mc13783;
+	struct mc13xxx *mc13xxx;
 	struct device *hwmon_dev;
 };
 
@@ -51,8 +51,8 @@ static int mc13783_adc_read(struct device *dev,
 	unsigned int sample[4];
 	int ret;
 
-	ret = mc13783_adc_do_conversion(priv->mc13783,
-			MC13783_ADC_MODE_MULT_CHAN,
+	ret = mc13xxx_adc_do_conversion(priv->mc13xxx,
+			MC13XXX_ADC_MODE_MULT_CHAN,
 			channel, sample);
 	if (ret)
 		return ret;
@@ -147,9 +147,9 @@ static const struct attribute_group mc13783_group_ts = {
 static int mc13783_adc_use_touchscreen(struct platform_device *pdev)
 {
 	struct mc13783_adc_priv *priv = platform_get_drvdata(pdev);
-	unsigned flags = mc13783_get_flags(priv->mc13783);
+	unsigned flags = mc13xxx_get_flags(priv->mc13xxx);
 
-	return flags & MC13783_USE_TOUCHSCREEN;
+	return flags & MC13XXX_USE_TOUCHSCREEN;
 }
 
 static int __init mc13783_adc_probe(struct platform_device *pdev)
@@ -161,7 +161,7 @@ static int __init mc13783_adc_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
-	priv->mc13783 = dev_get_drvdata(pdev->dev.parent);
+	priv->mc13xxx = dev_get_drvdata(pdev->dev.parent);
 
 	platform_set_drvdata(pdev, priv);
 
-- 
1.7.5.4

