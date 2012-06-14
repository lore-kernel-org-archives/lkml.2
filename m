Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab2FNKju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:39:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755672Ab2FNKjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:39:48 -0400
Date: Thu, 14 Jun 2012 12:39:34 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/6] x86/x2apic/cluster: vector_allocation_domain() should
 return a value
Message-ID: <20120614103933.GJ3383@dhcp-26-207.brq.redhat.com>
References: <cover.1339657103.git.agordeev@redhat.com>
 <20120614074913.GD3383@dhcp-26-207.brq.redhat.com>
 <20120614095925.GA19531@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614095925.GA19531@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 8637e38 ("x86/apic: Avoid useless scanning thru a cpumask
in assign_irq_vector()") vector_allocation_domain() operation indicates
if a cpumask is dynamic or static. This update fixes the oversight and
makes the operation to return a value.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/apic/x2apic_cluster.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 23a46cf..1885a73 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -228,10 +228,11 @@ static int x2apic_cluster_probe(void)
 /*
  * Each x2apic cluster is an allocation domain.
  */
-static void cluster_vector_allocation_domain(int cpu, struct cpumask *retmask)
+static bool cluster_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	cpumask_clear(retmask);
 	cpumask_copy(retmask, per_cpu(cpus_in_cluster, cpu));
+	return true;
 }
 
 static struct apic apic_x2apic_cluster = {
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
