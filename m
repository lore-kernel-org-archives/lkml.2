Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab2GDFKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:10:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54631 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab2GDFKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:10:37 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/25] leds: convert Big Networks LED driver to devm_kzalloc()
Date: Wed,  4 Jul 2012 13:09:53 +0800
Message-Id: <1341378617-10386-2-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Simon Guinot <sguinot@lacie.com>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-netxbig.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/leds/leds-netxbig.c b/drivers/leds/leds-netxbig.c
index 73973fd..e37618e 100644
--- a/drivers/leds/leds-netxbig.c
+++ b/drivers/leds/leds-netxbig.c
@@ -362,14 +362,14 @@ static int __devinit netxbig_led_probe(struct platform_device *pdev)
 	if (!pdata)
 		return -EINVAL;
 
-	leds_data = kzalloc(sizeof(struct netxbig_led_data) * pdata->num_leds,
-			    GFP_KERNEL);
+	leds_data = devm_kzalloc(&pdev->dev,
+		sizeof(struct netxbig_led_data) * pdata->num_leds, GFP_KERNEL);
 	if (!leds_data)
 		return -ENOMEM;
 
 	ret = gpio_ext_init(pdata->gpio_ext);
 	if (ret < 0)
-		goto err_free_data;
+		return ret;
 
 	for (i = 0; i < pdata->num_leds; i++) {
 		ret = create_netxbig_led(pdev, &leds_data[i], &pdata->leds[i]);
@@ -386,9 +386,6 @@ err_free_leds:
 		delete_netxbig_led(&leds_data[i]);
 
 	gpio_ext_free(pdata->gpio_ext);
-err_free_data:
-	kfree(leds_data);
-
 	return ret;
 }
 
@@ -404,7 +401,6 @@ static int __devexit netxbig_led_remove(struct platform_device *pdev)
 		delete_netxbig_led(&leds_data[i]);
 
 	gpio_ext_free(pdata->gpio_ext);
-	kfree(leds_data);
 
 	return 0;
 }
-- 
1.7.10.4

