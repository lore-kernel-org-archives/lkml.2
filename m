Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab2D0FvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 01:51:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51723 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab2D0FvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 01:51:23 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F9A3364.4090009@jp.fujitsu.com>
Date: Fri, 27 Apr 2012 14:49:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Han Ying <yinghan@google.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyuki@gmail.com
Subject: [RFC][PATCH 1/7 v2] temporal compile-fix in linux-next
References: <4F9A327A.6050409@jp.fujitsu.com>
In-Reply-To: <4F9A327A.6050409@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe Aneesh will post his own version. This is just for my work.

>From eaf25c555ec809006220ef22ef152aa04c30c1af Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 26 Apr 2012 17:51:52 +0900
Subject: [PATCH 1/9] compile-fix

My version of compile fix for linux-next, discussed between Andrew and
Aneesh.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/hugetlb.h    |    4 ----
 include/linux/memcontrol.h |   15 +++++++++++++++
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 828b073..fc226be 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -343,8 +343,4 @@ static inline unsigned int pages_per_huge_page(struct hstate *h)
 #define hstate_index(h) 0
 #endif
 
-#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
-extern int hugetlb_force_memcg_empty(struct cgroup *cgroup);
-#endif
-
 #endif /* _LINUX_HUGETLB_H */
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f173811..ca0914a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -450,9 +450,14 @@ extern int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
 					  struct page *page);
 extern bool mem_cgroup_have_hugetlb_usage(struct cgroup *cgroup);
 
+extern int hugetlb_force_memcg_empty(struct cgroup *cgroup);
+
 extern void  mem_cgroup_hugetlb_migrate(struct page *oldhpage,
 					struct page *newhpage);
 #else
+struct cgroup;
+struct mem_cgroup;
+
 static inline int
 mem_cgroup_hugetlb_charge_page(int idx, unsigned long nr_pages,
 						 struct mem_cgroup **ptr)
@@ -494,6 +499,16 @@ mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
 	return 0;
 }
 
+static inline void  mem_cgroup_hugetlb_migrate(struct page *oldhpage,
+				struct page *newhpage)
+{
+	return;
+}
+
+static inline int hugetlb_force_memcg_empty(struct cgroup *cgroup)
+{
+	return 0;
+}
 #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
 #endif /* _LINUX_MEMCONTROL_H */
 
-- 
1.7.4.1


