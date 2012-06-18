Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab2FRKbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:31:05 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:37452 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757370Ab2FRKbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:31:00 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-mm@kvack.org>
Cc: Pekka Enberg <penberg@kernel.org>, Cristoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>, <cgroups@vger.kernel.org>,
        <devel@openvz.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH v4 04/25] Wipe out CFLGS_OFF_SLAB from flags during initial slab creation
Date: Mon, 18 Jun 2012 14:27:57 +0400
Message-Id: <1340015298-14133-5-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340015298-14133-1-git-send-email-glommer@parallels.com>
References: <1340015298-14133-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CFLGS_OFF_SLAB is not a valid flag to be passed to cache creation.
If we are duplicating a cache - support added in a future patch -
we will rely on the flags it has stored in itself. That may include
CFLGS_OFF_SLAB.

So it is better to clean this flag at cache creation.

CC: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>
CC: David Rientjes <rientjes@google.com>
---
 mm/slab.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/slab.c b/mm/slab.c
index 2d5fe28..c30a61c 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2201,6 +2201,12 @@ int __kmem_cache_create(struct kmem_cache *cachep)
 		BUG_ON(flags & SLAB_POISON);
 #endif
 	/*
+	 * Passing this flag at creation time is invalid, but if we're
+	 * duplicating a slab, it may happen.
+	 */
+	flags &= ~CFLGS_OFF_SLAB;
+
+	/*
 	 * Always checks flags, a caller might be expecting debug support which
 	 * isn't available.
 	 */
-- 
1.7.10.2

