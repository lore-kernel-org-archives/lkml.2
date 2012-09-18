Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab2IRORA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 10:17:00 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:8579 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933077Ab2IROQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 10:16:53 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <cgroups@vger.kernel.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <devel@openvz.org>, Tejun Heo <tj@kernel.org>, <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH v3 03/16] slab: Ignore the cflgs bit in cache creation
Date: Tue, 18 Sep 2012 18:11:57 +0400
Message-Id: <1347977530-29755-4-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347977530-29755-1-git-send-email-glommer@parallels.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No cache should ever pass that as a creation flag, since this bit is
used to mark an internal decision of the slab about object placement. We
can just ignore this bit if it happens to be passed (such as when
duplicating a cache in the kmem memcg patches)

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>
CC: David Rientjes <rientjes@google.com>
---
 mm/slab.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/slab.c b/mm/slab.c
index a7ed60f..ccf496c 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2373,6 +2373,7 @@ __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
 	int err;
 	size_t size = cachep->size;
 
+	flags &= ~CFLGS_OFF_SLAB;
 #if DEBUG
 #if FORCED_DEBUG
 	/*
-- 
1.7.11.4

