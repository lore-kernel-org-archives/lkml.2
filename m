Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab1J0Gp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 02:45:57 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:33655 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752259Ab1J0Gpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 02:45:46 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 2/2] pch_uart: Delete modem status interrupt enable code
Date: Thu, 27 Oct 2011 15:45:19 +0900
Message-Id: <1319697919-5623-2-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1319697919-5623-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1319697919-5623-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, modem status interrupt software processing is not implemented.
So, if enabling modem status interrupt, the interrupt processing is not
processed correctly.
(pch_uart device has auto hardware flow control function. So, pch_uart driver
doesn't have to control modem status interrupt.)
This patch deletes the code.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/tty/serial/pch_uart.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index b1aabe8..1a076cd 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1121,7 +1121,8 @@ static void pch_uart_enable_ms(struct uart_port *port)
 {
 	struct eg20t_port *priv;
 	priv = container_of(port, struct eg20t_port, port);
-	pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_MS_INT);
+	dev_info(priv->port.dev,
+		"PCH UART : Modem status interrupt is not supported.\n");
 }
 
 /* Control the transmission of a break signal. */
-- 
1.7.4.4

