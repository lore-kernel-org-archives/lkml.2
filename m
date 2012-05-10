Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab2EJPZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:25:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34650 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2EJPZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:25:19 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH] slub: fix incorrect return type of get_any_partial()
Date: Fri, 11 May 2012 00:23:56 +0900
Message-Id: <1336663436-2169-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.00.1205080912590.25669@router.home>
References: <alpine.DEB.2.00.1205080912590.25669@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 497b66f2ecc97844493e6a147fd5a7e73f73f408 ('slub: return object pointer
from get_partial() / new_slab().') changed return type of some functions.
This updates missing part.

In addition, fix some comments

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/mm/slub.c b/mm/slub.c
index ffe13fd..23d66aa 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1577,9 +1577,9 @@ static void *get_partial_node(struct kmem_cache *s,
 }
 
 /*
- * Get a page from somewhere. Search in increasing NUMA distances.
+ * Get a partial slab from somewhere. Search in increasing NUMA distances.
  */
-static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags,
+static void *get_any_partial(struct kmem_cache *s, gfp_t flags,
 		struct kmem_cache_cpu *c)
 {
 #ifdef CONFIG_NUMA
@@ -1643,7 +1643,7 @@ static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags,
 }
 
 /*
- * Get a partial page, lock it and return it.
+ * Get a partial slab, lock it and return it.
  */
 static void *get_partial(struct kmem_cache *s, gfp_t flags, int node,
 		struct kmem_cache_cpu *c)
-- 
1.7.9.5

