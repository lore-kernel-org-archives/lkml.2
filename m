Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2KVTn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:43:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10375 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab2KVTnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:43:23 -0500
X-AuditID: cbfee61b-b7f616d00000319b-f0-50ae0d4ecdf4
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 01/12] ARM: EXYNOS: Add clk_ops for gating clocks of System
 MMU
Date: Thu, 22 Nov 2012 20:32:30 +0900
Message-id: <002201cdc8a5$0e9fb8c0$2bdf2a40$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3IpQ5zVIVC2V4yTPGz75JnGFmJVA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsVy+t8zY10/3nUBBvdmq1pc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX8vLaRseCtbMWLD7ENjBvEuxg5OSQETCT+3P7JAmGL
	SVy4t56ti5GLQ0hgGaPEry2bWGGKnk5ZzwqRWMQo8enfJCjnH6PEpKvXmEGq2AS0JFbPPc4I
	khAR6GWUuND/lQkkISwQIvGmYTqYzSKgKvFz0wGwsbwCthJz1qxhgbAFJX5MvgdmMwMNWr/z
	OBOELS+xec1boAUcQGeoSzz6qwsSFhHQk7i2oxOqRERi34t3jBDjBSS+TT7EAlEuK7HpADPE
	A83sElt3h0LYkhIHV9xgmcAoOgvJ4llIFs9CsngWkg0LGFlWMYqmFiQXFCel5xrpFSfmFpfm
	pesl5+duYoTEhvQOxlUNFocYBTgYlXh4MwzWBgixJpYVV+YeYpTgYFYS4b3HvS5AiDclsbIq
	tSg/vqg0J7X4EKMP0OETmaVEk/OBcZtXEm9obGxiZmJqYm5pam6KQ1hJnLfZIyVASCA9sSQ1
	OzW1ILUIZhwTB6dUA2P6lqfdAS11y9utPFu3nUjgtmZ8lifCEOjpF3q/zWGaVh/LvDMG59+c
	mizOcjVyarEDz+dlvAu6z0xLOjBxznJN0TtLQ/rClWdMV5Nh4Qo9G7Hu7J52LbH2gDq+Dw71
	pvNbnaWaL/S8T/tadplpWfltt0T516ddns36q+3dlMJtelzaoCGkSImlOCPRUIu5qDgRANq3
	imW6AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t9jAV0/3nUBBr2HFS0u75rDZjHj/D4m
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzfl7byFjwVrbi
	xYfYBsYN4l2MnBwSAiYST6esZ4WwxSQu3FvP1sXIxSEksIhR4tO/SawQzj9GiUlXrzGDVLEJ
	aEmsnnucESQhItDLKHGh/ysTSEJYIETiTcN0MJtFQFXi56YDYGN5BWwl5qxZwwJhC0r8mHwP
	zGYGGrR+53EmCFteYvOat0ALOIDOUJd49FcXJCwioCdxbUcnVImIxL4X7xgnMPLPQjJpFpJJ
	s5BMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Nh7Jr2DcVWDxSFGAQ5GJR7e
	DIO1AUKsiWXFlbmHGCU4mJVEeO9xrwsQ4k1JrKxKLcqPLyrNSS0+xOgD9OhEZinR5HxgWsgr
	iTc0NjEzsjQyszAyMTfHIawkztvskRIgJJCeWJKanZpakFoEM46Jg1OqgVHr0cbFxdHXme2O
	zzVaEKiovSDGqfXO0rQpQqxPpVKeynzenXzs89qTTD/ao67ee1qZd9duyrL4mk3iq5r7Hhuk
	yVvOf8Gc88B52a+lpn9TS/fpTb53l+/D3vsOz2PXfL2k8zz+fs278woPsi21Js/ttbN2WL1Q
	7oXMCl/rO+KmxSb6zXJXbwQrsRRnJBpqMRcVJwIAosC0G+oCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Touching some System MMU needs its master devices' clock to be enabled
before. This commit adds clk_ops.set_parent of gating clocks of System
MMU to ensure gating clocks of System MMU's mater devices are enabled
when enabling gating clocks of System MMU.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 arch/arm/mach-exynos/clock-exynos5.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/mach-exynos/clock-exynos5.c b/arch/arm/mach-exynos/clock-exynos5.c
index e48d7c2..a86e88e 100644
--- a/arch/arm/mach-exynos/clock-exynos5.c
+++ b/arch/arm/mach-exynos/clock-exynos5.c
@@ -614,6 +614,16 @@ static struct clksrc_clk exynos5_clk_aclk_300_gscl = {
 	.reg_src = { .reg = EXYNOS5_CLKSRC_TOP3, .shift = 10, .size = 1 },
 };
 
+static int exynos5_gate_clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	clk->parent = parent;
+	return 0;
+}
+
+static struct clk_ops exynos5_gate_clk_ops = {
+	.set_parent = exynos5_gate_clk_set_parent
+};
+
 static struct clk exynos5_init_clocks_off[] = {
 	{
 		.name		= "timers",
@@ -855,71 +865,85 @@ static struct clk exynos5_init_clocks_off[] = {
 		.name		= SYSMMU_CLOCK_NAME,
 		.devname	= SYSMMU_CLOCK_DEVNAME(mfc_l, 0),
 		.enable		= &exynos5_clk_ip_mfc_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 1),
 	}, {
 		.name		= SYSMMU_CLOCK_NAME,
 		.devname	= SYSMMU_CLOCK_DEVNAME(mfc_r, 1),
 		.enable		= &exynos5_clk_ip_mfc_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 2),
 	}, {
 		.name		= SYSMMU_CLOCK_NAME,
 		.devname	= SYSMMU_CLOCK_DEVNAME(tv, 2),
 		.enable		= &exynos5_clk_ip_disp1_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 9)
 	}, {
 		.name		= SYSMMU_CLOCK_NAME,
 		.devname	= SYSMMU_CLOCK_DEVNAME(jpeg, 3),
 		.enable		= &exynos5_clk_ip_gen_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 7),
 	}, {
 		.name		= SYSMMU_CLOCK_NAME,
 		.devname	= SYSMMU_CLOCK_DEVNAME(rot, 4),
 		.enable		= &exynos5_clk_ip_gen_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 6)
 	}, {
 		.name		= SYSMMU_CLOCK_NAME,
 		.devname	= SYSMMU_CLOCK_DEVNAME(gsc0, 5),
 		.enable		= &exynos5_clk_ip_gscl_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 7),
 	}, {
 		.name		= SYSMMU_CLOCK_NAME,
 		.devname	= SYSMMU_CLOCK_DEVNAME(gsc1, 6),
 		.enable		= &exynos5_clk_ip_gscl_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 8),
 	}, {
 		.name		= SYSMMU_CLOCK_NAME,
 		.devname	= SYSMMU_CLOCK_DEVNAME(gsc2, 7),
 		.enable		= &exynos5_clk_ip_gscl_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 9),
 	}, {
 		.name		= SYSMMU_CLOCK_NAME,
 		.devname	= SYSMMU_CLOCK_DEVNAME(gsc3, 8),
 		.enable		= &exynos5_clk_ip_gscl_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 10),
 	}, {
 		.name		= SYSMMU_CLOCK_NAME,
 		.devname	= SYSMMU_CLOCK_DEVNAME(isp, 9),
 		.enable		= &exynos5_clk_ip_isp0_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (0x3F << 8),
 	}, {
 		.name		= SYSMMU_CLOCK_NAME2,
 		.devname	= SYSMMU_CLOCK_DEVNAME(isp, 9),
 		.enable		= &exynos5_clk_ip_isp1_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (0xF << 4),
 	}, {
 		.name		= SYSMMU_CLOCK_NAME,
 		.devname	= SYSMMU_CLOCK_DEVNAME(camif0, 12),
 		.enable		= &exynos5_clk_ip_gscl_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 11),
 	}, {
 		.name		= SYSMMU_CLOCK_NAME,
 		.devname	= SYSMMU_CLOCK_DEVNAME(camif1, 13),
 		.enable		= &exynos5_clk_ip_gscl_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 12),
 	}, {
 		.name		= SYSMMU_CLOCK_NAME,
 		.devname	= SYSMMU_CLOCK_DEVNAME(2d, 14),
 		.enable		= &exynos5_clk_ip_acp_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 7)
 	}
 };
-- 
1.8.0


