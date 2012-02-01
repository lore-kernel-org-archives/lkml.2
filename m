Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab2BAVKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:10:30 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42567 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932585Ab2BAVKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:23 -0500
X-Sasl-enc: vBArb1AJFeWhNAUd1UgwCEOdI0K5jX+uo1mTpaCxtrTv 1328130620
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:48 2012
Message-Id: <20120201210048.214159802@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>,
        Wolfgang Frisch <wfpub@roembden.net>
Subject: [49/89] usb: io_ti: Make edge_remove_sysfs_attrs the port_remove method.
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 6d443d8499e4e59ffb949759cdded32730f8d2f6 upstream.

Calling edge_remove_sysfs_attrs from edge_disconnect is too late
as the device has already been removed from sysfs.

Do the simple and obvious thing and make edge_remove_sysfs_attrs
the port_remove method.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Reported-by: Wolfgang Frisch <wfpub@roembden.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/io_ti.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -2677,15 +2677,7 @@ cleanup:
 
 static void edge_disconnect(struct usb_serial *serial)
 {
-	int i;
-	struct edgeport_port *edge_port;
-
 	dbg("%s", __func__);
-
-	for (i = 0; i < serial->num_ports; ++i) {
-		edge_port = usb_get_serial_port_data(serial->port[i]);
-		edge_remove_sysfs_attrs(edge_port->port);
-	}
 }
 
 static void edge_release(struct usb_serial *serial)
@@ -2764,6 +2756,7 @@ static struct usb_serial_driver edgeport
 	.disconnect		= edge_disconnect,
 	.release		= edge_release,
 	.port_probe		= edge_create_sysfs_attrs,
+	.port_remove		= edge_remove_sysfs_attrs,
 	.ioctl			= edge_ioctl,
 	.set_termios		= edge_set_termios,
 	.tiocmget		= edge_tiocmget,
@@ -2795,6 +2788,7 @@ static struct usb_serial_driver edgeport
 	.disconnect		= edge_disconnect,
 	.release		= edge_release,
 	.port_probe		= edge_create_sysfs_attrs,
+	.port_remove		= edge_remove_sysfs_attrs,
 	.ioctl			= edge_ioctl,
 	.set_termios		= edge_set_termios,
 	.tiocmget		= edge_tiocmget,


