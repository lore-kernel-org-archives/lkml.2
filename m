Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab1J1Rcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:32:47 -0400
Received: from home.keithp.com ([63.227.221.253]:38170 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab1J1Rcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:32:46 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>,
        Ben Widawsky <ben@bwidawsk.net>
Subject: [PATCH] agp: iommu_gfx_mapped only available if CONFIG_INTEL_IOMMU is set
Date: Fri, 28 Oct 2011 10:32:34 -0700
Message-Id: <1319823154-26431-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernels with no iommu support cannot ever need the Ironlake
work-around, so never enable it in that case.

Might be better to completely remove the work-around from the kernel
in this case?

Signed-off-by: Keith Packard <keithp@keithp.com>
Cc: Ben Widawsky <ben@bwidawsk.net>
---
 drivers/char/agp/intel-gtt.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 3a8d448..222190f 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -1183,6 +1183,7 @@ static void gen6_cleanup(void)
 {
 }
 
+#ifdef CONFIG_INTEL_IOMMU
 /* Certain Gen5 chipsets require require idling the GPU before
  * unmapping anything from the GTT when VT-d is enabled.
  */
@@ -1201,6 +1202,7 @@ static inline int needs_idle_maps(void)
 
 	return 0;
 }
+#endif
 
 static int i9xx_setup(void)
 {
@@ -1236,8 +1238,10 @@ static int i9xx_setup(void)
 		intel_private.gtt_bus_addr = reg_addr + gtt_offset;
 	}
 
+#ifdef CONFIG_INTEL_IOMMU
 	if (needs_idle_maps())
 		intel_private.base.do_idle_maps = 1;
+#endif
 
 	intel_i9xx_setup_flush();
 
-- 
1.7.7

