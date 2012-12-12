Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab2LLODZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:03:25 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42379 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964Ab2LLODW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:03:22 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 32/33] leds-lp55xx: fix problem on removing LED attributes
Thread-Topic: [PATCH 32/33] leds-lp55xx: fix problem on removing LED
 attributes
Thread-Index: Ac3YcW9I6RHcYw3KR92oo8SUYyGpqg==
Date: Wed, 12 Dec 2012 14:03:18 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AC17@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
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

 LP55XX common device attributes, 'led_current' and 'max_current' are created
 while loading the driver.
 Those are LED device attributes which are removed automatically on releasing
 led class devices - led_classdev_unregister().
 Therefore, this duplicate code should be removed.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp55xx-common.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index c0c66ec..850303e 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -478,12 +478,9 @@ void lp55xx_unregister_leds(struct lp55xx_led *led, struct lp55xx_chip *chip)
 {
 	int i;
 	struct lp55xx_led *each;
-	struct kobject *kobj;
 
 	for (i = 0; i < chip->num_leds; i++) {
 		each = led + i;
-		kobj = &led->cdev.dev->kobj;
-		sysfs_remove_group(kobj, &lp55xx_led_attr_group);
 		led_classdev_unregister(&each->cdev);
 		flush_work(&each->brightness_work);
 	}
-- 
1.7.9.5


Best Regards,
Milo


