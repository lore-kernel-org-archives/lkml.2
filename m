Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965064Ab2CEN51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:57:27 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34847 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964849Ab2CENx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:27 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 52/68] TTY: simserial, remove useless comments
Date: Mon,  5 Mar 2012 14:52:39 +0100
Message-Id: <1330955575-26641-53-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Or the obsolete ones like:
   "Let's have a little bit of fun"
I have never had fun with software. For fun, one needs hard-ware.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |   29 +----------------------------
 1 file changed, 1 insertion(+), 28 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 323c932..d8237c3 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -4,16 +4,11 @@
  * This driver is mostly used for bringup purposes and will go away.
  * It has a strong dependency on the system console. All outputs
  * are rerouted to the same facility as the one used by printk which, in our
- * case means sys_sim.c console (goes via the simulator). The code hereafter
- * is completely leveraged from the serial.c driver.
+ * case means sys_sim.c console (goes via the simulator).
  *
  * Copyright (C) 1999-2000, 2002-2003 Hewlett-Packard Co
  *	Stephane Eranian <eranian@hpl.hp.com>
  *	David Mosberger-Tang <davidm@hpl.hp.com>
- *
- * 02/04/00 D. Mosberger	Merged in serial.c bug fixes in rs_close().
- * 02/25/00 D. Mosberger	Synced up with 2.3.99pre-5 version of serial.c.
- * 07/30/02 D. Mosberger	Replace sti()/cli() with explicit spinlocks & local irq masking
  */
 
 #include <linux/init.h>
@@ -441,9 +436,6 @@ static int activate(struct tty_port *port, struct tty_struct *tty)
 	else
 		state->xmit.buf = (unsigned char *) page;
 
-	/*
-	 * Allocate the IRQ if necessary
-	 */
 	if (state->irq) {
 		retval = request_irq(state->irq, rs_interrupt_single, 0,
 				"simserial", state);
@@ -525,19 +517,6 @@ static const struct file_operations rs_proc_fops = {
 	.release	= single_release,
 };
 
-/*
- * ---------------------------------------------------------------------
- * rs_init() and friends
- *
- * rs_init() is called at boot-time to initialize the serial driver.
- * ---------------------------------------------------------------------
- */
-
-/*
- * This routine prints out the appropriate serial driver version
- * number, and identifies which options were configured into this
- * driver.
- */
 static inline void show_serial_version(void)
 {
 	printk(KERN_INFO "%s version %s with", serial_name, serial_version);
@@ -567,9 +546,6 @@ static const struct tty_port_operations hp_port_ops = {
 	.shutdown = shutdown,
 };
 
-/*
- * The serial driver boot-time initialization code!
- */
 static int __init simrs_init(void)
 {
 	struct serial_state *state;
@@ -598,9 +574,6 @@ static int __init simrs_init(void)
 	hp_simserial_driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(hp_simserial_driver, &hp_ops);
 
-	/*
-	 * Let's have a little bit of fun !
-	 */
 	state = rs_table;
 	tty_port_init(&state->port);
 	state->port.ops = &hp_port_ops;
-- 
1.7.9.2


