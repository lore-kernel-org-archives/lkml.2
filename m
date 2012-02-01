Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab2BAVXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:23:10 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53980 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757540Ab2BAVTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:41 -0500
X-Sasl-enc: XAT+sXIhCux8QKR/429iF03aoSrvf3RBHSJPivIavATS 1328131180
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:51 2012
Message-Id: <20120201210051.342058242@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johan Hovold <jhovold@gmail.com>,
        Preston Fick <preston.fick@silabs.com>
Subject: [85/89] USB: cp210x: fix up set_termios variables
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 34b76fcaee574017862ea3fa0efdcd77a9d0e57d upstream.

[Based on a patch from Johan, mangled by gregkh to keep things in line]

Fix up the variable usage in the set_termios call.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Preston Fick <preston.fick@silabs.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cp210x.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -576,7 +576,8 @@ static void cp210x_set_termios(struct tt
 		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	unsigned int cflag, old_cflag;
-	unsigned int baud = 0, bits;
+	u32 baud;
+	unsigned int bits;
 	unsigned int modem_ctl[4];
 
 	dbg("%s - port %d", __func__, port->number);
@@ -593,7 +594,7 @@ static void cp210x_set_termios(struct tt
 	if (baud != tty_termios_baud_rate(old_termios) && baud != 0) {
 		dbg("%s - Setting baud rate to %d baud", __func__,
 				baud);
-		if (cp210x_set_config(port, CP210X_SET_BAUDRATE, &baud, 4)) {
+		if (cp210x_set_config(port, CP210X_SET_BAUDRATE, &baud, sizeof(baud))) {
 			dbg("Baud rate requested not supported by device");
 			baud = tty_termios_baud_rate(old_termios);
 		}


