Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab1AYOkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 09:40:20 -0500
Received: from mx1.zhaw.ch ([160.85.104.50]:51969 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab1AYOkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:40:19 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>
Subject: [PATCH 1/2] tty: serial: altera_uart: remove early_altera_uart_setup
Date: Tue, 25 Jan 2011 15:40:17 +0100
Message-Id: <1295966417-11306-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.0.4
X-PMX-Version: 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.1.25.143322
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __FRAUD_BODY_WEBMAIL 0, __FRAUD_WEBMAIL 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function has no users inside the tree and the nios2 architecture
doesn't use it (anymore) either.

Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/tty/serial/altera_uart.c |   23 -----------------------
 include/linux/altera_uart.h      |    4 ----
 2 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/drivers/tty/serial/altera_uart.c b/drivers/tty/serial/altera_uart.c
index bde59d1..5ef414c 100644
--- a/drivers/tty/serial/altera_uart.c
+++ b/drivers/tty/serial/altera_uart.c
@@ -406,29 +406,6 @@ static struct altera_uart altera_uart_ports[CONFIG_SERIAL_ALTERA_UART_MAXPORTS];
 
 #if defined(CONFIG_SERIAL_ALTERA_UART_CONSOLE)
 
-int __init early_altera_uart_setup(struct altera_uart_platform_uart *platp)
-{
-	struct uart_port *port;
-	int i;
-
-	for (i = 0; i < CONFIG_SERIAL_ALTERA_UART_MAXPORTS && platp[i].mapbase; i++) {
-		port = &altera_uart_ports[i].port;
-
-		port->line = i;
-		port->type = PORT_ALTERA_UART;
-		port->mapbase = platp[i].mapbase;
-		port->membase = ioremap(port->mapbase, ALTERA_UART_SIZE);
-		port->iotype = SERIAL_IO_MEM;
-		port->irq = platp[i].irq;
-		port->uartclk = platp[i].uartclk;
-		port->flags = UPF_BOOT_AUTOCONF;
-		port->ops = &altera_uart_ops;
-		port->private_data = platp;
-	}
-
-	return 0;
-}
-
 static void altera_uart_console_putc(struct uart_port *port, const char c)
 {
 	while (!(altera_uart_readl(port, ALTERA_UART_STATUS_REG) &
diff --git a/include/linux/altera_uart.h b/include/linux/altera_uart.h
index a10a907..c022c82 100644
--- a/include/linux/altera_uart.h
+++ b/include/linux/altera_uart.h
@@ -5,8 +5,6 @@
 #ifndef	__ALTUART_H
 #define	__ALTUART_H
 
-#include <linux/init.h>
-
 struct altera_uart_platform_uart {
 	unsigned long mapbase;	/* Physical address base */
 	unsigned int irq;	/* Interrupt vector */
@@ -14,6 +12,4 @@ struct altera_uart_platform_uart {
 	unsigned int bus_shift;	/* Bus shift (address stride) */
 };
 
-int __init early_altera_uart_setup(struct altera_uart_platform_uart *platp);
-
 #endif /* __ALTUART_H */
-- 
1.7.0.4

