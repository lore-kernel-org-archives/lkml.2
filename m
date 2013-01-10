Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab3AJJYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:24:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:4760 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab3AJJYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:24:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,443,1355126400"; 
   d="scan'208";a="244528018"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Jamie Iles <jamie@jamieiles.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv3 2/8] serial: 8250_dw: Don't use UPF_FIXED_TYPE
Date: Thu, 10 Jan 2013 11:25:06 +0200
Message-Id: <1357809912-25790-3-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357809912-25790-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1357809912-25790-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow 8250.c to determine the port type for us. This allows
the driver take advantage of FIFO on Designware UARTs that
have it.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Jamie Iles <jamie@jamieiles.com>
Acked-by: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 1d0dba2..ff83ea5 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -112,7 +112,7 @@ static int dw8250_probe(struct platform_device *pdev)
 	uart.port.handle_irq = dw8250_handle_irq;
 	uart.port.type = PORT_8250;
 	uart.port.flags = UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_IOREMAP |
-		UPF_FIXED_PORT | UPF_FIXED_TYPE;
+		UPF_FIXED_PORT;
 	uart.port.dev = &pdev->dev;
 
 	uart.port.iotype = UPIO_MEM;
-- 
1.7.10.4

