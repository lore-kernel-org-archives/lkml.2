Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab1KQF6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 00:58:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55095 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab1KQF6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 00:58:13 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 4/6] pch_uart: delete unused data structure
Date: Thu, 17 Nov 2011 14:57:31 +0900
Message-Id: <1321509453-12008-4-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1321509453-12008-1-git-send-email-tomoya.rohm@gmail.com>
References: <1321509453-12008-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/tty/serial/pch_uart.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 217cf37..6cf71f1 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -215,7 +215,6 @@ struct eg20t_port {
 	int start_tx;
 	int start_rx;
 	int tx_empty;
-	int int_dis_flag;
 	int trigger;
 	int trigger_level;
 	struct pch_uart_buffer rxbuf;
@@ -1011,10 +1010,6 @@ static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
 		}
 		handled |= (unsigned int)ret;
 	}
-	if (handled == 0 && iid <= 1) {
-		if (priv->int_dis_flag)
-			priv->int_dis_flag = 0;
-	}
 
 	spin_unlock_irqrestore(&priv->port.lock, flags);
 	return IRQ_RETVAL(handled);
@@ -1111,7 +1106,6 @@ static void pch_uart_stop_rx(struct uart_port *port)
 	priv = container_of(port, struct eg20t_port, port);
 	priv->start_rx = 0;
 	pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_RX_INT);
-	priv->int_dis_flag = 1;
 }
 
 /* Enable the modem status interrupts. */
-- 
1.7.4.4

