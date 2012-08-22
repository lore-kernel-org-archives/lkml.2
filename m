Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab2HVHcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:32:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51418 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757320Ab2HVHcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:32:53 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: [PATCH v2 2/2] leds-lp5523: set the brightness to 0 forcely on
 removing the driver
Thread-Topic: [PATCH v2 2/2] leds-lp5523: set the brightness to 0 forcely on
 removing the driver
Thread-Index: Ac2AOFFl8o1U4i4XQtq8Wf64ODBL0g==
Date: Wed, 22 Aug 2012 07:32:45 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF0C47@DQHE02.ent.ti.com>
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

Turning off the brightness of each channel is required
when removing the driver.

So use flush_work() rather than cancel_work_sync() to execute
remaining brightness works.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5523.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 9fd9a92..2fd5689 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -974,7 +974,7 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 fail2:
 	for (i = 0; i < chip->num_leds; i++) {
 		led_classdev_unregister(&chip->leds[i].cdev);
-		cancel_work_sync(&chip->leds[i].brightness_work);
+		flush_work(&chip->leds[i].brightness_work);
 	}
 fail1:
 	if (pdata->enable)
@@ -993,7 +993,7 @@ static int lp5523_remove(struct i2c_client *client)
 
 	for (i = 0; i < chip->num_leds; i++) {
 		led_classdev_unregister(&chip->leds[i].cdev);
-		cancel_work_sync(&chip->leds[i].brightness_work);
+		flush_work(&chip->leds[i].brightness_work);
 	}
 
 	if (chip->pdata->enable)
-- 
1.7.2.5


Best Regards,
Milo


