Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab1CUXai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:30:38 -0400
Received: from kroah.org ([198.145.64.141]:52592 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932066Ab1CUXRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:17:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:24 2011
Message-Id: <20110321230324.368110856@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:01:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>
Subject: [26/78] USB: serial/kobil_sct, fix potential tty NULL dereference
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 6960f40a954619857e7095a6179eef896f297077 upstream.

Make sure that we check the return value of tty_port_tty_get.
Sometimes it may return NULL and we later dereference that.

The only place here is in kobil_read_int_callback, so fix it.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/kobil_sct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -372,7 +372,7 @@ static void kobil_read_int_callback(stru
 	}
 
 	tty = tty_port_tty_get(&port->port);
-	if (urb->actual_length) {
+	if (tty && urb->actual_length) {
 
 		/* BEGIN DEBUG */
 		/*


