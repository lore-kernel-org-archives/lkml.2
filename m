Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab2LCLQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 06:16:48 -0500
Received: from mga03.intel.com ([143.182.124.21]:54270 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab2LCLQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 06:16:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,205,1355126400"; 
   d="scan'208";a="175377261"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Jamie Iles <jamie@jamieiles.com>,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 3/5] serial: 8250_dw: Map IO memory
Date: Mon,  3 Dec 2012 13:17:57 +0200
Message-Id: <1354533479-27306-4-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354533479-27306-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1354533479-27306-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This needs to be done in order to later access the
Designware specific registers.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dw.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index ff83ea5..300bbed 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -111,10 +111,13 @@ static int dw8250_probe(struct platform_device *pdev)
 	uart.port.irq = irq->start;
 	uart.port.handle_irq = dw8250_handle_irq;
 	uart.port.type = PORT_8250;
-	uart.port.flags = UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_IOREMAP |
-		UPF_FIXED_PORT;
+	uart.port.flags = UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_FIXED_PORT;
 	uart.port.dev = &pdev->dev;
 
+	uart.port.membase = ioremap(regs->start, regs->end - regs->start);
+	if (!uart.port.membase)
+		return -ENOMEM;
+
 	uart.port.iotype = UPIO_MEM;
 	uart.port.serial_in = dw8250_serial_in;
 	uart.port.serial_out = dw8250_serial_out;
-- 
1.7.10.4

