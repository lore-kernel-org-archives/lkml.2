Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab2LLOCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:02:47 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42327 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178Ab2LLOCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:02:44 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 24/33] leds-lp55xx: add unregister dev attr function
Thread-Topic: [PATCH 24/33] leds-lp55xx: add unregister dev attr function
Thread-Index: Ac3YcVhcl+EwOoJWTnW1rm3wUNZKhg==
Date: Wed, 12 Dec 2012 14:02:40 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0ABD7@DQHE02.ent.ti.com>
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

 lp55xx_unregister_sysfs() is used for removing lp55xx device attributes.
 Chip specific and engine attributes are removed on unloading the driver.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp55xx-common.c |   12 ++++++++++++
 drivers/leds/leds-lp55xx-common.h |    1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index 731f826..c0c66ec 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -508,3 +508,15 @@ dev_specific_attrs:
 		sysfs_create_group(&dev->kobj, cfg->dev_attr_group) : 0;
 }
 EXPORT_SYMBOL_GPL(lp55xx_register_sysfs);
+
+void lp55xx_unregister_sysfs(struct lp55xx_chip *chip)
+{
+	struct device *dev = &chip->cl->dev;
+	struct lp55xx_device_config *cfg = chip->cfg;
+
+	if (cfg->dev_attr_group)
+		sysfs_remove_group(&dev->kobj, cfg->dev_attr_group);
+
+	sysfs_remove_group(&dev->kobj, &lp55xx_engine_attr_group);
+}
+EXPORT_SYMBOL_GPL(lp55xx_unregister_sysfs);
diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
index 39f54d2..20586be 100644
--- a/drivers/leds/leds-lp55xx-common.h
+++ b/drivers/leds/leds-lp55xx-common.h
@@ -128,5 +128,6 @@ extern void lp55xx_unregister_leds(struct lp55xx_led *led,
 
 /* common device attributes functions */
 extern int lp55xx_register_sysfs(struct lp55xx_chip *chip);
+extern void lp55xx_unregister_sysfs(struct lp55xx_chip *chip);
 
 #endif /* _LEDS_LP55XX_COMMON_H */
-- 
1.7.9.5


Best Regards,
Milo


