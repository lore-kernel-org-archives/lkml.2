Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423355Ab2KNSyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:54:54 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:30302 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423239Ab2KNSyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:54:45 -0500
From: Glauber Costa <glommer@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 2/7] move include of workqueue.h to top of slab.h file
Date: Thu, 15 Nov 2012 06:54:48 +0400
Message-Id: <1352948093-2315-3-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352948093-2315-1-git-send-email-glommer@parallels.com>
References: <1352948093-2315-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested by akpm. I originally decided to put it closer to the use of
the work struct, but let's move it to top.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Michal Hocko <mhocko@suse.cz>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/slab.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 81ee767..18f8c98 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -11,6 +11,8 @@
 
 #include <linux/gfp.h>
 #include <linux/types.h>
+#include <linux/workqueue.h>
+
 
 /*
  * Flags to pass to kmem_cache_create().
@@ -180,8 +182,6 @@ unsigned int kmem_cache_size(struct kmem_cache *);
 #ifndef ARCH_SLAB_MINALIGN
 #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
 #endif
-
-#include <linux/workqueue.h>
 /*
  * This is the main placeholder for memcg-related information in kmem caches.
  * struct kmem_cache will hold a pointer to it, so the memory cost while
-- 
1.7.11.7

