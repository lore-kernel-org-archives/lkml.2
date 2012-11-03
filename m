Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab2KCLDm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 07:03:42 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:62865
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875Ab2KCK6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 06:58:47 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344204000"; 
   d="scan'208";a="161245662"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: David Airlie <airlied@linux.ie>
Cc: kernel-janitors@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/16] drivers/gpu/drm/drm_cache.c: use WARN_ONCE
Date: Sat,  3 Nov 2012 11:58:22 +0100
Message-Id: <1351940317-14812-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use WARN_ONCE rather than printk followed by WARN_ON_ONCE(1), for conciseness.

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression list es;
@@

-printk(
+WARN_ONCE(1,
  es);
-WARN_ON_ONCE(1);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/gpu/drm/drm_cache.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
index a575cb2..8df9a7b 100644
--- a/drivers/gpu/drm/drm_cache.c
+++ b/drivers/gpu/drm/drm_cache.c
@@ -94,8 +94,7 @@ drm_clflush_pages(struct page *pages[], unsigned long num_pages)
 		kunmap_atomic(page_virtual);
 	}
 #else
-	printk(KERN_ERR "Architecture has no drm_cache.c support\n");
-	WARN_ON_ONCE(1);
+	WARN_ONCE(1, KERN_ERR "Architecture has no drm_cache.c support\n");
 #endif
 }
 EXPORT_SYMBOL(drm_clflush_pages);
@@ -119,8 +118,7 @@ drm_clflush_sg(struct sg_table *st)
 	if (on_each_cpu(drm_clflush_ipi_handler, NULL, 1) != 0)
 		printk(KERN_ERR "Timed out waiting for cache flush.\n");
 #else
-	printk(KERN_ERR "Architecture has no drm_cache.c support\n");
-	WARN_ON_ONCE(1);
+	WARN_ONCE(1, KERN_ERR "Architecture has no drm_cache.c support\n");
 #endif
 }
 EXPORT_SYMBOL(drm_clflush_sg);
@@ -142,8 +140,7 @@ drm_clflush_virt_range(char *addr, unsigned long length)
 	if (on_each_cpu(drm_clflush_ipi_handler, NULL, 1) != 0)
 		printk(KERN_ERR "Timed out waiting for cache flush.\n");
 #else
-	printk(KERN_ERR "Architecture has no drm_cache.c support\n");
-	WARN_ON_ONCE(1);
+	WARN_ONCE(1, KERN_ERR "Architecture has no drm_cache.c support\n");
 #endif
 }
 EXPORT_SYMBOL(drm_clflush_virt_range);

