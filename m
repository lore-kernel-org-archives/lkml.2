Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab2JEMqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 08:46:23 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41949 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab2JEMqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 08:46:22 -0400
From: Huacai Chen <chenhc@lemote.com>
To: Alex Deucher <alexander.deucher@amd.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>,
        Huacai Chen <chenhc@lemote.com>, Hongliang Tao <taohl@lemote.com>,
        Hua Yan <yanh@lemote.com>
Subject: =?UTF-8?q?=5BPATCH=20V3=5D=20drm/radeon=3A=20Include=20swiotlb=2Eh=20if=20SWIOTLB=20configured?=
Date: Fri,  5 Oct 2012 20:45:56 +0800
Message-Id: <1349441156-30936-1-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

V3:
1, Send to Alex Deucher since this is radeon specific;
2, Add Reviewed-by email addresses.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Hongliang Tao <taohl@lemote.com>
Signed-off-by: Hua Yan <yanh@lemote.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
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

