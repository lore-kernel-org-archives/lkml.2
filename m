Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab1D2Pco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:32:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46165 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759367Ab1D2P3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:29:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=LyZaVfFMPHed84GM9R3TjHHV/vI1aCmBwizwLm3KbW2kRo8DSVopY2yxQjC09e5MJS
         UGU2ML2YM+2RO5E1y9hCYB9FJFBbiccwlwLxyCvZtnmwXW2InR1tZsWSCkbkm39bYzZJ
         F7Xgm1GTVIGP8bYKk6pONcspM6y1gqh0jTiXI=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/25] x86, NUMA: Move numa_nodes_parsed to numa.[hc]
Date: Fri, 29 Apr 2011 17:28:31 +0200
Message-Id: <1304090924-8197-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move numa_nodes_parsed from numa_64.[hc] to numa.[hc] to prepare for
NUMA init path unification.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/numa.h    |    1 +
 arch/x86/include/asm/numa_64.h |    4 ----
 arch/x86/mm/numa.c             |    1 +
 arch/x86/mm/numa_64.c          |    2 --
 4 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index b2bd5e6..6e1c74e 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -19,6 +19,7 @@
  * numa_cpu_node().
  */
 extern s16 __apicid_to_node[MAX_LOCAL_APIC];
+extern nodemask_t numa_nodes_parsed __initdata;
 
 static inline void set_apicid_to_node(int apicid, s16 node)
 {
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 794da6d..e84113f 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_X86_NUMA_64_H
 #define _ASM_X86_NUMA_64_H
 
-#include <linux/nodemask.h>
-
 #define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))
 
 extern int numa_off;
@@ -17,8 +15,6 @@ extern unsigned long numa_free_all_bootmem(void);
  */
 #define NODE_MIN_SIZE (4*1024*1024)
 
-extern nodemask_t numa_nodes_parsed __initdata;
-
 extern int __init numa_add_memblk(int nodeid, u64 start, u64 end);
 extern void __init numa_set_distance(int from, int to, int distance);
 
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 08530e3..74d8f90 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -6,6 +6,7 @@
 #include <asm/acpi.h>
 
 int __initdata numa_off;
+nodemask_t numa_nodes_parsed __initdata;
 
 static __init int numa_setup(char *opt)
 {
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 813a161..8d84f9c 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -26,8 +26,6 @@
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
 
-nodemask_t numa_nodes_parsed __initdata;
-
 static struct numa_meminfo numa_meminfo
 #ifndef CONFIG_MEMORY_HOTPLUG
 __initdata
-- 
1.7.1

