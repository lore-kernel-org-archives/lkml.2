Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2LLOGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:06:34 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44423 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab2LLOCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:02:08 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/33] leds-lp55xx: fix error condition in
 lp55xx_register_leds()
Thread-Topic: [PATCH 17/33] leds-lp55xx: fix error condition in
 lp55xx_register_leds()
Thread-Index: Ac3YcUMrk5yyvpnLTHSRTMnjgLYKkQ==
Date: Wed, 12 Dec 2012 14:02:04 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AB65@DQHE02.ent.ti.com>
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

  Use lp55xx_unregister_leds() rather than duplicate code.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp55xx-common.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index b423539..470601b 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -344,11 +344,7 @@ int lp55xx_register_leds(struct lp55xx_led *led, struct lp55xx_chip *chip)
 	return 0;
 
 err_init_led:
-	for (i = 0; i < chip->num_leds; i++) {
-		each = led + i;
-		led_classdev_unregister(&each->cdev);
-		flush_work(&each->brightness_work);
-	}
+	lp55xx_unregister_leds(led, chip);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(lp55xx_register_leds);
-- 
1.7.9.5


Best Regards,
Milo


