Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab1AQX0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 18:26:24 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38588 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab1AQX0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 18:26:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=R/fK6okOlZiYcZg6+ZmC93okWKrmk/GCAqsHchR6AMg8VO/uy67hjS0y/gP3RFTXpe
         PSC9ZI6UX1E03CQhk0eNK2nbUXKcgxD8klQR9R2U1awzQN0mZgzzHVq5EXzmK+KpTUhf
         YZpKqHBsfTqWjY0+jxcQYik0TZoQ5vCPq8iuY=
Subject: [PATCH] USB: serial: Updated support for ICOM devices
From: Pieter Maes <maescool@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 00:26:16 +0100
Message-ID: <1295306776.16281.5.camel@pietmacubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found the original patch on the db0fhn repeater wiki (couldn't find the email
of the origial author) I guess it was never commited.
I updated and added some Icom HAM-radio devices to the ftdi driver.
Added extra comments to make clear what devices it are.

Signed-off-by: Pieter Maes <maescool@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c     |   12 +++++++++++-
 drivers/usb/serial/ftdi_sio_ids.h |   22 +++++++++++++++++-----
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index a2668d0..4787c0c 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -676,7 +676,17 @@ static struct usb_device_id id_table_combined [] = {
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
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index bf08672..4e0eec3 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -569,11 +569,23 @@
 #define OCT_US101_PID		0x0421	/* OCT US101 USB to RS-232 */
 
 /*
- * Icom ID-1 digital transceiver
- */
-
-#define ICOM_ID1_VID            0x0C26
-#define ICOM_ID1_PID            0x0004
+ * Definitions for Icom Inc. devices
+ */
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
-- 
1.7.1



