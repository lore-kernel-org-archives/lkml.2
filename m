Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1FHRG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 13:06:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54890 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1FHRG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 13:06:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        airlied@redhat.com, thomas@shipmail.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] ttm: Do not increment the amount of pages in a pool by the current amount
Date: Wed,  8 Jun 2011 13:06:14 -0400
Message-Id: <1307552775-3185-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307552775-3185-1-git-send-email-konrad.wilk@oracle.com>
References: <1307552775-3185-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090209.4DEFAC2B.00F6:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.instead increment it by the count of pages that we want to
splice into the pool list.

In other words we were incrementing the pool->npages by the wrong
amount. This bug was observed from code inspection.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/ttm/ttm_page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index d948575..002b414 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -602,7 +602,7 @@ static void ttm_page_pool_fill_locked(struct ttm_page_pool *pool,
 			printk(KERN_ERR TTM_PFX
 			       "Failed to fill pool (%p).", pool);
 			/* If we have any pages left put them to the pool. */
-			list_for_each_entry(p, &pool->list, lru) {
+			list_for_each_entry(p, &new_pages, lru) {
 				++cpages;
 			}
 			list_splice(&new_pages, &pool->list);
-- 
1.7.4.1

