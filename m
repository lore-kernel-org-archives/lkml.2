Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934362Ab1FWSce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:32:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:62738 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759846Ab1FWRWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Nicolaus Colberg <nicolaus.colberg@cinterion.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 014/247] USB: adding USB support for Cinterion's HC2x, EU3 and PH8 products
Date: Thu, 23 Jun 2011 13:17:37 -0400
Message-Id: <1308849690-14530-15-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolaus Colberg <nicolaus.colberg@cinterion.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit aa52b3a92918039b273fc9d1994bd34227c40269 upstream.

/drivers/usb/serial/option.c: Adding support for Cinterion's HC25, HC28,
HC28J, EU3-E, EU3-P and PH8 by correcting/adding Cinterion's and
Siemens' Vendor IDs as well as Product IDs and USB_DEVICE tuples

Signed-off-by: Nicolaus Colberg <nicolaus.colberg@cinterion.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/option.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 58100d9..e8323de 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -383,7 +383,16 @@ static int  option_resume(struct usb_serial *serial);
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
@@ -933,7 +942,17 @@ static const struct usb_device_id option_ids[] = {
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
-- 
1.7.4.4

