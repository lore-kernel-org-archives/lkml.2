Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab2BAVYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:24:41 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43271 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757517Ab2BAVTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:36 -0500
X-Sasl-enc: liknLJjnm6icyVjDebIQIkZPQZW/RbSFPy/p4dpIKgRm 1328131175
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:51 2012
Message-Id: <20120201210051.089575959@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johan Hovold <jhovold@gmail.com>
Subject: [82/89] USB: cp210x: call generic open last in open
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 55b2afbb92ad92e9f6b0aa4354eb1c94589280c3 upstream.

Make sure port is fully initialised before calling generic open.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cp210x.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -393,8 +393,6 @@ static unsigned int cp210x_quantise_baud
 
 static int cp210x_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
-	int result;
-
 	dbg("%s - port %d", __func__, port->number);
 
 	if (cp210x_set_config_single(port, CP210X_IFC_ENABLE, UART_ENABLE)) {
@@ -403,13 +401,10 @@ static int cp210x_open(struct tty_struct
 		return -EPROTO;
 	}
 
-	result = usb_serial_generic_open(tty, port);
-	if (result)
-		return result;
-
 	/* Configure the termios structure */
 	cp210x_get_termios(tty, port);
-	return 0;
+
+	return usb_serial_generic_open(tty, port);
 }
 
 static void cp210x_close(struct usb_serial_port *port)


