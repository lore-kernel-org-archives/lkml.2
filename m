Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab1KPQ0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:26:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32982 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab1KPQY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:24:57 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Juergen Beisert <jbe@pengutronix.de>, Matthias Fuchs <mfuchs@ma-fu.de>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 1/8] serial: 8250: replace hardcoded 0xbf with #define
Date: Wed, 16 Nov 2011 17:24:38 +0100
Message-Id: <1321460685-15753-2-git-send-email-w.sang@pengutronix.de>
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

Makes it easier to find all occurences requesting CONF_MODE_B.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/tty/serial/8250.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index eeadf1b..f8f2320 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -2000,7 +2000,7 @@ static int serial8250_startup(struct uart_port *port)
 		serial_outp(up, UART_IER, 0);
 		serial_outp(up, UART_LCR, 0);
 		serial_icr_write(up, UART_CSR, 0); /* Reset the UART */
-		serial_outp(up, UART_LCR, 0xBF);
+		serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_B);
 		serial_outp(up, UART_EFR, UART_EFR_ECB);
 		serial_outp(up, UART_LCR, 0);
 	}
-- 
1.7.7.1

