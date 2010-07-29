Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0G2JJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 05:09:55 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:50336 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab0G2JJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 05:09:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/1] Char: nozomi, fix tty->count counting
Date: Thu, 29 Jul 2010 11:09:47 +0200
Message-Id: <1280394587-31670-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently ntty_install omits to increment tty count and we get the
following warnings:
Warning: dev (noz2) tty->count(0) != #fd's(1) in tty_open

So to fix that, add one tty->count++ there.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/char/nozomi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index d578449..7f9b858 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1611,6 +1611,7 @@ static int ntty_install(struct tty_driver *driver, struct tty_struct *tty)
 	ret = tty_init_termios(tty);
 	if (ret == 0) {
 		tty_driver_kref_get(driver);
+		tty->count++;
 		driver->ttys[tty->index] = tty;
 	}
 	return ret;
-- 
1.7.2


