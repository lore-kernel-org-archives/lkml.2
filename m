Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab2KUFDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 00:03:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58134 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2KUFDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 00:03:19 -0500
X-AuditID: cbfee61b-b7f616d00000319b-82-50ac60964ee8
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, sw0312.kim@samsung.com,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v3 02/12] ARM: EXYNOS: Add clk_ops for gating clocks of System
 MMU
Date: Wed, 21 Nov 2012 14:03:18 +0900
Message-id: <002801cdc7a5$8535f6d0$8fa1e470$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3HpYUaIEl+tOnhTL2nVMjbCCI2Tw==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zQ91pCWsCDA5/l7G4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mr4te0IS8Fy2YrJ/8sbGE+KdTFyckgImEg82/+EFcIW
	k7hwbz1bFyMXh5DAMkaJ7UtWMsMU3X3+BCoxnVHi653PrBDOP0aJlu5XjCBVbAJaEqvnHmcE
	SYgI9DJKXOj/ygTiMAv8YJRY/OYN2CxhgRCJhtd9bCA2i4CqxM8t+8CW8wrYSmyesYYZwhaU
	+DH5HguIzQw0df3O40wQtrzE5jVvgWo4gG5Sl3j0VxckLCKgJ7Hl72dWiBIRiX0v3jFCjBeQ
	+Db5EAtEuazEpgPMIOdICExmlzjbepkF4jVJiYMrbrBMYBSbhWTzLCSbZyHZPAvJigWMLKsY
	RVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxQuJGegfjqgaLQ4wCHIxKPLwS+1YHCLEmlhVX5h5i
	lOBgVhLhZZBfEyDEm5JYWZValB9fVJqTWnyI0Qfo8onMUqLJ+cCYziuJNzQ2NjEzMTUxtzQ1
	N8UhrCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qBMT1o6uljuvu3OW/3X5DqYHBNdcO9z6E8
	6080tNrUfLs///jk1Fc2qz54nf73vGNvfKPzVI/tkVNrZaK+lzTpxKWtZrf/4Ljj+xunF7qz
	2n1qPf4zBxpXnj99ROLSWwZPu1uOhjVLhTN32Z+emvWmM3/+wT/1n/+L3dk/Lc+sk6vtT9Cr
	B67iIUosxRmJhlrMRcWJAB/uv+DIAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd1pCWsCDJo2iltc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm/Np2hKVguWzF
	5P/lDYwnxboYOTkkBEwk7j5/wgZhi0lcuLceyObiEBKYzijx9c5nVgjnH6NES/crRpAqNgEt
	idVzjzOCJEQEehklLvR/ZQJxmAV+MEosfvOGGaRKWCBEouF1H9hcFgFViZ9b9rGC2LwCthKb
	Z6xhhrAFJX5MvscCYjMDTV2/8zgThC0vsXnNW6AaDqCb1CUe/dUFCYsI6Els+fuZFaJERGLf
	i3eMExgFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnBUPpPe
	wbiqweIQowAHoxIPr8S+1QFCrIllxZW5hxglOJiVRHgZ5NcECPGmJFZWpRblxxeV5qQWH2L0
	AXp0IrOUaHI+MGHklcQbGpuYGVkamVkYmZib4xBWEudt9kgJEBJITyxJzU5NLUgtghnHxMEp
	1cDI2dZydE65gdeU37PPJPSuT2hT3LLYR2RWRx5z45+P5zdelPxwZ7Kw7+ttVRl23x+86dmv
	xv3A7dBJ1mjNx+4hF9VzHvjZavGZfqxnfLPq2fWzS9bfe/NW1NfkTt4Ro00zzPYYTMw/pvBm
	r+WGfd7Z0710rhVMajf56DJfOVHvYaxnw7OQrq4KJZbijERDLeai4kQALS2wnPcCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Touching some System MMU needs its master devices' clock to be enabled
before. This commit adds clk_ops.set_parent of gating clocks of System
MMU to ensure gating clocks of System MMU's mater devices are enabled
when enabling gating clocks of System MMU.

Change-Id: Icd58b12f599e92692c032516331a444f4703ba6b
Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 arch/arm/mach-exynos/clock-exynos5.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm/mach-exynos/clock-exynos5.c b/arch/arm/mach-exynos/clock-exynos5.c
index 9e815ae..9dfb845 100644
--- a/arch/arm/mach-exynos/clock-exynos5.c
+++ b/arch/arm/mach-exynos/clock-exynos5.c
@@ -613,6 +613,16 @@ static struct clksrc_clk exynos5_clk_aclk_300_gscl = {
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
@@ -854,76 +864,91 @@ static struct clk exynos5_init_clocks_off[] = {
 		.name		= "sysmmu",
 		.devname	= "exynos-sysmmu.0",
 		.enable		= &exynos5_clk_ip_mfc_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 1),
 	}, {
 		.name		= "sysmmu",
 		.devname	= "exynos-sysmmu.1",
 		.enable		= &exynos5_clk_ip_mfc_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 2),
 	}, {
 		.name		= "sysmmu",
 		.devname	= "exynos-sysmmu.2",
 		.enable		= &exynos5_clk_ip_disp1_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 9)
 	}, {
 		.name		= "sysmmu",
 		.devname	= "exynos-sysmmu.3",
 		.enable		= &exynos5_clk_ip_gen_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 7),
 	}, {
 		.name		= "sysmmu",
 		.devname	= "exynos-sysmmu.4",
 		.enable		= &exynos5_clk_ip_gen_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 6)
 	}, {
 		.name		= "sysmmu",
 		.devname	= "exynos-sysmmu.5",
 		.enable		= &exynos5_clk_ip_gscl_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 7),
 	}, {
 		.name		= "sysmmu",
 		.devname	= "exynos-sysmmu.6",
 		.enable		= &exynos5_clk_ip_gscl_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 8),
 	}, {
 		.name		= "sysmmu",
 		.devname	= "exynos-sysmmu.7",
 		.enable		= &exynos5_clk_ip_gscl_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 9),
 	}, {
 		.name		= "sysmmu",
 		.devname	= "exynos-sysmmu.8",
 		.enable		= &exynos5_clk_ip_gscl_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 10),
 	}, {
 		.name		= "sysmmu",
 		.devname	= "exynos-sysmmu.9",
 		.enable		= &exynos5_clk_ip_isp0_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (0x3F << 8),
 	}, {
 		.name		= "sysmmu",
 		.devname	= "exynos-sysmmu.10",
 		.enable		= &exynos5_clk_ip_isp1_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (0xF << 4),
 	}, {
 		.name		= "sysmmu",
 		.devname	= "exynos-sysmmu.11",
 		.enable		= &exynos5_clk_ip_disp1_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 8)
 	}, {
 		.name		= "sysmmu",
 		.devname	= "exynos-sysmmu.12",
 		.enable		= &exynos5_clk_ip_gscl_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 11),
 	}, {
 		.name		= "sysmmu",
 		.devname	= "exynos-sysmmu.13",
 		.enable		= &exynos5_clk_ip_gscl_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 12),
 	}, {
 		.name		= "sysmmu",
 		.devname	= "exynos-sysmmu.14",
 		.enable		= &exynos5_clk_ip_acp_ctrl,
+		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 7)
 	}
 };
-- 
1.8.0


