Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935057Ab2JaICu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:02:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:4721 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753323Ab2JaH6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:58:32 -0400
X-IronPort-AV: E=Sophos;i="4.80,687,1344182400"; 
   d="scan'208";a="6107039"
From: Wen Congyang <wency@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: [PART3 Patch 03/14] procfs: use N_MEMORY instead N_HIGH_MEMORY
Date: Wed, 31 Oct 2012 16:04:01 +0800
Message-Id: <1351670652-9932-4-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351670652-9932-1-git-send-email-wency@cn.fujitsu.com>
References: <1351670652-9932-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 15:57:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 15:57:44,
	Serialize complete at 2012/10/31 15:57:44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
---
 fs/proc/kcore.c    | 2 +-
 fs/proc/task_mmu.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 86c67ee..e96d4f1 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -249,7 +249,7 @@ static int kcore_update_ram(void)
 	/* Not inialized....update now */
 	/* find out "max pfn" */
 	end_pfn = 0;
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		unsigned long node_end;
 		node_end  = NODE_DATA(nid)->node_start_pfn +
 			NODE_DATA(nid)->node_spanned_pages;
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 90c63f9..2d89601 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1126,7 +1126,7 @@ static struct page *can_gather_numa_stats(pte_t pte, struct vm_area_struct *vma,
 		return NULL;
 
 	nid = page_to_nid(page);
-	if (!node_isset(nid, node_states[N_HIGH_MEMORY]))
+	if (!node_isset(nid, node_states[N_MEMORY]))
 		return NULL;
 
 	return page;
@@ -1279,7 +1279,7 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 	if (md->writeback)
 		seq_printf(m, " writeback=%lu", md->writeback);
 
-	for_each_node_state(n, N_HIGH_MEMORY)
+	for_each_node_state(n, N_MEMORY)
 		if (md->node[n])
 			seq_printf(m, " N%d=%lu", n, md->node[n]);
 out:
-- 
1.8.0

