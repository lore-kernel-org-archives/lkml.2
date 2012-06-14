Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab2FNOrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:47:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35449 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab2FNOre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:47:34 -0400
Date: Thu, 14 Jun 2012 07:47:22 -0700
From: tip-bot for Alexander Gordeev <agordeev@redhat.com>
Message-ID: <tip-ea3807ea52a53f2cdfd60c89d8491fc9a8208d1c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, yinghai@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <20120614074954.GF3383@dhcp-26-207.brq.redhat.com>
References: <20120614074954.GF3383@dhcp-26-207.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic:
  Fix ugly casting and branching in cpu_mask_to_apicid_and()
Git-Commit-ID: ea3807ea52a53f2cdfd60c89d8491fc9a8208d1c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 14 Jun 2012 07:47:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea3807ea52a53f2cdfd60c89d8491fc9a8208d1c
Gitweb:     http://git.kernel.org/tip/ea3807ea52a53f2cdfd60c89d8491fc9a8208d1c
Author:     Alexander Gordeev <agordeev@redhat.com>
AuthorDate: Thu, 14 Jun 2012 09:49:55 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Jun 2012 12:53:14 +0200

x86/apic: Fix ugly casting and branching in cpu_mask_to_apicid_and()

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/20120614074954.GF3383@dhcp-26-207.brq.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/apic.c        |    8 ++++----
 arch/x86/kernel/apic/es7000_32.c   |    2 +-
 arch/x86/kernel/apic/summit_32.c   |    2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c |    8 ++++----
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 048a4f8..c421512 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2127,19 +2127,19 @@ int default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 				   const struct cpumask *andmask,
 				   unsigned int *apicid)
 {
-	int cpu;
+	unsigned int cpu;
 
 	for_each_cpu_and(cpu, cpumask, andmask) {
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
 			break;
 	}
 
-	if (likely((unsigned int)cpu < nr_cpu_ids)) {
+	if (likely(cpu < nr_cpu_ids)) {
 		*apicid = per_cpu(x86_cpu_to_apicid, cpu);
 		return 0;
-	} else {
-		return -EINVAL;
 	}
+
+	return -EINVAL;
 }
 
 /*
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 2c5317e..effece2 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -529,7 +529,7 @@ static inline int
 es7000_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *dest_id)
 {
 	unsigned int round = 0;
-	int cpu, uninitialized_var(apicid);
+	unsigned int cpu, uninitialized_var(apicid);
 
 	/*
 	 * The cpus in the mask must all be on the apic cluster.
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index bbad180..b53fd6c 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -267,7 +267,7 @@ static inline int
 summit_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *dest_id)
 {
 	unsigned int round = 0;
-	int cpu, apicid = 0;
+	unsigned int cpu, apicid = 0;
 
 	/*
 	 * The cpus in the mask must all be on the apic cluster.
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 026de01..8cfade9 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -274,7 +274,7 @@ uv_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			  const struct cpumask *andmask,
 			  unsigned int *apicid)
 {
-	int cpu;
+	int unsigned cpu;
 
 	/*
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
@@ -285,12 +285,12 @@ uv_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			break;
 	}
 
-	if (likely((unsigned int)cpu < nr_cpu_ids)) {
+	if (likely(cpu < nr_cpu_ids)) {
 		*apicid = per_cpu(x86_cpu_to_apicid, cpu) | uv_apicid_hibits;
 		return 0;
-	} else {
-		return -EINVAL;
 	}
+
+	return -EINVAL;
 }
 
 static unsigned int x2apic_get_apic_id(unsigned long x)
