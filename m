Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab2LLOCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:02:19 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50840 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab2LLOCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:02:15 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/33] leds-lp55xx: add new lp55xx_register_sysfs() for FW
 interface
Thread-Topic: [PATCH 18/33] leds-lp55xx: add new lp55xx_register_sysfs() for
 FW interface
Thread-Index: Ac3YcUcMoB6rLDt5Riu9VWnwBCo3cA==
Date: Wed, 12 Dec 2012 14:02:11 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AB6D@DQHE02.ent.ti.com>
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

 LP55xx family chips have internal program memory which run various patterns.
 Using this memory, LEDs continue on blinking/dimming without continuous I2C
 commands. That means the I2C HOST can be entered into sleep once the memory
 is updated.

 An application can get hex data from a file and write them into
 the program memory through the I2C. This is general firwmare interface.

 This patch is the initial step for adding the firmware interface.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp55xx-common.c |   16 ++++++++++++++++
 drivers/leds/leds-lp55xx-common.h |    4 ++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index 470601b..4995369 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -197,6 +197,14 @@ static int lp55xx_init_led(struct lp55xx_led *led,
 	return 0;
 }
 
+static struct attribute *lp55xx_engine_attributes[] = {
+	NULL,
+};
+
+static const struct attribute_group lp55xx_engine_attr_group = {
+	.attrs = lp55xx_engine_attributes,
+};
+
 int lp55xx_write(struct lp55xx_chip *chip, u8 reg, u8 val)
 {
 	return i2c_smbus_write_byte_data(chip->cl, reg, val);
@@ -364,3 +372,11 @@ void lp55xx_unregister_leds(struct lp55xx_led *led, struct lp55xx_chip *chip)
 	}
 }
 EXPORT_SYMBOL_GPL(lp55xx_unregister_leds);
+
+int lp55xx_register_sysfs(struct lp55xx_chip *chip)
+{
+	struct device *dev = &chip->cl->dev;
+
+	return sysfs_create_group(&dev->kobj, &lp55xx_engine_attr_group);
+}
+EXPORT_SYMBOL_GPL(lp55xx_register_sysfs);
diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
index c69c73a..2972bae 100644
--- a/drivers/leds/leds-lp55xx-common.h
+++ b/drivers/leds/leds-lp55xx-common.h
@@ -102,4 +102,8 @@ extern int lp55xx_register_leds(struct lp55xx_led *led,
 				struct lp55xx_chip *chip);
 extern void lp55xx_unregister_leds(struct lp55xx_led *led,
 				struct lp55xx_chip *chip);
+
+/* common device attributes functions */
+extern int lp55xx_register_sysfs(struct lp55xx_chip *chip);
+
 #endif /* _LEDS_LP55XX_COMMON_H */
-- 
1.7.9.5


Best Regards,
Milo


