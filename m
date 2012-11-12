Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab2KLQeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:34:21 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47759 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab2KLQeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:34:19 -0500
From: Joonsoo Kim <js1304@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 1/4] bootmem: remove not implemented function call, bootmem_arch_preferred_node()
Date: Tue, 13 Nov 2012 01:31:52 +0900
Message-Id: <1352737915-30906-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no implementation of bootmeme_arch_preferred_node() and
call for this function will makes compile-error.
So, remove it.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 434be4a..6f62c03e 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -589,19 +589,6 @@ static void * __init alloc_arch_preferred_bootmem(bootmem_data_t *bdata,
 {
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc(size, GFP_NOWAIT);
-
-#ifdef CONFIG_HAVE_ARCH_BOOTMEM
-	{
-		bootmem_data_t *p_bdata;
-
-		p_bdata = bootmem_arch_preferred_node(bdata, size, align,
-							goal, limit);
-		if (p_bdata)
-			return alloc_bootmem_bdata(p_bdata, size, align,
-							goal, limit);
-	}
-#endif
-	return NULL;
 }
 
 static void * __init alloc_bootmem_core(unsigned long size,
-- 
1.7.9.5

