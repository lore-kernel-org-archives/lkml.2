Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab2ASTh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 14:37:58 -0500
Received: from mail-fx0-f74.google.com ([209.85.161.74]:62015 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab2ASThz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 14:37:55 -0500
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Kosina <trivial@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-serial@vger.kernel.org, Simon Glass <sjg@chromium.org>
Subject: [PATCH] serial: trivial checkpatch fixes in drivers/tty/serial/8250.c
Date: Thu, 19 Jan 2012 11:37:47 -0800
Message-Id: <1327001868-29941-1-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the file checkpatch clean, fixing these warnings:

warning: drivers/tty/serial/8250.c,86: please, no space before tabs
warning: drivers/tty/serial/8250.c,345: please, no space before tabs
warning: drivers/tty/serial/8250.c,672: line over 80 characters
warning: drivers/tty/serial/8250.c,1070: line over 80 characters
warning: drivers/tty/serial/8250.c,1517: line over 80 characters
warning: drivers/tty/serial/8250.c,1519: line over 80 characters
warning: drivers/tty/serial/8250.c,2009: line over 80 characters
warning: drivers/tty/serial/8250.c,2023: line over 80 characters
warning: drivers/tty/serial/8250.c,2025: line over 80 characters
warning: drivers/tty/serial/8250.c,2230: line over 80 characters
error: drivers/tty/serial/8250.c,2252: code indent should use tabs where
	possible
warning: drivers/tty/serial/8250.c,3056: line over 80 characters
warning: drivers/tty/serial/8250.c,3133: line over 80 characters
warning: drivers/tty/serial/8250.c,3337: EXPORT_SYMBOL(foo); should
	immediately follow its function/variable
warning: drivers/tty/serial/8250.c,3338: EXPORT_SYMBOL(foo); should
	immediately follow its function/variable
warning: drivers/tty/serial/8250.c,3348: line over 80 characters

This warning remains, since I am not sure how to fix it:
error: drivers/tty/serial/8250.c,2929: Macros with complex values should
	be enclosed in parenthesis

I am not sure if trivial includes all of the above - please let me know.

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 drivers/tty/serial/8250.c |   53 ++++++++++++++++++++++++++------------------
 1 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 9f50c4e..5e72f99 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -83,7 +83,7 @@ static unsigned int skip_txen_test; /* force skip of txen test at init time */
 
 #define PASS_LIMIT	512
 
-#define BOTH_EMPTY 	(UART_LSR_TEMT | UART_LSR_THRE)
+#define BOTH_EMPTY	(UART_LSR_TEMT | UART_LSR_THRE)
 
 
 /*
@@ -342,7 +342,7 @@ static const u8
 		[UART_SCR]	= 0x2c
 	},
 	regmap_out[8] = {
-		[UART_TX] 	= 0x04,
+		[UART_TX]	= 0x04,
 		[UART_IER]	= 0x0c,
 		[UART_FCR]	= 0x18,
 		[UART_LCR]	= 0x1c,
@@ -669,7 +669,8 @@ static void disable_rsa(struct uart_8250_port *up)
 		result = !(mode & UART_RSA_MSR_FIFO);
 
 		if (!result) {
-			serial_outp(up, UART_RSA_MSR, mode & ~UART_RSA_MSR_FIFO);
+			serial_outp(up, UART_RSA_MSR, mode
+					& ~UART_RSA_MSR_FIFO);
 			mode = serial_inp(up, UART_RSA_MSR);
 			result = !(mode & UART_RSA_MSR_FIFO);
 		}
@@ -865,7 +866,7 @@ static int broken_efr(struct uart_8250_port *up)
 	/*
 	 * Exar ST16C2550 "A2" devices incorrectly detect as
 	 * having an EFR, and report an ID of 0x0201.  See
-	 * http://linux.derkeiler.com/Mailing-Lists/Kernel/2004-11/4812.html 
+	 * http://linux.derkeiler.com/Mailing-Lists/Kernel/2004-11/4812.html
 	 */
 	if (autoconfig_read_divisor_id(up) == 0x0201 && size_fifo(up) == 16)
 		return 1;
@@ -1067,7 +1068,8 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 		return;
 
 	DEBUG_AUTOCONF("ttyS%d: autoconf (0x%04lx, 0x%p): ",
-		       serial_index(&up->port), up->port.iobase, up->port.membase);
+		       serial_index(&up->port), up->port.iobase,
+		       up->port.membase);
 
 	/*
 	 * We really do need global IRQs disabled here - we're going to
@@ -1514,9 +1516,11 @@ unsigned int serial8250_modem_status(struct uart_8250_port *up)
 		if (status & UART_MSR_DDSR)
 			up->port.icount.dsr++;
 		if (status & UART_MSR_DDCD)
-			uart_handle_dcd_change(&up->port, status & UART_MSR_DCD);
+			uart_handle_dcd_change(&up->port,
+					       status & UART_MSR_DCD);
 		if (status & UART_MSR_DCTS)
-			uart_handle_cts_change(&up->port, status & UART_MSR_CTS);
+			uart_handle_cts_change(&up->port,
+					       status & UART_MSR_CTS);
 
 		wake_up_interruptible(&up->port.state->port.delta_msr_wait);
 	}
@@ -2006,7 +2010,8 @@ static int serial8250_startup(struct uart_port *port)
 	 */
 	if (!(up->port.flags & UPF_BUGGY_UART) &&
 	    (serial_inp(up, UART_LSR) == 0xff)) {
-		printk_ratelimited(KERN_INFO "ttyS%d: LSR safety check engaged!\n",
+		printk_ratelimited(KERN_INFO
+				   "ttyS%d: LSR safety check engaged!\n",
 				   serial_index(&up->port));
 		return -ENODEV;
 	}
@@ -2019,10 +2024,13 @@ static int serial8250_startup(struct uart_port *port)
 
 		serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_B);
 
-		fctr = serial_inp(up, UART_FCTR) & ~(UART_FCTR_RX|UART_FCTR_TX);
-		serial_outp(up, UART_FCTR, fctr | UART_FCTR_TRGD | UART_FCTR_RX);
+		fctr = serial_inp(up, UART_FCTR) &
+				  ~(UART_FCTR_RX | UART_FCTR_TX);
+		serial_outp(up, UART_FCTR, fctr | UART_FCTR_TRGD |
+			    UART_FCTR_RX);
 		serial_outp(up, UART_TRG, UART_TRG_96);
-		serial_outp(up, UART_FCTR, fctr | UART_FCTR_TRGD | UART_FCTR_TX);
+		serial_outp(up, UART_FCTR, fctr | UART_FCTR_TRGD |
+			    UART_FCTR_TX);
 		serial_outp(up, UART_TRG, UART_TRG_96);
 
 		serial_outp(up, UART_LCR, 0);
@@ -2247,9 +2255,8 @@ static unsigned int serial8250_get_divisor(struct uart_port *port, unsigned int
 	return quot;
 }
 
-void
-serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
-		          struct ktermios *old)
+void serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
+			       struct ktermios *old)
 {
 	struct uart_8250_port *up =
 		container_of(port, struct uart_8250_port, port);
@@ -2992,6 +2999,7 @@ void serial8250_suspend_port(int line)
 {
 	uart_suspend_port(&serial8250_reg, &serial8250_ports[line].port);
 }
+EXPORT_SYMBOL(serial8250_suspend_port);
 
 /**
  *	serial8250_resume_port - resume one serial port
@@ -3014,6 +3022,7 @@ void serial8250_resume_port(int line)
 	}
 	uart_resume_port(&serial8250_reg, &up->port);
 }
+EXPORT_SYMBOL(serial8250_resume_port);
 
 /*
  * Register a set of serial devices attached to a platform device.  The
@@ -3053,8 +3062,8 @@ static int __devinit serial8250_probe(struct platform_device *dev)
 		port.irqflags		|= irqflag;
 		ret = serial8250_register_port(&port);
 		if (ret < 0) {
-			dev_err(&dev->dev, "unable to register port at index %d "
-				"(IO%lx MEM%llx IRQ%d): %d\n", i,
+			dev_err(&dev->dev, "unable to register port at "
+				"index %d (IO%lx MEM%llx IRQ%d): %d\n", i,
 				p->iobase, (unsigned long long)p->mapbase,
 				p->irq, ret);
 		}
@@ -3130,7 +3139,8 @@ static struct platform_device *serial8250_isa_devs;
  */
 static DEFINE_MUTEX(serial_mutex);
 
-static struct uart_8250_port *serial8250_find_match_or_unused(struct uart_port *port)
+static struct uart_8250_port *serial8250_find_match_or_unused(
+						struct uart_port *port)
 {
 	int i;
 
@@ -3334,9 +3344,6 @@ static void __exit serial8250_exit(void)
 module_init(serial8250_init);
 module_exit(serial8250_exit);
 
-EXPORT_SYMBOL(serial8250_suspend_port);
-EXPORT_SYMBOL(serial8250_resume_port);
-
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Generic 8250/16x50 serial driver");
 
@@ -3345,10 +3352,12 @@ MODULE_PARM_DESC(share_irqs, "Share IRQs with other non-8250/16x50 devices"
 	" (unsafe)");
 
 module_param(nr_uarts, uint, 0644);
-MODULE_PARM_DESC(nr_uarts, "Maximum number of UARTs supported. (1-" __MODULE_STRING(CONFIG_SERIAL_8250_NR_UARTS) ")");
+MODULE_PARM_DESC(nr_uarts, "Maximum number of UARTs supported. (1-" \
+		 __MODULE_STRING(CONFIG_SERIAL_8250_NR_UARTS) ")");
 
 module_param(skip_txen_test, uint, 0644);
-MODULE_PARM_DESC(skip_txen_test, "Skip checking for the TXEN bug at init time");
+MODULE_PARM_DESC(skip_txen_test, \
+		"Skip checking for the TXEN bug at init time");
 
 #ifdef CONFIG_SERIAL_8250_RSA
 module_param_array(probe_rsa, ulong, &probe_rsa_count, 0444);
-- 
1.7.7.3

