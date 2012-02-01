Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab2BAVWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:22:02 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40461 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757557Ab2BAVTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:44 -0500
X-Sasl-enc: I87pqe9olMK37TLklnCNAlTN9XPMayZ0gybxbh6ozbMy 1328131183
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:51 2012
Message-Id: <20120201210051.533127419@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johan Hovold <jhovold@gmail.com>,
        Preston Fick <preston.fick@silabs.com>
Subject: [87/89] USB: cp210x: initialise baud rate at open
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit cdc32fd6f7b2b2580d7f1b74563f888e4dd9eb8a upstream.

The newer cp2104 devices require the baud rate to be initialised after
power on. Make sure it is set when port is opened.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Preston Fick <preston.fick@silabs.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cp210x.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -408,6 +408,10 @@ static int cp210x_open(struct tty_struct
 	/* Configure the termios structure */
 	cp210x_get_termios(tty, port);
 
+	/* The baud rate must be initialised on cp2104 */
+	if (tty)
+		cp210x_change_speed(tty, port, NULL);
+
 	return usb_serial_generic_open(tty, port);
 }
 


