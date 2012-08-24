Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796Ab2HXOff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:35:35 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:35799 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2HXOfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:35:33 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 4/5] mm/memblock: use existing interface to set nid
Date: Fri, 24 Aug 2012 22:33:39 +0800
Message-Id: <1345818820-12102-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345818820-12102-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1345818820-12102-1-git-send-email-liwanp@linux.vnet.ibm.com>
x-cbid: 12082414-2674-0000-0000-000005B9D1F1
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

