Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab1C3VGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:06:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:9430 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933107Ab1C3VF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:05:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727132708"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: maescool@gmail.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [19/275] USB: serial: Updated support for ICOM devices
Message-Id: <20110330210413.AF02C3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Pieter Maes <maescool@gmail.com>

commit a9d61bc49188e32d2ae9cf0f683cde3e1744feef upstream.

I found the original patch on the db0fhn repeater wiki (couldn't find the email
of the origial author) I guess it was never commited.
I updated and added some Icom HAM-radio devices to the ftdi driver.
Added extra comments to make clear what devices it are.

Signed-off-by: Pieter Maes <maescool@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/ftdi_sio.c     |   12 +++++++++++-
 drivers/usb/serial/ftdi_sio_ids.h |   20 ++++++++++++++++----
 2 files changed, 27 insertions(+), 5 deletions(-)

Index: linux-2.6.35.y/drivers/usb/serial/ftdi_sio.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/ftdi_sio.c	2011-03-29 22:52:00.334179369 -0700
+++ linux-2.6.35.y/drivers/usb/serial/ftdi_sio.c	2011-03-29 23:55:29.226719337 -0700
@@ -675,7 +675,17 @@
 	{ USB_DEVICE(FTDI_VID, FTDI_PCDJ_DAC2_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_RRCIRKITS_LOCOBUFFER_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ASK_RDR400_PID) },
-	{ USB_DEVICE(ICOM_ID1_VID, ICOM_ID1_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_1_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_OPC_U_UC_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP2C1_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP2C2_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP2D_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP2VT_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP2VR_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP4KVT_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP4KVR_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP2KVT_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP2KVR_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ACG_HFDUAL_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_YEI_SERVOCENTER31_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_THORLABS_PID) },
Index: linux-2.6.35.y/drivers/usb/serial/ftdi_sio_ids.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/ftdi_sio_ids.h	2011-03-29 22:52:00.334179369 -0700
+++ linux-2.6.35.y/drivers/usb/serial/ftdi_sio_ids.h	2011-03-29 23:55:29.226719337 -0700
@@ -569,11 +569,23 @@
 #define OCT_US101_PID		0x0421	/* OCT US101 USB to RS-232 */
 
 /*
- * Icom ID-1 digital transceiver
+ * Definitions for Icom Inc. devices
  */
-
-#define ICOM_ID1_VID            0x0C26
-#define ICOM_ID1_PID            0x0004
+#define ICOM_VID		0x0C26 /* Icom vendor ID */
+/* Note: ID-1 is a communications tranceiver for HAM-radio operators */
+#define ICOM_ID_1_PID		0x0004 /* ID-1 USB to RS-232 */
+/* Note: OPC is an Optional cable to connect an Icom Tranceiver */
+#define ICOM_OPC_U_UC_PID	0x0018 /* OPC-478UC, OPC-1122U cloning cable */
+/* Note: ID-RP* devices are Icom Repeater Devices for HAM-radio */
+#define ICOM_ID_RP2C1_PID	0x0009 /* ID-RP2C Asset 1 to RS-232 */
+#define ICOM_ID_RP2C2_PID	0x000A /* ID-RP2C Asset 2 to RS-232 */
+#define ICOM_ID_RP2D_PID	0x000B /* ID-RP2D configuration port*/
+#define ICOM_ID_RP2VT_PID	0x000C /* ID-RP2V Transmit config port */
+#define ICOM_ID_RP2VR_PID	0x000D /* ID-RP2V Receive config port */
+#define ICOM_ID_RP4KVT_PID	0x0010 /* ID-RP4000V Transmit config port */
+#define ICOM_ID_RP4KVR_PID	0x0011 /* ID-RP4000V Receive config port */
+#define ICOM_ID_RP2KVT_PID	0x0012 /* ID-RP2000V Transmit config port */
+#define ICOM_ID_RP2KVR_PID	0x0013 /* ID-RP2000V Receive config port */
 
 /*
  * GN Otometrics (http://www.otometrics.com)
