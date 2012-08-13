Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab2HMMlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 08:41:12 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37981 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab2HMMlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 08:41:11 -0400
From: Huacai Chen <chenhc@lemote.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>,
        Alex Deucher <alexdeucher@gmail.com>, Huacai Chen <chenhc@lemote.com>,
        Hongliang Tao <taohl@lemote.com>, Hua Yan <yanh@lemote.com>
Subject: [PATCH V2] drm/radeon: Include swiotlb.h if SWIOTLB configured.
Date: Mon, 13 Aug 2012 20:40:53 +0800
Message-Id: <1344861653-27261-1-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When SWIOTLB is configured, if without this patch kernel compilation
fails with such error messages:

drivers/gpu/drm/radeon/radeon_ttm.c: In function 'radeon_ttm_tt_populate':
drivers/gpu/drm/radeon/radeon_ttm.c:606:2: error: implicit declaration of function 'swiotlb_nr_tbl'
drivers/gpu/drm/radeon/radeon_ttm.c:607:3: warning: passing argument 2 of 'ttm_dma_populate' from incompatible pointer type
include/drm/ttm/ttm_page_alloc.h:81:12: note: expected 'struct device *' but argument is of type 'struct device *'
drivers/gpu/drm/radeon/radeon_ttm.c: In function 'radeon_ttm_tt_unpopulate':
drivers/gpu/drm/radeon/radeon_ttm.c:653:3: warning: passing argument 2 of 'ttm_dma_unpopulate' from incompatible pointer type
include/drm/ttm/ttm_page_alloc.h:82:13: note: expected 'struct device *' but argument is of type 'struct device *'

V2:
1, Add compilation error messages;
2, Make the From: address the same as Signed-off-by address.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Hongliang Tao <taohl@lemote.com>
Signed-off-by: Hua Yan <yanh@lemote.com>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/radeon/radeon_ttm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 5b71c71..fc3ac22 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -41,6 +41,10 @@
 #include "radeon_reg.h"
 #include "radeon.h"
 
+#ifdef CONFIG_SWIOTLB
+#include <linux/swiotlb.h>
+#endif
+
 #define DRM_FILE_PAGE_OFFSET (0x100000000ULL >> PAGE_SHIFT)
 
 static int radeon_ttm_debugfs_init(struct radeon_device *rdev);
-- 
1.7.7.3

