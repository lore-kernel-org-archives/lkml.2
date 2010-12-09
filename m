Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab0LIUEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:04:14 -0500
Received: from mail.perches.com ([173.55.12.10]:2391 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757017Ab0LIUEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:04:12 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Kosina <trivial@kernel.org>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 01/15] drm: Remove duplicate unlikely from IS_ERR
Date: Thu,  9 Dec 2010 12:03:54 -0800
Message-Id: <0a4b327b21bdb6fed75c24cde8d51fef9ed2c031.1291923889.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.464.gf80b6
In-Reply-To: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
References: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
In-Reply-To: <cover.1291923888.git.joe@perches.com>
References: <cover.1291923888.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IS_ERR already uses unlikely, remove unlikely from the call sites.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/ttm/ttm_tt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index af789dc..fb83a90 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -538,7 +538,7 @@ int ttm_tt_swapout(struct ttm_tt *ttm, struct file *persistant_swap_storage)
 		swap_storage = shmem_file_setup("ttm swap",
 						ttm->num_pages << PAGE_SHIFT,
 						0);
-		if (unlikely(IS_ERR(swap_storage))) {
+		if (IS_ERR(swap_storage)) {
 			printk(KERN_ERR "Failed allocating swap storage.\n");
 			return PTR_ERR(swap_storage);
 		}
@@ -552,7 +552,7 @@ int ttm_tt_swapout(struct ttm_tt *ttm, struct file *persistant_swap_storage)
 		if (unlikely(from_page == NULL))
 			continue;
 		to_page = read_mapping_page(swap_space, i, NULL);
-		if (unlikely(IS_ERR(to_page))) {
+		if (IS_ERR(to_page)) {
 			ret = PTR_ERR(to_page);
 			goto out_err;
 		}
-- 
1.7.3.3.464.gf80b6

