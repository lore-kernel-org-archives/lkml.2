Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab2FDTDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 15:03:34 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:30192 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755546Ab2FDTDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 15:03:31 -0400
From: Roland Stigge <stigge@antcom.de>
To: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linux@arm.linux.org.uk
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RESEND 1/2] serial/8250: Add LPC3220 standard UART type
Date: Mon,  4 Jun 2012 21:02:54 +0200
Message-Id: <1338836575-21738-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LPC32xx has "Standard" UARTs that are actually 16550A compatible but have
bigger FIFOs. Since the already supported 16X50 line still doesn't match here,
we agreed on adding a new type.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Alan Cox <alan@linux.intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>

---
Applies to v3.5-rc1

 drivers/tty/serial/8250/8250.c |    8 ++++++++
 include/linux/serial_core.h    |    3 ++-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- linux-2.6.orig/drivers/tty/serial/8250/8250.c
+++ linux-2.6/drivers/tty/serial/8250/8250.c
@@ -282,6 +282,14 @@ static const struct serial8250_config ua
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
 		.flags		= UART_CAP_FIFO | UART_CAP_AFE | UART_CAP_EFR,
 	},
+	[PORT_LPC3220] = {
+		.name		= "LPC3220",
+		.fifo_size	= 64,
+		.tx_loadsz	= 32,
+		.fcr		= UART_FCR_DMA_SELECT | UART_FCR_ENABLE_FIFO |
+				  UART_FCR_R_TRIG_00 | UART_FCR_T_TRIG_00,
+		.flags		= UART_CAP_FIFO,
+	},
 };
 
 /* Uart divisor latch read */
--- linux-2.6.orig/include/linux/serial_core.h
+++ linux-2.6/include/linux/serial_core.h
@@ -47,7 +47,8 @@
 #define PORT_U6_16550A	19	/* ST-Ericsson U6xxx internal UART */
 #define PORT_TEGRA	20	/* NVIDIA Tegra internal UART */
 #define PORT_XR17D15X	21	/* Exar XR17D15x UART */
-#define PORT_MAX_8250	21	/* max port ID */
+#define PORT_LPC3220	22	/* NXP LPC32xx SoC "Standard" UART */
+#define PORT_MAX_8250	22	/* max port ID */
 
 /*
  * ARM specific type numbers.  These are not currently guaranteed
