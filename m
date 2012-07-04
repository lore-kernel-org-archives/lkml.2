Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab2GDFK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:10:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54636 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab2GDFKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:10:53 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/25] leds: convert Atmel PWM LED driver to devm_kzalloc()
Date: Wed,  4 Jul 2012 13:09:55 +0800
Message-Id: <1341378617-10386-4-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-atmel-pwm.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-atmel-pwm.c b/drivers/leds/leds-atmel-pwm.c
index 64ad702..4543063 100644
--- a/drivers/leds/leds-atmel-pwm.c
+++ b/drivers/leds/leds-atmel-pwm.c
@@ -46,7 +46,8 @@ static int __devinit pwmled_probe(struct platform_device *pdev)
 	if (!pdata || pdata->num_leds < 1)
 		return -ENODEV;
 
-	leds = kcalloc(pdata->num_leds, sizeof(*leds), GFP_KERNEL);
+	leds = devm_kzalloc(&pdev->dev, pdata->num_leds * sizeof(*leds),
+			GFP_KERNEL);
 	if (!leds)
 		return -ENOMEM;
 
@@ -108,7 +109,6 @@ err:
 			pwm_channel_free(&leds[i].pwmc);
 		}
 	}
-	kfree(leds);
 
 	return status;
 }
@@ -129,7 +129,6 @@ static int __exit pwmled_remove(struct platform_device *pdev)
 		pwm_channel_free(&led->pwmc);
 	}
 
-	kfree(leds);
 	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
-- 
1.7.10.4

