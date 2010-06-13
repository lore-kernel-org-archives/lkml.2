Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab0FMPdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:33:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:37763 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196Ab0FMPcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:32:15 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/12] irq: kill IRQF_IRQPOLL
Date: Sun, 13 Jun 2010 17:31:30 +0200
Message-Id: <1276443098-20653-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276443098-20653-1-git-send-email-tj@kernel.org>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 13 Jun 2010 15:31:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With irqpoll polling switched to desc->poll_timer, IRQF_IRQPOLL is no
longer necessary.  Drop it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/arm/mach-aaec2000/core.c            |    2 +-
 arch/arm/mach-at91/at91rm9200_time.c     |    2 +-
 arch/arm/mach-at91/at91sam926x_time.c    |    2 +-
 arch/arm/mach-bcmring/core.c             |    2 +-
 arch/arm/mach-clps711x/time.c            |    2 +-
 arch/arm/mach-cns3xxx/core.c             |    2 +-
 arch/arm/mach-ebsa110/core.c             |    2 +-
 arch/arm/mach-ep93xx/core.c              |    2 +-
 arch/arm/mach-footbridge/dc21285-timer.c |    2 +-
 arch/arm/mach-footbridge/isa-timer.c     |    2 +-
 arch/arm/mach-h720x/cpu-h7201.c          |    2 +-
 arch/arm/mach-h720x/cpu-h7202.c          |    2 +-
 arch/arm/mach-integrator/integrator_ap.c |    2 +-
 arch/arm/mach-ixp2000/core.c             |    2 +-
 arch/arm/mach-ixp23xx/core.c             |    2 +-
 arch/arm/mach-ixp4xx/common.c            |    2 +-
 arch/arm/mach-lh7a40x/time.c             |    2 +-
 arch/arm/mach-mmp/time.c                 |    2 +-
 arch/arm/mach-netx/time.c                |    2 +-
 arch/arm/mach-ns9xxx/time-ns9360.c       |    2 +-
 arch/arm/mach-nuc93x/time.c              |    2 +-
 arch/arm/mach-omap1/time.c               |    2 +-
 arch/arm/mach-omap1/timer32k.c           |    2 +-
 arch/arm/mach-omap2/timer-gp.c           |    2 +-
 arch/arm/mach-pnx4008/time.c             |    2 +-
 arch/arm/mach-pxa/time.c                 |    2 +-
 arch/arm/mach-sa1100/time.c              |    2 +-
 arch/arm/mach-shark/core.c               |    2 +-
 arch/arm/mach-u300/timer.c               |    2 +-
 arch/arm/mach-w90x900/time.c             |    2 +-
 arch/arm/plat-iop/time.c                 |    2 +-
 arch/arm/plat-mxc/time.c                 |    2 +-
 arch/arm/plat-samsung/time.c             |    2 +-
 arch/arm/plat-versatile/timer-sp.c       |    2 +-
 arch/blackfin/kernel/time-ts.c           |    6 ++----
 arch/ia64/kernel/time.c                  |    2 +-
 arch/parisc/kernel/irq.c                 |    2 +-
 arch/x86/kernel/time.c                   |    2 +-
 drivers/clocksource/sh_cmt.c             |    3 +--
 drivers/clocksource/sh_mtu2.c            |    3 +--
 drivers/clocksource/sh_tmu.c             |    3 +--
 include/linux/interrupt.h                |    4 ----
 42 files changed, 42 insertions(+), 51 deletions(-)

diff --git a/arch/arm/mach-aaec2000/core.c b/arch/arm/mach-aaec2000/core.c
index 3ef6833..ac87535 100644
--- a/arch/arm/mach-aaec2000/core.c
+++ b/arch/arm/mach-aaec2000/core.c
@@ -139,7 +139,7 @@ aaec2000_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction aaec2000_timer_irq = {
 	.name		= "AAEC-2000 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= aaec2000_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-at91/at91rm9200_time.c b/arch/arm/mach-at91/at91rm9200_time.c
index 2500f41..a4a0049 100644
--- a/arch/arm/mach-at91/at91rm9200_time.c
+++ b/arch/arm/mach-at91/at91rm9200_time.c
@@ -87,7 +87,7 @@ static irqreturn_t at91rm9200_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction at91rm9200_timer_irq = {
 	.name		= "at91_tick",
-	.flags		= IRQF_SHARED | IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_SHARED | IRQF_DISABLED | IRQF_TIMER,
 	.handler	= at91rm9200_timer_interrupt
 };
 
diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
index 608a632..22a290b 100644
--- a/arch/arm/mach-at91/at91sam926x_time.c
+++ b/arch/arm/mach-at91/at91sam926x_time.c
@@ -123,7 +123,7 @@ static irqreturn_t at91sam926x_pit_interrupt(int irq, void *dev_id)
 
 static struct irqaction at91sam926x_pit_irq = {
 	.name		= "at91_tick",
-	.flags		= IRQF_SHARED | IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_SHARED | IRQF_DISABLED | IRQF_TIMER,
 	.handler	= at91sam926x_pit_interrupt
 };
 
diff --git a/arch/arm/mach-bcmring/core.c b/arch/arm/mach-bcmring/core.c
index 72e405d..99e10ff 100644
--- a/arch/arm/mach-bcmring/core.c
+++ b/arch/arm/mach-bcmring/core.c
@@ -266,7 +266,7 @@ static irqreturn_t bcmring_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction bcmring_timer_irq = {
 	.name = "bcmring Timer Tick",
-	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags = IRQF_DISABLED | IRQF_TIMER,
 	.handler = bcmring_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-clps711x/time.c b/arch/arm/mach-clps711x/time.c
index d581ef0..9dffaa6 100644
--- a/arch/arm/mach-clps711x/time.c
+++ b/arch/arm/mach-clps711x/time.c
@@ -56,7 +56,7 @@ p720t_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction clps711x_timer_irq = {
 	.name		= "CLPS711x Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= p720t_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-cns3xxx/core.c b/arch/arm/mach-cns3xxx/core.c
index 9ca4d58..9dcea9f 100644
--- a/arch/arm/mach-cns3xxx/core.c
+++ b/arch/arm/mach-cns3xxx/core.c
@@ -178,7 +178,7 @@ static irqreturn_t cns3xxx_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction cns3xxx_timer_irq = {
 	.name		= "timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= cns3xxx_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-ebsa110/core.c b/arch/arm/mach-ebsa110/core.c
index c7bc7fb..efb7734 100644
--- a/arch/arm/mach-ebsa110/core.c
+++ b/arch/arm/mach-ebsa110/core.c
@@ -195,7 +195,7 @@ ebsa110_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction ebsa110_timer_irq = {
 	.name		= "EBSA110 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= ebsa110_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
index 9092677..2910f6c 100644
--- a/arch/arm/mach-ep93xx/core.c
+++ b/arch/arm/mach-ep93xx/core.c
@@ -132,7 +132,7 @@ static irqreturn_t ep93xx_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction ep93xx_timer_irq = {
 	.name		= "ep93xx timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= ep93xx_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-footbridge/dc21285-timer.c b/arch/arm/mach-footbridge/dc21285-timer.c
index bc5e83f..42b0bd7 100644
--- a/arch/arm/mach-footbridge/dc21285-timer.c
+++ b/arch/arm/mach-footbridge/dc21285-timer.c
@@ -41,7 +41,7 @@ timer1_interrupt(int irq, void *dev_id)
 static struct irqaction footbridge_timer_irq = {
 	.name		= "Timer1 timer tick",
 	.handler	= timer1_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
 /*
diff --git a/arch/arm/mach-footbridge/isa-timer.c b/arch/arm/mach-footbridge/isa-timer.c
index f488fa2..ca1932e 100644
--- a/arch/arm/mach-footbridge/isa-timer.c
+++ b/arch/arm/mach-footbridge/isa-timer.c
@@ -71,7 +71,7 @@ isa_timer_interrupt(int irq, void *dev_id)
 static struct irqaction isa_timer_irq = {
 	.name		= "ISA timer tick",
 	.handler	= isa_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
 static void __init isa_timer_init(void)
diff --git a/arch/arm/mach-h720x/cpu-h7201.c b/arch/arm/mach-h720x/cpu-h7201.c
index 24df2a3..be1db54 100644
--- a/arch/arm/mach-h720x/cpu-h7201.c
+++ b/arch/arm/mach-h720x/cpu-h7201.c
@@ -37,7 +37,7 @@ h7201_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction h7201_timer_irq = {
 	.name		= "h7201 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= h7201_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-h720x/cpu-h7202.c b/arch/arm/mach-h720x/cpu-h7202.c
index fd33a19..e40deea 100644
--- a/arch/arm/mach-h720x/cpu-h7202.c
+++ b/arch/arm/mach-h720x/cpu-h7202.c
@@ -166,7 +166,7 @@ static struct irq_chip h7202_timerx_chip = {
 
 static struct irqaction h7202_timer_irq = {
 	.name		= "h7202 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= h7202_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-integrator/integrator_ap.c b/arch/arm/mach-integrator/integrator_ap.c
index 227cf4d..60f741e 100644
--- a/arch/arm/mach-integrator/integrator_ap.c
+++ b/arch/arm/mach-integrator/integrator_ap.c
@@ -447,7 +447,7 @@ static struct clock_event_device integrator_clockevent = {
 
 static struct irqaction integrator_timer_irq = {
 	.name		= "timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= integrator_timer_interrupt,
 	.dev_id		= &integrator_clockevent,
 };
diff --git a/arch/arm/mach-ixp2000/core.c b/arch/arm/mach-ixp2000/core.c
index babb225..693275d 100644
--- a/arch/arm/mach-ixp2000/core.c
+++ b/arch/arm/mach-ixp2000/core.c
@@ -213,7 +213,7 @@ static int ixp2000_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction ixp2000_timer_irq = {
 	.name		= "IXP2000 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= ixp2000_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-ixp23xx/core.c b/arch/arm/mach-ixp23xx/core.c
index aa4c442..8967392 100644
--- a/arch/arm/mach-ixp23xx/core.c
+++ b/arch/arm/mach-ixp23xx/core.c
@@ -359,7 +359,7 @@ ixp23xx_timer_interrupt(int irq, void *dev_id)
 static struct irqaction ixp23xx_timer_irq = {
 	.name		= "IXP23xx Timer Tick",
 	.handler	= ixp23xx_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
 void __init ixp23xx_init_timer(void)
diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index 0bce097..9a574fb 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -278,7 +278,7 @@ static irqreturn_t ixp4xx_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction ixp4xx_timer_irq = {
 	.name		= "timer1",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= ixp4xx_timer_interrupt,
 	.dev_id		= &clockevent_ixp4xx,
 };
diff --git a/arch/arm/mach-lh7a40x/time.c b/arch/arm/mach-lh7a40x/time.c
index 4601e42..841fe8c 100644
--- a/arch/arm/mach-lh7a40x/time.c
+++ b/arch/arm/mach-lh7a40x/time.c
@@ -49,7 +49,7 @@ lh7a40x_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction lh7a40x_timer_irq = {
 	.name		= "LHA740x Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= lh7a40x_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-mmp/time.c b/arch/arm/mach-mmp/time.c
index cf75694..3d6957a 100644
--- a/arch/arm/mach-mmp/time.c
+++ b/arch/arm/mach-mmp/time.c
@@ -177,7 +177,7 @@ static void __init timer_config(void)
 
 static struct irqaction timer_irq = {
 	.name		= "timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= timer_interrupt,
 	.dev_id		= &ckevt,
 };
diff --git a/arch/arm/mach-netx/time.c b/arch/arm/mach-netx/time.c
index 82801db..c0cc836 100644
--- a/arch/arm/mach-netx/time.c
+++ b/arch/arm/mach-netx/time.c
@@ -100,7 +100,7 @@ netx_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction netx_timer_irq = {
 	.name		= "NetX Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= netx_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-ns9xxx/time-ns9360.c b/arch/arm/mach-ns9xxx/time-ns9360.c
index 7728126..e60627f 100644
--- a/arch/arm/mach-ns9xxx/time-ns9360.c
+++ b/arch/arm/mach-ns9xxx/time-ns9360.c
@@ -121,7 +121,7 @@ static irqreturn_t ns9360_clockevent_handler(int irq, void *dev_id)
 
 static struct irqaction ns9360_clockevent_action = {
 	.name		= "ns9360-timer" __stringify(TIMER_CLOCKEVENT),
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= ns9360_clockevent_handler,
 };
 
diff --git a/arch/arm/mach-nuc93x/time.c b/arch/arm/mach-nuc93x/time.c
index 2f90f9d..8e0dbea 100644
--- a/arch/arm/mach-nuc93x/time.c
+++ b/arch/arm/mach-nuc93x/time.c
@@ -56,7 +56,7 @@ static irqreturn_t nuc93x_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction nuc93x_timer_irq = {
 	.name		= "nuc93x Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= nuc93x_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-omap1/time.c b/arch/arm/mach-omap1/time.c
index 1be6a21..c62fa79 100644
--- a/arch/arm/mach-omap1/time.c
+++ b/arch/arm/mach-omap1/time.c
@@ -157,7 +157,7 @@ static irqreturn_t omap_mpu_timer1_interrupt(int irq, void *dev_id)
 
 static struct irqaction omap_mpu_timer1_irq = {
 	.name		= "mpu_timer1",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= omap_mpu_timer1_interrupt,
 };
 
diff --git a/arch/arm/mach-omap1/timer32k.c b/arch/arm/mach-omap1/timer32k.c
index 20cfbcc..8ad901b 100644
--- a/arch/arm/mach-omap1/timer32k.c
+++ b/arch/arm/mach-omap1/timer32k.c
@@ -156,7 +156,7 @@ static irqreturn_t omap_32k_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction omap_32k_timer_irq = {
 	.name		= "32KHz timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= omap_32k_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-omap2/timer-gp.c b/arch/arm/mach-omap2/timer-gp.c
index 74fbed8..ddf9fae 100644
--- a/arch/arm/mach-omap2/timer-gp.c
+++ b/arch/arm/mach-omap2/timer-gp.c
@@ -62,7 +62,7 @@ static irqreturn_t omap2_gp_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction omap2_gp_timer_irq = {
 	.name		= "gp timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= omap2_gp_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-pnx4008/time.c b/arch/arm/mach-pnx4008/time.c
index 0c8aad4..1d5b2da 100644
--- a/arch/arm/mach-pnx4008/time.c
+++ b/arch/arm/mach-pnx4008/time.c
@@ -80,7 +80,7 @@ static irqreturn_t pnx4008_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction pnx4008_timer_irq = {
 	.name = "PNX4008 Tick Timer",
-	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags = IRQF_DISABLED | IRQF_TIMER,
 	.handler = pnx4008_timer_interrupt
 };
 
diff --git a/arch/arm/mach-pxa/time.c b/arch/arm/mach-pxa/time.c
index 293e40a..9fa6e1a 100644
--- a/arch/arm/mach-pxa/time.c
+++ b/arch/arm/mach-pxa/time.c
@@ -133,7 +133,7 @@ static struct clocksource cksrc_pxa_oscr0 = {
 
 static struct irqaction pxa_ost0_irq = {
 	.name		= "ost0",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= pxa_ost0_interrupt,
 	.dev_id		= &ckevt_pxa_osmr0,
 };
diff --git a/arch/arm/mach-sa1100/time.c b/arch/arm/mach-sa1100/time.c
index 74b6e0e..7ec781d 100644
--- a/arch/arm/mach-sa1100/time.c
+++ b/arch/arm/mach-sa1100/time.c
@@ -87,7 +87,7 @@ static struct clocksource cksrc_sa1100_oscr = {
 
 static struct irqaction sa1100_timer_irq = {
 	.name		= "ost0",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= sa1100_ost0_interrupt,
 	.dev_id		= &ckevt_sa1100_osmr0,
 };
diff --git a/arch/arm/mach-shark/core.c b/arch/arm/mach-shark/core.c
index 358d875..d1d6ea5 100644
--- a/arch/arm/mach-shark/core.c
+++ b/arch/arm/mach-shark/core.c
@@ -130,7 +130,7 @@ shark_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction shark_timer_irq = {
 	.name		= "Shark Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= shark_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-u300/timer.c b/arch/arm/mach-u300/timer.c
index 26d26f5..63db057 100644
--- a/arch/arm/mach-u300/timer.c
+++ b/arch/arm/mach-u300/timer.c
@@ -326,7 +326,7 @@ static irqreturn_t u300_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction u300_timer_irq = {
 	.name           = "U300 Timer Tick",
-	.flags          = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags          = IRQF_DISABLED | IRQF_TIMER,
 	.handler        = u300_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-w90x900/time.c b/arch/arm/mach-w90x900/time.c
index b80f769..9cda835 100644
--- a/arch/arm/mach-w90x900/time.c
+++ b/arch/arm/mach-w90x900/time.c
@@ -111,7 +111,7 @@ static irqreturn_t nuc900_timer0_interrupt(int irq, void *dev_id)
 
 static struct irqaction nuc900_timer0_irq = {
 	.name		= "nuc900-timer0",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= nuc900_timer0_interrupt,
 };
 
diff --git a/arch/arm/plat-iop/time.c b/arch/arm/plat-iop/time.c
index 6c8a02a..e320148 100644
--- a/arch/arm/plat-iop/time.c
+++ b/arch/arm/plat-iop/time.c
@@ -164,7 +164,7 @@ iop_timer_interrupt(int irq, void *dev_id)
 static struct irqaction iop_timer_irq = {
 	.name		= "IOP Timer Tick",
 	.handler	= iop_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.dev_id		= &iop_clockevent,
 };
 
diff --git a/arch/arm/plat-mxc/time.c b/arch/arm/plat-mxc/time.c
index f9a1b05..e5ca2bd 100644
--- a/arch/arm/plat-mxc/time.c
+++ b/arch/arm/plat-mxc/time.c
@@ -258,7 +258,7 @@ static irqreturn_t mxc_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction mxc_timer_irq = {
 	.name		= "i.MX Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= mxc_timer_interrupt,
 };
 
diff --git a/arch/arm/plat-samsung/time.c b/arch/arm/plat-samsung/time.c
index 2231d80..133069a 100644
--- a/arch/arm/plat-samsung/time.c
+++ b/arch/arm/plat-samsung/time.c
@@ -138,7 +138,7 @@ s3c2410_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction s3c2410_timer_irq = {
 	.name		= "S3C2410 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= s3c2410_timer_interrupt,
 };
 
diff --git a/arch/arm/plat-versatile/timer-sp.c b/arch/arm/plat-versatile/timer-sp.c
index fb0d1c2..62066b4 100644
--- a/arch/arm/plat-versatile/timer-sp.c
+++ b/arch/arm/plat-versatile/timer-sp.c
@@ -135,7 +135,7 @@ static struct clock_event_device sp804_clockevent = {
 
 static struct irqaction sp804_timer_irq = {
 	.name		= "timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
 	.handler	= sp804_timer_interrupt,
 	.dev_id		= &sp804_clockevent,
 };
diff --git a/arch/blackfin/kernel/time-ts.c b/arch/blackfin/kernel/time-ts.c
index 8c9a43d..6fefad4 100644
--- a/arch/blackfin/kernel/time-ts.c
+++ b/arch/blackfin/kernel/time-ts.c
@@ -213,8 +213,7 @@ irqreturn_t bfin_gptmr0_interrupt(int irq, void *dev_id)
 
 static struct irqaction gptmr0_irq = {
 	.name		= "Blackfin GPTimer0",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | \
-			  IRQF_IRQPOLL | IRQF_PERCPU,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_PERCPU,
 	.handler	= bfin_gptmr0_interrupt,
 };
 
@@ -322,8 +321,7 @@ irqreturn_t bfin_coretmr_interrupt(int irq, void *dev_id)
 
 static struct irqaction coretmr_irq = {
 	.name		= "Blackfin CoreTimer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | \
-			  IRQF_IRQPOLL | IRQF_PERCPU,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_PERCPU,
 	.handler	= bfin_coretmr_interrupt,
 };
 
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 653b3c4..8b366c4 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -411,7 +411,7 @@ static cycle_t itc_get_cycles(struct clocksource *cs)
 
 static struct irqaction timer_irqaction = {
 	.handler =	timer_interrupt,
-	.flags =	IRQF_DISABLED | IRQF_IRQPOLL,
+	.flags =	IRQF_DISABLED,
 	.name =		"timer"
 };
 
diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index efbcee5..24681d5 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -383,7 +383,7 @@ void do_cpu_irq_mask(struct pt_regs *regs)
 static struct irqaction timer_action = {
 	.handler = timer_interrupt,
 	.name = "timer",
-	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_PERCPU | IRQF_IRQPOLL,
+	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_PERCPU,
 };
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index fb5cc5e..476e2fe 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -88,7 +88,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER,
 	.name = "timer"
 };
 
diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index f3d3898..60b681c 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -610,8 +610,7 @@ static int sh_cmt_setup(struct sh_cmt_priv *p, struct platform_device *pdev)
 	p->irqaction.name = dev_name(&p->pdev->dev);
 	p->irqaction.handler = sh_cmt_interrupt;
 	p->irqaction.dev_id = p;
-	p->irqaction.flags = IRQF_DISABLED | IRQF_TIMER | \
-			     IRQF_IRQPOLL  | IRQF_NOBALANCING;
+	p->irqaction.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_NOBALANCING;
 
 	/* get hold of clock */
 	p->clk = clk_get(&p->pdev->dev, "cmt_fck");
diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index ef7a5be..9fe3507 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -281,8 +281,7 @@ static int sh_mtu2_setup(struct sh_mtu2_priv *p, struct platform_device *pdev)
 	p->irqaction.handler = sh_mtu2_interrupt;
 	p->irqaction.dev_id = p;
 	p->irqaction.irq = irq;
-	p->irqaction.flags = IRQF_DISABLED | IRQF_TIMER | \
-			     IRQF_IRQPOLL  | IRQF_NOBALANCING;
+	p->irqaction.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_NOBALANCING;
 
 	/* get hold of clock */
 	p->clk = clk_get(&p->pdev->dev, "mtu2_fck");
diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index de71590..75967f8 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -387,8 +387,7 @@ static int sh_tmu_setup(struct sh_tmu_priv *p, struct platform_device *pdev)
 	p->irqaction.handler = sh_tmu_interrupt;
 	p->irqaction.dev_id = p;
 	p->irqaction.irq = irq;
-	p->irqaction.flags = IRQF_DISABLED | IRQF_TIMER | \
-			     IRQF_IRQPOLL  | IRQF_NOBALANCING;
+	p->irqaction.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_NOBALANCING;
 
 	/* get hold of clock */
 	p->clk = clk_get(&p->pdev->dev, "tmu_fck");
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index c233113..61857f1 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -47,9 +47,6 @@
  * IRQF_TIMER - Flag to mark this interrupt as timer interrupt
  * IRQF_PERCPU - Interrupt is per cpu
  * IRQF_NOBALANCING - Flag to exclude this interrupt from irq balancing
- * IRQF_IRQPOLL - Interrupt is used for polling (only the interrupt that is
- *                registered first in an shared interrupt is considered for
- *                performance reasons)
  * IRQF_ONESHOT - Interrupt is not reenabled after the hardirq handler finished.
  *                Used by threaded interrupts which need to keep the
  *                irq line disabled until the threaded handler has been run.
@@ -61,7 +58,6 @@
 #define IRQF_TIMER		0x00000200
 #define IRQF_PERCPU		0x00000400
 #define IRQF_NOBALANCING	0x00000800
-#define IRQF_IRQPOLL		0x00001000
 #define IRQF_ONESHOT		0x00002000
 
 /*
-- 
1.6.4.2

