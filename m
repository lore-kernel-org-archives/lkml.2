Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab1KQF6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 00:58:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55095 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab1KQF6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 00:58:01 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 1/6] pch_uart: change type to u8
Date: Thu, 17 Nov 2011 14:57:28 +0900
Message-Id: <1321509453-12008-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Target uart register access size is 8bit.
However, 32bit is used at 2 points.

This patch modifies type "unsigned int" to "unsigned char".

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/tty/serial/pch_uart.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 284fa48..797fad2 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -460,14 +460,10 @@ static int pch_uart_hal_read(struct eg20t_port *priv, unsigned char *buf,
 	return i;
 }
 
-static unsigned int pch_uart_hal_get_iid(struct eg20t_port *priv)
+static unsigned char pch_uart_hal_get_iid(struct eg20t_port *priv)
 {
-	unsigned int iir;
-	int ret;
-
-	iir = ioread8(priv->membase + UART_IIR);
-	ret = (iir & (PCH_UART_IIR_IID | PCH_UART_IIR_TOI | PCH_UART_IIR_IP));
-	return ret;
+	return ioread8(priv->membase + UART_IIR) &\
+		      (PCH_UART_IIR_IID | PCH_UART_IIR_TOI | PCH_UART_IIR_IP);
 }
 
 static u8 pch_uart_hal_get_line_status(struct eg20t_port *priv)
@@ -955,7 +951,7 @@ static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
 	unsigned int handled;
 	u8 lsr;
 	int ret = 0;
-	unsigned int iid;
+	unsigned char iid;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->port.lock, flags);
-- 
1.7.4.4

