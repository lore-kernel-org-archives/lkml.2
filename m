Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455Ab2EKOdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:33:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41616 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab2EKOdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:33:22 -0400
Message-ID: <1336746790.1017.17.camel@twins>
Subject: Re: Commit cb83b62 fails to boot with a divide by zero error.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Robin Holt <holt@sgi.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Fri, 11 May 2012 16:33:10 +0200
In-Reply-To: <20120511133938.GG3751@sgi.com>
References: <20120511133938.GG3751@sgi.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 08:39 -0500, Robin Holt wrote:

> We found that reverting the commit:
> cb83b62 (x86/sched/core) sched/numa: Rewrite the CONFIG_NUMA sched domain support
> 
> also got things working.

there's a particularly stupid bug in that code



---
Subject: sched, numa: Fix the new NUMA topology bits
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri May 11 00:56:20 CEST 2012

There's no need to convert a node number to a node number by
pretending its a cpu number..

Reported-by: Yinghai Lu <yinghai@kernel.org>
Reported-and-Tested-by: Greg Pearson <greg.pearson@hp.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6378,8 +6378,7 @@ static void sched_init_numa(void)
 			sched_domains_numa_masks[i][j] = mask;
 
 			for (k = 0; k < nr_node_ids; k++) {
-				if (node_distance(cpu_to_node(j), k) >
-						sched_domains_numa_distance[i])
+				if (node_distance(j, k) > sched_domains_numa_distance[i])
 					continue;
 
 				cpumask_or(mask, mask, cpumask_of_node(k));

