Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1HPXUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 19:20:40 -0400
Received: from smarthost02.mail.zen.net.uk ([212.23.3.141]:46567 "EHLO
	smarthost02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096Ab1HPXUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 19:20:32 -0400
From: Andrew Bird <ajb@spheresystems.co.uk>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Bird <ajb@spheresystems.co.uk>
Subject: [PATCH 3/3] USB option driver add PID of Huawei Vodafone K4605
Date: Wed, 17 Aug 2011 00:20:04 +0100
Message-Id: <1313536804-5675-4-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1313536804-5675-1-git-send-email-ajb@spheresystems.co.uk>
References: <1313536804-5675-1-git-send-email-ajb@spheresystems.co.uk>
X-Originating-Smarthost02-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the product ID of Huawei's Vodafone K4605 mobile broadband
modem to option.c. This is necessary so that the driver gets loaded on
demand without the intervention of usb_modeswitch. In addition we make sure
that the device's network port interfaces are not bound by option.c, so
allowing another suitable driver to claim that instead. Unfortunately the
network device doesn't appear to be cdc_ether compatible.

Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
---
 drivers/usb/serial/option.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 53911aa..7e0f34b 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -149,6 +149,7 @@ static void option_instat_callback(struct urb *urb);
 #define HUAWEI_PRODUCT_K3765			0x1465
 #define HUAWEI_PRODUCT_E14AC			0x14AC
 #define HUAWEI_PRODUCT_K3806			0x14AE
+#define HUAWEI_PRODUCT_K4605			0x14C6
 #define HUAWEI_PRODUCT_K3770			0x14C9
 #define HUAWEI_PRODUCT_K3771			0x14CA
 #define HUAWEI_PRODUCT_K4510			0x14CB
@@ -553,6 +554,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_ETS1220, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E14AC, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3806, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4605, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0xff, 0x02, 0x31) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0xff, 0x02, 0x32) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3771, 0xff, 0x02, 0x31) },
@@ -1136,10 +1138,11 @@ static int option_probe(struct usb_serial *serial,
 		serial->interface->cur_altsetting->desc.bInterfaceClass != 0xff)
 		return -ENODEV;
 
-	/* Don't bind network interfaces on Huawei K3765 & K4505 */
+	/* Don't bind network interfaces on Huawei K3765, K4505 & K4605 */
 	if (serial->dev->descriptor.idVendor == HUAWEI_VENDOR_ID &&
 		(serial->dev->descriptor.idProduct == HUAWEI_PRODUCT_K3765 ||
-			serial->dev->descriptor.idProduct == HUAWEI_PRODUCT_K4505) &&
+			serial->dev->descriptor.idProduct == HUAWEI_PRODUCT_K4505 ||
+			serial->dev->descriptor.idProduct == HUAWEI_PRODUCT_K4605) &&
 		(serial->interface->cur_altsetting->desc.bInterfaceNumber == 1 ||
 			serial->interface->cur_altsetting->desc.bInterfaceNumber == 2))
 		return -ENODEV;
-- 
1.7.3.2

