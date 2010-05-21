Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934089Ab0EURE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:04:26 -0400
Received: from kroah.org ([198.145.64.141]:50308 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934083Ab0EUQwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:52:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/25] serial: bfin_sport_uart: drop useless status masks
Date: Fri, 21 May 2010 09:51:38 -0700
Message-Id: <1274460714-11277-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165113.GB11216@kroah.com>
References: <20100521165113.GB11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

These were all copied over from the Blackfin UART driver, but they don't
make sense here because these bits are all specific to the Blackfin UART.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_sport_uart.c |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 6ee73da..b9938ac 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -500,27 +500,12 @@ static void sport_set_termios(struct uart_port *port,
 
 	spin_lock_irqsave(&up->port.lock, flags);
 
-	port->read_status_mask = OE;
-	if (termios->c_iflag & INPCK)
-		port->read_status_mask |= (FE | PE);
-	if (termios->c_iflag & (BRKINT | PARMRK))
-		port->read_status_mask |= BI;
+	port->read_status_mask = 0;
 
 	/*
 	 * Characters to ignore
 	 */
 	port->ignore_status_mask = 0;
-	if (termios->c_iflag & IGNPAR)
-		port->ignore_status_mask |= FE | PE;
-	if (termios->c_iflag & IGNBRK) {
-		port->ignore_status_mask |= BI;
-		/*
-		 * If we're ignoring parity and break indicators,
-		 * ignore overruns too (for real raw support).
-		 */
-		if (termios->c_iflag & IGNPAR)
-			port->ignore_status_mask |= OE;
-	}
 
 	/* RX extract mask */
 	up->rxmask = 0x01 | (((up->csize + up->stopb) * 2 - 1) << 0x8);
-- 
1.7.0.3

