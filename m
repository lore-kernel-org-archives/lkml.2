Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab0EMUAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:00:53 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50709 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702Ab0EMUAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:00:47 -0400
Date: Thu, 13 May 2010 22:00:40 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 7/20] drivers/usb/serial: Use kzalloc
Message-ID: <Pine.LNX.4.64.1005132200240.6282@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kzalloc rather than the combination of kmalloc and memset.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,size,flags;
statement S;
@@

-x = kmalloc(size,flags);
+x = kzalloc(size,flags);
 if (x == NULL) S
-memset(x, 0, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/usb/serial/io_edgeport.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -3020,7 +3020,7 @@ static int edge_startup(struct usb_seria
 
 	/* set up our port private structures */
 	for (i = 0; i < serial->num_ports; ++i) {
-		edge_port = kmalloc(sizeof(struct edgeport_port), GFP_KERNEL);
+		edge_port = kzalloc(sizeof(struct edgeport_port), GFP_KERNEL);
 		if (edge_port == NULL) {
 			dev_err(&serial->dev->dev, "%s - Out of memory\n",
 								   __func__);
@@ -3033,7 +3033,6 @@ static int edge_startup(struct usb_seria
 			kfree(edge_serial);
 			return -ENOMEM;
 		}
-		memset(edge_port, 0, sizeof(struct edgeport_port));
 		spin_lock_init(&edge_port->ep_lock);
 		edge_port->port = serial->port[i];
 		usb_set_serial_port_data(serial->port[i], edge_port);
