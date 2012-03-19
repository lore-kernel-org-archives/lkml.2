Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab2CSHJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 03:09:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56434 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab2CSHJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 03:09:07 -0400
Message-ID: <1332140938.10116.0.camel@phoenix>
Subject: [PATCH] mfd: adp5520: Use i2c_get_clientdata and dev_get_drvdata at
 appropriate places
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        device-drivers-devel@blackfin.uclinux.org
Date: Mon, 19 Mar 2012 15:08:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/adp5520.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
index 8d816cc..1a7e22e 100644
--- a/drivers/mfd/adp5520.c
+++ b/drivers/mfd/adp5520.c
@@ -309,7 +309,7 @@ out_free_chip:
 
 static int __devexit adp5520_remove(struct i2c_client *client)
 {
-	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
+	struct adp5520_chip *chip = i2c_get_clientdata(client);
 
 	if (chip->irq)
 		free_irq(chip->irq, chip);
@@ -323,8 +323,7 @@ static int __devexit adp5520_remove(struct i2c_client *client)
 #ifdef CONFIG_PM
 static int adp5520_suspend(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
+	struct adp5520_chip *chip = dev_get_drvdata(dev);
 
 	adp5520_clr_bits(chip->dev, ADP5520_MODE_STATUS, ADP5520_nSTNBY);
 	return 0;
@@ -332,8 +331,7 @@ static int adp5520_suspend(struct device *dev)
 
 static int adp5520_resume(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
+	struct adp5520_chip *chip = dev_get_drvdata(dev);
 
 	adp5520_set_bits(chip->dev, ADP5520_MODE_STATUS, ADP5520_nSTNBY);
 	return 0;
-- 
1.7.5.4



