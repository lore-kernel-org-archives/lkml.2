Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474Ab2CIUqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:46:36 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:52774 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab2CIUqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 15:46:34 -0500
From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
To: cgroups@vger.kernel.org
Cc: suleiman@google.com, glommer@parallels.com, kamezawa.hiroyu@jp.fujitsu.com,
        penberg@kernel.org, cl@linux.com, yinghan@google.com, hughd@google.com,
        gthelen@google.com, peterz@infradead.org, dan.magenheimer@oracle.com,
        hannes@cmpxchg.org, mgorman@suse.de,
        James.Bottomley@HansenPartnership.com, linux-mm@kvack.org,
        devel@openvz.org, linux-kernel@vger.kernel.org,
        Suleiman Souhlal <ssouhlal@FreeBSD.org>
Subject: [PATCH v2 06/13] slab: Add kmem_cache_gfp_flags() helper function.
Date: Fri,  9 Mar 2012 12:39:09 -0800
Message-Id: <1331325556-16447-7-git-send-email-ssouhlal@FreeBSD.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org>
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function returns the gfp flags that are always applied to
allocations of a kmem_cache.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 include/linux/slab_def.h |    6 ++++++
 include/linux/slob_def.h |    6 ++++++
 include/linux/slub_def.h |    6 ++++++
 3 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index fbd1117..25f9a6a 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -159,6 +159,12 @@ found:
 	return __kmalloc(size, flags);
 }
 
+static inline gfp_t
+kmem_cache_gfp_flags(struct kmem_cache *cachep)
+{
+	return cachep->gfpflags;
+}
+
 #ifdef CONFIG_NUMA
 extern void *__kmalloc_node(size_t size, gfp_t flags, int node);
 extern void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
diff --git a/include/linux/slob_def.h b/include/linux/slob_def.h
index 0ec00b3..3fa527d 100644
--- a/include/linux/slob_def.h
+++ b/include/linux/slob_def.h
@@ -34,4 +34,10 @@ static __always_inline void *__kmalloc(size_t size, gfp_t flags)
 	return kmalloc(size, flags);
 }
 
+static inline gfp_t
+kmem_cache_gfp_flags(struct kmem_cache *cachep)
+{
+	return 0;
+}
+
 #endif /* __LINUX_SLOB_DEF_H */
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index a32bcfd..5911d81 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -313,4 +313,10 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 }
 #endif
 
+static inline gfp_t
+kmem_cache_gfp_flags(struct kmem_cache *cachep)
+{
+	return cachep->allocflags;
+}
+
 #endif /* _LINUX_SLUB_DEF_H */
-- 
1.7.7.3

