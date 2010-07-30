Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab0G3WwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 18:52:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62124 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab0G3Wv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 18:51:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Wa0pqWNFwJ0IHS08XbIpva49edu0hGCYkshV0z2+R0tl6Ld11vuYMCSh3MID/Xoy30
         Zetb0hiin8YcKM2vu48wwCWLt2JfPuVd26oC9BeJz637LeqwDHlTvclp5oUCxclEiGhm
         6VKJ7ormIUNF99ERWyJecvq9J/Za6nhrT+Wf0=
Subject: [PATCH] staging/quatech_usb2: remove unused qt2_box_flush function
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Richard Ash <richard@audacityteam.org>,
        =?ISO-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
        Soeren Moeller <soerenmoeller2001@gmail.com>,
        =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 18:51:51 -0400
Message-ID: <1280530311.2256.4.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

In today linux-next I got a compilation warning:

drivers/staging/quatech_usb2/quatech_usb2.c:1852: warning: ‘qt2_box_flush’ defined but not used

Since -next is an integration three, maybe this function is going to be used. 
But anyway I send a patch that fix the warning removing the qt2_box_flush function just in case.

Thanks a lot.

Javier

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/quatech_usb2/quatech_usb2.c |   24 +-----------------------
 1 files changed, 1 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
index ecd7313..9838ea2 100644
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -258,8 +258,6 @@ static int qt2_box_get_register(struct usb_serial *serial,
 static int qt2_box_set_register(struct usb_serial *serial,
 		unsigned short Uart_Number, unsigned short Register_Num,
 		unsigned short Value);
-static int qt2_box_flush(struct usb_serial *serial,  unsigned char uart_number,
-		unsigned short rcv_or_xmit);
 static int qt2_boxsetuart(struct usb_serial *serial, unsigned short Uart_Number,
 		unsigned short default_divisor, unsigned char default_LCR);
 static int qt2_boxsethw_flowctl(struct usb_serial *serial,
@@ -645,9 +643,6 @@ static void qt2_close(struct usb_serial_port *port)
 	/* get the device private data */
 	port_extra = qt2_get_port_private(port); /* port private data */
 
-	/* we don't need to force flush though the hardware, so we skip using
-	 * qt2_box_flush() here */
-
 	/* we can now (and only now) stop reading data */
 	port_extra->close_pending = true;
 	dbg("%s(): port_extra->close_pending = true", __func__);
@@ -1841,24 +1836,6 @@ static int qt2_box_set_register(struct usb_serial *serial,
 	return result;
 }
 
-
-/** @brief Request the Tx or Rx buffers on the USB side be flushed
- *
- * Tx flush: When all the currently buffered data has been sent, send an escape
- * sequence back up the data stream to us
- * Rx flush: add a flag in the data stream now so we know when it's made it's
- * way up to us.
- */
-static int qt2_box_flush(struct usb_serial *serial,  unsigned char uart_number,
-		    unsigned short rcv_or_xmit)
-{
-	int result;
-	result = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
-		QT2_FLUSH_DEVICE, 0x40, rcv_or_xmit, uart_number, NULL, 0,
-		300);
-	return result;
-}
-
 /** qt2_boxsetuart - Issue a SET_UART vendor-spcific request on the default
  * control pipe. If successful sets baud rate divisor and LCR value.
  */
@@ -1873,6 +1850,7 @@ static int qt2_boxsetuart(struct usb_serial *serial, unsigned short Uart_Number,
 			QT2_GET_SET_UART, 0x40, default_divisor, UartNumandLCR,
 			NULL, 0, 300);
 }
+
 /** qt2_boxsethw_flowctl - Turn hardware (RTS/CTS) flow control on and off for
  * a hardware UART.
  */
-- 
1.7.0.4



