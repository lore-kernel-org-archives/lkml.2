Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965458Ab1C3WKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:10:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:54022 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933154Ab1C3VGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621235858"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: nicolaus.colberg@cinterion.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [20/275] USB: adding USB support for Cinterion's HC2x, EU3 and PH8 products
Message-Id: <20110330210414.BBEA83E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Nicolaus Colberg <nicolaus.colberg@cinterion.com>

commit aa52b3a92918039b273fc9d1994bd34227c40269 upstream.

/drivers/usb/serial/option.c: Adding support for Cinterion's HC25, HC28,
HC28J, EU3-E, EU3-P and PH8 by correcting/adding Cinterion's and
Siemens' Vendor IDs as well as Product IDs and USB_DEVICE tuples

Signed-off-by: Nicolaus Colberg <nicolaus.colberg@cinterion.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/option.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/usb/serial/option.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/option.c	2011-03-29 22:51:59.987188247 -0700
+++ linux-2.6.35.y/drivers/usb/serial/option.c	2011-03-29 23:02:58.635335088 -0700
@@ -362,7 +362,16 @@
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
@@ -912,7 +921,17 @@
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
