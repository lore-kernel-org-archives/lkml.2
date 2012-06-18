Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737Ab2FRKbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:31:23 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:12718 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757677Ab2FRKbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:31:20 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-mm@kvack.org>
Cc: Pekka Enberg <penberg@kernel.org>, Cristoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>, <cgroups@vger.kernel.org>,
        <devel@openvz.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH v4 10/25] slab/slub: struct memcg_params
Date: Mon, 18 Jun 2012 14:28:03 +0400
Message-Id: <1340015298-14133-11-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340015298-14133-1-git-send-email-glommer@parallels.com>
References: <1340015298-14133-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the kmem slab controller, we need to record some extra
information in the kmem_cache structure.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
CC: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Michal Hocko <mhocko@suse.cz>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/slab.h     |    8 ++++++++
 include/linux/slab_def.h |    4 ++++
 include/linux/slub_def.h |    3 +++
 3 files changed, 15 insertions(+)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 3c2181a..e007cc5 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -177,6 +177,14 @@ unsigned int kmem_cache_size(struct kmem_cache *);
 #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
 #endif
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
+struct mem_cgroup_cache_params {
+	struct mem_cgroup *memcg;
+	int id;
+	atomic_t refcnt;
+};
+#endif
+
 /*
  * Common kmalloc functions provided by all allocators
  */
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 0c634fa..04ca5be 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -83,6 +83,10 @@ struct kmem_cache {
 	int obj_offset;
 #endif /* CONFIG_DEBUG_SLAB */
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
+	struct mem_cgroup_cache_params memcg_params;
+#endif
+
 /* 6) per-cpu/per-node data, touched during every alloc/free */
 	/*
 	 * We put array[] at the end of kmem_cache, because we want to size
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index df448ad..7637f3b 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -101,6 +101,9 @@ struct kmem_cache {
 #ifdef CONFIG_SYSFS
 	struct kobject kobj;	/* For sysfs */
 #endif
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
+	struct mem_cgroup_cache_params memcg_params;
+#endif
 
 #ifdef CONFIG_NUMA
 	/*
-- 
1.7.10.2

