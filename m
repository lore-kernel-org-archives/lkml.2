Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab0HLA1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:27:22 -0400
Received: from kroah.org ([198.145.64.141]:60126 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759432Ab0HLAEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:01 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:24 2010
Message-Id: <20100812000124.574813541@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:00:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>
Subject: [14/54] Char: nozomi, fix tty->count counting
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit ee78bb95b7bea08b7774a02073ea2bb45611a9e1 upstream.

Currently ntty_install omits to increment tty count and we get the
following warnings:
Warning: dev (noz2) tty->count(0) != #fd's(1) in tty_open

So to fix that, add one tty->count++ there.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/nozomi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1611,6 +1611,7 @@ static int ntty_install(struct tty_drive
 	ret = tty_init_termios(tty);
 	if (ret == 0) {
 		tty_driver_kref_get(driver);
+		tty->count++;
 		driver->ttys[tty->index] = tty;
 	}
 	return ret;


