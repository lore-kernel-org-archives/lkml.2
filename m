Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab0GUNP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:15:56 -0400
Received: from smarthost02.mail.zen.net.uk ([212.23.3.141]:42410 "EHLO
	smarthost02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754277Ab0GUNPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:15:54 -0400
From: Andrew Bird <ajb@spheresystems.co.uk>
To: linux-kernel@vger.kernel.org
Cc: ajb@spheresystems.co.uk
Subject: [PATCH 2/2] USB - Option.c add Huawei K3765/K4505, ignore net interface
Date: Wed, 21 Jul 2010 14:15:48 +0100
Message-Id: <1279718148-2410-1-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: git-send-email 1.6.2.5
X-Originating-Smarthost02-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/usb/serial/option.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 8a1008c..df26870 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -145,6 +145,8 @@ static void option_instat_callback(struct urb *urb);
 #define HUAWEI_PRODUCT_E143D			0x143D
 #define HUAWEI_PRODUCT_E143E			0x143E
 #define HUAWEI_PRODUCT_E143F			0x143F
+#define HUAWEI_PRODUCT_K4505			0x1464
+#define HUAWEI_PRODUCT_K3765			0x1465
 #define HUAWEI_PRODUCT_E14AC			0x14AC
 
 #define QUANTA_VENDOR_ID			0x0408
@@ -383,6 +385,13 @@ static const struct option_blacklist_info four_g_w14_blacklist = {
 	.reason = OPTION_BLACKLIST_SENDSETUP
 };
 
+static const u8 huawei_k3765_k4505_reserved_if[] = { 1 }; /* net */
+static const struct option_blacklist_info huawei_k3765_k4505_blacklist = {
+	.infolen = ARRAY_SIZE(huawei_k3765_k4505_reserved_if),
+	.ifaceinfo = huawei_k3765_k4505_reserved_if,
+	.reason = OPTION_BLACKLIST_RESERVED_IF
+};
+
 static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -480,6 +489,12 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143D, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143E, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143F, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4505),
+		.driver_info = (kernel_ulong_t)&huawei_k3765_k4505_blacklist
+	},
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3765),
+		.driver_info = (kernel_ulong_t)&huawei_k3765_k4505_blacklist
+	},
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E14AC) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_9508) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) }, /* Novatel Merlin V640/XV620 */
-- 
1.6.2.5

