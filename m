Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab2KMI3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:29:14 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60106 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092Ab2KMI3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:29:08 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Tero Kristo <t-kristo@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/13] mfd: twl: Convert module id definitions to enums
Date: Tue, 13 Nov 2012 09:28:48 +0100
Message-ID: <1352795334-7406-8-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352795334-7406-1-git-send-email-peter.ujfalusi@ti.com>
References: <1352795334-7406-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use enum list for the module definitions (TWL4030_MODULE_*) which will ease
up future work with the IDs.
At the same time group the IDs in block of five so it is easier to find the
ID we are looking for (to count the number they stand for).

At the same time define TWL_MODULE_LED so client drivers can switch to use
it as soon as it is possible.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl-core.c  |  9 +++----
 include/linux/i2c/twl.h | 65 +++++++++++++++++++++++++------------------------
 2 files changed, 36 insertions(+), 38 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index d666c9d..bb33b52 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -66,9 +66,6 @@
 
 /* Triton Core internal information (BEGIN) */
 
-/* Last - for index max*/
-#define TWL4030_MODULE_LAST		TWL4030_MODULE_SECURED_REG
-
 #define TWL_NUM_SLAVES		4
 
 #define SUB_CHIP_ID0 0
@@ -184,7 +181,7 @@ struct twl_mapping {
 };
 static struct twl_mapping *twl_map;
 
-static struct twl_mapping twl4030_map[TWL4030_MODULE_LAST + 1] = {
+static struct twl_mapping twl4030_map[] = {
 	/*
 	 * NOTE:  don't change this table without updating the
 	 * <linux/i2c/twl.h> defines for TWL4030_MODULE_*
@@ -327,7 +324,7 @@ int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 	int sid;
 	struct twl_client *twl;
 
-	if (unlikely(mod_no > TWL_MODULE_LAST)) {
+	if (unlikely(mod_no >= TWL_MODULE_LAST)) {
 		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
 		return -EPERM;
 	}
@@ -369,7 +366,7 @@ int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 	int sid;
 	struct twl_client *twl;
 
-	if (unlikely(mod_no > TWL_MODULE_LAST)) {
+	if (unlikely(mod_no >= TWL_MODULE_LAST)) {
 		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
 		return -EPERM;
 	}
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 7278c72..b1c44cc 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -39,39 +39,39 @@
  * address each module uses within a given i2c slave.
  */
 
-/* Slave 0 (i2c address 0x48) */
-#define TWL4030_MODULE_USB		0x00
-
-/* Slave 1 (i2c address 0x49) */
-#define TWL4030_MODULE_AUDIO_VOICE	0x01
-#define TWL4030_MODULE_GPIO		0x02
-#define TWL4030_MODULE_INTBR		0x03
-#define TWL4030_MODULE_PIH		0x04
-#define TWL4030_MODULE_TEST		0x05
-
-/* Slave 2 (i2c address 0x4a) */
-#define TWL4030_MODULE_KEYPAD		0x06
-#define TWL4030_MODULE_MADC		0x07
-#define TWL4030_MODULE_INTERRUPTS	0x08
-#define TWL4030_MODULE_LED		0x09
-#define TWL4030_MODULE_MAIN_CHARGE	0x0A
-#define TWL4030_MODULE_PRECHARGE	0x0B
-#define TWL4030_MODULE_PWM0		0x0C
-#define TWL4030_MODULE_PWM1		0x0D
-#define TWL4030_MODULE_PWMA		0x0E
-#define TWL4030_MODULE_PWMB		0x0F
-
-#define TWL5031_MODULE_ACCESSORY	0x10
-#define TWL5031_MODULE_INTERRUPTS	0x11
-
-/* Slave 3 (i2c address 0x4b) */
-#define TWL4030_MODULE_BACKUP		0x12
-#define TWL4030_MODULE_INT		0x13
-#define TWL4030_MODULE_PM_MASTER	0x14
-#define TWL4030_MODULE_PM_RECEIVER	0x15
-#define TWL4030_MODULE_RTC		0x16
-#define TWL4030_MODULE_SECURED_REG	0x17
+enum twl4030_module_ids {
+	TWL4030_MODULE_USB = 0,		/* Slave 0 (i2c address 0x48) */
+	TWL4030_MODULE_AUDIO_VOICE,	/* Slave 1 (i2c address 0x49) */
+	TWL4030_MODULE_GPIO,
+	TWL4030_MODULE_INTBR,
+	TWL4030_MODULE_PIH,
+
+	TWL4030_MODULE_TEST,
+	TWL4030_MODULE_KEYPAD,		/* Slave 2 (i2c address 0x4a) */
+	TWL4030_MODULE_MADC,
+	TWL4030_MODULE_INTERRUPTS,
+	TWL4030_MODULE_LED,
+
+	TWL4030_MODULE_MAIN_CHARGE,
+	TWL4030_MODULE_PRECHARGE,
+	TWL4030_MODULE_PWM0,
+	TWL4030_MODULE_PWM1,
+	TWL4030_MODULE_PWMA,
+
+	TWL4030_MODULE_PWMB,
+	TWL5031_MODULE_ACCESSORY,
+	TWL5031_MODULE_INTERRUPTS,
+	TWL4030_MODULE_BACKUP,		/* Slave 3 (i2c address 0x4b) */
+	TWL4030_MODULE_INT,
+
+	TWL4030_MODULE_PM_MASTER,
+	TWL4030_MODULE_PM_RECEIVER,
+	TWL4030_MODULE_RTC,
+	TWL4030_MODULE_SECURED_REG,
+	TWL4030_MODULE_LAST,
+};
 
+/* Similar functionalities implemented in TWL4030/6030 */
 #define TWL_MODULE_USB		TWL4030_MODULE_USB
 #define TWL_MODULE_PIH		TWL4030_MODULE_PIH
 #define TWL_MODULE_MAIN_CHARGE	TWL4030_MODULE_MAIN_CHARGE
@@ -79,6 +79,7 @@
 #define TWL_MODULE_PM_RECEIVER	TWL4030_MODULE_PM_RECEIVER
 #define TWL_MODULE_RTC		TWL4030_MODULE_RTC
 #define TWL_MODULE_PWM		TWL4030_MODULE_PWM0
+#define TWL_MODULE_LED		TWL4030_MODULE_LED
 
 #define TWL6030_MODULE_ID0	0x0D
 #define TWL6030_MODULE_ID1	0x0E
-- 
1.8.0

