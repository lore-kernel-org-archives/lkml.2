Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585Ab0GAStn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:49:43 -0400
Received: from kroah.org ([198.145.64.141]:35434 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757699Ab0GASW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:22:58 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:09 2010
Message-Id: <20100701173209.505465490@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:30:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johan Hovold <jhovold@gmail.com>
Subject: [patch 032/149] USB: ir-usb: fix double free
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 2ff78c0c2b67120c8e503268da3f177cae2228a2 upstream.

If the user specifies a custom bulk buffer size we get a double free at
port release.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ir-usb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -312,6 +312,7 @@ static int ir_open(struct tty_struct *tt
 		kfree(port->read_urb->transfer_buffer);
 		port->read_urb->transfer_buffer = buffer;
 		port->read_urb->transfer_buffer_length = buffer_size;
+		port->bulk_in_buffer = buffer;
 
 		buffer = kmalloc(buffer_size, GFP_KERNEL);
 		if (!buffer) {
@@ -321,6 +322,7 @@ static int ir_open(struct tty_struct *tt
 		kfree(port->write_urb->transfer_buffer);
 		port->write_urb->transfer_buffer = buffer;
 		port->write_urb->transfer_buffer_length = buffer_size;
+		port->bulk_out_buffer = buffer;
 		port->bulk_out_size = buffer_size;
 	}
 


