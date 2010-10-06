Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985Ab0JFOBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 10:01:01 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:45738 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758964Ab0JFOBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 10:01:00 -0400
From: Pekka Enberg <penberg@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>
Subject: [PATCH] SLUB: Fix memory hotplug with !NUMA
Date: Wed,  6 Oct 2010 17:00:57 +0300
Message-Id: <1286373657-3894-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build breakage when memory hotplug is enabled on
UMA configurations:

  /home/test/linux-2.6/mm/slub.c: In function 'kmem_cache_init':
  /home/test/linux-2.6/mm/slub.c:3031:2: error: 'slab_memory_callback'
  undeclared (first use in this function)
  /home/test/linux-2.6/mm/slub.c:3031:2: note: each undeclared
  identifier is reported only once for each function it appears in
  make[2]: *** [mm/slub.o] Error 1
  make[1]: *** [mm] Error 2
  make: *** [sub-make] Error 2

Reported-by: Zimny Lech <napohybelskurwysynom2010@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 mm/slub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index fe536d3..8fd5401 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2851,7 +2851,7 @@ int kmem_cache_shrink(struct kmem_cache *s)
 }
 EXPORT_SYMBOL(kmem_cache_shrink);
 
-#if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
+#if defined(CONFIG_MEMORY_HOTPLUG)
 static int slab_mem_going_offline_callback(void *arg)
 {
 	struct kmem_cache *s;
-- 
1.6.3.3

