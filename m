Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab1HPT61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:58:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58418 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab1HPT6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:58:25 -0400
Date: Tue, 16 Aug 2011 13:58:21 -0600
From: Alex Chiang <achiang@canonical.com>
To: gregkh@suse.de
Cc: ajb@spheresystems.co.uk, linux-usb@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] USB option driver add PID of Huawei Vodafone K4605
Message-ID: <20110816195820.GC31609@canonical.com>
Mail-Followup-To: Alex Chiang <achiang@canonical.com>, gregkh@suse.de,
	ajb@spheresystems.co.uk, linux-usb@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Bird <ajb@spheresystems.co.uk>

This patch adds the product ID of Huawei's Vodafone K4605 mobile broadband
modem to option.c. This is necessary so that the driver gets loaded on
demand without the intervention of usb_modeswitch. This has the benefit of
it becoming available faster and also ensures that the option driver is not
bound to a network interface that should be claimed by suitable network
driver.

Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
Signed-off-by: Alex Chiang <achiang@canonical.com>
---
 This patch might be good for -stable, but it doesn't really
 matter to me if it hits that tree or not.

 drivers/usb/serial/option.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 6e04222..ab86e0d 100644
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
 		serial->interface->cur_altsetting->desc.bInterfaceNumber == 1)
 		return -ENODEV;
 
-- 
1.7.4.1

