Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab1DYUuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:50:46 -0400
Received: from 1wt.eu ([62.212.114.60]:34139 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932205Ab1DYUYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:30 -0400
Message-Id: <20110425200236.905912775@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 090/173] USB: serial/kobil_sct, fix potential tty NULL dereference
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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
 
 	tty = port->port.tty;
-	if (urb->actual_length) {
+	if (tty && urb->actual_length) {
 
 		/* BEGIN DEBUG */
 		/*


