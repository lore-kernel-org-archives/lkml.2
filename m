Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab2IDHHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 03:07:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55709 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab2IDHG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 03:06:59 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH 2/3] leds-lp5523: add new device id for LP55231
Thread-Topic: [PATCH 2/3] leds-lp5523: add new device id for LP55231
Thread-Index: Ac2Ka8dR3KHkJmgIQc63lknN+9gGuQ==
Date: Tue, 4 Sep 2012 07:06:18 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF2105@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 To support LP55231 device, the device id is added.
 Additionally, the i2c driver name is changed from lp5523 to lp5523x.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5523.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 80d3792..e69e72a 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -104,6 +104,11 @@
 #define LED_ACTIVE(mux, led)		(!!(mux & (0x0001 << led)))
 #define SHIFT_MASK(id)			(((id) - 1) * 2)
 
+enum lp5523_chip_id {
+	LP5523,
+	LP55231,
+};
+
 struct lp5523_engine {
 	int		id;
 	u8		mode;
@@ -1005,7 +1010,8 @@ static int lp5523_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id lp5523_id[] = {
-	{ "lp5523", 0 },
+	{ "lp5523",  LP5523 },
+	{ "lp55231", LP55231 },
 	{ }
 };
 
@@ -1013,7 +1019,7 @@ MODULE_DEVICE_TABLE(i2c, lp5523_id);
 
 static struct i2c_driver lp5523_driver = {
 	.driver = {
-		.name	= "lp5523",
+		.name	= "lp5523x",
 	},
 	.probe		= lp5523_probe,
 	.remove		= lp5523_remove,
-- 
1.7.9.5


Best Regards,
Milo


