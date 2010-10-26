Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525Ab0JZKS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:18:27 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60792 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759305Ab0JZKSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:18:23 -0400
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 11/14] drivers/serial/vr41xx_siu.c: delete double assignment
Date: Tue, 26 Oct 2010 12:25:40 +0200
Message-Id: <1288088743-3725-12-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288088743-3725-1-git-send-email-julia@diku.dk>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Delete successive assignments to the same location.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/serial/vr41xx_siu.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/serial/vr41xx_siu.c b/drivers/serial/vr41xx_siu.c
index 3beb6ab..121a33e 100644
--- a/drivers/serial/vr41xx_siu.c
+++ b/drivers/serial/vr41xx_siu.c
@@ -849,7 +849,6 @@ void __init vr41xx_siu_early_setup(struct uart_port *port)
 	siu_uart_ports[port->line].type = port->type;
 	siu_uart_ports[port->line].uartclk = SIU_BAUD_BASE * 16;
 	siu_uart_ports[port->line].mapbase = port->mapbase;
-	siu_uart_ports[port->line].mapbase = port->mapbase;
 	siu_uart_ports[port->line].ops = &siu_uart_ops;
 }
 

