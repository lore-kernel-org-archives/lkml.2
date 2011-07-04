Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab1GDCOp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 22:14:45 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:35555 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab1GDCO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 22:14:27 -0400
From: KyongHo Cho <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Joerg Roedel <joro@8bytes.org>, Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Kwanghyun La <nala.la@samsung.com>, Ilho Lee <ilho215.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        KyongHo Cho <pullip.cho@samsung.com>
Subject: [PATCH 2/6] ARM: EXYNOS4: SYSMMU: Enable clock gating for System MMU of SSS
Date: Mon,  4 Jul 2011 10:41:43 +0900
Message-Id: <1309743708-1505-3-git-send-email-pullip.cho@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1309743708-1505-1-git-send-email-pullip.cho@samsung.com>
References: <1309743708-1505-1-git-send-email-pullip.cho@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clock gating of SYSMMU_SSS that was missing is added.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 arch/arm/mach-exynos4/clock.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos4/clock.c b/arch/arm/mach-exynos4/clock.c
index 256b46b..ecbe87b 100644
--- a/arch/arm/mach-exynos4/clock.c
+++ b/arch/arm/mach-exynos4/clock.c
@@ -154,6 +154,11 @@ static int exynos4_clk_audss_ctrl(struct clk *clk, int enable)
 	return s5p_gatectrl(S5P_CLKGATE_AUDSS, clk, enable);
 }
 
+static int exynos4_clk_ip_dmc_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(S5P_CLKGATE_IP_DMC, clk, enable);
+}
+
 /* Core list of CMU_CPU side */
 
 static struct clksrc_clk clk_mout_apll = {
@@ -622,6 +627,10 @@ static struct clk init_clocks_off[] = {
 		.enable		= exynos4_clk_ip_peril_ctrl,
 		.ctrlbit	= (1 << 13),
 	}, {
+		.name		= "SYSMMU_SSS",
+		.enable		= exynos4_clk_ip_dmc_ctrl,
+		.ctrlbit	= (1 << 12),
+	}, {
 		.name		= "SYSMMU_FIMC0",
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 7),
-- 
1.7.1

