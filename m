Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab1KPQZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:25:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32995 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab1KPQY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:24:58 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Juergen Beisert <jbe@pengutronix.de>, Matthias Fuchs <mfuchs@ma-fu.de>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 5/8] serial: 8250: reject delaying RTS with RS485
Date: Wed, 16 Nov 2011 17:24:42 +0100
Message-Id: <1321460685-15753-6-git-send-email-w.sang@pengutronix.de>
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

There might be chips capable of doing this, but for now nothing is implemented,
so reject usage of this feature.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/tty/serial/8250.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 6a2f47f..28b3608 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -2735,6 +2735,9 @@ static int serial8250_ioctl_port(struct uart_port *port,
 				   sizeof(rs485ctrl)))
 			return -EFAULT;
 
+		if (rs485ctrl.delay_rts_before_send || rs485ctrl.delay_rts_after_send)
+			return -EOPNOTSUPP;
+
 		spin_lock_irqsave(&up->port.lock, flags);
 		lcr = serial_inp(up, UART_LCR);
 		serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_B);
-- 
1.7.7.1

