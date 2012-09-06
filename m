Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab2IFMvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:51:24 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:35534 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755801Ab2IFMvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:51:16 -0400
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
Subject: [PATCH v4 21/21] serial: omap: enable RX and TX FIFO usage
Date: Thu,  6 Sep 2012 15:45:40 +0300
Message-Id: <1346935540-1792-22-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1346935540-1792-1-git-send-email-balbi@ti.com>
References: <20120906122948.GC29202@arwen.pp.htv.fi>
 <1346935540-1792-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enable RX FIFO for 16 characters and TX FIFO
for 16 spaces.

Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 164c3c9..cfd2094 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -56,8 +56,8 @@
 #define OMAP_UART_SCR_RX_TRIG_GRANU1_MASK		(1 << 7)
 
 /* FCR register bitmasks */
-#define OMAP_UART_FCR_RX_FIFO_TRIG_SHIFT		6
 #define OMAP_UART_FCR_RX_FIFO_TRIG_MASK			(0x3 << 6)
+#define OMAP_UART_FCR_TX_FIFO_TRIG_MASK			(0x3 << 4)
 
 /* MVR register bitmasks */
 #define OMAP_UART_MVR_SCHEME_SHIFT	30
@@ -834,9 +834,13 @@ serial_omap_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	up->scr |= OMAP_UART_SCR_RX_TRIG_GRANU1_MASK;
 
-	/* Set receive FIFO threshold to 1 byte */
+	/* Set receive FIFO threshold to 16 characters and
+	 * transmit FIFO threshold to 16 spaces
+	 */
 	up->fcr &= ~OMAP_UART_FCR_RX_FIFO_TRIG_MASK;
-	up->fcr |= (0x1 << OMAP_UART_FCR_RX_FIFO_TRIG_SHIFT);
+	up->fcr &= ~OMAP_UART_FCR_TX_FIFO_TRIG_MASK;
+	up->fcr |= UART_FCR6_R_TRIGGER_16 | UART_FCR6_T_TRIGGER_24 |
+		UART_FCR_ENABLE_FIFO;
 
 	serial_out(up, UART_FCR, up->fcr);
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
-- 
1.7.12.rc3

