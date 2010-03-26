Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab0CZWDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:03:33 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39839 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227Ab0CZWDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:03:32 -0400
Date: Fri, 26 Mar 2010 23:03:29 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: peterz@infradead.org, mingo@elte.hu, tglx@linutronix.de, oleg@redhat.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/7] arch/powerpc/kernel: Use set_cpus_allowed_ptr
Message-ID: <Pine.LNX.4.64.1003262303080.6480@ask.diku.dk>
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
 arch/powerpc/kernel/smp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -561,12 +561,12 @@ void __init smp_cpus_done(unsigned int m
 	 * se we pin us down to CPU 0 for a short while
 	 */
 	old_mask = current->cpus_allowed;
-	set_cpus_allowed(current, cpumask_of_cpu(boot_cpuid));
+	set_cpus_allowed_ptr(current, cpumask_of(boot_cpuid));
 	
 	if (smp_ops && smp_ops->setup_cpu)
 		smp_ops->setup_cpu(boot_cpuid);
 
-	set_cpus_allowed(current, old_mask);
+	set_cpus_allowed_ptr(current, &old_mask);
 
 	snapshot_timebases();
 

