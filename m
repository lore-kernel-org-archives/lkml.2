Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab2FNHuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 03:50:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab2FNHuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 03:50:17 -0400
Date: Thu, 14 Jun 2012 09:50:11 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 4/6] x86/apic/es7000+summit: Fix compile warning in
 cpu_mask_to_apicid()
Message-ID: <20120614075010.GG3383@dhcp-26-207.brq.redhat.com>
References: <cover.1339657103.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1339657103.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/apic/es7000_32.c |    2 +-
 arch/x86/kernel/apic/summit_32.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index effece2..0c1347d 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -554,8 +554,8 @@ es7000_cpu_mask_to_apicid_and(const struct cpumask *inmask,
 			      const struct cpumask *andmask,
 			      unsigned int *apicid)
 {
-	*apicid = early_per_cpu(x86_cpu_to_logical_apicid, 0);
 	cpumask_var_t cpumask;
+	*apicid = early_per_cpu(x86_cpu_to_logical_apicid, 0);
 
 	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
 		return 0;
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index b53fd6c..e6cc182 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -291,8 +291,8 @@ summit_cpu_mask_to_apicid_and(const struct cpumask *inmask,
 			      const struct cpumask *andmask,
 			      unsigned int *apicid)
 {
-	*apicid = early_per_cpu(x86_cpu_to_logical_apicid, 0);
 	cpumask_var_t cpumask;
+	*apicid = early_per_cpu(x86_cpu_to_logical_apicid, 0);
 
 	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
 		return 0;
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
