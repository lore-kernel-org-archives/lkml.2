Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab2AJXOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:14:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933949Ab2AJXBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:01:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:50:23 2012
Message-Id: <20120110215023.222994184@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:48:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johan Hovold <jhovold@gmail.com>
Subject: [27/42] USB: omninet: fix write_room
In-Reply-To: <20120110215031.GA19398@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 694c6301e515bad574af74b6552134c4d9dcb334 upstream.

Fix regression introduced by commit 507ca9bc047666 ([PATCH] USB: add
ability for usb-serial drivers to determine if their write urb is
currently being used.) which inverted the logic in write_room so that it
returns zero when the write urb is actually free.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/omninet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/omninet.c
+++ b/drivers/usb/serial/omninet.c
@@ -315,7 +315,7 @@ static int omninet_write_room(struct tty
 	int room = 0; /* Default: no room */
 
 	/* FIXME: no consistent locking for write_urb_busy */
-	if (wport->write_urb_busy)
+	if (!wport->write_urb_busy)
 		room = wport->bulk_out_size - OMNINET_HEADERLEN;
 
 	dbg("%s - returns %d", __func__, room);


