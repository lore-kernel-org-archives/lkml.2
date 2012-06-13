Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab2FMK2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 06:28:36 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:51061 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab2FMK23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 06:28:29 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org,
        hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V9 08/15] hugetlb: Make some static variables global
Date: Wed, 13 Jun 2012 15:57:27 +0530
Message-Id: <1339583254-895-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
x-cbid: 12061310-2674-0000-0000-000004E24DF4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

We will use them later in hugetlb_cgroup.c

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/linux/hugetlb.h |    5 +++++
 mm/hugetlb.c            |    7 ++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index ed550d8..4aca057 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -21,6 +21,11 @@ struct hugepage_subpool {
 	long max_hpages, used_hpages;
 };
 
+extern spinlock_t hugetlb_lock;
+extern int hugetlb_max_hstate;
+#define for_each_hstate(h) \
+	for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
+
 struct hugepage_subpool *hugepage_new_subpool(long nr_blocks);
 void hugepage_put_subpool(struct hugepage_subpool *spool);
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b5b6e15..e899a2d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -35,7 +35,7 @@ const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
 static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
 
-static int hugetlb_max_hstate;
+int hugetlb_max_hstate;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
 
@@ -46,13 +46,10 @@ static struct hstate * __initdata parsed_hstate;
 static unsigned long __initdata default_hstate_max_huge_pages;
 static unsigned long __initdata default_hstate_size;
 
-#define for_each_hstate(h) \
-	for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
-
 /*
  * Protects updates to hugepage_freelists, nr_huge_pages, and free_huge_pages
  */
-static DEFINE_SPINLOCK(hugetlb_lock);
+DEFINE_SPINLOCK(hugetlb_lock);
 
 static inline void unlock_or_release_subpool(struct hugepage_subpool *spool)
 {
-- 
1.7.10

