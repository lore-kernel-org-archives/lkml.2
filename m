Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965168Ab2CEOD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:03:28 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34707 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab2CENxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:15 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 07/68] TTY: remove tty driver re-set from tty_reopen
Date: Mon,  5 Mar 2012 14:51:54 +0100
Message-Id: <1330955575-26641-8-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is from tty_reopen:
    struct tty_driver *driver = tty->driver;
    ...
    tty->driver = driver;
and it doesn't make sense at all. The driver is intended to be set in
initialize_tty_struct from tty_init_dev (initial open). So this set in
tty_reopen is not needed.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_io.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index d0d3d1f..dd8a938 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1348,7 +1348,6 @@ static int tty_reopen(struct tty_struct *tty)
 		tty->link->count++;
 	}
 	tty->count++;
-	tty->driver = driver; /* N.B. why do this every time?? */
 
 	mutex_lock(&tty->ldisc_mutex);
 	WARN_ON(!test_bit(TTY_LDISC, &tty->flags));
-- 
1.7.9.2


