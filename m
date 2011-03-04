Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932Ab1CDQWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 11:22:19 -0500
Received: from server103.greatnet.de ([83.133.97.6]:59037 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759908Ab1CDQWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 11:22:17 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@elte.hu
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, gorcunov@gmail.com,
        Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCHv3 6/7] x86: remove unneeded prototypes
Date: Fri,  4 Mar 2011 17:21:54 +0100
Message-Id: <1299255715-8680-6-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299255715-8680-1-git-send-email-henne@nachtwindheim.de>
References: <1299255715-8680-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lapic_clockevent is moved, that we can get rid of some
unneeded prototypes.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/apic/apic.c |   38 +++++++++++++++++---------------------
 1 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 161342a..35d7fa2 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -187,29 +187,8 @@ static struct resource lapic_resource = {
 
 static unsigned int calibration_result;
 
-static int lapic_next_event(unsigned long delta,
-			    struct clock_event_device *evt);
-static void lapic_timer_setup(enum clock_event_mode mode,
-			      struct clock_event_device *evt);
-static void lapic_timer_broadcast(const struct cpumask *mask);
 static void apic_pm_activate(void);
 
-/*
- * The local apic timer can be used for any function which is CPU local.
- */
-static struct clock_event_device lapic_clockevent = {
-	.name		= "lapic",
-	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT
-			| CLOCK_EVT_FEAT_C3STOP | CLOCK_EVT_FEAT_DUMMY,
-	.shift		= 32,
-	.set_mode	= lapic_timer_setup,
-	.set_next_event	= lapic_next_event,
-	.broadcast	= lapic_timer_broadcast,
-	.rating		= 100,
-	.irq		= -1,
-};
-static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
-
 static unsigned long apic_phys;
 
 /*
@@ -501,6 +480,23 @@ static void lapic_timer_broadcast(const struct cpumask *mask)
 #endif
 }
 
+
+/*
+ * The local apic timer can be used for any function which is CPU local.
+ */
+static struct clock_event_device lapic_clockevent = {
+	.name		= "lapic",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT
+			| CLOCK_EVT_FEAT_C3STOP | CLOCK_EVT_FEAT_DUMMY,
+	.shift		= 32,
+	.set_mode	= lapic_timer_setup,
+	.set_next_event	= lapic_next_event,
+	.broadcast	= lapic_timer_broadcast,
+	.rating		= 100,
+	.irq		= -1,
+};
+static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
+
 /*
  * Setup the local APIC timer for this CPU. Copy the initialized values
  * of the boot CPU and register the clock event in the framework.
-- 
1.7.2.3

