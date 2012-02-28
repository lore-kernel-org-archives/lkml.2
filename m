Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964980Ab2B1BaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:30:07 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46792 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964895Ab2B1BHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:07:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.74.138 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010210.789296376@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:02:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andrew Lunn <andrew@lunn.ch>
Subject: [ 40/73] USB: Serial: ti_usb_3410_5052: Add Abbot Diabetes Care cable id
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

commit 7fd25702ba616d9ba56e2a625472f29e5aff25ee upstream.

This USB-serial cable with mini stereo jack enumerates as:
Bus 001 Device 004: ID 1a61:3410 Abbott Diabetes Care

It is a TI3410 inside.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ti_usb_3410_5052.c |    6 ++++--
 drivers/usb/serial/ti_usb_3410_5052.h |    4 ++++
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -165,7 +165,7 @@ static unsigned int product_5052_count;
 /* the array dimension is the number of default entries plus */
 /* TI_EXTRA_VID_PID_COUNT user defined entries plus 1 terminating */
 /* null entry */
-static struct usb_device_id ti_id_table_3410[13+TI_EXTRA_VID_PID_COUNT+1] = {
+static struct usb_device_id ti_id_table_3410[14+TI_EXTRA_VID_PID_COUNT+1] = {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_EZ430_ID) },
 	{ USB_DEVICE(MTS_VENDOR_ID, MTS_GSM_NO_FW_PRODUCT_ID) },
@@ -179,6 +179,7 @@ static struct usb_device_id ti_id_table_
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_4543_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454B_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454C_PRODUCT_ID) },
+	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_PRODUCT_ID) },
 };
 
 static struct usb_device_id ti_id_table_5052[5+TI_EXTRA_VID_PID_COUNT+1] = {
@@ -188,7 +189,7 @@ static struct usb_device_id ti_id_table_
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_FIRMWARE_PRODUCT_ID) },
 };
 
-static struct usb_device_id ti_id_table_combined[17+2*TI_EXTRA_VID_PID_COUNT+1] = {
+static struct usb_device_id ti_id_table_combined[18+2*TI_EXTRA_VID_PID_COUNT+1] = {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_EZ430_ID) },
 	{ USB_DEVICE(MTS_VENDOR_ID, MTS_GSM_NO_FW_PRODUCT_ID) },
@@ -206,6 +207,7 @@ static struct usb_device_id ti_id_table_
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_4543_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454B_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454C_PRODUCT_ID) },
+	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_PRODUCT_ID) },
 	{ }
 };
 
--- a/drivers/usb/serial/ti_usb_3410_5052.h
+++ b/drivers/usb/serial/ti_usb_3410_5052.h
@@ -49,6 +49,10 @@
 #define MTS_MT9234ZBA_PRODUCT_ID	0xF115
 #define MTS_MT9234ZBAOLD_PRODUCT_ID	0x0319
 
+/* Abbott Diabetics vendor and product ids */
+#define ABBOTT_VENDOR_ID		0x1a61
+#define ABBOTT_PRODUCT_ID		0x3410
+
 /* Commands */
 #define TI_GET_VERSION			0x01
 #define TI_GET_PORT_STATUS		0x02


