Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab0JVSYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:24:13 -0400
Received: from kroah.org ([198.145.64.141]:37706 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833Ab0JVSYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:24:10 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 41/49] altera_uart: Don't use plain integer as NULL pointer
Date: Fri, 22 Oct 2010 11:21:20 -0700
Message-Id: <1287771688-14805-41-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <cbouatmailru@gmail.com>

Fixes sparse warning.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Acked-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/serial/altera_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/altera_uart.c b/drivers/serial/altera_uart.c
index dfc1ecc..7212162 100644
--- a/drivers/serial/altera_uart.c
+++ b/drivers/serial/altera_uart.c
@@ -461,7 +461,7 @@ static int __init altera_uart_console_setup(struct console *co, char *options)
 	if (co->index < 0 || co->index >= CONFIG_SERIAL_ALTERA_UART_MAXPORTS)
 		return -EINVAL;
 	port = &altera_uart_ports[co->index].port;
-	if (port->membase == 0)
+	if (!port->membase)
 		return -ENODEV;
 
 	if (options)
-- 
1.7.2

