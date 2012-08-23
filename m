Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924Ab2HWKih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:38:37 -0400
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:34655 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933820Ab2HWKiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:38:05 -0400
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
Subject: [PATCH v3 22/23] serial: omap: move uart_omap_port definition to C file
Date: Thu, 23 Aug 2012 13:33:02 +0300
Message-Id: <1345717983-18179-23-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345717983-18179-1-git-send-email-balbi@ti.com>
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nobody needs to access the uart_omap_port structure
other than omap-serial.c file. Let's move that
structure definition to the C source file in order
to prevent anyone from accessing our structure.

Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/plat-omap/include/plat/omap-serial.h | 37 --------------------------
 drivers/tty/serial/omap-serial.c              | 38 +++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/omap-serial.h b/arch/arm/plat-omap/include/plat/omap-serial.h
index 12e6805..c266934 100644
--- a/arch/arm/plat-omap/include/plat/omap-serial.h
+++ b/arch/arm/plat-omap/include/plat/omap-serial.h
@@ -102,41 +102,4 @@ struct uart_omap_dma {
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
index e5a56cb..0e5ffdf 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -69,6 +69,44 @@
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

