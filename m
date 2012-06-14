Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab2FNOsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:48:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35463 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab2FNOsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:48:32 -0400
Date: Thu, 14 Jun 2012 07:48:15 -0700
From: tip-bot for Alexander Gordeev <agordeev@redhat.com>
Message-ID: <tip-49ad3fd4834182cce9725abb98e080b479fed464@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, yinghai@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <20120614075010.GG3383@dhcp-26-207.brq.redhat.com>
References: <20120614075010.GG3383@dhcp-26-207.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic/es7000+summit:
  Fix compile warning in cpu_mask_to_apicid()
Git-Commit-ID: 49ad3fd4834182cce9725abb98e080b479fed464
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 14 Jun 2012 07:48:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  49ad3fd4834182cce9725abb98e080b479fed464
Gitweb:     http://git.kernel.org/tip/49ad3fd4834182cce9725abb98e080b479fed464
Author:     Alexander Gordeev <agordeev@redhat.com>
AuthorDate: Thu, 14 Jun 2012 09:50:11 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Jun 2012 12:53:15 +0200

x86/apic/es7000+summit: Fix compile warning in cpu_mask_to_apicid()

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/20120614075010.GG3383@dhcp-26-207.brq.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
