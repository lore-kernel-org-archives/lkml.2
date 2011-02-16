Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab1BPAW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:22:56 -0500
Received: from kroah.org ([198.145.64.141]:49237 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477Ab1BPAWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:41 2011
Message-Id: <20110216001441.400230604@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [163/272] 68360serial: Plumb in rs_360_get_icount()
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 3e517f4b1de4787ecff87a73a9865a0b1aa2b10b upstream.

Commit 0587102cf9f427c185bfdeb2cef41e13ee0264b1 replaced a direct
implementation of SIOCGICOUNT with an implementation of
tty_operations::get_icount, but it did not actually set
rs_360_ops.get_icount.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/68360serial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/serial/68360serial.c
+++ b/drivers/serial/68360serial.c
@@ -2428,6 +2428,7 @@ static const struct tty_operations rs_36
 	/* .read_proc = rs_360_read_proc, */
 	.tiocmget = rs_360_tiocmget,
 	.tiocmset = rs_360_tiocmset,
+	.get_icount = rs_360_get_icount,
 };
 
 static int __init rs_360_init(void)


