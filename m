Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab1D2P3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:29:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54924 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759504Ab1D2P3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:29:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=DH0EEWcCqBDo0Szug367RCinxraFAkiIPxFiISeLy+5wEDKNTTZ9fUrjLWBmPLdyy2
         fpS+RHysyZ3KjDJXnGLseQBGqDXp/FpJQE7nylSUDPCKY7gABq0e7QANGJXNasP6XxVJ
         8qNQnvjHHn2v8muBnawCrAgzBJRjp7D9l4nbI=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 22/25] x86, NUMA: Make numa_init_array() static
Date: Fri, 29 Apr 2011 17:28:41 +0200
Message-Id: <1304090924-8197-23-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

numa_init_array() no longer has users outside of numa.c.  Make it
static.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/numa.h |    2 --
 arch/x86/mm/numa.c          |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index c1934fc..a3f6d3e 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -61,14 +61,12 @@ static inline int numa_cpu_node(int cpu)
 #ifdef CONFIG_NUMA
 extern void __cpuinit numa_set_node(int cpu, int node);
 extern void __cpuinit numa_clear_node(int cpu);
-extern void __init numa_init_array(void);
 extern void __init init_cpu_to_node(void);
 extern void __cpuinit numa_add_cpu(int cpu);
 extern void __cpuinit numa_remove_cpu(int cpu);
 #else	/* CONFIG_NUMA */
 static inline void numa_set_node(int cpu, int node)	{ }
 static inline void numa_clear_node(int cpu)		{ }
-static inline void numa_init_array(void)		{ }
 static inline void init_cpu_to_node(void)		{ }
 static inline void numa_add_cpu(int cpu)		{ }
 static inline void numa_remove_cpu(int cpu)		{ }
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index e6bc804..28e9aad 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -535,7 +535,7 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
  * as the number of CPUs is not known yet. We round robin the existing
  * nodes.
  */
-void __init numa_init_array(void)
+static void __init numa_init_array(void)
 {
 	int rr, i;
 
-- 
1.7.1

