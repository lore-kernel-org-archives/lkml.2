Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab1BPArv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:47:51 -0500
Received: from kroah.org ([198.145.64.141]:45198 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932669Ab1BPAro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:47:44 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:01 2011
Message-Id: <20110216002101.092070009@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:19:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicolaus Colberg <nicolaus.colberg@cinterion.com>
Subject: [patch 020/176] USB: adding USB support for Cinterions HC2x, EU3 and PH8 products
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nicolaus Colberg <nicolaus.colberg@cinterion.com>

commit aa52b3a92918039b273fc9d1994bd34227c40269 upstream.

/drivers/usb/serial/option.c: Adding support for Cinterion's HC25, HC28,
HC28J, EU3-E, EU3-P and PH8 by correcting/adding Cinterion's and
Siemens' Vendor IDs as well as Product IDs and USB_DEVICE tuples

Signed-off-by: Nicolaus Colberg <nicolaus.colberg@cinterion.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

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


