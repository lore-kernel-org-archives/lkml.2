Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585Ab2GDFNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:13:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54671 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2GDFND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:13:03 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/25] leds: convert TCA6507 LED driver to devm_kzalloc()
Date: Wed,  4 Jul 2012 13:10:09 +0800
Message-Id: <1341378617-10386-18-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-tca6507.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
index f74a45a..dabcf7a 100644
--- a/drivers/leds/leds-tca6507.c
+++ b/drivers/leds/leds-tca6507.c
@@ -687,7 +687,7 @@ static int __devinit tca6507_probe(struct i2c_client *client,
 			NUM_LEDS);
 		return -ENODEV;
 	}
-	tca = kzalloc(sizeof(*tca), GFP_KERNEL);
+	tca = devm_kzalloc(&client->dev, sizeof(*tca), GFP_KERNEL);
 	if (!tca)
 		return -ENOMEM;
 
@@ -727,7 +727,6 @@ exit:
 		if (tca->leds[i].led_cdev.name)
 			led_classdev_unregister(&tca->leds[i].led_cdev);
 	}
-	kfree(tca);
 	return err;
 }
 
@@ -743,7 +742,6 @@ static int __devexit tca6507_remove(struct i2c_client *client)
 	}
 	tca6507_remove_gpio(tca);
 	cancel_work_sync(&tca->work);
-	kfree(tca);
 
 	return 0;
 }
-- 
1.7.10.4

