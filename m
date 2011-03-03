Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab1CCUFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:05:19 -0500
Received: from server103.greatnet.de ([83.133.97.6]:55245 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758772Ab1CCUFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:05:18 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@elte.hu
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 6/7] x86: remove unneeded prototypes
Date: Thu,  3 Mar 2011 21:05:00 +0100
Message-Id: <1299182701-8591-6-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de>
References: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lapic_clockevent is moved, that we can get rid of some
unneeded prototypes.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 arch/x86/kernel/apic/apic.c |   38 +++++++++++++++++---------------------
 1 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a0e9c1f..64efb2d 100644
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

