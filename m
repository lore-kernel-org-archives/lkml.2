Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993371Ab2KOIvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:51:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:44853 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S2993230Ab2KOIva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:51:30 -0500
X-IronPort-AV: E=Sophos;i="4.83,256,1352044800"; 
   d="scan'208";a="6205589"
From: Wen Congyang <wency@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Lin feng <linfeng@cn.fujitsu.com>, Wen Congyang <wency@cn.fujitsu.com>
Subject: [PART3 Patch v2 07/14] mempolicy: use N_MEMORY instead N_HIGH_MEMORY
Date: Thu, 15 Nov 2012 16:57:30 +0800
Message-Id: <1352969857-26623-8-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352969857-26623-1-git-send-email-wency@cn.fujitsu.com>
References: <1352969857-26623-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/15 16:51:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/15 16:51:20,
	Serialize complete at 2012/11/15 16:51:20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 mm/mempolicy.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index d04a8a5..d4a084c 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -212,9 +212,9 @@ static int mpol_set_nodemask(struct mempolicy *pol,
 	/* if mode is MPOL_DEFAULT, pol is NULL. This is right. */
 	if (pol == NULL)
 		return 0;
-	/* Check N_HIGH_MEMORY */
+	/* Check N_MEMORY */
 	nodes_and(nsc->mask1,
-		  cpuset_current_mems_allowed, node_states[N_HIGH_MEMORY]);
+		  cpuset_current_mems_allowed, node_states[N_MEMORY]);
 
 	VM_BUG_ON(!nodes);
 	if (pol->mode == MPOL_PREFERRED && nodes_empty(*nodes))
@@ -1388,7 +1388,7 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
 		goto out_put;
 	}
 
-	if (!nodes_subset(*new, node_states[N_HIGH_MEMORY])) {
+	if (!nodes_subset(*new, node_states[N_MEMORY])) {
 		err = -EINVAL;
 		goto out_put;
 	}
@@ -2361,7 +2361,7 @@ void __init numa_policy_init(void)
 	 * fall back to the largest node if they're all smaller.
 	 */
 	nodes_clear(interleave_nodes);
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		unsigned long total_pages = node_present_pages(nid);
 
 		/* Preserve the largest node */
@@ -2442,7 +2442,7 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 		*nodelist++ = '\0';
 		if (nodelist_parse(nodelist, nodes))
 			goto out;
-		if (!nodes_subset(nodes, node_states[N_HIGH_MEMORY]))
+		if (!nodes_subset(nodes, node_states[N_MEMORY]))
 			goto out;
 	} else
 		nodes_clear(nodes);
@@ -2476,7 +2476,7 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 		 * Default to online nodes with memory if no nodelist
 		 */
 		if (!nodelist)
-			nodes = node_states[N_HIGH_MEMORY];
+			nodes = node_states[N_MEMORY];
 		break;
 	case MPOL_LOCAL:
 		/*
-- 
1.8.0

