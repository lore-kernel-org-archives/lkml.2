Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab1KPQ0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:26:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32994 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218Ab1KPQY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:24:58 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Juergen Beisert <jbe@pengutronix.de>, Matthias Fuchs <mfuchs@ma-fu.de>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 6/8] serial: 8250: update rs485 flags with polarity settings
Date: Wed, 16 Nov 2011 17:24:43 +0100
Message-Id: <1321460685-15753-7-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321460685-15753-1-git-send-email-w.sang@pengutronix.de>
References: <1321460685-15753-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report the only mode we can support with the 16C850.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/tty/serial/8250.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 28b3608..8cf6d76 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -2750,6 +2750,9 @@ static int serial8250_ioctl_port(struct uart_port *port,
 		serial_outp(up, UART_LCR, lcr);
 		spin_unlock_irqrestore(&up->port.lock, flags);
 
+		/* only mode supported by the 16C850 */
+		rs485ctrl.flags &= ~SER_RS485_RTS_ON_SEND;
+		rs485ctrl.flags |= SER_RS485_RTS_AFTER_SEND;
 		up->rs485_flags = rs485ctrl.flags;
 
 		return 0;
-- 
1.7.7.1

