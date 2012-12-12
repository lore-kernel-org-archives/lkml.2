Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab2LLOA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:00:56 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44348 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab2LLOAx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:00:53 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/33] leds-lp55xx: add device reset function in lp5521/5523
Thread-Topic: [PATCH 05/33] leds-lp55xx: add device reset function in
 lp5521/5523
Thread-Index: Ac3YcRXnCKtJ2eZXTGa97r0TZ/t5UQ==
Date: Wed, 12 Dec 2012 14:00:48 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AAD0@DQHE02.ent.ti.com>
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

 Use explicit each driver function rather than raw command.
 These function will be merged into the lp55xx common driver.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   10 +++++++++-
 drivers/leds/leds-lp5523.c |   10 +++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index f729f7a..37075fd 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -687,6 +687,13 @@ static void lp5521_unregister_sysfs(struct i2c_client *client)
 				&lp5521_led_attribute_group);
 }
 
+static void lp5521_reset_device(struct lp5521_chip *chip)
+{
+	struct i2c_client *client = chip->client;
+
+	lp5521_write(client, LP5521_REG_RESET, 0xff);
+}
+
 static int lp5521_init_device(struct lp5521_chip *chip)
 {
 	struct lp5521_platform_data *pdata = chip->pdata;
@@ -707,7 +714,8 @@ static int lp5521_init_device(struct lp5521_chip *chip)
 		usleep_range(1000, 2000); /* 500us abs min. */
 	}
 
-	lp5521_write(client, LP5521_REG_RESET, 0xff);
+	lp5521_reset_device(chip);
+
 	usleep_range(10000, 20000); /*
 				     * Exact value is not available. 10 - 20ms
 				     * appears to be enough for reset.
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 6a1c4f2..ec21642 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -946,6 +946,13 @@ static void lp5523_unregister_leds(struct lp5523_chip *chip)
 	}
 }
 
+static void lp5523_reset_device(struct lp5523_chip *chip)
+{
+	struct i2c_client *client = chip->client;
+
+	lp5523_write(client, LP5523_REG_RESET, 0xff);
+}
+
 static int lp5523_init_device(struct lp5523_chip *chip)
 {
 	struct lp5523_platform_data *pdata = chip->pdata;
@@ -965,7 +972,8 @@ static int lp5523_init_device(struct lp5523_chip *chip)
 		usleep_range(1000, 2000); /* 500us abs min. */
 	}
 
-	lp5523_write(client, LP5523_REG_RESET, 0xff);
+	lp5523_reset_device(chip);
+
 	usleep_range(10000, 20000); /*
 				     * Exact value is not available. 10 - 20ms
 				     * appears to be enough for reset.
-- 
1.7.9.5


Best Regards,
Milo


