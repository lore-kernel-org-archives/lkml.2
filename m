Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab2GDFLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:11:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54638 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab2GDFLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:11:01 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/25] leds: convert LP3944 LED driver to devm_kzalloc()
Date: Wed,  4 Jul 2012 13:09:56 +0800
Message-Id: <1341378617-10386-5-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-lp3944.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/leds-lp3944.c b/drivers/leds/leds-lp3944.c
index b8f9f0a..e8b1021 100644
--- a/drivers/leds/leds-lp3944.c
+++ b/drivers/leds/leds-lp3944.c
@@ -393,7 +393,8 @@ static int __devinit lp3944_probe(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	data = kzalloc(sizeof(struct lp3944_data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(struct lp3944_data),
+			GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -403,10 +404,8 @@ static int __devinit lp3944_probe(struct i2c_client *client,
 	mutex_init(&data->lock);
 
 	err = lp3944_configure(client, data, lp3944_pdata);
-	if (err < 0) {
-		kfree(data);
+	if (err < 0)
 		return err;
-	}
 
 	dev_info(&client->dev, "lp3944 enabled\n");
 	return 0;
@@ -431,8 +430,6 @@ static int __devexit lp3944_remove(struct i2c_client *client)
 			break;
 		}
 
-	kfree(data);
-
 	return 0;
 }
 
-- 
1.7.10.4

