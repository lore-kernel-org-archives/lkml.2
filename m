Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab1KKNsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 08:48:45 -0500
Received: from mail-va3.bigfish.com ([216.32.180.10]:32844 "EHLO
	VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752524Ab1KKNsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 08:48:43 -0500
X-SpamScore: -10
X-BigFish: VPS-10(zzzz1202hzz15d4R8275bhz2dh668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LUI110-02-65W-02
X-M-MSG: 
Date: Fri, 11 Nov 2011 14:48:32 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Airlie <airlied@linux.ie>, David Woodhouse <dwmw2@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>
Subject: [PATCH] iommu/intel: Fix build failure with intel-gtt and
 !intel-iommu
Message-ID: <20111111134832.GI13213@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this is fixed already. I stumbled over it while
compile-testing merges in the IOMMU tree.

>From 7d8438f41b3cfbb1094030d7cf5d06da0fd16308 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Fri, 11 Nov 2011 14:42:53 +0100
Subject: [PATCH] iommu/intel: Fix build failure with intel-gtt and !intel-iommu

With v3.2-rc1 the following build error occurs when Intel
IOMMU is off and Intel-GTT is on:

ERROR: "intel_iommu_gfx_mapped" [drivers/char/agp/intel-gtt.ko] undefined!

This patch fixes that.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/char/agp/intel-gtt.c |    2 +-
 include/linux/intel-iommu.h  |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 66cd0b8..bfe5133 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -22,6 +22,7 @@
 #include <linux/pagemap.h>
 #include <linux/agp_backend.h>
 #include <linux/delay.h>
+#include <linux/intel-iommu.h>
 #include <asm/smp.h>
 #include "agp.h"
 #include "intel-agp.h"
@@ -1186,7 +1187,6 @@ static void gen6_cleanup(void)
 /* Certain Gen5 chipsets require require idling the GPU before
  * unmapping anything from the GTT when VT-d is enabled.
  */
-extern int intel_iommu_gfx_mapped;
 static inline int needs_idle_maps(void)
 {
 	const unsigned short gpu_devid = intel_private.pcidev->device;
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index e6ca56d..651cc08 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -363,4 +363,10 @@ extern int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
 extern int dmar_ir_support(void);
 
+#ifdef CONFIG_INTEL_IOMMU
+extern int intel_iommu_gfx_mapped;
+#else
+#define intel_iommu_gfx_mapped	1
+#endif /* CONFIG_INTEL_IOMMU */
+
 #endif
-- 
1.7.5.4


-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

