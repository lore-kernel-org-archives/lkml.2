Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab2KIMLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 07:11:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62511 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2KIMLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 07:11:17 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>
Subject: [PATCH] drm/ttm: remove unneeded preempt_disable/enable
Date: Fri,  9 Nov 2012 21:10:43 +0900
Message-Id: <1352463043-9408-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352463043-9408-1-git-send-email-akinobu.mita@gmail.com>
References: <1352463043-9408-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is unnecessary to disable preemption explicitly while calling
copy_highpage().  Because copy_highpage() will do it again through
kmap_atomic/kunmap_atomic.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: dri-devel@lists.freedesktop.org
Cc: David Airlie <airlied@linux.ie>
---
 drivers/gpu/drm/ttm/ttm_tt.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index bf82601..7d759a4 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -308,9 +308,7 @@ int ttm_tt_swapin(struct ttm_tt *ttm)
 		if (unlikely(to_page == NULL))
 			goto out_err;
 
-		preempt_disable();
 		copy_highpage(to_page, from_page);
-		preempt_enable();
 		page_cache_release(from_page);
 	}
 
@@ -358,9 +356,7 @@ int ttm_tt_swapout(struct ttm_tt *ttm, struct file *persistent_swap_storage)
 			ret = PTR_ERR(to_page);
 			goto out_err;
 		}
-		preempt_disable();
 		copy_highpage(to_page, from_page);
-		preempt_enable();
 		set_page_dirty(to_page);
 		mark_page_accessed(to_page);
 		page_cache_release(to_page);
-- 
1.7.11.7

