Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872Ab2HWKj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:39:58 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:37247 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933880Ab2HWKhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:37:55 -0400
From: Felipe Balbi <balbi@ti.com>
To: alan@linux.intel.com
Cc: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v3 18/23] serial: omap: implement set_wake
Date: Thu, 23 Aug 2012 13:32:58 +0300
Message-Id: <1345717983-18179-19-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345717983-18179-1-git-send-email-balbi@ti.com>
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been missing from OMAP UART driver
for quite a while and it's simple enough
to implement it.

Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index e871635..d6f5eed 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -861,6 +861,15 @@ serial_omap_set_termios(struct uart_port *port, struct ktermios *termios,
 	dev_dbg(up->port.dev, "serial_omap_set_termios+%d\n", up->port.line);
 }
 
+static int serial_omap_set_wake(struct uart_port *port, unsigned int state)
+{
+	struct uart_omap_port *up = to_uart_omap_port(port);
+
+	serial_omap_enable_wakeup(up, state);
+
+	return 0;
+}
+
 static void
 serial_omap_pm(struct uart_port *port, unsigned int state,
 	       unsigned int oldstate)
@@ -1115,6 +1124,7 @@ static struct uart_ops serial_omap_pops = {
 	.shutdown	= serial_omap_shutdown,
 	.set_termios	= serial_omap_set_termios,
 	.pm		= serial_omap_pm,
+	.set_wake	= serial_omap_set_wake,
 	.type		= serial_omap_type,
 	.release_port	= serial_omap_release_port,
 	.request_port	= serial_omap_request_port,
-- 
1.7.12.rc3

