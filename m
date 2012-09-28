Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031919Ab2I1U5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:57:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36626 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031541Ab2I1UsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:03 -0400
X-Sasl-enc: E5Mo4K1+lOaz9G1ERxMdM3fawtp06bmF4Uv052m0dP/U 1348865282
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?=C3=89ric=20Piel?= <piel@delmic.com>
Subject: =?UTF-8?q?=5B=20076/127=5D=20USB=3A=20ftdi-sio=3A=20add=20support=20for=20more=20Physik=20Instrumente=20devices?=
Date: Fri, 28 Sep 2012 13:34:09 -0700
Message-Id: <20120928203054.775348119@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/serial/ftdi_sio.c     |   17 +++++++++++++++++
 drivers/usb/serial/ftdi_sio_ids.h |   21 ++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -811,7 +811,24 @@ static struct usb_device_id id_table_com
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
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -797,8 +797,27 @@
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


