Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154Ab2KJJOP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 04:14:15 -0500
Received: from canardo.mork.no ([148.122.252.1]:37367 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab2KJJOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 04:14:12 -0500
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: Richard <richjunk@pacbell.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        <stable@vger.kernel.org>, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH usb-linus] USB: keyspan: fix typo causing GPF on open
Date: Sat, 10 Nov 2012 10:13:42 +0100
Message-Id: <1352538822-28221-1-git-send-email-bjorn@mork.no>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <509D5BCD.3010901@pacbell.net>
References: <509D5BCD.3010901@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f79b2d0f (USB: keyspan: fix NULL-pointer dereferences and
memory leaks) had a small typo which made the driver use wrong
offsets when mapping serial port private data.  This results in
in a GPF when the port is opened.

Reported-by: Richard <richjunk@pacbell.net>
Cc: <stable@vger.kernel.org>
Cc: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
Hello Richard,

I wonder if you are able to test and verify this?  I do not guarantee
that there aren't other issues around, but this small typo looked like
an obvious killer...

Bjørn

 drivers/usb/serial/keyspan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 7179b0c..cff8dd5 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -2430,7 +2430,7 @@ static void keyspan_release(struct usb_serial *serial)
 static int keyspan_port_probe(struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
-	struct keyspan_port_private *s_priv;
+	struct keyspan_serial_private *s_priv;
 	struct keyspan_port_private *p_priv;
 	const struct keyspan_device_details *d_details;
 	struct callbacks *cback;
@@ -2445,7 +2445,6 @@ static int keyspan_port_probe(struct usb_serial_port *port)
 	if (!p_priv)
 		return -ENOMEM;
 
-	s_priv = usb_get_serial_data(port->serial);
 	p_priv->device_details = d_details;
 
 	/* Setup values for the various callback routines */
-- 
1.7.10.4

