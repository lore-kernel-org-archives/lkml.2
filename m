Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab2IXGUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 02:20:31 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:25614 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab2IXGU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 02:20:29 -0400
Date: Mon, 24 Sep 2012 08:19:03 +0200
Message-Id: <201209240619.q8O6J3Ft029443@localhost.localdomain>
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Alan Cox <alan@linux.intel.com>, Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] Powerpc 8xx CPM_UART too many interrupts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting the fifo to only 1 byte generates one interrupt every 1ms at 9600 bauds.
This is too much. This patch reduces the threshold to speeds below 2400 bauds 
like in the 8250 UART driver.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

--- linux-3.5-vanilla/drivers/tty/serial/cpm_uart/cpm_uart_core.c	2012-07-21 22:58:29.000000000 +0200
+++ linux-3.5/drivers/tty/serial/cpm_uart/cpm_uart_core.c	2012-08-09 17:38:37.000000000 +0200
@@ -71,7 +71,7 @@
 
 /**************************************************************/
 
-#define HW_BUF_SPD_THRESHOLD    9600
+#define HW_BUF_SPD_THRESHOLD    2400
 
 /*
  * Check, if transmit buffers are processed
@@ -505,7 +505,7 @@
 	pr_debug("CPM uart[%d]:set_termios\n", port->line);
 
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk / 16);
-	if (baud <= HW_BUF_SPD_THRESHOLD ||
+	if (baud < HW_BUF_SPD_THRESHOLD ||
 	    (pinfo->port.state && pinfo->port.state->port.tty->low_latency))
 		pinfo->rx_fifosize = 1;
 	else
