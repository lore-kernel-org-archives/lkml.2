Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2LEL2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:28:25 -0500
Received: from www.linutronix.de ([62.245.132.108]:47588 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab2LEL2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:28:24 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] scatterlist: add a warning if sg_virt() is used on highmem pages
Date: Wed,  5 Dec 2012 12:28:18 +0100
Message-Id: <1354706898-24515-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sg_virt() on highmem pages won't work. This WARN_ON() should catch some
that still try.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/scatterlist.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 4bd6c06..4d4adab 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -198,6 +198,9 @@ static inline dma_addr_t sg_phys(struct scatterlist *sg)
  **/
 static inline void *sg_virt(struct scatterlist *sg)
 {
+#ifdef CONFIG_DEBUG_SG
+	WARN_ON(PageHighMem(sg_page(sg)));
+#endif
 	return page_address(sg_page(sg)) + sg->offset;
 }
 
-- 
1.7.10.4

