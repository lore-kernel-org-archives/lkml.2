Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965005Ab2E0BJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:09:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933381Ab2E0BJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:09:31 -0400
Message-Id: <20120527010430.255515781@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:09 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?=C3=89ric=20Piel?= <piel@delmic.com>
Subject: [ 46/94] USB: ftdi-sio: add support for Physik Instrumente E-861
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Éric Piel <piel@delmic.com>

commit b69cc672052540e8efb1368420f10d7d4d8b8a3d upstream.

This adds VID/PID for the PI E-861. Without it, I had to do:
modprobe -q ftdi-sio product=0x1008 vendor=0x1a72

http://www.physikinstrumente.com/en/products/prdetail.php?sortnr=900610

Signed-off-by: Éric Piel <piel@delmic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    8 ++++++++
 2 files changed, 9 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -809,6 +809,7 @@ static struct usb_device_id id_table_com
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(LARSENBRUSGAARD_VID, LB_ALTITRACK_PID) },
 	{ USB_DEVICE(GN_OTOMETRICS_VID, AURICAL_USB_PID) },
+	{ USB_DEVICE(PI_VID, PI_E861_PID) },
 	{ USB_DEVICE(BAYER_VID, BAYER_CONTOUR_CABLE_PID) },
 	{ USB_DEVICE(FTDI_VID, MARVELL_OPENRD_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -785,6 +785,14 @@
 #define RTSYSTEMS_SERIAL_VX7_PID	0x9e52	/* Serial converter for VX-7 Radios using FT232RL */
 #define RTSYSTEMS_CT29B_PID		0x9e54	/* CT29B Radio Cable */
 
+
+/*
+ * Physik Instrumente
+ * http://www.physikinstrumente.com/en/products/
+ */
+#define PI_VID              0x1a72  /* Vendor ID */
+#define PI_E861_PID         0x1008  /* E-861 piezo controller USB connection */
+
 /*
  * Bayer Ascensia Contour blood glucose meter USB-converter cable.
  * http://winglucofacts.com/cables/


