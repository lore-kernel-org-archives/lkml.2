Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab0G3Rqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:46:40 -0400
Received: from kroah.org ([198.145.64.141]:36066 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302Ab0G3Rfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:35:44 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:12 2010
Message-Id: <20100730173112.312965173@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:31:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Corey Minyard <minyard@acm.org>
Subject: [106/140] USB: FTDI: Add support for the RT System VX-7 radio programming cable
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Corey Minyard <minyard@acm.org>

commit fcc6cb789c77ffee31710eec64efeb25f2124f7a upstream.

RT Systems has put out bunch of ham radio cables based on the FT232RL
chip.  Each cable type has a unique PID, this adds one for the Yaesu VX-7
radios.

Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -697,6 +697,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_NDI_AURORA_SCU_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_NDI_device_quirk },
 	{ USB_DEVICE(TELLDUS_VID, TELLDUS_TELLSTICK_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_SERIAL_VX7_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MAXSTREAM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_PHI_FISCO_PID) },
 	{ USB_DEVICE(TML_VID, TML_USB_SERIAL_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -703,6 +703,12 @@
 #define TELLDUS_TELLSTICK_PID		0x0C30	/* RF control dongle 433 MHz using FT232RL */
 
 /*
+ * RT Systems programming cables for various ham radios
+ */
+#define RTSYSTEMS_VID			0x2100	/* Vendor ID */
+#define RTSYSTEMS_SERIAL_VX7_PID	0x9e52	/* Serial converter for VX-7 Radios using FT232RL */
+
+/*
  * Bayer Ascensia Contour blood glucose meter USB-converter cable.
  * http://winglucofacts.com/cables/
  */


