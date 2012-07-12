Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162221Ab2GLWza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:55:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162182Ab2GLWoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:44:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 149/187] USB: metro-usb: fix tty_flip_buffer_push use
Date: Thu, 12 Jul 2012 15:35:05 -0700
Message-Id: <20120712191536.204232796@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit b7d28e32c93801d60c1a7a817f774a02b7bdde43 upstream.

Do not set low_latency flag at open as tty_flip_buffer_push must not be
called in IRQ context with low_latency set.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/metro-usb.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/usb/serial/metro-usb.c
+++ b/drivers/usb/serial/metro-usb.c
@@ -171,14 +171,6 @@ static int metrousb_open(struct tty_stru
 	metro_priv->throttled = 0;
 	spin_unlock_irqrestore(&metro_priv->lock, flags);
 
-	/*
-	 * Force low_latency on so that our tty_push actually forces the data
-	 * through, otherwise it is scheduled, and with high data rates (like
-	 * with OHCI) data can get lost.
-	 */
-	if (tty)
-		tty->low_latency = 1;
-
 	/* Clear the urb pipe. */
 	usb_clear_halt(serial->dev, port->interrupt_in_urb->pipe);
 


