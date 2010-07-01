Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab0GAVHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:07:06 -0400
Received: from kroah.org ([198.145.64.141]:47784 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932797Ab0GAUvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:00 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:36 2010
Message-Id: <20100701173436.406810555@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johan Hovold <jhovold@gmail.com>
Subject: [patch 114/164] USB: mos7840: fix null-pointer dereference
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit b41709f1263bb1ad37efc43fea0bb0b670c12e78 upstream.

Fix null-pointer dereference on error path.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/mos7840.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -717,7 +717,6 @@ static void mos7840_bulk_in_callback(str
 	mos7840_port = urb->context;
 	if (!mos7840_port) {
 		dbg("%s", "NULL mos7840_port pointer");
-		mos7840_port->read_urb_busy = false;
 		return;
 	}
 


