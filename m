Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab1CGNHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 08:07:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab1CGNHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 08:07:12 -0500
From: Petr Holasek <pholasek@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: emunson@mgebm.net, anton@redhat.com, Petr Holasek <pholasek@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org
Subject: [PATCH] hugetlb: /proc/meminfo shows data for all sizes of hugepages
Date: Mon,  7 Mar 2011 14:05:55 +0100
Message-Id: <1299503155-6210-1-git-send-email-pholasek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/meminfo file shows data for all used sizes of hugepages
on system, not only for default hugepage size.

Signed-off-by: Petr Holasek <pholasek@redhat.com>
---
 mm/hugetlb.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bb0b7c1..7919849 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1963,18 +1963,20 @@ out:
 
 void hugetlb_report_meminfo(struct seq_file *m)
 {
-	struct hstate *h = &default_hstate;
-	seq_printf(m,
-			"HugePages_Total:   %5lu\n"
-			"HugePages_Free:    %5lu\n"
-			"HugePages_Rsvd:    %5lu\n"
-			"HugePages_Surp:    %5lu\n"
-			"Hugepagesize:   %8lu kB\n",
-			h->nr_huge_pages,
-			h->free_huge_pages,
-			h->resv_huge_pages,
-			h->surplus_huge_pages,
-			1UL << (huge_page_order(h) + PAGE_SHIFT - 10));
+	struct hstate *h;
+
+	for_each_hstate(h)
+		seq_printf(m,
+				"HugePages_Total:   %5lu\n"
+				"HugePages_Free:    %5lu\n"
+				"HugePages_Rsvd:    %5lu\n"
+				"HugePages_Surp:    %5lu\n"
+				"Hugepagesize:   %8lu kB\n",
+				h->nr_huge_pages,
+				h->free_huge_pages,
+				h->resv_huge_pages,
+				h->surplus_huge_pages,
+				1UL << (huge_page_order(h) + PAGE_SHIFT - 10));
 }
 
 int hugetlb_report_node_meminfo(int nid, char *buf)
-- 
1.7.1

