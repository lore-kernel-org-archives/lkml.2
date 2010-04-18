Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab0DRTCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 15:02:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:44612 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab0DRTCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 15:02:15 -0400
Date: Sun, 18 Apr 2010 12:00:50 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org,
       mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de,
       davej@redhat.com, cpufreq@vger.kernel.org
Subject: [PATCH 1/7] sched: add a comment to get_cpu_idle_time_us()
Message-ID: <20100418120050.562d63a6@infradead.org>
In-Reply-To: <20100418115949.7b743898@infradead.org>
References: <20100418115949.7b743898@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6f9df3bc6571d6545c552151f408d69265e15f92 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 18 Apr 2010 10:25:19 -0700
Subject: [PATCH 1/7] sched: add a comment to get_cpu_idle_time_us()

The exported function get_cpu_idle_time_us() has no comment
describing it; add a kerneldoc comment

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/time/tick-sched.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f992762..54dc155 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -179,6 +179,20 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 	return now;
 }
 
+/**
+ * get_cpu_idle_time_us - get the total idle time of a cpu
+ * @cpu: CPU number to query
+ * @last_update_time: variable to store update time in
+ *
+ * Return the cummulative idle time (since boot) for a given
+ * CPU, in microseconds. The idle time returned includes
+ * the iowait time (unlike what "top" and co report).
+ *
+ * This time is measured via accounting rather than sampling,
+ * and is as accurate as ktime_get() is.
+ *
+ * This function returns -1 if NOHZ is not enabled.
+ */
 u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-- 
1.6.2.5

