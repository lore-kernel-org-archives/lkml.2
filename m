Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab0C3XUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:20:53 -0400
Received: from kroah.org ([198.145.64.141]:45948 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498Ab0C3XTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:54 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:49 2010
Message-Id: <20100330224749.148020901@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tilman Schmidt <tilman@imap.cc>, Karsten Keil <keil@b1-systems.de>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [045/156] gigaset: prune use of tty_buffer_request_room
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit 873a69a358a6b393fd8d9d92e193ec8895cac4d7 upstream.

Calling tty_buffer_request_room() before tty_insert_flip_string()
is unnecessary, costs CPU and for big buffers can mess up the
multi-page allocation avoidance.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Acked-by: Karsten Keil <keil@b1-systems.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/gigaset/interface.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
@@ -632,7 +632,6 @@ void gigaset_if_receive(struct cardstate
 	if (tty == NULL)
 		gig_dbg(DEBUG_ANY, "receive on closed device");
 	else {
-		tty_buffer_request_room(tty, len);
 		tty_insert_flip_string(tty, buffer, len);
 		tty_flip_buffer_push(tty);
 	}


