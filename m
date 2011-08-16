Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab1HPCup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:50:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab1HPCun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:50:43 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Mon Aug 15 19:44:54 2011
Message-Id: <20110816024454.117793826@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 15 Aug 2011 19:42:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrew Bird <ajb@spheresystems.co.uk>
Subject: [13/26] USB: option driver: add PID for Vodafone-Huawei K4511
In-Reply-To: <20110816024553.GA5631@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Bird <ajb@spheresystems.co.uk>

commit 35e9e21fb30dc4452b33aed5cbf233743bffca40 upstream.

This patch adds the product ID of Huawei's Vodafone K4511 mobile broadband
modem to option.c. This is necessary so that the driver gets loaded on demand
without the intervention of usb_modeswitch. This has the benefit of it becoming
available faster and also ensures that the option driver is not bound to a
network interface that should be claimed by cdc_ether.

Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -151,6 +151,7 @@ static void option_instat_callback(struc
 #define HUAWEI_PRODUCT_K3770			0x14C9
 #define HUAWEI_PRODUCT_K3771			0x14CA
 #define HUAWEI_PRODUCT_K4510			0x14CB
+#define HUAWEI_PRODUCT_K4511			0x14CC
 #define HUAWEI_PRODUCT_ETS1220			0x1803
 #define HUAWEI_PRODUCT_E353			0x1506
 
@@ -556,6 +557,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3771, 0xff, 0x02, 0x32) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4510, 0xff, 0x01, 0x31) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4510, 0xff, 0x01, 0x32) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4511, 0xff, 0x01, 0x31) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4511, 0xff, 0x01, 0x32) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E353, 0xff, 0x01, 0x01) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V620) },


