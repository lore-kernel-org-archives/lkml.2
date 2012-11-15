Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423342Ab2KNSyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:54:53 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:43176 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423237Ab2KNSyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:54:45 -0500
From: Glauber Costa <glommer@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 1/7] memcg: simplify ida initialization
Date: Thu, 15 Nov 2012 06:54:47 +0400
Message-Id: <1352948093-2315-2-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352948093-2315-1-git-send-email-glommer@parallels.com>
References: <1352948093-2315-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by akpm, change the manual initialization of our kmem
index to DEFINE_IDA()

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Michal Hocko <mhocko@suse.cz>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 mm/memcontrol.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6136fec..c0c6adf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -569,7 +569,7 @@ static void disarm_sock_keys(struct mem_cgroup *memcg)
  * memcg_limited_groups_array_size.  It will double each time we have to
  * increase it.
  */
-static struct ida kmem_limited_groups;
+static DEFINE_IDA(kmem_limited_groups);
 int memcg_limited_groups_array_size;
 
 /*
@@ -5686,9 +5686,6 @@ static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 	if (ret)
 		return ret;
 
-	if (mem_cgroup_is_root(memcg))
-		ida_init(&kmem_limited_groups);
-
 	return mem_cgroup_sockets_init(memcg, ss);
 };
 
-- 
1.7.11.7

