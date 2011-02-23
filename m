Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab1BWBFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:05:51 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:17358 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580Ab1BWBEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:04:49 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jesper Juhl <jj@chaosbits.net>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH linux-next 5/8] pch_uart: fix uart clock setting issue
Date: Wed, 23 Feb 2011 10:03:16 +0900
Message-Id: <1298422999-4050-5-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1298422999-4050-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1298422999-4050-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, uart clock is not set correctly.
This patch fixes the issue.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/tty/serial/pch_uart.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 6807f61..7179202 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1088,7 +1088,12 @@ static int pch_uart_startup(struct uart_port *port)
 
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

