Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab2EZQMO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 12:12:14 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:49357 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752713Ab2EZQMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 12:12:13 -0400
From: Roland Stigge <stigge@antcom.de>
To: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RFC] serial/8250: Adjusting FIFO parameters for LPC32xx
Date: Sat, 26 May 2012 18:11:18 +0200
Message-Id: <1338048678-23991-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is how the modified FIFO is handled in the repositories at
git.lpclinux.com. Is there a better way for doing this (without ifdef)?  Looks
like registering additional types (like PORT_16550A) isn't encouraged.  Maybe
extending of_serial.c? The latter currently doesn't handle .fifosize and
.tx_loadsz, though.

Any suggestions appreciated.

Thanks in advance,

Roland
 
---
 drivers/tty/serial/8250/8250.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- linux-2.6.orig/drivers/tty/serial/8250/8250.c
+++ linux-2.6/drivers/tty/serial/8250/8250.c
@@ -158,9 +158,16 @@ static const struct serial8250_config ua
 	},
 	[PORT_16550A] = {
 		.name		= "16550A",
+#ifdef CONFIG_ARCH_LPC32XX
+		.fifo_size	= 64,
+		.tx_loadsz	= 32,
+		.fcr		= UART_FCR_DMA_SELECT | UART_FCR_ENABLE_FIFO |
+				  UART_FCR_R_TRIG_00 | UART_FCR_T_TRIG_00,
+#else
 		.fifo_size	= 16,
 		.tx_loadsz	= 16,
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+#endif
 		.flags		= UART_CAP_FIFO,
 	},
 	[PORT_CIRRUS] = {
