Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228Ab2GDFLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:11:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54647 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab2GDFLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:11:36 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/25] leds: convert PCA9633 LED driver to devm_kzalloc()
Date: Wed,  4 Jul 2012 13:10:00 +0800
Message-Id: <1341378617-10386-9-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Peter Meerwald <p.meerwald@bct-electronic.com>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-pca9633.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/leds/leds-pca9633.c b/drivers/leds/leds-pca9633.c
index d8926fd..edcd706 100644
--- a/drivers/leds/leds-pca9633.c
+++ b/drivers/leds/leds-pca9633.c
@@ -108,7 +108,7 @@ static int __devinit pca9633_probe(struct i2c_client *client,
 		}
 	}
 
-	pca9633 = kcalloc(4, sizeof(*pca9633), GFP_KERNEL);
+	pca9633 = devm_kzalloc(&client->dev, 4 * sizeof(*pca9633), GFP_KERNEL);
 	if (!pca9633)
 		return -ENOMEM;
 
@@ -156,8 +156,6 @@ exit:
 		cancel_work_sync(&pca9633[i].work);
 	}
 
-	kfree(pca9633);
-
 	return err;
 }
 
@@ -171,8 +169,6 @@ static int __devexit pca9633_remove(struct i2c_client *client)
 		cancel_work_sync(&pca9633[i].work);
 	}
 
-	kfree(pca9633);
-
 	return 0;
 }
 
-- 
1.7.10.4

