Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab2IFMw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:52:58 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:44724 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755659Ab2IFMvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:51:02 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: alan@linux.intel.com, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v4 16/21] serial: omap: implement set_wake
Date: Thu,  6 Sep 2012 15:45:35 +0300
Message-Id: <1346935540-1792-17-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1346935540-1792-1-git-send-email-balbi@ti.com>
References: <20120906122948.GC29202@arwen.pp.htv.fi>
 <1346935540-1792-1-git-send-email-balbi@ti.com>
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
index 9e4419c..7531147 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -875,6 +875,15 @@ serial_omap_set_termios(struct uart_port *port, struct ktermios *termios,
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
@@ -1129,6 +1138,7 @@ static struct uart_ops serial_omap_pops = {
 	.shutdown	= serial_omap_shutdown,
 	.set_termios	= serial_omap_set_termios,
 	.pm		= serial_omap_pm,
+	.set_wake	= serial_omap_set_wake,
 	.type		= serial_omap_type,
 	.release_port	= serial_omap_release_port,
 	.request_port	= serial_omap_request_port,
-- 
1.7.12.rc3

