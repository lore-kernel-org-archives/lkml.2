Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab2IQBSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:18:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33621 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409Ab2IQAuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:14 -0400
Message-Id: <20120917003641.853905523@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?=C3=89ric=20Piel?= <piel@delmic.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 113/135] USB: ftdi-sio: add support for more Physik Instrumente devices
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Éric Piel <piel@delmic.com>

commit dafc4f7be1a556ca3868d343c00127728b397068 upstream.

Commit b69cc672052540 added support for the E-861.  After acquiring a C-867, I
realised that every Physik Instrumente's device has a different PID. They are
listed in the Windows device driver's .inf file. So here are all PIDs for the
current (and probably future) USB devices from Physik Instrumente.

Compiled, but only actually tested on the E-861 and C-867.

Signed-off-by: Éric Piel <piel@delmic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c     |   17 +++++++++++++++++
 drivers/usb/serial/ftdi_sio_ids.h |   21 ++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 5620db6..1197d47 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -810,7 +810,24 @@ static struct usb_device_id id_table_combined [] = {
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(LARSENBRUSGAARD_VID, LB_ALTITRACK_PID) },
 	{ USB_DEVICE(GN_OTOMETRICS_VID, AURICAL_USB_PID) },
+	{ USB_DEVICE(FTDI_VID, PI_C865_PID) },
+	{ USB_DEVICE(FTDI_VID, PI_C857_PID) },
+	{ USB_DEVICE(PI_VID, PI_C866_PID) },
+	{ USB_DEVICE(PI_VID, PI_C663_PID) },
+	{ USB_DEVICE(PI_VID, PI_C725_PID) },
+	{ USB_DEVICE(PI_VID, PI_E517_PID) },
+	{ USB_DEVICE(PI_VID, PI_C863_PID) },
 	{ USB_DEVICE(PI_VID, PI_E861_PID) },
+	{ USB_DEVICE(PI_VID, PI_C867_PID) },
+	{ USB_DEVICE(PI_VID, PI_E609_PID) },
+	{ USB_DEVICE(PI_VID, PI_E709_PID) },
+	{ USB_DEVICE(PI_VID, PI_100F_PID) },
+	{ USB_DEVICE(PI_VID, PI_1011_PID) },
+	{ USB_DEVICE(PI_VID, PI_1012_PID) },
+	{ USB_DEVICE(PI_VID, PI_1013_PID) },
+	{ USB_DEVICE(PI_VID, PI_1014_PID) },
+	{ USB_DEVICE(PI_VID, PI_1015_PID) },
+	{ USB_DEVICE(PI_VID, PI_1016_PID) },
 	{ USB_DEVICE(KONDO_VID, KONDO_USB_SERIAL_PID) },
 	{ USB_DEVICE(BAYER_VID, BAYER_CONTOUR_CABLE_PID) },
 	{ USB_DEVICE(FTDI_VID, MARVELL_OPENRD_PID),
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 5dd96ca..080d158 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -791,8 +791,27 @@
  * Physik Instrumente
  * http://www.physikinstrumente.com/en/products/
  */
+/* These two devices use the VID of FTDI */
+#define PI_C865_PID	0xe0a0  /* PI C-865 Piezomotor Controller */
+#define PI_C857_PID	0xe0a1  /* PI Encoder Trigger Box */
+
 #define PI_VID              0x1a72  /* Vendor ID */
-#define PI_E861_PID         0x1008  /* E-861 piezo controller USB connection */
+#define PI_C866_PID	0x1000  /* PI C-866 Piezomotor Controller */
+#define PI_C663_PID	0x1001  /* PI C-663 Mercury-Step */
+#define PI_C725_PID	0x1002  /* PI C-725 Piezomotor Controller */
+#define PI_E517_PID	0x1005  /* PI E-517 Digital Piezo Controller Operation Module */
+#define PI_C863_PID	0x1007  /* PI C-863 */
+#define PI_E861_PID	0x1008  /* PI E-861 Piezomotor Controller */
+#define PI_C867_PID	0x1009  /* PI C-867 Piezomotor Controller */
+#define PI_E609_PID	0x100D  /* PI E-609 Digital Piezo Controller */
+#define PI_E709_PID	0x100E  /* PI E-709 Digital Piezo Controller */
+#define PI_100F_PID	0x100F  /* PI Digital Piezo Controller */
+#define PI_1011_PID	0x1011  /* PI Digital Piezo Controller */
+#define PI_1012_PID	0x1012  /* PI Motion Controller */
+#define PI_1013_PID	0x1013  /* PI Motion Controller */
+#define PI_1014_PID	0x1014  /* PI Device */
+#define PI_1015_PID	0x1015  /* PI Device */
+#define PI_1016_PID	0x1016  /* PI Digital Servo Module */
 
 /*
  * Kondo Kagaku Co.Ltd.


