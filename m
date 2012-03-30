Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965546Ab2C3VRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:17:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935981Ab2C3VRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:17:25 -0400
Message-Id: <20120330194827.188543977@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Bruno Thomsen <bruno.thomsen@gmail.com>
Subject: [ 010/175] USB: Microchip VID mislabeled as Hornby VID in ftdi_sio.
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bruno Thomsen <bruno.thomsen@gmail.com>

commit c1cee1d84001815a1b4321c49b995254c0df3100 upstream.

Microchip VID (0x04d8) was mislabeled as Hornby VID according to USB-IDs.

A Full Speed USB Demo Board PID (0x000a) was mislabeled as
Hornby Elite (an Digital Command Controller Console for model railways).

Most likely the Hornby based their design on
PIC18F87J50 Full Speed USB Demo Board.

Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    2 +-
 drivers/usb/serial/ftdi_sio_ids.h |   10 +++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -797,7 +797,7 @@ static struct usb_device_id id_table_com
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(ADI_VID, ADI_GNICEPLUS_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
-	{ USB_DEVICE(HORNBY_VID, HORNBY_ELITE_PID) },
+	{ USB_DEVICE(MICROCHIP_VID, MICROCHIP_USB_BOARD_PID) },
 	{ USB_DEVICE(JETI_VID, JETI_SPC1201_PID) },
 	{ USB_DEVICE(MARVELL_VID, MARVELL_SHEEVAPLUG_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -532,10 +532,14 @@
 #define ADI_GNICEPLUS_PID	0xF001
 
 /*
- * Hornby Elite
+ * Microchip Technology, Inc.
+ *
+ * MICROCHIP_VID (0x04D8) and MICROCHIP_USB_BOARD_PID (0x000A) are also used by:
+ * Hornby Elite - Digital Command Control Console
+ * http://www.hornby.com/hornby-dcc/controllers/
  */
-#define HORNBY_VID		0x04D8
-#define HORNBY_ELITE_PID	0x000A
+#define MICROCHIP_VID		0x04D8
+#define MICROCHIP_USB_BOARD_PID	0x000A /* CDC RS-232 Emulation Demo */
 
 /*
  * RATOC REX-USB60F


