Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab0KMDae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 22:30:34 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28676 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab0KMDaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 22:30:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6165"; a="61810877"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: dwalker@codeaurora.org
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 06/14] msm: iommu: Support for the 2nd GFX core's IOMMU
Date: Fri, 12 Nov 2010 19:29:52 -0800
Message-Id: <1289619000-13167-7-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
References: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the platform data and resources needed for the second
2D graphics core's IOMMU.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/devices-msm8x60-iommu.c |   54 +++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/devices-msm8x60-iommu.c b/arch/arm/mach-msm/devices-msm8x60-iommu.c
index 8cccb26..a6ecd39 100644
--- a/arch/arm/mach-msm/devices-msm8x60-iommu.c
+++ b/arch/arm/mach-msm/devices-msm8x60-iommu.c
@@ -254,6 +254,27 @@ static struct resource msm_iommu_gfx2d0_resources[] = {
 	},
 };
 
+static struct resource msm_iommu_gfx2d1_resources[] = {
+	{
+		.start = MSM_IOMMU_GFX2D1_PHYS,
+		.end   = MSM_IOMMU_GFX2D1_PHYS + MSM_IOMMU_GFX2D1_SIZE - 1,
+		.name  = "physbase",
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.name = "nonsecure_irq",
+		.start = SMMU_GFX2D1_CB_SC_NON_SECURE_IRQ,
+		.end   = SMMU_GFX2D1_CB_SC_NON_SECURE_IRQ,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "secure_irq",
+		.start = SMMU_GFX2D1_CB_SC_SECURE_IRQ,
+		.end   = SMMU_GFX2D1_CB_SC_SECURE_IRQ,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
 static struct platform_device msm_root_iommu_dev = {
 	.name = "msm_iommu",
 	.id = -1,
@@ -307,6 +328,11 @@ static struct msm_iommu_dev gfx2d0_iommu = {
 	.clk_rate = 27000000
 };
 
+static struct msm_iommu_dev gfx2d1_iommu = {
+	.name = "gfx2d1",
+	.clk_rate = 27000000
+};
+
 static struct platform_device msm_device_iommu_jpegd = {
 	.name = "msm_iommu",
 	.id = 0,
@@ -417,6 +443,16 @@ static struct platform_device msm_device_iommu_gfx2d0 = {
 	.resource = msm_iommu_gfx2d0_resources,
 };
 
+struct platform_device msm_device_iommu_gfx2d1 = {
+	.name = "msm_iommu",
+	.id = 11,
+	.dev = {
+		.parent = &msm_root_iommu_dev.dev,
+	},
+	.num_resources = ARRAY_SIZE(msm_iommu_gfx2d1_resources),
+	.resource = msm_iommu_gfx2d1_resources,
+};
+
 static struct msm_iommu_ctx_dev jpegd_src_ctx = {
 	.name = "jpegd_src",
 	.num = 0,
@@ -538,6 +574,12 @@ static struct msm_iommu_ctx_dev gfx2d0_2d0_ctx = {
 	.mids = {0, 1, 2, 3, 4, 5, 6, 7, -1}
 };
 
+static struct msm_iommu_ctx_dev gfx2d1_2d1_ctx = {
+	.name = "gfx2d1_2d1",
+	.num = 0,
+	.mids = {0, 1, 2, 3, 4, 5, 6, 7, -1}
+};
+
 static struct platform_device msm_device_jpegd_src_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 0,
@@ -698,6 +740,14 @@ static struct platform_device msm_device_gfx2d0_2d0_ctx = {
 	},
 };
 
+static struct platform_device msm_device_gfx2d1_2d1_ctx = {
+	.name = "msm_iommu_ctx",
+	.id = 20,
+	.dev = {
+		.parent = &msm_device_iommu_gfx2d1.dev,
+	},
+};
+
 static struct platform_device *msm_iommu_devs[] = {
 	&msm_device_iommu_jpegd,
 	&msm_device_iommu_vpe,
@@ -710,6 +760,7 @@ static struct platform_device *msm_iommu_devs[] = {
 	&msm_device_iommu_vcodec_b,
 	&msm_device_iommu_gfx3d,
 	&msm_device_iommu_gfx2d0,
+	&msm_device_iommu_gfx2d1,
 };
 
 static struct msm_iommu_dev *msm_iommu_data[] = {
@@ -724,6 +775,7 @@ static struct msm_iommu_dev *msm_iommu_data[] = {
 	&vcodec_b_iommu,
 	&gfx3d_iommu,
 	&gfx2d0_iommu,
+	&gfx2d1_iommu,
 };
 
 static struct platform_device *msm_iommu_ctx_devs[] = {
@@ -747,6 +799,7 @@ static struct platform_device *msm_iommu_ctx_devs[] = {
 	&msm_device_gfx3d_user_ctx,
 	&msm_device_gfx3d_priv_ctx,
 	&msm_device_gfx2d0_2d0_ctx,
+	&msm_device_gfx2d1_2d1_ctx,
 };
 
 static struct msm_iommu_ctx_dev *msm_iommu_ctx_data[] = {
@@ -770,6 +823,7 @@ static struct msm_iommu_ctx_dev *msm_iommu_ctx_data[] = {
 	&gfx3d_user_ctx,
 	&gfx3d_priv_ctx,
 	&gfx2d0_2d0_ctx,
+	&gfx2d1_2d1_ctx,
 };
 
 static int msm8x60_iommu_init(void)
-- 
1.7.0.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

