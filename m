Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab2D3KD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 06:03:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53972 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab2D3KDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 06:03:24 -0400
Date: Mon, 30 Apr 2012 03:02:02 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        John Stultz <john.stultz@linaro.org>, linaro-kernel@lists.linaro.org,
        patches@linaro.org
Subject: [PATCH 3/3] slab: Get rid of mem_cgroup_put_kmem_cache()
Message-ID: <20120430100202.GC28569@lizard>
References: <20120430095918.GA13824@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120430095918.GA13824@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is no longer used, so can be safely removed.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 include/linux/slab_def.h |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 2d371ae..72ea626 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -232,12 +232,6 @@ kmem_cache_get_ref(struct kmem_cache *cachep)
 }
 
 static inline void
-mem_cgroup_put_kmem_cache(struct kmem_cache *cachep)
-{
-	rcu_read_unlock();
-}
-
-static inline void
 mem_cgroup_kmem_cache_prepare_sleep(struct kmem_cache *cachep)
 {
 	/*
@@ -266,11 +260,6 @@ kmem_cache_drop_ref(struct kmem_cache *cachep)
 }
 
 static inline void
-mem_cgroup_put_kmem_cache(struct kmem_cache *cachep)
-{
-}
-
-static inline void
 mem_cgroup_kmem_cache_prepare_sleep(struct kmem_cache *cachep)
 {
 }
-- 
1.7.9.2
