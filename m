Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab1LDXoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 18:44:00 -0500
Received: from mail.windriver.com ([147.11.1.11]:63547 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab1LDXmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 18:42:38 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: alan@linux.intel.com, gregkh@suse.de, scottwood@freescale.com,
        galak@kernel.crashing.org
Cc: linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] serial: move struct uart_8250_port from 8250.c to 8250.h
Date: Sun,  4 Dec 2011 18:42:18 -0500
Message-Id: <1323042143-25330-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323042143-25330-1-git-send-email-paul.gortmaker@windriver.com>
References: <1322783258-20443-1-git-send-email-paul.gortmaker@windriver.com>
 <1323042143-25330-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we want to promote sharing and move away from one single
uart driver with a bunch of platform specific bugfixes all
munged into one, relocate some header like material from
the C file to the header.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/tty/serial/8250.c |   26 --------------------------
 drivers/tty/serial/8250.h |   26 ++++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index eeadf1b..d97628e 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -129,32 +129,6 @@ static unsigned long probe_rsa[PORT_RSA_MAX];
 static unsigned int probe_rsa_count;
 #endif /* CONFIG_SERIAL_8250_RSA  */
 
-struct uart_8250_port {
-	struct uart_port	port;
-	struct timer_list	timer;		/* "no irq" timer */
-	struct list_head	list;		/* ports on this IRQ */
-	unsigned short		capabilities;	/* port capabilities */
-	unsigned short		bugs;		/* port bugs */
-	unsigned int		tx_loadsz;	/* transmit fifo load size */
-	unsigned char		acr;
-	unsigned char		ier;
-	unsigned char		lcr;
-	unsigned char		mcr;
-	unsigned char		mcr_mask;	/* mask of user bits */
-	unsigned char		mcr_force;	/* mask of forced bits */
-	unsigned char		cur_iotype;	/* Running I/O type */
-
-	/*
-	 * Some bits in registers are cleared on a read, so they must
-	 * be saved whenever the register is read but the bits will not
-	 * be immediately processed.
-	 */
-#define LSR_SAVE_FLAGS UART_LSR_BRK_ERROR_BITS
-	unsigned char		lsr_saved_flags;
-#define MSR_SAVE_FLAGS UART_MSR_ANY_DELTA
-	unsigned char		msr_saved_flags;
-};
-
 struct irq_info {
 	struct			hlist_node node;
 	int			irq;
diff --git a/drivers/tty/serial/8250.h b/drivers/tty/serial/8250.h
index 6edf4a6..ae027be 100644
--- a/drivers/tty/serial/8250.h
+++ b/drivers/tty/serial/8250.h
@@ -13,6 +13,32 @@
 
 #include <linux/serial_8250.h>
 
+struct uart_8250_port {
+	struct uart_port	port;
+	struct timer_list	timer;		/* "no irq" timer */
+	struct list_head	list;		/* ports on this IRQ */
+	unsigned short		capabilities;	/* port capabilities */
+	unsigned short		bugs;		/* port bugs */
+	unsigned int		tx_loadsz;	/* transmit fifo load size */
+	unsigned char		acr;
+	unsigned char		ier;
+	unsigned char		lcr;
+	unsigned char		mcr;
+	unsigned char		mcr_mask;	/* mask of user bits */
+	unsigned char		mcr_force;	/* mask of forced bits */
+	unsigned char		cur_iotype;	/* Running I/O type */
+
+	/*
+	 * Some bits in registers are cleared on a read, so they must
+	 * be saved whenever the register is read but the bits will not
+	 * be immediately processed.
+	 */
+#define LSR_SAVE_FLAGS UART_LSR_BRK_ERROR_BITS
+	unsigned char		lsr_saved_flags;
+#define MSR_SAVE_FLAGS UART_MSR_ANY_DELTA
+	unsigned char		msr_saved_flags;
+};
+
 struct old_serial_port {
 	unsigned int uart;
 	unsigned int baud_base;
-- 
1.7.7

