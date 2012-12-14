Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab2LNWib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:38:31 -0500
Received: from mail.kernel.org ([198.145.19.201]:38295 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757195Ab2LNW1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:27:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Martin Teichmann <lkb.teichmann@gmail.com>
Subject: [ 11/22] USB: ftdi_sio: Add support for Newport AGILIS motor drivers
Date: Fri, 14 Dec 2012 14:25:56 -0800
Message-Id: <20121214222252.316347729@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222249.889051473@linuxfoundation.org>
References: <20121214222249.889051473@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Teichmann <lkb.teichmann@gmail.com>

commit d7e14b375b40c04cd735b115713043b69a2c68ac upstream.

The Newport AGILIS model AG-UC8 compact piezo motor controller
(http://search.newport.com/?q=*&x2=sku&q2=AG-UC8)
is yet another device using an FTDI USB-to-serial chip. It works
fine with the ftdi_sio driver when adding

  options ftdi-sio product=0x3000 vendor=0x104d

to modprobe.d. udevadm reports "Newport" as the manufacturer,
and "Agilis" as the product name.

Signed-off-by: Martin Teichmann <lkb.teichmann@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -195,6 +195,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_THROTTLE_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GATEWAY_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_PID) },
+	{ USB_DEVICE(NEWPORT_VID, NEWPORT_AGILIS_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -752,6 +752,12 @@
 #define TTI_VID			0x103E	/* Vendor Id */
 #define TTI_QL355P_PID		0x03E8	/* TTi QL355P power supply */
 
+/*
+ * Newport Cooperation (www.newport.com)
+ */
+#define NEWPORT_VID			0x104D
+#define NEWPORT_AGILIS_PID		0x3000
+
 /* Interbiometrics USB I/O Board */
 /* Developed for Interbiometrics by Rudolf Gugler */
 #define INTERBIOMETRICS_VID              0x1209


