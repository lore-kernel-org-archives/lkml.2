Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab2EKU5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 16:57:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:27989 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227Ab2EKU5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 16:57:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="139649304"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Al Borchers <alborchers@steinerpoint.com>,
        Peter Berger <pberger@brimson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH] ti_usb_3410_5052: Add support for the FRI2 serial console
Date: Fri, 11 May 2012 13:56:57 -0700
Message-Id: <3438dcd640bf2f55d6e9a22d77c474839f1ddc70.1336769817.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kontron M2M development board, also known as the Fish River Island II,
has an optional daughter card providing access to the PCH_UART (EG20T) via
a ti_usb_3410_5052 uart to usb chip.

http://us.kontron.com/products/systems+and+platforms/m2m/m2m+smart+services+developer+kit.html

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Al Borchers <alborchers@steinerpoint.com>
CC: Peter Berger <pberger@brimson.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-usb@vger.kernel.org
---
 drivers/usb/serial/ti_usb_3410_5052.c |    6 ++++--
 drivers/usb/serial/ti_usb_3410_5052.h |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index ab74123..3377437 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -165,7 +165,7 @@ static unsigned int product_5052_count;
 /* the array dimension is the number of default entries plus */
 /* TI_EXTRA_VID_PID_COUNT user defined entries plus 1 terminating */
 /* null entry */
-static struct usb_device_id ti_id_table_3410[14+TI_EXTRA_VID_PID_COUNT+1] = {
+static struct usb_device_id ti_id_table_3410[15+TI_EXTRA_VID_PID_COUNT+1] = {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_EZ430_ID) },
 	{ USB_DEVICE(MTS_VENDOR_ID, MTS_GSM_NO_FW_PRODUCT_ID) },
@@ -180,6 +180,7 @@ static struct usb_device_id ti_id_table_3410[14+TI_EXTRA_VID_PID_COUNT+1] = {
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454B_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454C_PRODUCT_ID) },
 	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_PRODUCT_ID) },
+	{ USB_DEVICE(TI_VENDOR_ID, FRI2_PRODUCT_ID) },
 };
 
 static struct usb_device_id ti_id_table_5052[5+TI_EXTRA_VID_PID_COUNT+1] = {
@@ -189,7 +190,7 @@ static struct usb_device_id ti_id_table_5052[5+TI_EXTRA_VID_PID_COUNT+1] = {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_FIRMWARE_PRODUCT_ID) },
 };
 
-static struct usb_device_id ti_id_table_combined[18+2*TI_EXTRA_VID_PID_COUNT+1] = {
+static struct usb_device_id ti_id_table_combined[19+2*TI_EXTRA_VID_PID_COUNT+1] = {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_EZ430_ID) },
 	{ USB_DEVICE(MTS_VENDOR_ID, MTS_GSM_NO_FW_PRODUCT_ID) },
@@ -208,6 +209,7 @@ static struct usb_device_id ti_id_table_combined[18+2*TI_EXTRA_VID_PID_COUNT+1]
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454B_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454C_PRODUCT_ID) },
 	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_PRODUCT_ID) },
+	{ USB_DEVICE(TI_VENDOR_ID, FRI2_PRODUCT_ID) },
 	{ }
 };
 
diff --git a/drivers/usb/serial/ti_usb_3410_5052.h b/drivers/usb/serial/ti_usb_3410_5052.h
index f140f1b..b353e7e 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.h
+++ b/drivers/usb/serial/ti_usb_3410_5052.h
@@ -37,6 +37,7 @@
 #define TI_5152_BOOT_PRODUCT_ID		0x5152	/* no EEPROM, no firmware */
 #define TI_5052_EEPROM_PRODUCT_ID	0x505A	/* EEPROM, no firmware */
 #define TI_5052_FIRMWARE_PRODUCT_ID	0x505F	/* firmware is running */
+#define FRI2_PRODUCT_ID			0x5053  /* Fish River Island II */
 
 /* Multi-Tech vendor and product ids */
 #define MTS_VENDOR_ID			0x06E0
-- 
1.7.7.6

