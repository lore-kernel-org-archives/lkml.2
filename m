Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030196Ab2CEOJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:09:58 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34626 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313Ab2CENxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Chris Zankel <chris@zankel.net>
Subject: [PATCH 20/68] TTY: iss/console, use tty_port
Date: Mon,  5 Mar 2012 14:52:07 +0100
Message-Id: <1330955575-26641-21-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though the port is not used for anything real there yet, this
will change as tty buffers will be in tty_port in the near future. So
the port will be needed in all drivers.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Chris Zankel <chris@zankel.net>
---
 arch/xtensa/platforms/iss/console.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
index 94ab8ec..d1a7861 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -37,6 +37,7 @@
 #define SERIAL_TIMER_VALUE (20 * HZ)
 
 static struct tty_driver *serial_driver;
+static struct tty_port serial_port;
 static struct timer_list serial_timer;
 
 static DEFINE_SPINLOCK(timer_lock);
@@ -68,6 +69,7 @@ static void rs_poll(unsigned long);
 
 static int rs_open(struct tty_struct *tty, struct file * filp)
 {
+	tty->port = &serial_port;
 	spin_lock(&timer_lock);
 	if (tty->count == 1) {
 		setup_timer(&serial_timer, rs_poll, (unsigned long)tty);
@@ -202,6 +204,8 @@ static const struct tty_operations serial_ops = {
 
 int __init rs_init(void)
 {
+	tty_port_init(&serial_port);
+
 	serial_driver = alloc_tty_driver(SERIAL_MAX_NUM_LINES);
 
 	printk ("%s %s\n", serial_name, serial_version);
-- 
1.7.9.2


