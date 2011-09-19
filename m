Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab1ISRyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 13:54:08 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32769 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab1ISRyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 13:54:07 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6474"; a="119669751"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] msm: platsmp: Mark ioremapped memory as __iomem
Date: Mon, 19 Sep 2011 10:54:04 -0700
Message-Id: <1316454844-32733-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.7.rc0.70.g82660
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a handful of sparse warnings.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/platsmp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index 1a1af9e..365ef3f 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -79,7 +79,7 @@ static __cpuinit void prepare_cold_cpu(unsigned int cpu)
 	ret = scm_set_boot_addr(virt_to_phys(msm_secondary_startup),
 				SCM_FLAG_COLDBOOT_CPU1);
 	if (ret == 0) {
-		void *sc1_base_ptr;
+		void __iomem *sc1_base_ptr;
 		sc1_base_ptr = ioremap_nocache(0x00902000, SZ_4K*2);
 		if (sc1_base_ptr) {
 			writel(0, sc1_base_ptr + VDD_SC1_ARRAY_CLAMP_GFS_CTL);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

