Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab1CUXqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:46:39 -0400
Received: from kroah.org ([198.145.64.141]:49450 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409Ab1CUXPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:39 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:13 2011
Message-Id: <20110321230713.414745349@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>
Subject: [41/87] USB: serial/kobil_sct, fix potential tty NULL dereference
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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


