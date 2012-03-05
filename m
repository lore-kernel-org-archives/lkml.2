Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965157Ab2CEOHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:07:16 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34666 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab2CENxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 46/68] TTY: simserial, remove some tty ops
Date: Mon,  5 Mar 2012 14:52:33 +0100
Message-Id: <1330955575-26641-47-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All ->start, ->stop and ->wait_until_sent are empty and need not be
defined. The time to remove them is now.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |   39 +--------------------------------------
 1 file changed, 1 insertion(+), 38 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 909357e..d173dba 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -64,32 +64,7 @@ static struct console *console;
 
 extern struct console *console_drivers; /* from kernel/printk.c */
 
-/*
- * ------------------------------------------------------------
- * rs_stop() and rs_start()
- *
- * This routines are called before setting or resetting tty->stopped.
- * They enable or disable transmitter interrupts, as necessary.
- * ------------------------------------------------------------
- */
-static void rs_stop(struct tty_struct *tty)
-{
-#ifdef SIMSERIAL_DEBUG
-	printk("rs_stop: tty->stopped=%d tty->hw_stopped=%d tty->flow_stopped=%d\n",
-		tty->stopped, tty->hw_stopped, tty->flow_stopped);
-#endif
-
-}
-
-static void rs_start(struct tty_struct *tty)
-{
-#ifdef SIMSERIAL_DEBUG
-	printk("rs_start: tty->stopped=%d tty->hw_stopped=%d tty->flow_stopped=%d\n",
-		tty->stopped, tty->hw_stopped, tty->flow_stopped);
-#endif
-}
-
-static  void receive_chars(struct tty_struct *tty)
+static void receive_chars(struct tty_struct *tty)
 {
 	unsigned char ch;
 	static unsigned char seen_esc = 0;
@@ -406,7 +381,6 @@ static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 	if ((old_termios->c_cflag & CRTSCTS) &&
 	    !(tty->termios->c_cflag & CRTSCTS)) {
 		tty->hw_stopped = 0;
-		rs_start(tty);
 	}
 }
 /*
@@ -514,14 +488,6 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 }
 
 /*
- * rs_wait_until_sent() --- wait until the transmitter is empty
- */
-static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
-{
-}
-
-
-/*
  * rs_hangup() --- called by tty_hangup() when a hangup is signaled.
  */
 static void rs_hangup(struct tty_struct *tty)
@@ -736,10 +702,7 @@ static const struct tty_operations hp_ops = {
 	.unthrottle = rs_unthrottle,
 	.send_xchar = rs_send_xchar,
 	.set_termios = rs_set_termios,
-	.stop = rs_stop,
-	.start = rs_start,
 	.hangup = rs_hangup,
-	.wait_until_sent = rs_wait_until_sent,
 	.proc_fops = &rs_proc_fops,
 };
 
-- 
1.7.9.2


