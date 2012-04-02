Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab2DBL4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:51 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48195 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab2DBLzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH 53/69] TTY: 68328serial, remove garbage
Date: Mon,  2 Apr 2012 13:54:37 +0200
Message-Id: <1333367693-3244-54-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- empty functions
- unused global variables

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
---
 drivers/tty/serial/68328serial.c |   19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index c1cd214..81ed91e 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -73,11 +73,6 @@ static unsigned int uart_irqs[NR_PORTS] = UART_IRQ_DEFNS;
 /* multiple ports are contiguous in memory */
 m68328_uart *uart_addr = (m68328_uart *)USTCNT_ADDR;
 
-struct tty_struct m68k_ttys;
-struct m68k_serial *m68k_consinfo = 0;
-
-#define M68K_CLOCK (16667000) /* FIXME: 16MHz is likely wrong */
-
 struct tty_driver *serial_driver;
 
 static void change_speed(struct m68k_serial *info);
@@ -132,17 +127,6 @@ static int baud_table[] = {
 	0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400, 4800,
 	9600, 19200, 38400, 57600, 115200, 0 };
 
-/* Sets or clears DTR/RTS on the requested line */
-static inline void m68k_rtsdtr(struct m68k_serial *ss, int set)
-{
-	if (set) {
-		/* set the RTS/CTS line */
-	} else {
-		/* clear it */
-	}
-	return;
-}
-
 /* Utility routines */
 static inline int get_baud(struct m68k_serial *ss)
 {
@@ -1104,9 +1088,6 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	info->count--;
 	info->blocked_open++;
 	while (1) {
-		local_irq_disable();
-		m68k_rtsdtr(info, 1);
-		local_irq_enable();
 		current->state = TASK_INTERRUPTIBLE;
 		if (tty_hung_up_p(filp) ||
 		    !(info->flags & ASYNC_INITIALIZED)) {
-- 
1.7.9.2


