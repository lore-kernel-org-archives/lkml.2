Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab0KTDCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 22:02:46 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57047 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001Ab0KTDCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 22:02:43 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6172"; a="63633398"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: dwalker@codeaurora.org
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 1/3] msm: iommu: Add bus clocks to platform data
Date: Fri, 19 Nov 2010 19:02:32 -0800
Message-Id: <1290222154-11096-2-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1290222154-11096-1-git-send-email-stepanm@codeaurora.org>
References: <1290222154-11096-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the IOMMU bus clock and the IOMMU bus interconnect
clocks to the platform data for an IOMMU device. These
clocks are needed to access the IOMMU registers.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
Please hold off on this until the clock driver is in.
 arch/arm/mach-msm/include/mach/iommu.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/iommu.h b/arch/arm/mach-msm/include/mach/iommu.h
index 296c0f1..62f6699 100644
--- a/arch/arm/mach-msm/include/mach/iommu.h
+++ b/arch/arm/mach-msm/include/mach/iommu.h
@@ -19,6 +19,7 @@
 #define MSM_IOMMU_H

 #include <linux/interrupt.h>
+#include <linux/clk.h>

 /* Sharability attributes of MSM IOMMU mappings */
 #define MSM_IOMMU_ATTR_NON_SH		0x0
@@ -74,13 +75,17 @@ struct msm_iommu_ctx_dev {
  * struct msm_iommu_drvdata - A single IOMMU hardware instance
  * @base:	IOMMU config port base address (VA)
  * @irq:	Interrupt number
-  *
+ * @clk:	The bus clock for this IOMMU hardware instance
+ * @pclk:	The clock for the IOMMU bus interconnect
+ *
  * A msm_iommu_drvdata holds the global driver data about a single piece
  * of an IOMMU hardware instance.
  */
 struct msm_iommu_drvdata {
 	void __iomem *base;
 	int irq;
+	struct clk *clk;
+	struct clk *pclk;
 };

 /**
--
1.7.0.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

