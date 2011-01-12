Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab1ALPqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 10:46:50 -0500
Received: from ww001vmmolly.erlm.siemens.de ([217.194.34.78]:38201 "EHLO
	thymena.erlm.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1ALPqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 10:46:48 -0500
X-Greylist: delayed 908 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jan 2011 10:46:47 EST
From: "Colberg, Nicolaus" <nicolaus.colberg@cinterion.com>
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 Jan 2011 16:30:03 +0100
Subject: [PATCH] USB: adding USB support for Cinterion's HC2x, EU3 and PH8
 products
Thread-Topic: [PATCH] USB: adding USB support for Cinterion's HC2x, EU3 and
 PH8 products
Thread-Index: AcucW98DHgFAq6rHSBaTz4fs0AtmtgABQ04wAAAOjwAAADyQ8AAGrjmwAADvvVAA66mIIAAKmNaAAANkfiAAYb/SoAQfSUyw
Message-ID: <4E6F1050EF9EB54D990DE2225676A127B877099A@BN000018.cinterion.internal>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-purgate: noscan
X-purgate: noscan
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolaus Colberg <nicolaus.colberg@cinterion.com>

/drivers/usb/serial/option.c: Adding support for Cinterion's HC25, HC28, HC28J, EU3-E, EU3-P and PH8 by
correcting/adding Cinterion's and Siemens' Vendor IDs as well as Product IDs and USB_DEVICE tuples
Signed-off-by: Nicolaus Colberg <nicolaus.colberg@cinterion.com>
---
patch is against linux-2.6.36.2
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -382,7 +382,16 @@ static void option_instat_callback(struc
 #define HAIER_VENDOR_ID				0x201e
 #define HAIER_PRODUCT_CE100			0x2009
 
-#define CINTERION_VENDOR_ID			0x0681
+/* Cinterion (formerly Siemens) products */
+#define SIEMENS_VENDOR_ID				0x0681
+#define CINTERION_VENDOR_ID				0x1e2d
+#define CINTERION_PRODUCT_HC25_MDM		0x0047
+#define CINTERION_PRODUCT_HC25_MDMNET	0x0040
+#define CINTERION_PRODUCT_HC28_MDM		0x004C
+#define CINTERION_PRODUCT_HC28_MDMNET	0x004A /* same for HC28J */
+#define CINTERION_PRODUCT_EU3_E			0x0051
+#define CINTERION_PRODUCT_EU3_P			0x0052
+#define CINTERION_PRODUCT_PH8			0x0053
 
 /* Olivetti products */
 #define OLIVETTI_VENDOR_ID			0x0b3c
@@ -939,7 +948,17 @@ static const struct usb_device_id option
 	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_100F) },
 	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_1011)},
 	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_1012)},
-	{ USB_DEVICE(CINTERION_VENDOR_ID, 0x0047) },
+	/* Cinterion */
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_E) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_P) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PH8) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDM) }, 
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDMNET) },
+	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC25_MDM) },
+	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC25_MDMNET) },
+	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC28_MDM) }, /* HC28 enumerates with Siemens or Cinterion VID depending on FW revision */
+	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC28_MDMNET) },
+
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
 	{ } /* Terminating entry */