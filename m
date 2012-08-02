Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab2HBGG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:06:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50609 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752972Ab2HBGAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:00:53 -0400
X-IronPort-AV: E=Sophos;i="4.77,698,1336320000"; 
   d="scan'208";a="5534621"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
Subject: [RFC PATCH 04/23 V2] oom: use N_MEMORY instead N_HIGH_MEMORY
Date: Thu, 2 Aug 2012 14:01:09 +0800
Message-Id: <1343887288-8866-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com>
References: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/02 14:01:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/02 14:01:24,
	Serialize complete at 2012/08/02 14:01:24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/oom_kill.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index ac300c9..1e58f12 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -257,7 +257,7 @@ static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
 	 * the page allocator means a mempolicy is in effect.  Cpuset policy
 	 * is enforced in get_page_from_freelist().
 	 */
-	if (nodemask && !nodes_subset(node_states[N_HIGH_MEMORY], *nodemask)) {
+	if (nodemask && !nodes_subset(node_states[N_MEMORY], *nodemask)) {
 		*totalpages = total_swap_pages;
 		for_each_node_mask(nid, *nodemask)
 			*totalpages += node_spanned_pages(nid);
-- 
1.7.1

