Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab2LSAYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:24:51 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:36737
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755039Ab2LSAYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:24:49 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1de0h1202h1e76h1d1ah1d2ahzz8275bh84d07hz2fh95h668h839hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h906i1155h)
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        <monstr@monstr.eu>, John Linn <john.linn@xilinx.com>
CC: <git@xilinx.com>, <josh.cartwright@ni.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 1/7] arm: zynq: timer: Replace PSS through PS
Date: Tue, 18 Dec 2012 16:16:33 -0800
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1355876199-23788-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1355876199-23788-1-git-send-email-soren.brinkmann@xilinx.com>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <ee701193-af05-4e73-9376-42a4c6ac3c01@CO9EHSMHS032.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The acronym PSS is deprecated by Xilinx. The correct term, which is
also used in Xilinx documentation is PS (processing system).
This is just a search and replace:
 - s/PSS/PS/g
 - s/pss/ps/g

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/mach-zynq/common.c |   6 +-
 arch/arm/mach-zynq/common.h |   2 +-
 arch/arm/mach-zynq/timer.c  | 134 ++++++++++++++++++++++----------------------
 3 files changed, 71 insertions(+), 71 deletions(-)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index e16d4be..892f65e 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -90,13 +90,13 @@ static void __init xilinx_zynq_timer_init(void)
 
 	xilinx_zynq_clocks_init(slcr);
 
-	xttcpss_timer_init();
+	xttcps_timer_init();
 }
 
 /*
  * Instantiate and initialize the system timer structure
  */
-static struct sys_timer xttcpss_sys_timer = {
+static struct sys_timer xttcps_sys_timer = {
 	.init		= xilinx_zynq_timer_init,
 };
 
@@ -120,6 +120,6 @@ MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
 	.init_irq	= xilinx_irq_init,
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= xilinx_init_machine,
-	.timer		= &xttcpss_sys_timer,
+	.timer		= &xttcps_sys_timer,
 	.dt_compat	= xilinx_dt_match,
 MACHINE_END
diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
index 954b91c..8b4dbba 100644
--- a/arch/arm/mach-zynq/common.h
+++ b/arch/arm/mach-zynq/common.h
@@ -17,6 +17,6 @@
 #ifndef __MACH_ZYNQ_COMMON_H__
 #define __MACH_ZYNQ_COMMON_H__
 
-void __init xttcpss_timer_init(void);
+void __init xttcps_timer_init(void);
 
 #endif
diff --git a/arch/arm/mach-zynq/timer.c b/arch/arm/mach-zynq/timer.c
index de3df28..570491d 100644
--- a/arch/arm/mach-zynq/timer.c
+++ b/arch/arm/mach-zynq/timer.c
@@ -35,17 +35,17 @@
  * Timer Register Offset Definitions of Timer 1, Increment base address by 4
  * and use same offsets for Timer 2
  */
-#define XTTCPSS_CLK_CNTRL_OFFSET	0x00 /* Clock Control Reg, RW */
-#define XTTCPSS_CNT_CNTRL_OFFSET	0x0C /* Counter Control Reg, RW */
-#define XTTCPSS_COUNT_VAL_OFFSET	0x18 /* Counter Value Reg, RO */
-#define XTTCPSS_INTR_VAL_OFFSET		0x24 /* Interval Count Reg, RW */
-#define XTTCPSS_MATCH_1_OFFSET		0x30 /* Match 1 Value Reg, RW */
-#define XTTCPSS_MATCH_2_OFFSET		0x3C /* Match 2 Value Reg, RW */
-#define XTTCPSS_MATCH_3_OFFSET		0x48 /* Match 3 Value Reg, RW */
-#define XTTCPSS_ISR_OFFSET		0x54 /* Interrupt Status Reg, RO */
-#define XTTCPSS_IER_OFFSET		0x60 /* Interrupt Enable Reg, RW */
-
-#define XTTCPSS_CNT_CNTRL_DISABLE_MASK	0x1
+#define XTTCPS_CLK_CNTRL_OFFSET	0x00 /* Clock Control Reg, RW */
+#define XTTCPS_CNT_CNTRL_OFFSET	0x0C /* Counter Control Reg, RW */
+#define XTTCPS_COUNT_VAL_OFFSET	0x18 /* Counter Value Reg, RO */
+#define XTTCPS_INTR_VAL_OFFSET		0x24 /* Interval Count Reg, RW */
+#define XTTCPS_MATCH_1_OFFSET		0x30 /* Match 1 Value Reg, RW */
+#define XTTCPS_MATCH_2_OFFSET		0x3C /* Match 2 Value Reg, RW */
+#define XTTCPS_MATCH_3_OFFSET		0x48 /* Match 3 Value Reg, RW */
+#define XTTCPS_ISR_OFFSET		0x54 /* Interrupt Status Reg, RO */
+#define XTTCPS_IER_OFFSET		0x60 /* Interrupt Enable Reg, RW */
+
+#define XTTCPS_CNT_CNTRL_DISABLE_MASK	0x1
 
 /* Setup the timers to use pre-scaling, using a fixed value for now that will
  * work across most input frequency, but it may need to be more dynamic
@@ -57,72 +57,72 @@
 #define CNT_CNTRL_RESET		(1<<4)
 
 /**
- * struct xttcpss_timer - This definition defines local timer structure
+ * struct xttcps_timer - This definition defines local timer structure
  *
  * @base_addr:	Base address of timer
  **/
-struct xttcpss_timer {
+struct xttcps_timer {
 	void __iomem	*base_addr;
 };
 
-struct xttcpss_timer_clocksource {
-	struct xttcpss_timer	xttc;
+struct xttcps_timer_clocksource {
+	struct xttcps_timer	xttc;
 	struct clocksource	cs;
 };
 
-#define to_xttcpss_timer_clksrc(x) \
-		container_of(x, struct xttcpss_timer_clocksource, cs)
+#define to_xttcps_timer_clksrc(x) \
+		container_of(x, struct xttcps_timer_clocksource, cs)
 
-struct xttcpss_timer_clockevent {
-	struct xttcpss_timer		xttc;
+struct xttcps_timer_clockevent {
+	struct xttcps_timer		xttc;
 	struct clock_event_device	ce;
 	struct clk			*clk;
 };
 
-#define to_xttcpss_timer_clkevent(x) \
-		container_of(x, struct xttcpss_timer_clockevent, ce)
+#define to_xttcps_timer_clkevent(x) \
+		container_of(x, struct xttcps_timer_clockevent, ce)
 
 /**
- * xttcpss_set_interval - Set the timer interval value
+ * xttcps_set_interval - Set the timer interval value
  *
  * @timer:	Pointer to the timer instance
  * @cycles:	Timer interval ticks
  **/
-static void xttcpss_set_interval(struct xttcpss_timer *timer,
+static void xttcps_set_interval(struct xttcps_timer *timer,
 					unsigned long cycles)
 {
 	u32 ctrl_reg;
 
 	/* Disable the counter, set the counter value  and re-enable counter */
-	ctrl_reg = __raw_readl(timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
-	ctrl_reg |= XTTCPSS_CNT_CNTRL_DISABLE_MASK;
-	__raw_writel(ctrl_reg, timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
+	ctrl_reg = __raw_readl(timer->base_addr + XTTCPS_CNT_CNTRL_OFFSET);
+	ctrl_reg |= XTTCPS_CNT_CNTRL_DISABLE_MASK;
+	__raw_writel(ctrl_reg, timer->base_addr + XTTCPS_CNT_CNTRL_OFFSET);
 
-	__raw_writel(cycles, timer->base_addr + XTTCPSS_INTR_VAL_OFFSET);
+	__raw_writel(cycles, timer->base_addr + XTTCPS_INTR_VAL_OFFSET);
 
 	/* Reset the counter (0x10) so that it starts from 0, one-shot
 	   mode makes this needed for timing to be right. */
 	ctrl_reg |= CNT_CNTRL_RESET;
-	ctrl_reg &= ~XTTCPSS_CNT_CNTRL_DISABLE_MASK;
-	__raw_writel(ctrl_reg, timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
+	ctrl_reg &= ~XTTCPS_CNT_CNTRL_DISABLE_MASK;
+	__raw_writel(ctrl_reg, timer->base_addr + XTTCPS_CNT_CNTRL_OFFSET);
 }
 
 /**
- * xttcpss_clock_event_interrupt - Clock event timer interrupt handler
+ * xttcps_clock_event_interrupt - Clock event timer interrupt handler
  *
  * @irq:	IRQ number of the Timer
- * @dev_id:	void pointer to the xttcpss_timer instance
+ * @dev_id:	void pointer to the xttcps_timer instance
  *
  * returns: Always IRQ_HANDLED - success
  **/
-static irqreturn_t xttcpss_clock_event_interrupt(int irq, void *dev_id)
+static irqreturn_t xttcps_clock_event_interrupt(int irq, void *dev_id)
 {
-	struct xttcpss_timer_clockevent *xttce = dev_id;
-	struct xttcpss_timer *timer = &xttce->xttc;
+	struct xttcps_timer_clockevent *xttce = dev_id;
+	struct xttcps_timer *timer = &xttce->xttc;
 
 	/* Acknowledge the interrupt and call event handler */
-	__raw_writel(__raw_readl(timer->base_addr + XTTCPSS_ISR_OFFSET),
-			timer->base_addr + XTTCPSS_ISR_OFFSET);
+	__raw_writel(__raw_readl(timer->base_addr + XTTCPS_ISR_OFFSET),
+			timer->base_addr + XTTCPS_ISR_OFFSET);
 
 	xttce->ce.event_handler(&xttce->ce);
 
@@ -136,46 +136,46 @@ static irqreturn_t xttcpss_clock_event_interrupt(int irq, void *dev_id)
  **/
 static cycle_t __xttc_clocksource_read(struct clocksource *cs)
 {
-	struct xttcpss_timer *timer = &to_xttcpss_timer_clksrc(cs)->xttc;
+	struct xttcps_timer *timer = &to_xttcps_timer_clksrc(cs)->xttc;
 
 	return (cycle_t)__raw_readl(timer->base_addr +
-				XTTCPSS_COUNT_VAL_OFFSET);
+				XTTCPS_COUNT_VAL_OFFSET);
 }
 
 /**
- * xttcpss_set_next_event - Sets the time interval for next event
+ * xttcps_set_next_event - Sets the time interval for next event
  *
  * @cycles:	Timer interval ticks
  * @evt:	Address of clock event instance
  *
  * returns: Always 0 - success
  **/
-static int xttcpss_set_next_event(unsigned long cycles,
+static int xttcps_set_next_event(unsigned long cycles,
 					struct clock_event_device *evt)
 {
-	struct xttcpss_timer_clockevent *xttce = to_xttcpss_timer_clkevent(evt);
-	struct xttcpss_timer *timer = &xttce->xttc;
+	struct xttcps_timer_clockevent *xttce = to_xttcps_timer_clkevent(evt);
+	struct xttcps_timer *timer = &xttce->xttc;
 
-	xttcpss_set_interval(timer, cycles);
+	xttcps_set_interval(timer, cycles);
 	return 0;
 }
 
 /**
- * xttcpss_set_mode - Sets the mode of timer
+ * xttcps_set_mode - Sets the mode of timer
  *
  * @mode:	Mode to be set
  * @evt:	Address of clock event instance
  **/
-static void xttcpss_set_mode(enum clock_event_mode mode,
+static void xttcps_set_mode(enum clock_event_mode mode,
 					struct clock_event_device *evt)
 {
-	struct xttcpss_timer_clockevent *xttce = to_xttcpss_timer_clkevent(evt);
-	struct xttcpss_timer *timer = &xttce->xttc;
+	struct xttcps_timer_clockevent *xttce = to_xttcps_timer_clkevent(evt);
+	struct xttcps_timer *timer = &xttce->xttc;
 	u32 ctrl_reg;
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
-		xttcpss_set_interval(timer,
+		xttcps_set_interval(timer,
 				     DIV_ROUND_CLOSEST(clk_get_rate(xttce->clk),
 						       PRESCALE * HZ));
 		break;
@@ -183,17 +183,17 @@ static void xttcpss_set_mode(enum clock_event_mode mode,
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
 		ctrl_reg = __raw_readl(timer->base_addr +
-					XTTCPSS_CNT_CNTRL_OFFSET);
-		ctrl_reg |= XTTCPSS_CNT_CNTRL_DISABLE_MASK;
+					XTTCPS_CNT_CNTRL_OFFSET);
+		ctrl_reg |= XTTCPS_CNT_CNTRL_DISABLE_MASK;
 		__raw_writel(ctrl_reg,
-				timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
+				timer->base_addr + XTTCPS_CNT_CNTRL_OFFSET);
 		break;
 	case CLOCK_EVT_MODE_RESUME:
 		ctrl_reg = __raw_readl(timer->base_addr +
-					XTTCPSS_CNT_CNTRL_OFFSET);
-		ctrl_reg &= ~XTTCPSS_CNT_CNTRL_DISABLE_MASK;
+					XTTCPS_CNT_CNTRL_OFFSET);
+		ctrl_reg &= ~XTTCPS_CNT_CNTRL_DISABLE_MASK;
 		__raw_writel(ctrl_reg,
-				timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
+				timer->base_addr + XTTCPS_CNT_CNTRL_OFFSET);
 		break;
 	}
 }
@@ -201,7 +201,7 @@ static void xttcpss_set_mode(enum clock_event_mode mode,
 static void __init zynq_ttc_setup_clocksource(struct device_node *np,
 					     void __iomem *base)
 {
-	struct xttcpss_timer_clocksource *ttccs;
+	struct xttcps_timer_clocksource *ttccs;
 	struct clk *clk;
 	int err;
 	u32 reg;
@@ -230,11 +230,11 @@ static void __init zynq_ttc_setup_clocksource(struct device_node *np,
 	ttccs->cs.mask = CLOCKSOURCE_MASK(16);
 	ttccs->cs.flags = CLOCK_SOURCE_IS_CONTINUOUS;
 
-	__raw_writel(0x0,  ttccs->xttc.base_addr + XTTCPSS_IER_OFFSET);
+	__raw_writel(0x0,  ttccs->xttc.base_addr + XTTCPS_IER_OFFSET);
 	__raw_writel(CLK_CNTRL_PRESCALE | CLK_CNTRL_PRESCALE_EN,
-		     ttccs->xttc.base_addr + XTTCPSS_CLK_CNTRL_OFFSET);
+		     ttccs->xttc.base_addr + XTTCPS_CLK_CNTRL_OFFSET);
 	__raw_writel(CNT_CNTRL_RESET,
-		     ttccs->xttc.base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
+		     ttccs->xttc.base_addr + XTTCPS_CNT_CNTRL_OFFSET);
 
 	err = clocksource_register_hz(&ttccs->cs, clk_get_rate(clk) / PRESCALE);
 	if (WARN_ON(err))
@@ -244,7 +244,7 @@ static void __init zynq_ttc_setup_clocksource(struct device_node *np,
 static void __init zynq_ttc_setup_clockevent(struct device_node *np,
 					    void __iomem *base)
 {
-	struct xttcpss_timer_clockevent *ttcce;
+	struct xttcps_timer_clockevent *ttcce;
 	int err, irq;
 	u32 reg;
 
@@ -272,17 +272,17 @@ static void __init zynq_ttc_setup_clockevent(struct device_node *np,
 
 	ttcce->ce.name = np->name;
 	ttcce->ce.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
-	ttcce->ce.set_next_event = xttcpss_set_next_event;
-	ttcce->ce.set_mode = xttcpss_set_mode;
+	ttcce->ce.set_next_event = xttcps_set_next_event;
+	ttcce->ce.set_mode = xttcps_set_mode;
 	ttcce->ce.rating = 200;
 	ttcce->ce.irq = irq;
 
-	__raw_writel(0x23, ttcce->xttc.base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
+	__raw_writel(0x23, ttcce->xttc.base_addr + XTTCPS_CNT_CNTRL_OFFSET);
 	__raw_writel(CLK_CNTRL_PRESCALE | CLK_CNTRL_PRESCALE_EN,
-		     ttcce->xttc.base_addr + XTTCPSS_CLK_CNTRL_OFFSET);
-	__raw_writel(0x1,  ttcce->xttc.base_addr + XTTCPSS_IER_OFFSET);
+		     ttcce->xttc.base_addr + XTTCPS_CLK_CNTRL_OFFSET);
+	__raw_writel(0x1,  ttcce->xttc.base_addr + XTTCPS_IER_OFFSET);
 
-	err = request_irq(irq, xttcpss_clock_event_interrupt, IRQF_TIMER,
+	err = request_irq(irq, xttcps_clock_event_interrupt, IRQF_TIMER,
 			  np->name, ttcce);
 	if (WARN_ON(err))
 		return;
@@ -301,12 +301,12 @@ static const __initconst struct of_device_id zynq_ttc_match[] = {
 };
 
 /**
- * xttcpss_timer_init - Initialize the timer
+ * xttcps_timer_init - Initialize the timer
  *
  * Initializes the timer hardware and register the clock source and clock event
  * timers with Linux kernal timer framework
  **/
-void __init xttcpss_timer_init(void)
+void __init xttcps_timer_init(void)
 {
 	struct device_node *np;
 
-- 
1.8.0.2


