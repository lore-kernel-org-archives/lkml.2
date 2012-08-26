Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab2HZJA5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 05:00:57 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:49880 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab2HZJAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 05:00:55 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 3/4] mm/memblock: use existing interface to set nid
Date: Sun, 26 Aug 2012 17:00:25 +0800
Message-Id: <1345971626-17090-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345971626-17090-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1345971626-17090-1-git-send-email-liwanp@linux.vnet.ibm.com>
x-cbid: 12082609-8256-0000-0000-000003E438B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Use existing interface (function) to set NUMA node ID (NID) for
the regions, either memory or reserved region.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/memblock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 880e461..3620493 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -756,7 +756,7 @@ int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
 		return ret;
 
 	for (i = start_rgn; i < end_rgn; i++)
-		type->regions[i].nid = nid;
+		memblock_set_region_node(&type->regions[i], nid);
 
 	memblock_merge_regions(type);
 	return 0;
-- 
1.7.5.4

