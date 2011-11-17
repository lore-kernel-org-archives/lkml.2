Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab1KQF6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 00:58:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55095 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab1KQF6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 00:58:17 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 5/6] pch_uart: Fix return value issue
Date: Thu, 17 Nov 2011 14:57:32 +0900
Message-Id: <1321509453-12008-5-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1321509453-12008-1-git-send-email-tomoya.rohm@gmail.com>
References: <1321509453-12008-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, occurring line status interrupt,
returned value is not set in interrupt handler function.
As a result, 0 can be returned.

This patch adds setting returned value.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/tty/serial/pch_uart.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 6cf71f1..8c750d8 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -35,6 +35,7 @@ enum {
 	PCH_UART_HANDLED_RX_ERR_INT_SHIFT,
 	PCH_UART_HANDLED_RX_TRG_INT_SHIFT,
 	PCH_UART_HANDLED_MS_INT_SHIFT,
+	PCH_UART_HANDLED_LS_INT_SHIFT,
 };
 
 enum {
@@ -59,6 +60,8 @@ enum {
 					PCH_UART_HANDLED_RX_TRG_INT_SHIFT)<<1))
 #define PCH_UART_HANDLED_MS_INT	(1<<((PCH_UART_HANDLED_MS_INT_SHIFT)<<1))
 
+#define PCH_UART_HANDLED_LS_INT	(1<<((PCH_UART_HANDLED_LS_INT_SHIFT)<<1))
+
 #define PCH_UART_RBR		0x00
 #define PCH_UART_THR		0x00
 
@@ -968,6 +971,8 @@ static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
 						UART_LSR_PE | UART_LSR_OE)) {
 				pch_uart_err_ir(priv, lsr);
 				ret = PCH_UART_HANDLED_RX_ERR_INT;
+			} else {
+				ret = PCH_UART_HANDLED_LS_INT;
 			}
 			break;
 		case PCH_UART_IID_RDR:	/* Received Data Ready */
-- 
1.7.4.4

