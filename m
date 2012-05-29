Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab2E2ATo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 20:19:44 -0400
Received: from ozlabs.org ([203.10.76.45]:47645 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab2E2ATn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 20:19:43 -0400
Date: Tue, 29 May 2012 10:19:37 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tony Luck <tony.luck@intel.com>, mingo@kernel.org,
        torvalds@linux-foundation.org, cmetcalf@tilera.com, sivanich@sgi.com,
        akpm@linux-foundation.org, ralf@linux-mips.org, greg.pearson@hp.com,
        ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net,
        kamezawa.hiroyu@jp.fujitsu.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, lethal@linux-sh.org,
        davem@davemloft.net, benh@kernel.crashing.org, dhowells@redhat.com,
        mattst88@gmail.com, fenghua.yu@intel.com, shangw@linux.vnet.ibm.com
Subject: Re: [tip:sched/core] sched/numa: Rewrite the CONFIG_NUMA sched
 domain support
Message-ID: <20120529101937.70ef0bf1@kryten>
In-Reply-To: <1337931080.9783.154.camel@laptop>
References: <tip-r74n3n8hhuc2ynbrnp3vt954@git.kernel.org>
	<CA+8MBbJknmrUXG7U_hBaTs4vJ-1Fa-ENq5g3Qzzh6EmsNiSfXg@mail.gmail.com>
	<1337931080.9783.154.camel@laptop>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Peter,

We have a number of ppc64 boxes that are hitting this and have
verified that the patch fixes it.

Tested-by: Anton Blanchard <anton@samba.org>

Thanks!
Anton

---
Subject: sched: Don't try allocating memory from offline nodes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri May 25 09:26:43 CEST 2012

Allocators don't appreciate it when you try and allocate memory from
offline nodes.

Reported-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched/core.c
===================================================================
--- linux-2.6.orig/kernel/sched/core.c
+++ linux-2.6/kernel/sched/core.c
@@ -6449,7 +6449,7 @@ static void sched_init_numa(void)
 			return;
 
 		for (j = 0; j < nr_node_ids; j++) {
-			struct cpumask *mask = kzalloc_node(cpumask_size(), GFP_KERNEL, j);
+			struct cpumask *mask = kzalloc(cpumask_size(), GFP_KERNEL);
 			if (!mask)
 				return;
 


