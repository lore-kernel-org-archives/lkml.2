Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121Ab1BPMVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:21:37 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36104 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759053Ab1BPMV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:21:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Tp5B3Fw03Io2VzqyfS0EUjYfJCpjm+5ruto3dkU8/2Hy5Rr6jAnR3xTnb/wE+EhTMF
         rxcO4x3aN6h5KEm2wRqGO07Jg0Tmv7sJczMQZJk8LrrMSd+tMxLKUgld0zd6boyikzHm
         M+p5S1yVxNFy19BspE1kOhcAMYz0cenU1JxWg=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/33] x86-64, NUMA: Remove local variable found from amd_numa_init()
Date: Wed, 16 Feb 2011 13:20:43 +0100
Message-Id: <1297858867-25981-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use weight count on mem_nodes_parsed instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/amdtopology_64.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index 4f822a2..7d85cf7 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -74,7 +74,7 @@ int __init amd_numa_init(void)
 	unsigned long end = PFN_PHYS(max_pfn);
 	unsigned numnodes;
 	unsigned long prevbase;
-	int i, nb, found = 0;
+	int i, nb;
 	u32 nodeid, reg;
 
 	if (!early_pci_allowed())
@@ -165,8 +165,6 @@ int __init amd_numa_init(void)
 		pr_info("Node %d MemBase %016lx Limit %016lx\n",
 			nodeid, base, limit);
 
-		found++;
-
 		nodes[nodeid].start = base;
 		nodes[nodeid].end = limit;
 
@@ -176,7 +174,7 @@ int __init amd_numa_init(void)
 		node_set(nodeid, cpu_nodes_parsed);
 	}
 
-	if (!found)
+	if (!nodes_weight(mem_nodes_parsed))
 		return -ENOENT;
 	return 0;
 }
-- 
1.7.1

