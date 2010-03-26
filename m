Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab0CZWB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:01:56 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:45592 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab0CZWBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:01:54 -0400
Date: Fri, 26 Mar 2010 23:01:51 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: peterz@infradead.org, mingo@elte.hu, tglx@linutronix.de, oleg@redhat.com,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/7] arch/arm: Use set_cpus_allowed_ptr
Message-ID: <Pine.LNX.4.64.1003262301300.6480@ask.diku.dk>
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
 arch/arm/mach-integrator/cpu.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -u -p a/arch/arm/mach-integrator/cpu.c b/arch/arm/mach-integrator/cpu.c
--- a/arch/arm/mach-integrator/cpu.c
+++ b/arch/arm/mach-integrator/cpu.c
@@ -99,7 +99,7 @@ static int integrator_set_target(struct 
 	 * Bind to the specified CPU.  When this call returns,
 	 * we should be running on the right CPU.
 	 */
-	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 	BUG_ON(cpu != smp_processor_id());
 
 	/* get current setting */
@@ -127,7 +127,7 @@ static int integrator_set_target(struct 
 	freqs.cpu = policy->cpu;
 
 	if (freqs.old == freqs.new) {
-		set_cpus_allowed(current, cpus_allowed);
+		set_cpus_allowed_ptr(current, &cpus_allowed);
 		return 0;
 	}
 
@@ -150,7 +150,7 @@ static int integrator_set_target(struct 
 	/*
 	 * Restore the CPUs allowed mask.
 	 */
-	set_cpus_allowed(current, cpus_allowed);
+	set_cpus_allowed_ptr(current, &cpus_allowed);
 
 	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 
@@ -166,7 +166,7 @@ static unsigned int integrator_get(unsig
 
 	cpus_allowed = current->cpus_allowed;
 
-	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 	BUG_ON(cpu != smp_processor_id());
 
 	/* detect memory etc. */
@@ -182,7 +182,7 @@ static unsigned int integrator_get(unsig
 
 	current_freq = icst_hz(&cclk_params, vco) / 1000; /* current freq */
 
-	set_cpus_allowed(current, cpus_allowed);
+	set_cpus_allowed_ptr(current, &cpus_allowed);
 
 	return current_freq;
 }
