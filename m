Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab2GCBTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:19:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54756 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932639Ab2GCBTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:19:08 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] power: move lp8727 header into platform_data directory
Thread-Topic: [PATCH] power: move lp8727 header into platform_data directory
Thread-Index: Ac1YudTPlWD0xaZ3QGmUrX7KWPLpdQ==
Date: Tue, 3 Jul 2012 01:19:03 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FCCD7@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.177.86]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lp8727 header can be used only in the platform side,
so it can be moved to the platform_data directory.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c       |    2 +-
 include/linux/lp8727.h               |   65 ----------------------------------
 include/linux/platform_data/lp8727.h |   65 ++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 66 deletions(-)
 delete mode 100644 include/linux/lp8727.h
 create mode 100644 include/linux/platform_data/lp8727.h

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index d8b7578..6a364f4 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -15,7 +15,7 @@
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
 #include <linux/power_supply.h>
-#include <linux/lp8727.h>
+#include <linux/platform_data/lp8727.h>
 
 #define DEBOUNCE_MSEC	270
 
diff --git a/include/linux/lp8727.h b/include/linux/lp8727.h
deleted file mode 100644
index ea98c61..0000000
--- a/include/linux/lp8727.h
+++ /dev/null
@@ -1,65 +0,0 @@
-/*
- * LP8727 Micro/Mini USB IC with integrated charger
- *
- *			Copyright (C) 2011 Texas Instruments
- *			Copyright (C) 2011 National Semiconductor
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _LP8727_H
-#define _LP8727_H
-
-enum lp8727_eoc_level {
-	EOC_5P,
-	EOC_10P,
-	EOC_16P,
-	EOC_20P,
-	EOC_25P,
-	EOC_33P,
-	EOC_50P,
-};
-
-enum lp8727_ichg {
-	ICHG_90mA,
-	ICHG_100mA,
-	ICHG_400mA,
-	ICHG_450mA,
-	ICHG_500mA,
-	ICHG_600mA,
-	ICHG_700mA,
-	ICHG_800mA,
-	ICHG_900mA,
-	ICHG_1000mA,
-};
-
-/**
- * struct lp8727_chg_param
- * @eoc_level : end of charge level setting
- * @ichg : charging current
- */
-struct lp8727_chg_param {
-	enum lp8727_eoc_level eoc_level;
-	enum lp8727_ichg ichg;
-};
-
-/**
- * struct lp8727_platform_data
- * @get_batt_present : check battery status - exists or not
- * @get_batt_level : get battery voltage (mV)
- * @get_batt_capacity : get battery capacity (%)
- * @get_batt_temp : get battery temperature
- * @ac, @usb : charging parameters each charger type
- */
-struct lp8727_platform_data {
-	u8 (*get_batt_present)(void);
-	u16 (*get_batt_level)(void);
-	u8 (*get_batt_capacity)(void);
-	u8 (*get_batt_temp)(void);
-	struct lp8727_chg_param ac;
-	struct lp8727_chg_param usb;
-};
-
-#endif
diff --git a/include/linux/platform_data/lp8727.h b/include/linux/platform_data/lp8727.h
new file mode 100644
index 0000000..ea98c61
--- /dev/null
+++ b/include/linux/platform_data/lp8727.h
@@ -0,0 +1,65 @@
+/*
+ * LP8727 Micro/Mini USB IC with integrated charger
+ *
+ *			Copyright (C) 2011 Texas Instruments
+ *			Copyright (C) 2011 National Semiconductor
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _LP8727_H
+#define _LP8727_H
+
+enum lp8727_eoc_level {
+	EOC_5P,
+	EOC_10P,
+	EOC_16P,
+	EOC_20P,
+	EOC_25P,
+	EOC_33P,
+	EOC_50P,
+};
+
+enum lp8727_ichg {
+	ICHG_90mA,
+	ICHG_100mA,
+	ICHG_400mA,
+	ICHG_450mA,
+	ICHG_500mA,
+	ICHG_600mA,
+	ICHG_700mA,
+	ICHG_800mA,
+	ICHG_900mA,
+	ICHG_1000mA,
+};
+
+/**
+ * struct lp8727_chg_param
+ * @eoc_level : end of charge level setting
+ * @ichg : charging current
+ */
+struct lp8727_chg_param {
+	enum lp8727_eoc_level eoc_level;
+	enum lp8727_ichg ichg;
+};
+
+/**
+ * struct lp8727_platform_data
+ * @get_batt_present : check battery status - exists or not
+ * @get_batt_level : get battery voltage (mV)
+ * @get_batt_capacity : get battery capacity (%)
+ * @get_batt_temp : get battery temperature
+ * @ac, @usb : charging parameters each charger type
+ */
+struct lp8727_platform_data {
+	u8 (*get_batt_present)(void);
+	u16 (*get_batt_level)(void);
+	u8 (*get_batt_capacity)(void);
+	u8 (*get_batt_temp)(void);
+	struct lp8727_chg_param ac;
+	struct lp8727_chg_param usb;
+};
+
+#endif
-- 
1.7.2.5


Best Regards,
Milo



