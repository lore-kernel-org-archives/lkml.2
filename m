Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab0JVSXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:23:42 -0400
Received: from kroah.org ([198.145.64.141]:37700 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758686Ab0JVSXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:23:40 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 39/49] altera_uart: Fixup type usage of port flags
Date: Fri, 22 Oct 2010 11:21:18 -0700
Message-Id: <1287771688-14805-39-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <cbouatmailru@gmail.com>

port->flags is of type upf_t, which corresponds to UPF_* flags.

ASYNC_BOOT_AUTOCONF is an unsigned integer, which happen to
be the same as UPF_BOOT_AUTOCONF.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Acked-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/altera_uart.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/altera_uart.c b/drivers/serial/altera_uart.c
index fbc8f8e..dfc1ecc 100644
--- a/drivers/serial/altera_uart.c
+++ b/drivers/serial/altera_uart.c
@@ -421,7 +421,7 @@ int __init early_altera_uart_setup(struct altera_uart_platform_uart *platp)
 		port->iotype = SERIAL_IO_MEM;
 		port->irq = platp[i].irq;
 		port->uartclk = platp[i].uartclk;
-		port->flags = ASYNC_BOOT_AUTOCONF;
+		port->flags = UPF_BOOT_AUTOCONF;
 		port->ops = &altera_uart_ops;
 		port->private_data = platp;
 	}
@@ -551,7 +551,7 @@ static int __devinit altera_uart_probe(struct platform_device *pdev)
 	port->iotype = SERIAL_IO_MEM;
 	port->uartclk = platp->uartclk;
 	port->ops = &altera_uart_ops;
-	port->flags = ASYNC_BOOT_AUTOCONF;
+	port->flags = UPF_BOOT_AUTOCONF;
 	port->private_data = platp;
 
 	uart_add_one_port(&altera_uart_driver, port);
-- 
1.7.2

