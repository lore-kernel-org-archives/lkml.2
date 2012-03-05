Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965011Ab2CENzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:55:40 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34887 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425Ab2CENxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:31 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Chris Zankel <chris@zankel.net>
Subject: [PATCH 18/68] XTENSA: iss/console, use setup_timer
Date: Mon,  5 Mar 2012 14:52:05 +0100
Message-Id: <1330955575-26641-19-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use setup_timer instead of explicit assignments.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Chris Zankel <chris@zankel.net>
---
 arch/xtensa/platforms/iss/console.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
index 19a802a..01842e4 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -69,11 +69,8 @@ static void rs_poll(unsigned long);
 static int rs_open(struct tty_struct *tty, struct file * filp)
 {
 	spin_lock(&timer_lock);
-
 	if (tty->count == 1) {
-		init_timer(&serial_timer);
-		serial_timer.data = (unsigned long) tty;
-		serial_timer.function = rs_poll;
+		setup_timer(&serial_timer, rs_poll, (unsigned long)tty);
 		mod_timer(&serial_timer, jiffies + SERIAL_TIMER_VALUE);
 	}
 	spin_unlock(&timer_lock);
-- 
1.7.9.2


