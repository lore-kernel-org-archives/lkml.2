Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438Ab0HLAML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:12:11 -0400
Received: from kroah.org ([198.145.64.141]:47928 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933222Ab0HLAIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:51 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:17 2010
Message-Id: <20100812000617.485594030@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:06:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David A. Ranch" <dranch@trinnet.net>
Subject: [52/67] USB: ftdi_sio: device id for Navitator
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: dranch@trinnet.net <dranch@trinnet.net>

commit b6180ef7c99574c3350bbffa2a3a9d675321543d upstream.

This patch is to add a US Interface, Inc. "Navigator" USB device.
Specifically, it's a HAM Radio USB sound modem that also
incorporates three pairs of unique FTDI serial ports.  The standard
Linux FTDI serial driver will only recognize the first two serial
ports of an unknown FDTI derived device and this patch adds in
recognition to these specific new IDs.

Signed-off-by: David A. Ranch <dranch@trinnet.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    3 +++
 drivers/usb/serial/ftdi_sio_ids.h |    5 +++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -157,6 +157,9 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_5_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_6_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_7_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_USINT_CAT_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_USINT_WKEY_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_USINT_RS232_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ACTZWAVE_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_IRTRANS_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_IPLUS_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -40,6 +40,11 @@
 
 #define FTDI_NXTCAM_PID		0xABB8 /* NXTCam for Mindstorms NXT */
 
+/* US Interface Navigator (http://www.usinterface.com/) */
+#define FTDI_USINT_CAT_PID	0xb810	/* Navigator CAT and 2nd PTT lines */
+#define FTDI_USINT_WKEY_PID	0xb811	/* Navigator WKEY and FSK lines */
+#define FTDI_USINT_RS232_PID	0xb812	/* Navigator RS232 and CONFIG lines */
+
 /* OOCDlink by Joern Kaipf <joernk@web.de>
  * (http://www.joernonline.de/dw/doku.php?id=start&idx=projects:oocdlink) */
 #define FTDI_OOCDLINK_PID	0xbaf8	/* Amontec JTAGkey */


