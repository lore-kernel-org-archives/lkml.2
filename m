Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab2GDFMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:12:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54656 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956Ab2GDFMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:12:03 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/25] leds: convert LT3593 LED driver to devm_kzalloc()
Date: Wed,  4 Jul 2012 13:10:03 +0800
Message-Id: <1341378617-10386-12-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-lt3593.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/leds-lt3593.c b/drivers/leds/leds-lt3593.c
index e311a96c..09a7322 100644
--- a/drivers/leds/leds-lt3593.c
+++ b/drivers/leds/leds-lt3593.c
@@ -149,8 +149,9 @@ static int __devinit lt3593_led_probe(struct platform_device *pdev)
 	if (!pdata)
 		return -EBUSY;
 
-	leds_data = kzalloc(sizeof(struct lt3593_led_data) * pdata->num_leds,
-				GFP_KERNEL);
+	leds_data = devm_kzalloc(&pdev->dev,
+			sizeof(struct lt3593_led_data) * pdata->num_leds,
+			GFP_KERNEL);
 	if (!leds_data)
 		return -ENOMEM;
 
@@ -169,8 +170,6 @@ err:
 	for (i = i - 1; i >= 0; i--)
 		delete_lt3593_led(&leds_data[i]);
 
-	kfree(leds_data);
-
 	return ret;
 }
 
@@ -185,8 +184,6 @@ static int __devexit lt3593_led_remove(struct platform_device *pdev)
 	for (i = 0; i < pdata->num_leds; i++)
 		delete_lt3593_led(&leds_data[i]);
 
-	kfree(leds_data);
-
 	return 0;
 }
 
-- 
1.7.10.4

