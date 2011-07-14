Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab1GNVjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:39:16 -0400
Received: from smtp-out.google.com ([74.125.121.67]:20847 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546Ab1GNVir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:38:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=oaLaqCxuS1dYw+/22aQ1xWF8NevuHxTQ/WcwEkdmKAR2vbVwYhmeMsC2x8gFsISvb
	9A3PHhAW5pFLmtheZTNrA==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 2/6] trace: Add tracepoints to timer interrupt handlers
Date: Thu, 14 Jul 2011 14:38:11 -0700
Message-Id: <1310679495-29104-3-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tracepoints to generic kernel timer interrupt handlers to trace the
hardware timer interrupts.

This is a part of overall effort to trace all the interrupts happening
in a system to figure out what time is spent in kernel space versus user
space.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 include/trace/events/irq.h   |  156 ++++++++++++++++++++++++++++++++++++++++++
 kernel/hrtimer.c             |    6 ++
 kernel/time/tick-broadcast.c |   16 ++++-
 kernel/time/tick-common.c    |    8 ++-
 kernel/time/tick-sched.c     |    4 +
 5 files changed, 187 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 4b4c7d9..e6e72e0 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -139,6 +139,162 @@ DEFINE_EVENT(softirq, softirq_raise,
 	TP_ARGS(vec_nr)
 );
 
+DECLARE_EVENT_CLASS(timer_interrupt,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	ignore	)
+	),
+
+	TP_fast_assign(
+		__entry->ignore = ignore;
+	),
+
+	TP_printk("%u", __entry->ignore)
+);
+
+/**
+ * hrtimer_interrupt_entry - called immediately after entering the hrtimer
+ * handler
+ *
+ * When used in combination with the hrtimer_interrupt_exit tracepoint
+ * we can determine the hrtimer handler runtime.
+ */
+DEFINE_EVENT(timer_interrupt, hrtimer_interrupt_entry,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
+/**
+ * hrtimer_interrupt_exit - called just before the hrtimer handler returns
+ *
+ * When used in combination with the hrtimer_interrupt_entry tracepoint
+ * we can determine the hrtimer handler runtime.
+ */
+DEFINE_EVENT(timer_interrupt, hrtimer_interrupt_exit,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
+/**
+ * timer_broadcast_entry - called immediately after entering the broadcast
+ * timer handler
+ *
+ * When used in combination with the timer_broadcast_exit tracepoint
+ * we can determine the broadcast timer handler runtime.
+ */
+DEFINE_EVENT(timer_interrupt, timer_broadcast_entry,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
+/**
+ * timer_broadcast_exit - called just before the broadcast timer handler
+ * returns
+ *
+ * When used in combination with the timer_broadcast_entry tracepoint
+ * we can determine the broadcast timer handler runtime.
+ */
+DEFINE_EVENT(timer_interrupt, timer_broadcast_exit,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
+/**
+ * timer_oneshot_entry - called immediately after entering the oneshot
+ * timer handler
+ *
+ * When used in combination with the timer_oneshot_exit tracepoint
+ * we can determine the oneshot timer handler runtime.
+ */
+DEFINE_EVENT(timer_interrupt, timer_oneshot_entry,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
+/**
+ * timer_oneshot_exit - called just before the oneshot timer handler
+ * returns
+ *
+ * When used in combination with the timer_oneshot_entry tracepoint
+ * we can determine the oneshot timer handler runtime.
+ */
+DEFINE_EVENT(timer_interrupt, timer_oneshot_exit,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
+/**
+ * timer_periodic_entry - called immediately after entering the periodic
+ * timer handler
+ *
+ * When used in combination with the timer_periodic_exit tracepoint
+ * we can determine the periodic timer handler runtime.
+ */
+DEFINE_EVENT(timer_interrupt, timer_periodic_entry,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
+/**
+ * timer_periodic_exit - called just before the periodic timer handler
+ * returns
+ *
+ * When used in combination with the timer_periodic_entry tracepoint
+ * we can determine the periodic timer handler runtime.
+ */
+DEFINE_EVENT(timer_interrupt, timer_periodic_exit,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
+/**
+ * timer_nohz_entry - called immediately after entering the nohz
+ * timer handler
+ *
+ * When used in combination with the timer_nohz_exit tracepoint
+ * we can determine the nohz timer handler runtime.
+ */
+DEFINE_EVENT(timer_interrupt, timer_nohz_entry,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
+/**
+ * timer_nohz_exit - called just before the nohz timer handler
+ * returns
+ *
+ * When used in combination with the timer_nohz_entry tracepoint
+ * we can determine the nohz timer handler runtime.
+ */
+DEFINE_EVENT(timer_interrupt, timer_nohz_exit,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
 #endif /*  _TRACE_IRQ_H */
 
 /* This part must be outside protection */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index a9205e3..3bf83d5 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -48,6 +48,7 @@
 
 #include <asm/uaccess.h>
 
+#include <trace/events/irq.h>
 #include <trace/events/timer.h>
 
 /*
@@ -1244,6 +1245,8 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	ktime_t expires_next, now, entry_time, delta;
 	int i, retries = 0;
 
+	trace_hrtimer_interrupt_entry(0);
+
 	BUG_ON(!cpu_base->hres_active);
 	cpu_base->nr_events++;
 	dev->next_event.tv64 = KTIME_MAX;
@@ -1316,6 +1319,7 @@ retry:
 	if (expires_next.tv64 == KTIME_MAX ||
 	    !tick_program_event(expires_next, 0)) {
 		cpu_base->hang_detected = 0;
+		trace_hrtimer_interrupt_exit(0);
 		return;
 	}
 
@@ -1355,6 +1359,8 @@ retry:
 	tick_program_event(expires_next, 1);
 	printk_once(KERN_WARNING "hrtimer: interrupt took %llu ns\n",
 		    ktime_to_ns(delta));
+
+	trace_hrtimer_interrupt_exit(0);
 }
 
 /*
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index c7218d1..fc3b9d6 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -20,6 +20,7 @@
 #include <linux/sched.h>
 
 #include "tick-internal.h"
+#include <trace/events/irq.h>
 
 /*
  * Broadcast support for broken x86 hardware, where the local apic
@@ -176,13 +177,17 @@ static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
 {
 	ktime_t next;
 
+	trace_timer_broadcast_entry(0);
+
 	tick_do_periodic_broadcast();
 
 	/*
 	 * The device is in periodic mode. No reprogramming necessary:
 	 */
-	if (dev->mode == CLOCK_EVT_MODE_PERIODIC)
+	if (dev->mode == CLOCK_EVT_MODE_PERIODIC) {
+		trace_timer_broadcast_exit(0);
 		return;
+	}
 
 	/*
 	 * Setup the next period for devices, which do not have
@@ -194,10 +199,13 @@ static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
 	for (next = dev->next_event; ;) {
 		next = ktime_add(next, tick_period);
 
-		if (!clockevents_program_event(dev, next, ktime_get()))
+		if (!clockevents_program_event(dev, next, ktime_get())) {
+			trace_timer_broadcast_exit(0);
 			return;
+		}
 		tick_do_periodic_broadcast();
 	}
+	trace_timer_broadcast_exit(0);
 }
 
 /*
@@ -404,6 +412,8 @@ static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
 	ktime_t now, next_event;
 	int cpu;
 
+	trace_timer_oneshot_entry(0);
+
 	raw_spin_lock(&tick_broadcast_lock);
 again:
 	dev->next_event.tv64 = KTIME_MAX;
@@ -443,6 +453,8 @@ again:
 			goto again;
 	}
 	raw_spin_unlock(&tick_broadcast_lock);
+
+	trace_timer_oneshot_exit(0);
 }
 
 /*
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 119528d..a7f81af 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -18,6 +18,7 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
+#include <trace/events/irq.h>
 
 #include <asm/irq_regs.h>
 
@@ -84,6 +85,8 @@ void tick_handle_periodic(struct clock_event_device *dev)
 	int cpu = smp_processor_id();
 	ktime_t next;
 
+	trace_timer_periodic_entry(0);
+
 	tick_periodic(cpu);
 
 	if (dev->mode != CLOCK_EVT_MODE_ONESHOT)
@@ -94,8 +97,10 @@ void tick_handle_periodic(struct clock_event_device *dev)
 	 */
 	next = ktime_add(dev->next_event, tick_period);
 	for (;;) {
-		if (!clockevents_program_event(dev, next, ktime_get()))
+		if (!clockevents_program_event(dev, next, ktime_get())) {
+			trace_timer_periodic_exit(0);
 			return;
+		}
 		/*
 		 * Have to be careful here. If we're in oneshot mode,
 		 * before we call tick_periodic() in a loop, we need
@@ -109,6 +114,7 @@ void tick_handle_periodic(struct clock_event_device *dev)
 			tick_periodic(cpu);
 		next = ktime_add(next, tick_period);
 	}
+	trace_timer_periodic_exit(0);
 }
 
 /*
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d5097c4..54e7b07 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -20,6 +20,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <trace/events/irq.h>
 
 #include <asm/irq_regs.h>
 
@@ -568,6 +569,8 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 	int cpu = smp_processor_id();
 	ktime_t now = ktime_get();
 
+	trace_timer_nohz_entry(0);
+
 	dev->next_event.tv64 = KTIME_MAX;
 
 	/*
@@ -604,6 +607,7 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 		now = ktime_get();
 		tick_do_update_jiffies64(now);
 	}
+	trace_timer_nohz_exit(0);
 }
 
 /**
-- 
1.7.3.1

