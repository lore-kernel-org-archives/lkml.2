Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab2ILMQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:16:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55024 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979Ab2ILMQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:16:16 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH 1/2] leds-lp5523: turn off the LED engines on unloading the
 driver
Thread-Topic: [PATCH 1/2] leds-lp5523: turn off the LED engines on unloading
 the driver
Thread-Index: Ac2Q4F5uy3SBL7unS+aF/VTsMp8ooQ==
Date: Wed, 12 Sep 2012 12:16:00 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF49CB@DQHE02.ent.ti.com>
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

 The LP5523 has 3 engines which are used for running LED patterns.
 These engines should be off while unloading the driver.
 Obviously, LP5523 platform data are used for releasing the resource
 such like enable()/release_resource(), but these are not mandatory.
 Therefore this patch is required without the platform data dependency.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5523.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 3d60428..5ebdc92 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -997,6 +997,9 @@ static int lp5523_remove(struct i2c_client *client)
 	struct lp5523_chip *chip = i2c_get_clientdata(client);
 	int i;
 
+	/* Disable engine mode */
+	lp5523_write(client, LP5523_REG_OP_MODE, LP5523_CMD_DISABLED);
+
 	lp5523_unregister_sysfs(client);
 
 	for (i = 0; i < chip->num_leds; i++) {
-- 
1.7.9.5


Best Regards,
Milo

