Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab0CZWDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:03:54 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39867 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267Ab0CZWDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:03:52 -0400
Date: Fri, 26 Mar 2010 23:03:49 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: peterz@infradead.org, mingo@elte.hu, tglx@linutronix.de, oleg@redhat.com,
       Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/7] arch/sh/kernel: Use set_cpus_allowed_ptr
Message-ID: <Pine.LNX.4.64.1003262303300.6480@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use set_cpus_allowed_ptr rather than set_cpus_allowed.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1,E2;
@@

- set_cpus_allowed(E1, cpumask_of_cpu(E2))
+ set_cpus_allowed_ptr(E1, cpumask_of(E2))

@@
expression E;
identifier I;
@@

- set_cpus_allowed(E, I)
+ set_cpus_allowed_ptr(E, &I)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/sh/kernel/cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/arch/sh/kernel/cpufreq.c b/arch/sh/kernel/cpufreq.c
--- a/arch/sh/kernel/cpufreq.c
+++ b/arch/sh/kernel/cpufreq.c
@@ -48,7 +48,7 @@ static int sh_cpufreq_target(struct cpuf
 		return -ENODEV;
 
 	cpus_allowed = current->cpus_allowed;
-	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
 	BUG_ON(smp_processor_id() != cpu);
 
@@ -66,7 +66,7 @@ static int sh_cpufreq_target(struct cpuf
 	freqs.flags	= 0;
 
 	cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
-	set_cpus_allowed(current, cpus_allowed);
+	set_cpus_allowed_ptr(current, &cpus_allowed);
 	clk_set_rate(cpuclk, freq);
 	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 
