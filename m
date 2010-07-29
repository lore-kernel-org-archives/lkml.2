Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab0G2F1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 01:27:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52217 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab0G2F1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 01:27:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [PATCH 2/5] memcg: kill unnecessary initialization in mem_cgroup_shrink_node_zone()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100729140700.4AA2.A69D9226@jp.fujitsu.com>
References: <20100729140700.4AA2.A69D9226@jp.fujitsu.com>
Message-Id: <20100729142652.4AAB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 29 Jul 2010 14:27:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sc.nr_reclaimed and sc.nr_scanned have already been initialized
few lines above "struct scan_control sc = {}" statement.

So, This patch remove this unnecessary code.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/vmscan.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 224184f..102ee3a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1948,8 +1948,6 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
 	sc.nodemask = &nm;
-	sc.nr_reclaimed = 0;
-	sc.nr_scanned = 0;
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_begin(0,
 						      sc.may_writepage,
-- 
1.6.5.2



