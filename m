Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab2CENxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:53:13 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34613 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab2CENxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:07 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 02/68] TTY: tty_io, remove buffer re-assignments
Date: Mon,  5 Mar 2012 14:51:49 +0100
Message-Id: <1330955575-26641-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TTY buffer head and tail are initialized in tty_buffer_init. No need
to do it once again in initialize_tty_struct where tty_buffer_init is
called.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_io.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 44736f9..f105ce5 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2933,7 +2933,6 @@ void initialize_tty_struct(struct tty_struct *tty,
 	tty->session = NULL;
 	tty->pgrp = NULL;
 	tty->overrun_time = jiffies;
-	tty->buf.head = tty->buf.tail = NULL;
 	tty_buffer_init(tty);
 	mutex_init(&tty->termios_mutex);
 	mutex_init(&tty->ldisc_mutex);
-- 
1.7.9.2


