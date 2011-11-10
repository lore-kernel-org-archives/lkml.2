Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934358Ab1KJNHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:07:42 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59844 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635Ab1KJNHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:07:40 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] serial,mfd: Fix CMSPAR setup
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Thu, 10 Nov 2011 13:17:55 +0000
Message-ID: <20111110131752.13023.60767.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This is referenced the wrong way. Mika Westerberg added some checks to the
tty to support multiple console, but the real problem is simply referencing the
termios object via the wrong path.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/serial/mfd.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)


diff --git a/drivers/tty/serial/mfd.c b/drivers/tty/serial/mfd.c
index 286c386..e272d39 100644
--- a/drivers/tty/serial/mfd.c
+++ b/drivers/tty/serial/mfd.c
@@ -884,7 +884,6 @@ serial_hsu_set_termios(struct uart_port *port, struct ktermios *termios,
 {
 	struct uart_hsu_port *up =
 			container_of(port, struct uart_hsu_port, port);
-	struct tty_struct *tty = port->state->port.tty;
 	unsigned char cval, fcr = 0;
 	unsigned long flags;
 	unsigned int baud, quot;
@@ -907,8 +906,7 @@ serial_hsu_set_termios(struct uart_port *port, struct ktermios *termios,
 	}
 
 	/* CMSPAR isn't supported by this driver */
-	if (tty)
-		tty->termios->c_cflag &= ~CMSPAR;
+	termios->c_cflag &= ~CMSPAR;
 
 	if (termios->c_cflag & CSTOPB)
 		cval |= UART_LCR_STOP;

