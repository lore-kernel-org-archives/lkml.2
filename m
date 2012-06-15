Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab2FOMmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:42:10 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:45604 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab2FOMmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:42:08 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org,
        hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 1/4] hugeltb: Mark hugelb_max_hstate __read_mostly
Date: Fri, 15 Jun 2012 18:11:19 +0530
Message-Id: <1339764082-1611-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339764082-1611-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1339764082-1611-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
x-cbid: 12061512-2674-0000-0000-000004E96CFD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

We set this value only during boot.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/linux/hugetlb.h |    2 +-
 mm/hugetlb.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 9650bb1..0f0877e 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -23,7 +23,7 @@ struct hugepage_subpool {
 };
 
 extern spinlock_t hugetlb_lock;
-extern int hugetlb_max_hstate;
+extern int hugetlb_max_hstate __read_mostly;
 #define for_each_hstate(h) \
 	for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a5a30bf..c57740b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -37,7 +37,7 @@ const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
 static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
 
-int hugetlb_max_hstate;
+int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
 
-- 
1.7.10

