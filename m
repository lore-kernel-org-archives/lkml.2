Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504Ab2J2Vh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:37:29 -0400
Received: from mail.kernel.org ([198.145.19.201]:47527 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761230Ab2J2VhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 045/101] USB: ipw: fix interface-data memory leak in error path
Date: Mon, 29 Oct 2012 14:34:58 -0700
Message-Id: <20121029213245.257445154@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit a997448c89905b80aa4022f734f03685e733d711 upstream.

Move interface data allocation to attach so that it is deallocated
should usb-serial probe fail.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ipw.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/ipw.c
+++ b/drivers/usb/serial/ipw.c
@@ -209,8 +209,7 @@ static int ipw_open(struct tty_struct *t
 	return 0;
 }
 
-/* fake probe - only to allocate data structures */
-static int ipw_probe(struct usb_serial *serial, const struct usb_device_id *id)
+static int ipw_attach(struct usb_serial *serial)
 {
 	struct usb_wwan_intf_private *data;
 
@@ -310,7 +309,7 @@ static struct usb_serial_driver ipw_devi
 	.num_ports =		1,
 	.open =			ipw_open,
 	.close =		ipw_close,
-	.probe =		ipw_probe,
+	.attach =		ipw_attach,
 	.release =		ipw_release,
 	.port_probe =		usb_wwan_port_probe,
 	.port_remove =		usb_wwan_port_remove,


