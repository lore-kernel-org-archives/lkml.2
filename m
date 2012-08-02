Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab2HBGBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:01:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32170 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab2HBGBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:01:08 -0400
X-IronPort-AV: E=Sophos;i="4.77,698,1336320000"; 
   d="scan'208";a="5534631"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Minchan Kim <minchan@kernel.org>,
        linux-mm@kvack.org
Subject: [RFC PATCH 12/23 V2] vmscan: use N_MEMORY instead N_HIGH_MEMORY
Date: Thu, 2 Aug 2012 14:01:17 +0800
Message-Id: <1343887288-8866-13-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com>
References: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/02 14:01:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/02 14:01:38,
	Serialize complete at 2012/08/02 14:01:38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/vmscan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 66e4310..1888026 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2921,7 +2921,7 @@ static int __devinit cpu_callback(struct notifier_block *nfb,
 	int nid;
 
 	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN) {
-		for_each_node_state(nid, N_HIGH_MEMORY) {
+		for_each_node_state(nid, N_MEMORY) {
 			pg_data_t *pgdat = NODE_DATA(nid);
 			const struct cpumask *mask;
 
@@ -2976,7 +2976,7 @@ static int __init kswapd_init(void)
 	int nid;
 
 	swap_setup();
-	for_each_node_state(nid, N_HIGH_MEMORY)
+	for_each_node_state(nid, N_MEMORY)
  		kswapd_run(nid);
 	hotcpu_notifier(cpu_callback, 0);
 	return 0;
-- 
1.7.1

