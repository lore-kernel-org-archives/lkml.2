Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154Ab2EJPeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:34:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53568 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757029Ab2EJPeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:34:13 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH] slub: fix a possible memory leak
Date: Fri, 11 May 2012 00:32:59 +0900
Message-Id: <1336663979-2611-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory allocated by kstrdup should be freed,
when kmalloc(kmem_size, GFP_KERNEL) is failed.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/mm/slub.c b/mm/slub.c
index 23d66aa..9c920a0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3968,9 +3968,9 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 			}
 			return s;
 		}
-		kfree(n);
 		kfree(s);
 	}
+	kfree(n);
 err:
 	up_write(&slub_lock);
 
-- 
1.7.9.5

