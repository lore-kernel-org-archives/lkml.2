Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab0GUQlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 12:41:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:14274 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab0GUQk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 12:40:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,239,1278313200"; 
   d="scan'208";a="537544612"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ben Hutchings" <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, "Geert Stappers" <stappers@stappers.nl>,
        "Dave Airlie" <airlied@redhat.com>
Subject: [git pull] ia64 changes
Date: Wed, 21 Jul 2010 09:40:57 -0700
Message-Id: <4c47231922590620a5@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit hit Linus upstream today and broke the ia64 build:

commit 1e8655f87333def92bb8215b423adc65403b08a5
Author: Ben Hutchings <ben@decadent.org.uk>
Date:   Sun Jul 18 21:51:42 2010 +0100

    drm/ttm: Fix build on architectures without AGP
    
    Make inclusion of <asm/agp.h> conditional on TTM_HAS_AGP.  The use
    of the functions declared in it is already conditional.
    
    Reported-by: Geert Stappers <stappers@stappers.nl>
    Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
    Tested-by: Geert Stappers <stappers@stappers.nl>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index b1d67dc..1f32b46 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -40,7 +40,9 @@
 #include <linux/slab.h>
 
 #include <asm/atomic.h>
+#ifdef TTM_HAS_AGP
 #include <asm/agp.h>
+#endif
 
 #include "ttm/ttm_bo_driver.h"
 #include "ttm/ttm_page_alloc.h"


The problem is that TTM_HAS_AGP is defined in "ttm/ttm_bo_driver.h" ... which
is included *after* you used it to test whether to include <asm/agp.h>

I suspect some re-arrangement is in order :-)

-Tony
