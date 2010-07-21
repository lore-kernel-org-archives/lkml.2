Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab0GURPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:15:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:30066 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab0GURPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:15:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,239,1278313200"; 
   d="scan'208";a="588367610"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ben Hutchings" <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, "Geert Stappers" <stappers@stappers.nl>,
        "Dave Airlie" <airlied@redhat.com>
Subject: [PATCH] Fix ttm_page_alloc.c build breakage
Date: Wed, 21 Jul 2010 10:15:39 -0700
Message-Id: <4c472b3b227169b7c1@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 1e8655f87333def92bb8215b423adc65403b08a5
    drm/ttm: Fix build on architectures without AGP

looks at TTM_HAS_AGP before it has been set in ttm_bo_driver.h
    
Move the conditional inclusion of <asm/agp.h> *after* we have included
ttm_bo_driver.h

Signed-of-by: Tony Luck <tony.luck@intel.com>

---

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index 1f32b46..f394b3b 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -40,13 +40,13 @@
 #include <linux/slab.h>
 
 #include <asm/atomic.h>
-#ifdef TTM_HAS_AGP
-#include <asm/agp.h>
-#endif
 
 #include "ttm/ttm_bo_driver.h"
 #include "ttm/ttm_page_alloc.h"
 
+#ifdef TTM_HAS_AGP
+#include <asm/agp.h>
+#endif
 
 #define NUM_PAGES_TO_ALLOC		(PAGE_SIZE/sizeof(struct page *))
 #define SMALL_ALLOCATION		16
