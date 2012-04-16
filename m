Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab2DPKpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 06:45:18 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:58412 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab2DPKpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 06:45:13 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V6 01/14] hugetlb: rename max_hstate to hugetlb_max_hstate
Date: Mon, 16 Apr 2012 16:14:38 +0530
Message-Id: <1334573091-18602-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
x-cbid: 12041610-4790-0000-0000-00000233E283
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

We will be using this from other subsystems like memcg
in later patches.

Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 mm/hugetlb.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b8ce6f4..766eb90 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -34,7 +34,7 @@ const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
 static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
 
-static int max_hstate;
+static int hugetlb_max_hstate;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
 
@@ -46,7 +46,7 @@ static unsigned long __initdata default_hstate_max_huge_pages;
 static unsigned long __initdata default_hstate_size;
 
 #define for_each_hstate(h) \
-	for ((h) = hstates; (h) < &hstates[max_hstate]; (h)++)
+	for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
 
 /*
  * Protects updates to hugepage_freelists, nr_huge_pages, and free_huge_pages
@@ -1897,9 +1897,9 @@ void __init hugetlb_add_hstate(unsigned order)
 		printk(KERN_WARNING "hugepagesz= specified twice, ignoring\n");
 		return;
 	}
-	BUG_ON(max_hstate >= HUGE_MAX_HSTATE);
+	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
 	BUG_ON(order == 0);
-	h = &hstates[max_hstate++];
+	h = &hstates[hugetlb_max_hstate++];
 	h->order = order;
 	h->mask = ~((1ULL << (order + PAGE_SHIFT)) - 1);
 	h->nr_huge_pages = 0;
@@ -1920,10 +1920,10 @@ static int __init hugetlb_nrpages_setup(char *s)
 	static unsigned long *last_mhp;
 
 	/*
-	 * !max_hstate means we haven't parsed a hugepagesz= parameter yet,
+	 * !hugetlb_max_hstate means we haven't parsed a hugepagesz= parameter yet,
 	 * so this hugepages= parameter goes to the "default hstate".
 	 */
-	if (!max_hstate)
+	if (!hugetlb_max_hstate)
 		mhp = &default_hstate_max_huge_pages;
 	else
 		mhp = &parsed_hstate->max_huge_pages;
@@ -1942,7 +1942,7 @@ static int __init hugetlb_nrpages_setup(char *s)
 	 * But we need to allocate >= MAX_ORDER hstates here early to still
 	 * use the bootmem allocator.
 	 */
-	if (max_hstate && parsed_hstate->order >= MAX_ORDER)
+	if (hugetlb_max_hstate && parsed_hstate->order >= MAX_ORDER)
 		hugetlb_hstate_alloc_pages(parsed_hstate);
 
 	last_mhp = mhp;
-- 
1.7.10

