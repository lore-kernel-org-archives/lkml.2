Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab2FTXBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:01:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63241 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab2FTXBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:01:31 -0400
From: Michel Lespinasse <walken@google.com>
To: linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] slab: do not call compound_head() in page_get_cache()
Date: Wed, 20 Jun 2012 16:01:13 -0700
Message-Id: <1340233273-10994-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

page_get_cache() does not need to call compound_head(), as its unique
caller virt_to_slab() already makes sure to return a head page.

Additionally, removing the compound_head() call makes page_get_cache()
consistent with page_get_slab().

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 mm/slab.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index e901a36..6a1aa1f 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -501,7 +501,6 @@ static inline void page_set_cache(struct page *page, struct kmem_cache *cache)
 
 static inline struct kmem_cache *page_get_cache(struct page *page)
 {
-	page = compound_head(page);
 	BUG_ON(!PageSlab(page));
 	return (struct kmem_cache *)page->lru.next;
 }
-- 
1.7.7.3

