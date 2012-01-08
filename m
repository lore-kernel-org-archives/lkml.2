Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab2AHNeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 08:34:18 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57563 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab2AHNdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 08:33:36 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [RFC PATCH v2 7/9] drm: avoid using on_each_cpu hard coded ret value
Date: Sun,  8 Jan 2012 15:32:27 +0200
Message-Id: <1326029549-2794-8-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1326029549-2794-1-git-send-email-gilad@benyossef.com>
References: <1326029549-2794-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on_each_cpu always returns a hard coded return code of zero.

Removing all tests based on this return value saves run time
cycles for compares and code bloat for branches.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Michal Nazarewicz <mina86@mina86.com>
CC: David Airlie <airlied@linux.ie>
CC: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/drm_cache.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
index 5928653..668653c 100644
--- a/drivers/gpu/drm/drm_cache.c
+++ b/drivers/gpu/drm/drm_cache.c
@@ -75,8 +75,7 @@ drm_clflush_pages(struct page *pages[], unsigned long num_pages)
 		return;
 	}
 
-	if (on_each_cpu(drm_clflush_ipi_handler, NULL, 1) != 0)
-		printk(KERN_ERR "Timed out waiting for cache flush.\n");
+	on_each_cpu(drm_clflush_ipi_handler, NULL, 1);
 
 #elif defined(__powerpc__)
 	unsigned long i;
-- 
1.7.0.4

