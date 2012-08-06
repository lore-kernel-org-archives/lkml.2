Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab2HFJXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:23:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42381 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755623Ab2HFJXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:23:44 -0400
X-IronPort-AV: E=Sophos;i="4.77,719,1336320000"; 
   d="scan'208";a="5560140"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org
Subject: [RFC V3 PATCH 13/25] vmstat: use N_MEMORY instead N_HIGH_MEMORY
Date: Mon, 6 Aug 2012 17:23:07 +0800
Message-Id: <1344244999-5081-14-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1344244999-5081-1-git-send-email-laijs@cn.fujitsu.com>
References: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com>
 <1344244999-5081-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/06 17:24:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/06 17:24:08,
	Serialize complete at 2012/08/06 17:24:08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux.com>
---
 mm/vmstat.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 1bbbbd9..aa3da12 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -917,7 +917,7 @@ static int pagetypeinfo_show(struct seq_file *m, void *arg)
 	pg_data_t *pgdat = (pg_data_t *)arg;
 
 	/* check memoryless node */
-	if (!node_state(pgdat->node_id, N_HIGH_MEMORY))
+	if (!node_state(pgdat->node_id, N_MEMORY))
 		return 0;
 
 	seq_printf(m, "Page block order: %d\n", pageblock_order);
@@ -1279,7 +1279,7 @@ static int unusable_show(struct seq_file *m, void *arg)
 	pg_data_t *pgdat = (pg_data_t *)arg;
 
 	/* check memoryless node */
-	if (!node_state(pgdat->node_id, N_HIGH_MEMORY))
+	if (!node_state(pgdat->node_id, N_MEMORY))
 		return 0;
 
 	walk_zones_in_node(m, pgdat, unusable_show_print);
-- 
1.7.4.4

