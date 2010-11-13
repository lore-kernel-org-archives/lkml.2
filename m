Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab0KMDa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 22:30:28 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48513 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab0KMDaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 22:30:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6165"; a="61718508"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: dwalker@codeaurora.org
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 07/14] msm: iommu: Mark functions with the right section names
Date: Fri, 12 Nov 2010 19:29:53 -0800
Message-Id: <1289619000-13167-8-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
References: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark the init and exit functions as __init and __exit where
appropriate.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/devices-msm8x60-iommu.c |    4 ++--
 arch/arm/mach-msm/iommu.c                 |    2 +-
 arch/arm/mach-msm/iommu_dev.c             |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-msm/devices-msm8x60-iommu.c b/arch/arm/mach-msm/devices-msm8x60-iommu.c
index a6ecd39..f9e7bd3 100644
--- a/arch/arm/mach-msm/devices-msm8x60-iommu.c
+++ b/arch/arm/mach-msm/devices-msm8x60-iommu.c
@@ -826,7 +826,7 @@ static struct msm_iommu_ctx_dev *msm_iommu_ctx_data[] = {
 	&gfx2d1_2d1_ctx,
 };
 
-static int msm8x60_iommu_init(void)
+static int __init msm8x60_iommu_init(void)
 {
 	int ret, i;
 
@@ -886,7 +886,7 @@ failure:
 	return ret;
 }
 
-static void msm8x60_iommu_exit(void)
+static void __exit msm8x60_iommu_exit(void)
 {
 	int i;
 
diff --git a/arch/arm/mach-msm/iommu.c b/arch/arm/mach-msm/iommu.c
index f71747d..134add7 100644
--- a/arch/arm/mach-msm/iommu.c
+++ b/arch/arm/mach-msm/iommu.c
@@ -585,7 +585,7 @@ static struct iommu_ops msm_iommu_ops = {
 	.domain_has_cap = msm_iommu_domain_has_cap
 };
 
-static int msm_iommu_init(void)
+static int __init msm_iommu_init(void)
 {
 	register_iommu(&msm_iommu_ops);
 	return 0;
diff --git a/arch/arm/mach-msm/iommu_dev.c b/arch/arm/mach-msm/iommu_dev.c
index 9019cee..b83c73b 100644
--- a/arch/arm/mach-msm/iommu_dev.c
+++ b/arch/arm/mach-msm/iommu_dev.c
@@ -346,7 +346,7 @@ static struct platform_driver msm_iommu_ctx_driver = {
 	.remove		= msm_iommu_ctx_remove,
 };
 
-static int msm_iommu_driver_init(void)
+static int __init msm_iommu_driver_init(void)
 {
 	int ret;
 	ret = platform_driver_register(&msm_iommu_driver);
@@ -365,7 +365,7 @@ error:
 	return ret;
 }
 
-static void msm_iommu_driver_exit(void)
+static void __exit msm_iommu_driver_exit(void)
 {
 	platform_driver_unregister(&msm_iommu_ctx_driver);
 	platform_driver_unregister(&msm_iommu_driver);
-- 
1.7.0.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

