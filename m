Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab2JNOxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:53:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46651 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932269Ab2JNOns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:48 -0400
Message-Id: <20121014143541.450616040@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:29 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Antonio Ospite <ospite@studenti.unina.it>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 056/147] USB: ftdi_sio: add TIAO USB Multi-Protocol Adapter (TUMPA) support
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Ospite <ospite@studenti.unina.it>

commit 54575b05af36959dfb6a49a3e9ca0c2b456b7126 upstream.

TIAO/DIYGADGET USB Multi-Protocol Adapter (TUMPA) is an FTDI FT2232H
based device which provides an easily accessible JTAG, SPI, I2C, serial
breakout.

http://www.diygadget.com/tiao-usb-multi-protocol-adapter-jtag-spi-i2c-serial.html
http://www.tiaowiki.com/w/TIAO_USB_Multi_Protocol_Adapter_User%27s_Manual

FTDI FT2232H provides two serial channels (A and B), but on the TUMPA
channel A is dedicated to JTAG/SPI while channel B can be used for
UART/RS-232: use the ftdi_jtag_quirk to expose only channel B as
a usb-serial interface to userspace.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 8742a0e..9169f51 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -579,6 +579,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PEDO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PROD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_TAVIR_STK500_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TIAO_UMPA_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	/*
 	 * ELV devices:
 	 */
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 41fe582..57c12ef 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -517,6 +517,11 @@
  */
 #define FTDI_TAVIR_STK500_PID	0xFA33	/* STK500 AVR programmer */
 
+/*
+ * TIAO product ids (FTDI_VID)
+ * http://www.tiaowiki.com/w/Main_Page
+ */
+#define FTDI_TIAO_UMPA_PID	0x8a98	/* TIAO/DIYGADGET USB Multi-Protocol Adapter */
 
 
 /********************************/


