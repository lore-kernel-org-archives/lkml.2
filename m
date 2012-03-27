Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab2C0CJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 22:09:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36969 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab2C0CJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 22:09:47 -0400
Message-ID: <1332814182.21855.2.camel@phoenix>
Subject: [PATCH 2/2] regulator: ad5398: Use devm_kzalloc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 27 Mar 2012 10:09:42 +0800
In-Reply-To: <1332814105.21855.1.camel@phoenix>
References: <1332814105.21855.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ad5398.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
index ed58798..7d51793 100644
--- a/drivers/regulator/ad5398.c
+++ b/drivers/regulator/ad5398.c
@@ -220,7 +220,7 @@ static int __devinit ad5398_probe(struct i2c_client *client,
 	if (!init_data)
 		return -EINVAL;
 
-	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
@@ -246,7 +246,6 @@ static int __devinit ad5398_probe(struct i2c_client *client,
 	return 0;
 
 err:
-	kfree(chip);
 	return ret;
 }
 
@@ -255,8 +254,6 @@ static int __devexit ad5398_remove(struct i2c_client *client)
 	struct ad5398_chip_info *chip = i2c_get_clientdata(client);
 
 	regulator_unregister(chip->rdev);
-	kfree(chip);
-
 	return 0;
 }
 
-- 
1.7.5.4



