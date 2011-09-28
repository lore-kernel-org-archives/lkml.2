Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab1I1WhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:37:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271Ab1I1WhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:37:19 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:27 2011
Message-Id: <20110928220127.026506493@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrew Bird <ajb@spheresystems.co.uk>,
        Alex Chiang <achiang@canonical.com>
Subject: [017/244] USB option driver add PID of Huawei Vodafone K4605
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Bird <ajb@spheresystems.co.uk>

commit 7e1805844da18a37e6d251d286f93c94b52d791e upstream.

This patch adds the product ID of Huawei's Vodafone K4605 mobile broadband
modem to option.c. This is necessary so that the driver gets loaded on
demand without the intervention of usb_modeswitch. This has the benefit of
it becoming available faster and also ensures that the option driver is not
bound to a network interface that should be claimed by suitable network
driver.

Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
Signed-off-by: Alex Chiang <achiang@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -149,6 +149,7 @@ static void option_instat_callback(struc
 #define HUAWEI_PRODUCT_K3765			0x1465
 #define HUAWEI_PRODUCT_E14AC			0x14AC
 #define HUAWEI_PRODUCT_K3806			0x14AE
+#define HUAWEI_PRODUCT_K4605			0x14C6
 #define HUAWEI_PRODUCT_K3770			0x14C9
 #define HUAWEI_PRODUCT_K3771			0x14CA
 #define HUAWEI_PRODUCT_K4510			0x14CB
@@ -553,6 +554,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_ETS1220, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E14AC, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3806, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4605, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0xff, 0x02, 0x31) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0xff, 0x02, 0x32) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3771, 0xff, 0x02, 0x31) },
@@ -1136,10 +1138,11 @@ static int option_probe(struct usb_seria
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
 


