Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232Ab1KHTmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:42:21 -0500
Received: from www17.your-server.de ([213.133.104.17]:50337 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab1KHTmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:42:20 -0500
Subject: [PATCH] Staging: line6: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Nov 2011 20:40:26 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1320781234.8062.156.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use kmemdup rather than duplicating its implementation

 The semantic patch that makes this change is available
 in scripts/coccinelle/api/memdup.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/staging/line6/midi.c b/drivers/staging/line6/midi.c
--- a/drivers/staging/line6/midi.c 2011-11-07 19:38:11.240305613 +0100
+++ b/drivers/staging/line6/midi.c 2011-11-08 10:52:27.890730177 +0100
@@ -135,7 +135,7 @@ static int send_midi_async(struct usb_li
 	line6_write_hexdump(line6, 'S', data, length);
 #endif
 
-	transfer_buffer = kmalloc(length, GFP_ATOMIC);
+	transfer_buffer = kmemdup(data, length, GFP_ATOMIC);
 
 	if (transfer_buffer == NULL) {
 		usb_free_urb(urb);
@@ -143,7 +143,6 @@ static int send_midi_async(struct usb_li
 		return -ENOMEM;
 	}
 
-	memcpy(transfer_buffer, data, length);
 	usb_fill_int_urb(urb, line6->usbdev,
 			 usb_sndbulkpipe(line6->usbdev,
 					 line6->ep_control_write),


