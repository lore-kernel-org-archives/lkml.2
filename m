Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab2BAVzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:55:21 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51705 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757009Ab2BAVIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:08:01 -0500
X-Sasl-enc: OpDMPAKcWE2UMMRpLQO6oqyem9pBRoyL6O+keIM/V3Fv 1328130480
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:15:32 2012
Message-Id: <20120201201531.999536287@clark.kroah.org>
User-Agent: quilt/0.51-14.1
Date: Wed, 01 Feb 2012 12:14:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Korsgaard <jacmet@sunsite.dk>
Subject: [11/20] USB: ftdi_sio: add PID for TI XDS100v2 / BeagleBone A3
In-Reply-To: <20120201210055.GA25374@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Korsgaard <jacmet@sunsite.dk>

commit 55f13aeae0346f0c89bfface91ad9a97653dc433 upstream.

Port A for JTAG, port B for serial.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    7 +++++++
 2 files changed, 9 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -806,6 +806,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(BAYER_VID, BAYER_CONTOUR_CABLE_PID) },
 	{ USB_DEVICE(FTDI_VID, MARVELL_OPENRD_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(FTDI_VID, TI_XDS100V2_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, HAMEG_HO820_PID) },
 	{ USB_DEVICE(FTDI_VID, HAMEG_HO720_PID) },
 	{ USB_DEVICE(FTDI_VID, HAMEG_HO730_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -38,6 +38,13 @@
 /* www.candapter.com Ewert Energy Systems CANdapter device */
 #define FTDI_CANDAPTER_PID 0x9F80 /* Product Id */
 
+/*
+ * Texas Instruments XDS100v2 JTAG / BeagleBone A3
+ * http://processors.wiki.ti.com/index.php/XDS100
+ * http://beagleboard.org/bone
+ */
+#define TI_XDS100V2_PID		0xa6d0
+
 #define FTDI_NXTCAM_PID		0xABB8 /* NXTCam for Mindstorms NXT */
 
 /* US Interface Navigator (http://www.usinterface.com/) */


