Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1AEXNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:13:43 -0500
Received: from kroah.org ([198.145.64.141]:50664 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637Ab1AEXGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:06:11 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:23 2011
Message-Id: <20110105230323.419831074@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [01/49] TTY: Fix error return from tty_ldisc_open()
In-Reply-To: <20110105230438.GA26241@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------


The backported version of "TTY: ldisc, fix open flag handling" in
2.6.32.27 causes tty_ldisc_open() to return 0 on error.  Fix that.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tty_ldisc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -451,6 +451,7 @@ static int tty_ldisc_open(struct tty_str
 		ret = ld->ops->open(tty);
 		if (ret)
 			clear_bit(TTY_LDISC_OPEN, &tty->flags);
+		return ret;
 	}
 	return 0;
 }


