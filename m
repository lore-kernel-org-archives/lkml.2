Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161462Ab2JXWLB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:11:01 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64288 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161226Ab2JXWJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:09:42 -0400
From: Omar Ramirez Luna <omar.ramirez@copitl.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Victor Manuel Jaquez Leal <vjaquez@igalia.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@copitl.com>
Subject: [PATCH 3/6] staging: tidspbridge: change type to __iomem for per and core addresses
Date: Wed, 24 Oct 2012 17:09:17 -0500
Message-Id: <1351116560-6918-4-git-send-email-omar.ramirez@copitl.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351116560-6918-1-git-send-email-omar.ramirez@copitl.com>
References: <1351116560-6918-1-git-send-email-omar.ramirez@copitl.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently per_pm_base and core_pm_base are declared as u32, however
_raw_* changed the data type, since:

195bbca ARM: 7500/1: io: avoid writeback addressing modes for __raw_ accessors

This should fix warnings for per and core accesses:

warning: passing argument 2 of '__raw_writel' makes pointer from integer without a cast
../io.h:88: note: expected 'volatile void *' but argument is of type 'u32'

Signed-off-by: Omar Ramirez Luna <omar.ramirez@copitl.com>
---

Intended for 3.7 due to code changes during rc1.

 .../tidspbridge/include/dspbridge/cfgdefs.h        |    4 ++--
 drivers/staging/tidspbridge/rmgr/drv.c             |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h b/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
index 60a2781..b32c756 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
@@ -53,8 +53,8 @@ struct cfg_hostres {
 	u32 chnl_buf_size;
 	u32 num_chnls;
 	void __iomem *per_base;
-	u32 per_pm_base;
-	u32 core_pm_base;
+	void __iomem *per_pm_base;
+	void __iomem *core_pm_base;
 	void __iomem *dmmu_base;
 };
 
diff --git a/drivers/staging/tidspbridge/rmgr/drv.c b/drivers/staging/tidspbridge/rmgr/drv.c
index 6795205..db1da28 100644
--- a/drivers/staging/tidspbridge/rmgr/drv.c
+++ b/drivers/staging/tidspbridge/rmgr/drv.c
@@ -667,10 +667,10 @@ int drv_request_bridge_res_dsp(void **phost_resources)
 							 OMAP_DSP_MEM3_SIZE);
 		host_res->per_base = ioremap(OMAP_PER_CM_BASE,
 						OMAP_PER_CM_SIZE);
-		host_res->per_pm_base = (u32) ioremap(OMAP_PER_PRM_BASE,
-							 OMAP_PER_PRM_SIZE);
-		host_res->core_pm_base = (u32) ioremap(OMAP_CORE_PRM_BASE,
-							  OMAP_CORE_PRM_SIZE);
+		host_res->per_pm_base = ioremap(OMAP_PER_PRM_BASE,
+						OMAP_PER_PRM_SIZE);
+		host_res->core_pm_base = ioremap(OMAP_CORE_PRM_BASE,
+							OMAP_CORE_PRM_SIZE);
 		host_res->dmmu_base = ioremap(OMAP_DMMU_BASE,
 						 OMAP_DMMU_SIZE);
 
-- 
1.7.9.5

