Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab1BRCXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 21:23:52 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:19446 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753942Ab1BRCXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 21:23:14 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 5/8] pch_uart: fix uart clock setting issue
Date: Fri, 18 Feb 2011 11:24:01 +0900
Message-Id: <1297995844-11282-5-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1297995844-11282-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1297995844-11282-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, uart clock is not set correctly.
This patch fixes the issue.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/serial/pch_uart.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/pch_uart.c b/drivers/serial/pch_uart.c
index 6885535..1898861 100644
--- a/drivers/serial/pch_uart.c
+++ b/drivers/serial/pch_uart.c
@@ -1089,7 +1089,12 @@ static int pch_uart_startup(struct uart_port *port)
 
 	priv = container_of(port, struct eg20t_port, port);
 	priv->tx_empty = 1;
-	port->uartclk = priv->base_baud;
+
+	if (port->uartclk)
+		priv->base_baud = port->uartclk;
+	else
+		port->uartclk = priv->base_baud;
+
 	pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_ALL_INT);
 	ret = pch_uart_hal_set_line(priv, default_baud,
 			      PCH_UART_HAL_PARITY_NONE, PCH_UART_HAL_8BIT,
-- 
1.7.3.4

