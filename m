Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab1LIRHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:07:37 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49424 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab1LIRHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:07:35 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH RESEND 1/8] serial: 8250: replace hardcoded 0xbf with #define
Date: Fri,  9 Dec 2011 18:07:13 +0100
Message-Id: <1323450440-414-2-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323450440-414-1-git-send-email-w.sang@pengutronix.de>
References: <1323450440-414-1-git-send-email-w.sang@pengutronix.de>
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
1.7.7.3

