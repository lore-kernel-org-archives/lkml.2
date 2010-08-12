Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535Ab0HLASP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:18:15 -0400
Received: from kroah.org ([198.145.64.141]:60510 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932910Ab0HLAIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:11 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:14 2010
Message-Id: <20100812000614.403974919@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>
Subject: [19/67] Char: nozomi, fix tty->count counting
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

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


