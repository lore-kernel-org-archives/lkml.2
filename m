Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab1KAHio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 03:38:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49465 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab1KAHin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 03:38:43 -0400
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] cpumask: update the Note of setup_node_to_cpumask_map
Date: Tue, 1 Nov 2011 15:37:36 +0800
Message-Id: <1320133056-25752-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.8.rc0
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-01 15:38:47,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-01 15:38:48,
	Serialize complete at 2011-11-01 15:38:48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

node_to_cpumask() had been replaced by cpumask_of_node(), and wholly
removed since commit 29c337a0.

So update the Note of setup_node_to_cpumask_map().

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 arch/powerpc/mm/numa.c |    2 +-
 arch/x86/mm/numa.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 2164006..664272c 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -58,7 +58,7 @@ static int distance_lookup_table[MAX_NUMNODES][MAX_DISTANCE_REF_POINTS];
  * Allocate node_to_cpumask_map based on number of available nodes
  * Requires node_possible_map to be valid.
  *
- * Note: node_to_cpumask() is not valid until after this is done.
+ * Note: cpumask_of_node() is not valid until after this is done.
  */
 static void __init setup_node_to_cpumask_map(void)
 {
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index fbeaaf4..43049f0 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -110,7 +110,7 @@ void __cpuinit numa_clear_node(int cpu)
  * Allocate node_to_cpumask_map based on number of available nodes
  * Requires node_possible_map to be valid.
  *
- * Note: node_to_cpumask() is not valid until after this is done.
+ * Note: cpumask_of_node() is not valid until after this is done.
  * (Use CONFIG_DEBUG_PER_CPU_MAPS to check this.)
  */
 void __init setup_node_to_cpumask_map(void)
-- 
1.7.8.rc0

