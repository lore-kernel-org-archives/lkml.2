Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760567Ab2FVMAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 08:00:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51818 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760269Ab2FVMAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 08:00:08 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        Tejun Heo <tj@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH 1/2] memcg: use existing function to judge root mem cgroup
Date: Fri, 22 Jun 2012 19:57:22 +0800
Message-Id: <1340366243-28104-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f72b5e5..776fc57 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4873,7 +4873,7 @@ mem_cgroup_create(struct cgroup *cont)
 			goto free_out;
 
 	/* root ? */
-	if (cont->parent == NULL) {
+	if (!(mem_cgroup_is_root(cont))) {
 		int cpu;
 		enable_swap_cgroup();
 		parent = NULL;
-- 
1.7.9.5

