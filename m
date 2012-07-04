Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560Ab2GDFMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:12:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54666 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933547Ab2GDFMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:12:41 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/25] leds: convert ADP5520 LED driver to devm_kzalloc() and cleanup error exit path
Date: Wed,  4 Jul 2012 13:10:07 +0800
Message-Id: <1341378617-10386-16-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-adp5520.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/leds-adp5520.c b/drivers/leds/leds-adp5520.c
index b1400db..72b110f 100644
--- a/drivers/leds/leds-adp5520.c
+++ b/drivers/leds/leds-adp5520.c
@@ -119,7 +119,8 @@ static int __devinit adp5520_led_probe(struct platform_device *pdev)
 		return -EFAULT;
 	}
 
-	led = kzalloc(sizeof(*led) * pdata->num_leds, GFP_KERNEL);
+	led = devm_kzalloc(&pdev->dev, sizeof(*led) * pdata->num_leds,
+				GFP_KERNEL);
 	if (led == NULL) {
 		dev_err(&pdev->dev, "failed to alloc memory\n");
 		return -ENOMEM;
@@ -129,7 +130,7 @@ static int __devinit adp5520_led_probe(struct platform_device *pdev)
 
 	if (ret) {
 		dev_err(&pdev->dev, "failed to write\n");
-		goto err_free;
+		return ret
 	}
 
 	for (i = 0; i < pdata->num_leds; ++i) {
@@ -179,8 +180,6 @@ err:
 		}
 	}
 
-err_free:
-	kfree(led);
 	return ret;
 }
 
@@ -200,7 +199,6 @@ static int __devexit adp5520_led_remove(struct platform_device *pdev)
 		cancel_work_sync(&led[i].work);
 	}
 
-	kfree(led);
 	return 0;
 }
 
-- 
1.7.10.4

