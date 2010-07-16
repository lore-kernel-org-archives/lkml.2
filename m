Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964955Ab0GPKNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 06:13:38 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38648 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964921Ab0GPKNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 06:13:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
Subject: [PATCH 1/7] memcg: sc.nr_to_reclaim should be initialized
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100716191006.7369.A69D9226@jp.fujitsu.com>
References: <20100716191006.7369.A69D9226@jp.fujitsu.com>
Message-Id: <20100716191256.736C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 16 Jul 2010 19:13:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, mem_cgroup_shrink_node_zone() initialize sc.nr_to_reclaim as 0.
It mean shrink_zone() only scan 32 pages and immediately return even if
it doesn't reclaim any pages.

This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1691ad0..bd1d035 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1932,6 +1932,7 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 						struct zone *zone, int nid)
 {
 	struct scan_control sc = {
+		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
 		.may_swap = !noswap,
-- 
1.6.5.2



