Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230Ab2FHRZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 13:25:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55766 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab2FHRY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 13:24:59 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 1/4] slub: change declare of get_slab() to inline at all times
Date: Sat,  9 Jun 2012 02:23:14 +0900
Message-Id: <1339176197-13270-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <yes>
References: <yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__kmalloc and it's variants are invoked much frequently
and these are performance critical functions,
so their callee functions are declared '__always_inline'
But, currently, get_slab() isn't declared '__always_inline'.
In result, __kmalloc and it's variants call get_slab() on x86.
It is not desirable result, so change it to inline at all times.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/mm/slub.c b/mm/slub.c
index 71de9b5..30ceb6d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3320,7 +3320,7 @@ static inline int size_index_elem(size_t bytes)
 	return (bytes - 1) / 8;
 }
 
-static struct kmem_cache *get_slab(size_t size, gfp_t flags)
+static __always_inline struct kmem_cache *get_slab(size_t size, gfp_t flags)
 {
 	int index;
 
-- 
1.7.9.5

