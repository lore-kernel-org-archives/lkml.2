Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab2KTHdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:33:17 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:20955 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab2KTHaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:30:00 -0500
X-AuditID: cbfee61b-b7f616d00000319b-20-50ab3177546f
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, sw0312.kim@samsung.com,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v2 02/12] ARM: EXYNOS: Add clk_ops for gating clocks of System
 MMU
Date: Tue, 20 Nov 2012 16:29:59 +0900
Message-id: <001c01cdc6f0$d8d3c3e0$8a7b4ba0$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3G8Ni8dPnlPyM6ReGWVy5qsjG0gg==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zfd1yw9UBBh1/9S0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDK2zcwo+ChT8XjOHPYGxmliXYwcHBICJhLfDtd0MXIC
	mWISF+6tZ+ti5OIQEljGKHFiQh8TRMJE4sj5hSwQiemMEsv3vYOq+scosXXGb2aQKjYBLYnV
	c48zgiREBHoZJS70f2UCcZgFfjBKLH7zBqxKWCBEYsXbD2A2i4CqxKxNt1hBbF4BW4lXU2ex
	QdiCEj8m32MBsZmBpq7feZwJwpaX2LzmLTPE3eoSj/7qgoRFBPQk7nbdZ4UoEZHY9+IdI8R4
	AYlvkw+xQJTLSmw6wAxyjoRAP7vEitv9rBCvSUocXHGDZQKj2Cwkm2ch2TwLyeZZSFYsYGRZ
	xSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRESNdI7GFc1WBxiFOBgVOLhfZiwKkCINbGsuDL3
	EKMEB7OSCG9TOVCINyWxsiq1KD++qDQntfgQow/Q5ROZpUST84ERnVcSb2hsbGJmYmpibmlq
	bopDWEmct9kjJUBIID2xJDU7NbUgtQhmHBMHp1QDY/Lv6UvSnBTfrsuwrWuXvdPXle3OnXnZ
	W1NglZlc120V5o+Tl0f58X7b/zfed5n1R9cT62o1j9yZcmOhzhuJbzp9m1UZ/ig69+c87/bZ
	fr3n9q67IXYZ3gKxlZbxAokFR3osbuzSCzvjeFw8bm2m/px3N3btdTT0dZiTISVfXTTz3ImH
	e28/UGIpzkg01GIuKk4EAEEcZcjHAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd1yw9UBBnOOaltc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmbJuZUfBRpuLx
	nDnsDYzTxLoYOTkkBEwkjpxfyAJhi0lcuLeerYuRi0NIYDqjxPJ976Ccf4wSW2f8ZgapYhPQ
	klg99zgjSEJEoJdR4kL/VyYQh1ngB6PE4jdvwKqEBUIkVrz9AGazCKhKzNp0ixXE5hWwlXg1
	dRYbhC0o8WPyPbDdzEBT1+88zgRhy0tsXvMWqJcD6CZ1iUd/dUHCIgJ6Ene77rNClIhI7Hvx
	jnECo8AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjspn0jsY
	VzVYHGIU4GBU4uF9mLAqQIg1say4MvcQowQHs5IIb1M5UIg3JbGyKrUoP76oNCe1+BCjD9Cj
	E5mlRJPzgQkjryTe0NjEzMjSyMzCyMTcHIewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5OqQbG
	Kv1t1i0p36ZJevsujz62ovnlnYSJR0xddJQim1c/U7vOM63optBB36vMCbJpMlYeExOs3ROU
	386ovPGTw7L0S8t6ndiFpYq6ibqbpkY/l/+QKV1/Wemx9izzGA8+K06vSbnuSVbbi+pMtEJf
	Hvzq/Htl2cwbZ40tM9muvVub/2+hxNsN+YVKLMUZiYZazEXFiQCtomf49wIAAA==
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


