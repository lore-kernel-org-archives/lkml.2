Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2IFMvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:51:17 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:35681 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755788Ab2IFMvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:51:13 -0400
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
Subject: [PATCH v4 20/21] serial: omap: move uart_omap_port definition to C file
Date: Thu,  6 Sep 2012 15:45:39 +0300
Message-Id: <1346935540-1792-21-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1346935540-1792-1-git-send-email-balbi@ti.com>
References: <20120906122948.GC29202@arwen.pp.htv.fi>
 <1346935540-1792-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nobody needs to access the uart_omap_port structure
other than omap-serial.c file. Let's move that
structure definition to the C source file in order
to prevent anyone from accessing our structure.

Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/plat-omap/include/plat/omap-serial.h | 37 --------------------------
 drivers/tty/serial/omap-serial.c              | 38 +++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/omap-serial.h b/arch/arm/plat-omap/include/plat/omap-serial.h
index a79ed8b..3c9fd3e 100644
--- a/arch/arm/plat-omap/include/plat/omap-serial.h
+++ b/arch/arm/plat-omap/include/plat/omap-serial.h
@@ -105,45 +105,8 @@ struct uart_omap_dma {
 	unsigned int		rx_timeout;
 };
 
-struct uart_omap_port {
-	struct uart_port	port;
-	struct uart_omap_dma	uart_dma;
-	struct device		*dev;
-
-	unsigned char		ier;
-	unsigned char		lcr;
-	unsigned char		mcr;
-	unsigned char		fcr;
-	unsigned char		efr;
-	unsigned char		dll;
-	unsigned char		dlh;
-	unsigned char		mdr1;
-	unsigned char		scr;
-
-	int			use_dma;
-	/*
-	 * Some bits in registers are cleared on a read, so they must
-	 * be saved whenever the register is read but the bits will not
-	 * be immediately processed.
-	 */
-	unsigned int		lsr_break_flag;
-	unsigned char		msr_saved_flags;
-	char			name[20];
-	unsigned long		port_activity;
-	u32			context_loss_cnt;
-	u32			errata;
-	u8			wakeups_enabled;
 
 	int			DTR_gpio;
 	int			DTR_inverted;
 	int			DTR_active;
-
-	struct pm_qos_request	pm_qos_request;
-	u32			latency;
-	u32			calc_latency;
-	struct work_struct	qos_work;
-};
-
-#define to_uart_omap_port(p)	((container_of((p), struct uart_omap_port, port)))
-
 #endif /* __OMAP_SERIAL_H__ */
diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 881b652..164c3c9 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -70,6 +70,44 @@
 #define OMAP_UART_MVR_MAJ_SHIFT		8
 #define OMAP_UART_MVR_MIN_MASK		0x3f
 
+struct uart_omap_port {
+	struct uart_port	port;
+	struct uart_omap_dma	uart_dma;
+	struct device		*dev;
+
+	unsigned char		ier;
+	unsigned char		lcr;
+	unsigned char		mcr;
+	unsigned char		fcr;
+	unsigned char		efr;
+	unsigned char		dll;
+	unsigned char		dlh;
+	unsigned char		mdr1;
+	unsigned char		scr;
+
+	int			use_dma;
+	/*
+	 * Some bits in registers are cleared on a read, so they must
+	 * be saved whenever the register is read but the bits will not
+	 * be immediately processed.
+	 */
+	unsigned int		lsr_break_flag;
+	unsigned char		msr_saved_flags;
+	char			name[20];
+	unsigned long		port_activity;
+	u32			context_loss_cnt;
+	u32			errata;
+	u8			wakeups_enabled;
+	unsigned int		irq_pending:1;
+
+	struct pm_qos_request	pm_qos_request;
+	u32			latency;
+	u32			calc_latency;
+	struct work_struct	qos_work;
+};
+
+#define to_uart_omap_port(p)	((container_of((p), struct uart_omap_port, port)))
+
 static struct uart_omap_port *ui[OMAP_MAX_HSUART_PORTS];
 
 /* Forward declaration of functions */
-- 
1.7.12.rc3

