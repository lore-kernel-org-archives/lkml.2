Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab2KVVtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:49:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:49635 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997Ab2KVSkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Richard <richjunk@pacbell.net>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 39/83] USB: keyspan: fix typo causing GPF on open
Date: Wed, 21 Nov 2012 16:42:01 -0800
Message-Id: <20121122004216.986739238@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit f0e3e35c9049087172c65302b42da8fe7ebb63a8 upstream.

Commit f79b2d0f (USB: keyspan: fix NULL-pointer dereferences and
memory leaks) had a small typo which made the driver use wrong
offsets when mapping serial port private data.  This results in
in a GPF when the port is opened.

Reported-by: Richard <richjunk@pacbell.net>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Acked-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/keyspan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -2448,7 +2448,7 @@ static void keyspan_release(struct usb_s
 static int keyspan_port_probe(struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
-	struct keyspan_port_private *s_priv;
+	struct keyspan_serial_private *s_priv;
 	struct keyspan_port_private *p_priv;
 	const struct keyspan_device_details *d_details;
 	struct callbacks *cback;
@@ -2463,7 +2463,6 @@ static int keyspan_port_probe(struct usb
 	if (!p_priv)
 		return -ENOMEM;
 
-	s_priv = usb_get_serial_data(port->serial);
 	p_priv->device_details = d_details;
 
 	/* Setup values for the various callback routines */


