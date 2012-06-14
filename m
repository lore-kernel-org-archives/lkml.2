Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2FNOpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:45:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35425 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2FNOpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:45:53 -0400
Date: Thu, 14 Jun 2012 07:45:38 -0700
From: tip-bot for Alexander Gordeev <agordeev@redhat.com>
Message-ID: <tip-cac4afbc3da58d9e5701b34bd4c1f11ea13328d4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, yinghai@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <20120614103933.GJ3383@dhcp-26-207.brq.redhat.com>
References: <20120614103933.GJ3383@dhcp-26-207.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/x2apic/cluster: Vector_allocation_domain()
  should return a value
Git-Commit-ID: cac4afbc3da58d9e5701b34bd4c1f11ea13328d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 14 Jun 2012 07:45:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cac4afbc3da58d9e5701b34bd4c1f11ea13328d4
Gitweb:     http://git.kernel.org/tip/cac4afbc3da58d9e5701b34bd4c1f11ea13328d4
Author:     Alexander Gordeev <agordeev@redhat.com>
AuthorDate: Thu, 14 Jun 2012 12:39:34 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Jun 2012 12:53:12 +0200

x86/x2apic/cluster: Vector_allocation_domain() should return a value

Since commit 8637e38 ("x86/apic: Avoid useless scanning thru a
cpumask in assign_irq_vector()") vector_allocation_domain()
operation indicates if a cpumask is dynamic or static. This
update fixes the oversight and makes the operation to return a
value.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/20120614103933.GJ3383@dhcp-26-207.brq.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
