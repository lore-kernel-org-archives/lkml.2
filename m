Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab2EQPuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:50:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36951 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab2EQPuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:50:14 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 3/4] slub: use __SetPageSlab function to set PG_slab flag
Date: Fri, 18 May 2012 00:47:47 +0900
Message-Id: <1337269668-4619-4-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337269668-4619-1-git-send-email-js1304@gmail.com>
References: <1337269668-4619-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To set page-flag, using SetPageXXXX() and __SetPageXXXX() is more
understandable and maintainable. So change it.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/mm/slub.c b/mm/slub.c
index c38efce..69342fd 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1369,7 +1369,7 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 
 	inc_slabs_node(s, page_to_nid(page), page->objects);
 	page->slab = s;
-	page->flags |= 1 << PG_slab;
+	__SetPageSlab(page);
 
 	start = page_address(page);
 
-- 
1.7.9.5

