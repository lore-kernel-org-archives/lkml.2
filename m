Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab2JDWEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:04:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45178 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933667Ab2JDVUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:20:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Antonio Ospite <ospite@studenti.unina.it>
Subject: [ 09/58] USB: ftdi_sio: add TIAO USB Multi-Protocol Adapter (TUMPA) support
Date: Thu,  4 Oct 2012 14:19:16 -0700
Message-Id: <20121004210636.612350838@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.449598766@linuxfoundation.org>
References: <20121004210635.449598766@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    5 +++++
 2 files changed, 7 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -584,6 +584,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PEDO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PROD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_TAVIR_STK500_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TIAO_UMPA_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	/*
 	 * ELV devices:
 	 */
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


