Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2DYOxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:53:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54257 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab2DYOxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:53:01 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH] slub: fix incorrect return type of get_any_partial()
Date: Fri, 27 Jan 2012 00:12:23 -0800
Message-Id: <1327651943-28225-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 497b66f2ecc97844493e6a147fd5a7e73f73f408 ('slub: return object pointer
from get_partial() / new_slab().') changed return type of some functions.
This updates missing part.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/mm/slub.c b/mm/slub.c
index ffe13fd..18bf13e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1579,7 +1579,7 @@ static void *get_partial_node(struct kmem_cache *s,
 /*
  * Get a page from somewhere. Search in increasing NUMA distances.
  */
-static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags,
+static void *get_any_partial(struct kmem_cache *s, gfp_t flags,
 		struct kmem_cache_cpu *c)
 {
 #ifdef CONFIG_NUMA
-- 
1.7.0.4

