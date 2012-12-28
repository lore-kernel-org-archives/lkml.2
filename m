Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab2L1Tgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:36:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55424 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932268Ab2L1TTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:00 -0500
Message-Id: <20121228190347.142261146@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:51 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Martin Teichmann <lkb.teichmann@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 081/173] USB: ftdi_sio: Add support for Newport AGILIS motor drivers
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index e1203bd..0a373b3 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -191,6 +191,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_THROTTLE_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GATEWAY_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_PID) },
+	{ USB_DEVICE(NEWPORT_VID, NEWPORT_AGILIS_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 57c12ef..049b6e7 100644
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


