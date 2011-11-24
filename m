Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab1KXJM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:12:28 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:9194 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab1KXJM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:12:26 -0500
X-AuditID: cbfee61b-b7bfbae0000012f9-6e-4ece0a783327
From: Donggeun Kim <dg77.kim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        akpm@linux-foundation.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, dg77.kim@samsung.com
Subject: [PATCH 1/2] MFD: MAX8997: add platform data for MAX8997 MUIC driver
Date: Thu, 24 Nov 2011 18:12:17 +0900
Message-id: <1322125938-6944-2-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, MAX8997 device does not support MUIC function of it.
To add MAX8997 MUIC driver, header file should be updated.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/mfd/max8997.h |   58 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/include/linux/mfd/max8997.h b/include/linux/mfd/max8997.h
index 0bbd13d..49d2a0b 100644
--- a/include/linux/mfd/max8997.h
+++ b/include/linux/mfd/max8997.h
@@ -77,6 +77,60 @@ struct max8997_regulator_data {
 	struct regulator_init_data *initdata;
 };
 
+enum max8997_muic_usb_type {
+	MAX8997_USB_HOST,
+	MAX8997_USB_DEVICE,
+};
+
+enum max8997_muic_charger_type {
+	MAX8997_CHARGER_TYPE_NONE = 0,
+	MAX8997_CHARGER_TYPE_USB,
+	MAX8997_CHARGER_TYPE_DOWNSTREAM_PORT,
+	MAX8997_CHARGER_TYPE_DEDICATED_CHG,
+	MAX8997_CHARGER_TYPE_500MA,
+	MAX8997_CHARGER_TYPE_1A,
+	MAX8997_CHARGER_TYPE_DEAD_BATTERY = 7,
+};
+
+struct max8997_muic_reg_data {
+	u8 addr;
+	u8 data;
+};
+
+/**
+ * struct max8997_muic_platform_data
+ * @usb_callback: callback function for USB
+ *		  inform callee of USB type (HOST or DEVICE)
+ *		  and attached state(true or false)
+ * @charger_callback: callback function for charger
+ *		  inform callee of charger_type
+ *		  and attached state(true or false)
+ * @deskdock_callback: callback function for desk dock
+ *		  inform callee of attached state(true or false)
+ * @cardock_callback: callback function for car dock
+ *		  inform callee of attached state(true or false)
+ * @mhl_callback: callback function for MHL (Mobile High-definition Link)
+ *		  inform callee of attached state(true or false)
+ * @uart_callback: callback function for JIG UART
+ *		   inform callee of attached state(true or false)
+ * @init_data: array of max8997_muic_reg_data
+ *	       used for initializing registers of MAX8997 MUIC device
+ * @num_init_data: array size of init_data
+ */
+struct max8997_muic_platform_data {
+	void (*usb_callback)(enum max8997_muic_usb_type usb_type,
+		bool attached);
+	void (*charger_callback)(bool attached,
+		enum max8997_muic_charger_type charger_type);
+	void (*deskdock_callback) (bool attached);
+	void (*cardock_callback) (bool attached);
+	void (*mhl_callback) (bool attached);
+	void (*uart_callback) (bool attached);
+
+	struct max8997_muic_reg_data *init_data;
+	int num_init_data;
+};
+
 struct max8997_platform_data {
 	/* IRQ */
 	int irq_base;
@@ -113,7 +167,9 @@ struct max8997_platform_data {
 	/* charge Full Timeout */
 	int timeout; /* 0 (no timeout), 5, 6, 7 hours */
 
-	/* MUIC: Not implemented */
+	/* ---- MUIC ---- */
+	struct max8997_muic_platform_data *muic_pdata;
+
 	/* HAPTIC: Not implemented */
 	/* RTC: Not implemented */
 	/* Flash: Not implemented */
-- 
1.7.4.1

