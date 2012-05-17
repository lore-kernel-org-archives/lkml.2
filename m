Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787Ab2EQPuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:50:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36951 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758773Ab2EQPuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:50:11 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 2/4] slub: change cmpxchg_double_slab in unfreeze_partials to __cmpxchg_double_slab
Date: Fri, 18 May 2012 00:47:46 +0900
Message-Id: <1337269668-4619-3-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337269668-4619-1-git-send-email-js1304@gmail.com>
References: <1337269668-4619-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unfreeze_partials() is only called with interrupt disabled,
so __cmpxchg_double_slab is suitable.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/mm/slub.c b/mm/slub.c
index d28bc45..c38efce 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1935,7 +1935,7 @@ static void unfreeze_partials(struct kmem_cache *s)
 				l = m;
 			}
 
-		} while (!cmpxchg_double_slab(s, page,
+		} while (!__cmpxchg_double_slab(s, page,
 				old.freelist, old.counters,
 				new.freelist, new.counters,
 				"unfreezing slab"));
-- 
1.7.9.5

