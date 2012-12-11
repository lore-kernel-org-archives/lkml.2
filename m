Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab2LKLJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 06:09:31 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:43055 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab2LKLJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 06:09:28 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-df-50c71467d48b
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Dae Inki'" <inki.dae@samsung.com>, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahun Sharma'" <rahul.sharma@samsung.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        "'SWKim'" <sw0312.kim@samsung.com>
Subject: [PATCH v5 05/14] ARM: EXYNOS: Add clk_ops for gating clocks of System
 MMU
Date: Tue, 11 Dec 2012 20:09:27 +0900
Message-id: <003501cdd78f$fc276db0$f4764910$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3XjHNcM1dN30GgQw6XWOazTgfB8AAA4DTw
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zI910keMBBkvW61pc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX8vLaRseCtbMWLD7ENjBvEuxg5OSQETCT6D15ig7DF
	JC7cWw9mCwksY5R48ykPpqZrQh97FyMXUHw6o8Thb1MYIZx/jBK/e9Yxg1SxCWhJrJ57nBHE
	FhG4yyjx8jwPSBGzwBEmiZ33z7GAJIQFQiT+z29gB7FZBFQl7n7/BNTMwcErYCuxeEUNSJhX
	QFDix+R7YOXMQDPX7zzOBGHLS2xe8xasXEJAXeLRX12IVUYSD9/eYIYoEZHY9+IdI8R0AYlv
	kw+xQJTLSmw6wAxyjYRAP7vEj+5J7BCPSUocXHGDZQKj2Cwkm2ch2TwLyeZZSFYsYGRZxSia
	WpBcUJyUnmuoV5yYW1yal66XnJ+7iRESMVI7GFc2WBxiFOBgVOLh1dA6FiDEmlhWXJl7iFGC
	g1lJhDdS6HiAEG9KYmVValF+fFFpTmrxIUYfoMsnMkuJJucDozmvJN7Q2NjEzMTUxNzS1NwU
	h7CSOG+zR0qAkEB6YklqdmpqQWoRzDgmDk6pBsaSs9E16WsXekb8vP7lvE/kxeVPJkp93Ba9
	Wryjiynvwb8egetiKnv1yo7MU70Z0XPtoW1t35VFd2eyrTySp/Z0maPso83sitMVL+5d8mPH
	iS6hi5G7HykeXdVqJzkrxUD6gb23XsTPl1ejZC5d2HrjaeuftXfOxLVIy3ycd8v96qLY8/dM
	V/7/rcRSnJFoqMVcVJwIACZzBkzFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t9jQd10keMBBndXqFtc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm/Ly2kbHgrWzF
	iw+xDYwbxLsYOTkkBEwkuib0sUPYYhIX7q1n62Lk4hASmM4ocfjbFEYI5x+jxO+edcwgVWwC
	WhKr5x5nBLFFBO4ySrw8zwNSxCxwhEli5/1zLCAJYYEQif/zG8DGsgioStz9/gmomYODV8BW
	YvGKGpAwr4CgxI/J98DKmYFmrt95nAnClpfYvOYtWLmEgLrEo7+6EKuMJB6+vcEMUSIise/F
	O8YJjAKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOCKfSe1g
	XNlgcYhRgINRiYdXQ+tYgBBrYllxZe4hRgkOZiUR3kih4wFCvCmJlVWpRfnxRaU5qcWHGH2A
	/pzILCWanA9MFnkl8YbGJmZGlkZmFkYm5uY4hJXEeZs9UgKEBNITS1KzU1MLUotgxjFxcEo1
	MMpPzNjYtY5BlTeeeYvhn9UBAhkSzPre17OCgr28vlef+vy35wKLR6P49LeuS4P7fiyoWPtL
	9bGGXJzkK5kdXIGf2r56Rus9dJDrP508749nQ5ZAn6x6w5YPYUckz8063GrJ+arJ6PQem0lf
	9n3+u6Fd0H+vyUnBvctvqhZ2p+gyvj8oMKNooxJLcUaioRZzUXEiANsKd5/1AgAA
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


