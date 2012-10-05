Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab2JEIOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:14:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55765 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab2JEIOn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:14:43 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/28] leds-lp5521/5523: add specific max_channel
Thread-Topic: [PATCH 09/28] leds-lp5521/5523: add specific max_channel
Thread-Index: Ac2i0XHJ2BWIJu5HQfqQfZOVo8bfRQ==
Date: Fri, 5 Oct 2012 08:14:30 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F64176764@DQHE02.ent.ti.com>
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

 LP5521 has max 3 channels.
 On the other hand, LP5523/55231 provides up to 9 channels.
 A number of channels is used for validating platform data channel number
 while initializing LEDs.(lp55xx_init_leds)
 To support this, max_channel is configured in each driver.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |    1 +
 drivers/leds/leds-lp5523.c |    3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 1791655..4076f54 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -606,6 +606,7 @@ static void lp5521_unregister_sysfs(struct i2c_client *client)
 
 /* Chip specific configurations */
 static struct lp55xx_device_config lp5521_cfg = {
+	.max_channel  = LP5521_MAX_LEDS,
 	.reset = {
 		.addr = LP5521_REG_RESET,
 		.val  = LP5521_RESET,
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 5d383b2..85521f8 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -38,6 +38,8 @@
 
 #include "leds-lp55xx-common.h"
 
+#define LP5523_MAX_LEDS			9
+
 #define LP5523_REG_ENABLE		0x00
 #define LP5523_REG_OP_MODE		0x01
 #define LP5523_REG_RATIOMETRIC_MSB	0x02
@@ -686,6 +688,7 @@ static void lp5523_set_mode(struct lp5523_engine *engine, u8 mode)
 
 /* Chip specific configurations */
 static struct lp55xx_device_config lp5523_cfg = {
+	.max_channel  = LP5523_MAX_LEDS,
 	.reset = {
 		.addr = LP5523_REG_RESET,
 		.val  = LP5523_RESET,
-- 
1.7.9.5


Best Regards,
Milo


