Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab2HUJER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:04:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40131 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472Ab2HUJEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:04:12 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: [PATCH 3/4] leds-lp5523: change the return type of lp5523_set_mode()
Thread-Topic: [PATCH 3/4] leds-lp5523: change the return type of
 lp5523_set_mode()
Thread-Index: Ac1/e+VYLTKSXlVkR0GVS48po3txqw==
Date: Tue, 21 Aug 2012 09:03:58 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF0AF3@DQHE02.ent.ti.com>
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

The return value of this function is not handled any place, so
make it as void type.

And three if-statements are replaced with switch-statements.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5523.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index f090819..f8231f1 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -150,7 +150,7 @@ static inline struct lp5523_chip *led_to_lp5523(struct lp5523_led *led)
 			    leds[led->id]);
 }
 
-static int lp5523_set_mode(struct lp5523_engine *engine, u8 mode);
+static void lp5523_set_mode(struct lp5523_engine *engine, u8 mode);
 static int lp5523_set_engine_mode(struct lp5523_engine *engine, u8 mode);
 static int lp5523_load_program(struct lp5523_engine *engine, const u8 *pattern);
 
@@ -789,26 +789,28 @@ static void lp5523_unregister_sysfs(struct i2c_client *client)
 /*--------------------------------------------------------------*/
 /*			Set chip operating mode			*/
 /*--------------------------------------------------------------*/
-static int lp5523_set_mode(struct lp5523_engine *engine, u8 mode)
+static void lp5523_set_mode(struct lp5523_engine *engine, u8 mode)
 {
-	int ret = 0;
-
 	/* if in that mode already do nothing, except for run */
 	if (mode == engine->mode && mode != LP5523_CMD_RUN)
-		return 0;
+		return;
 
-	if (mode == LP5523_CMD_RUN) {
-		ret = lp5523_run_program(engine);
-	} else if (mode == LP5523_CMD_LOAD) {
+	switch (mode) {
+	case LP5523_CMD_RUN:
+		lp5523_run_program(engine);
+		break;
+	case LP5523_CMD_LOAD:
 		lp5523_set_engine_mode(engine, LP5523_CMD_DISABLED);
 		lp5523_set_engine_mode(engine, LP5523_CMD_LOAD);
-	} else if (mode == LP5523_CMD_DISABLED) {
+		break;
+	case LP5523_CMD_DISABLED:
 		lp5523_set_engine_mode(engine, LP5523_CMD_DISABLED);
+		break;
+	default:
+		return;
 	}
 
 	engine->mode = mode;
-
-	return ret;
 }
 
 /*--------------------------------------------------------------*/
-- 
1.7.2.5


Best Regards,
Milo


