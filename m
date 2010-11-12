Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab0KLNF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 08:05:57 -0500
Received: from smtp.nokia.com ([147.243.128.24]:35727 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab0KLNFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 08:05:54 -0500
From: Emeltchenko Andrei <Andrei.Emeltchenko.news@gmail.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm@lists.arm.linux.org.uk, linux-serial@vger.kernel.org
Subject: [PATCHv4 3/4] OMAP2: Serial: remove magic numbers for MDR1 reg
Date: Fri, 12 Nov 2010 15:04:02 +0200
Message-Id: <1289567043-6213-4-git-send-email-Andrei.Emeltchenko.news@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1289567043-6213-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
References: <1289567043-6213-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>

Change magic number to ones defined in serial_reg
for omap2 serial driver

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
---
 arch/arm/mach-omap2/serial.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
index becf0e3..edd7c99 100644
--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -168,9 +168,9 @@ static inline void serial_write_reg(struct omap_uart_state *uart, int offset,
 
 static inline void __init omap_uart_reset(struct omap_uart_state *uart)
 {
-	serial_write_reg(uart, UART_OMAP_MDR1, 0x07);
+	serial_write_reg(uart, UART_OMAP_MDR1, UART_OMAP_MDR1_DISABLE);
 	serial_write_reg(uart, UART_OMAP_SCR, 0x08);
-	serial_write_reg(uart, UART_OMAP_MDR1, 0x00);
+	serial_write_reg(uart, UART_OMAP_MDR1, UART_OMAP_MDR1_16X_MODE);
 }
 
 #if defined(CONFIG_PM) && defined(CONFIG_ARCH_OMAP3)
@@ -246,9 +246,10 @@ static void omap_uart_restore_context(struct omap_uart_state *uart)
 	uart->context_valid = 0;
 
 	if (uart->errata & UART_ERRATA_i202_MDR1_ACCESS)
-		omap_uart_mdr1_errataset(uart, 0x07, 0xA0);
+		omap_uart_mdr1_errataset(uart, UART_OMAP_MDR1_DISABLE, 0xA0);
 	else
-		serial_write_reg(uart, UART_OMAP_MDR1, 0x7);
+		serial_write_reg(uart, UART_OMAP_MDR1, UART_OMAP_MDR1_DISABLE);
+
 	serial_write_reg(uart, UART_LCR, 0xBF); /* Config B mode */
 	efr = serial_read_reg(uart, UART_EFR);
 	serial_write_reg(uart, UART_EFR, UART_EFR_ECB);
@@ -267,11 +268,13 @@ static void omap_uart_restore_context(struct omap_uart_state *uart)
 	serial_write_reg(uart, UART_OMAP_SCR, uart->scr);
 	serial_write_reg(uart, UART_OMAP_WER, uart->wer);
 	serial_write_reg(uart, UART_OMAP_SYSC, uart->sysc);
+
 	if (uart->errata & UART_ERRATA_i202_MDR1_ACCESS)
-		omap_uart_mdr1_errataset(uart, 0x00, 0xA1);
+		omap_uart_mdr1_errataset(uart, UART_OMAP_MDR1_16X_MODE, 0xA1);
 	else
 		/* UART 16x mode */
-		serial_write_reg(uart, UART_OMAP_MDR1, 0x00);
+		serial_write_reg(uart, UART_OMAP_MDR1,
+				UART_OMAP_MDR1_16X_MODE);
 }
 #else
 static inline void omap_uart_save_context(struct omap_uart_state *uart) {}
-- 
1.7.0.4

