Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2BVSGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:06:23 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58547 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab2BVSGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:06:19 -0500
Date: Wed, 22 Feb 2012 19:06:20 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 1/3] max17042_battery: Use devm_kzalloc() where applicable
In-reply-to: <1329933982-2529-1-git-send-email-k.lewandowsk@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        cbou@mail.ru, Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1329933982-2529-2-git-send-email-k.lewandowsk@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.8.3
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1329933982-2529-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to simplify probe and exit function.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/max17042_battery.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 86acee2..21a3650 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -220,7 +220,7 @@ static int __devinit max17042_probe(struct i2c_client *client,
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
 		return -EIO;
 
-	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
@@ -246,7 +246,6 @@ static int __devinit max17042_probe(struct i2c_client *client,
 	ret = power_supply_register(&client->dev, &chip->battery);
 	if (ret) {
 		dev_err(&client->dev, "failed: power supply register\n");
-		kfree(chip);
 		return ret;
 	}
 
@@ -269,7 +268,6 @@ static int __devexit max17042_remove(struct i2c_client *client)
 	struct max17042_chip *chip = i2c_get_clientdata(client);
 
 	power_supply_unregister(&chip->battery);
-	kfree(chip);
 	return 0;
 }
 
-- 
1.7.8.3

