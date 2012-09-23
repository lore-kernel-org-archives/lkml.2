Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab2IWIDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 04:03:24 -0400
Received: from smtp208.alice.it ([82.57.200.104]:36396 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab2IWIDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 04:03:19 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Sep 2012 04:03:19 EDT
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-usb@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Uwe Hermann <uwe@hermann-uwe.de>, support@diygadget.com
Subject: [PATCH] USB: ftdi_sio: add TIAO USB Multi-Protocol Adapter (TUMPA) support
Date: Sun, 23 Sep 2012 09:57:25 +0200
Message-Id: <1348387045-11525-1-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.7.10.4
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/usb/serial/ftdi_sio_ids.h |    5 +++++
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 2 files changed, 7 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 5dd96ca..2d6e641 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -514,6 +514,11 @@
  */
 #define FTDI_TAVIR_STK500_PID	0xFA33	/* STK500 AVR programmer */
 
+/*
+ * TIAO product ids (FTDI_VID)
+ * http://www.tiaowiki.com/w/Main_Page
+ */
+#define FTDI_TIAO_UMPA_PID	0x8a98	/* TIAO/DIYGADGET USB Multi-Protocol Adapter */
 
 
 /********************************/
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 5620db6..d1ef169 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -584,6 +584,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PEDO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PROD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_TAVIR_STK500_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TIAO_UMPA_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	/*
 	 * ELV devices:
 	 */
-- 
1.7.10.4

