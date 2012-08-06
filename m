Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab2HFJ2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:28:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55710 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630Ab2HFJ2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:28:30 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <sourav.poddar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH] driver: misc: bmp085: remove "of_match_table" property.
Date: Mon, 6 Aug 2012 14:58:44 +0530
Message-ID: <1344245324-16704-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an automatic binding done for I2C devices in the of_i2c core
code. So, DT will be able to bind to any I2C device using the
already existing table: MODULE_DEVICE_TABLE(i2c, bmp085_id).

Tested on omap5430 evm.

Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 drivers/misc/bmp085-i2c.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/bmp085-i2c.c b/drivers/misc/bmp085-i2c.c
index 9943971..a4f33c9 100644
--- a/drivers/misc/bmp085-i2c.c
+++ b/drivers/misc/bmp085-i2c.c
@@ -57,12 +57,6 @@ static int bmp085_i2c_remove(struct i2c_client *client)
 	return bmp085_remove(&client->dev);
 }
 
-static const struct of_device_id bmp085_of_match[] = {
-	{ .compatible = "bosch,bmp085", },
-	{ },
-};
-MODULE_DEVICE_TABLE(of, bmp085_of_match);
-
 static const struct i2c_device_id bmp085_id[] = {
 	{ BMP085_NAME, 0 },
 	{ "bmp180", 0 },
@@ -74,7 +68,6 @@ static struct i2c_driver bmp085_i2c_driver = {
 	.driver = {
 		.owner	= THIS_MODULE,
 		.name	= BMP085_NAME,
-		.of_match_table = bmp085_of_match
 	},
 	.id_table	= bmp085_id,
 	.probe		= bmp085_i2c_probe,
-- 
1.7.1

