Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab2BGPLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 10:11:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63574 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab2BGPKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 10:10:51 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=-I-d5KTFargA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=2zli643jjhjTyJyuCMsA:9 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120207151049.632303467@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 07 Feb 2012 09:56:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rob Herring <robherring2@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Kevin Hilman <khilman@ti.com>, Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 3/3][RFC] cpuidle/tracing: Denote the tracepoints as being in rcu_idle_exit()
 section
References: <20120207145653.829892056@goodmis.org>
Content-Disposition: inline; filename=0003-cpuidle-tracing-Denote-the-tracepoints-as-being-in-r.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

As the tracepoints in the cpuidle code are called when rcu_idle_exit() is in
effect, the _rcuidle() version must be used, otherwise the rcu_read_lock()s
that protect the tracepoint will not be honored.

Cc: Len Brown <len.brown@intel.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/cpuidle/cpuidle.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 59f4261..6588f43 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -94,13 +94,13 @@ int cpuidle_idle_call(void)
 
 	target_state = &drv->states[next_state];
 
-	trace_power_start(POWER_CSTATE, next_state, dev->cpu);
-	trace_cpu_idle(next_state, dev->cpu);
+	trace_power_start_rcuidle(POWER_CSTATE, next_state, dev->cpu);
+	trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
 	entered_state = target_state->enter(dev, drv, next_state);
 
-	trace_power_end(dev->cpu);
-	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
+	trace_power_end_rcuidle(dev->cpu);
+	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
 
 	if (entered_state >= 0) {
 		/* Update cpuidle counters */
-- 
1.7.8.3


