Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab2KNIvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:51:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:15890 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766Ab2KNIvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:51:41 -0500
X-AuditID: cbfee61b-b7f616d00000319b-f3-50a35b78366d
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH 2/4] ARM: EXYNOS: Add clk_ops for gating clocks of System MMU
Date: Wed, 14 Nov 2012 17:51:04 +0900
Message-id: <002201cdc245$2e05dac0$8a119040$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3CRS3lHSVf47EGS3yhmPmjuO+Ylw==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zA92K6MUBBpdvaltc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVsm5lR8FGm4vGcOewNjNPEuhg5OSQETCR+vN/GAmGL
	SVy4t56ti5GLQ0hgGaPE50P3GGGKnv46wAyRmM4oMWNWMwuE849RYuPtqWwgVWwCWhKr5x5n
	BEmICPQySlzo/8oE4jALPGCUWHH4IRNIlbCAr8TtPVuAZnFwsAioSux7qA0S5hWwlZh67AMz
	hC0o8WPyPbCbmIGGrt95nAnClpfYvOYtWKuEgLrEo7+6IGERAT2JjzevskOUiEjse/EO7GoW
	AQGJb5MPsUCUy0psgnhAQmAyu8Szj33sEJ9JShxccYNlAqPYLCSbZyHZPAvJ5llIVixgZFnF
	KJpakFxQnJSea6RXnJhbXJqXrpecn7uJERI10jsYVzVYHGIU4GBU4uEN6F8UIMSaWFZcmXuI
	UYKDWUmEN9ZqcYAQb0piZVVqUX58UWlOavEhRh+gyycyS4km5wMjOq8k3tDY2MTMxNTE3NLU
	3BSHsJI4b7NHSoCQQHpiSWp2ampBahHMOCYOTqkGxlad1RNV5bY37q14cPaN8xfGmU4vzv9q
	nFK01zf61asDx+1nLTYrqGtT6mF/dXvn5V/8e94Kajb+nnt7XuqrvbdnCm9+resq6ufMPzXn
	ot6GuSK3q+50tatluooVzt1pstXr/OYLE1K9ljw8KXol3uDNDZ4T/Fpn2duDwyRWRciybX63
	yEJu0W0lluKMREMt5qLiRABKKoJCxwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jQd2K6MUBBj++qlpc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmbJuZUfBRpuLx
	nDnsDYzTxLoYOTkkBEwknv46wAxhi0lcuLeerYuRi0NIYDqjxIxZzSwQzj9GiY23p7KBVLEJ
	aEmsnnucESQhItDLKHGh/ysTiMMs8IBRYsXhh0wgVcICvhK392wBmsvBwSKgKrHvoTZImFfA
	VmLqsQ/MELagxI/J91hAbGagoet3HmeCsOUlNq95C9YqIaAu8eivLkhYREBP4uPNq+wQJSIS
	+168Y5zAKDALyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCY/KZ
	9A7GVQ0WhxgFOBiVeHgD+hcFCLEmlhVX5h5ilOBgVhLhjbVaHCDEm5JYWZValB9fVJqTWnyI
	0Qfoz4nMUqLJ+cB0kVcSb2hsYmZkaWRmYWRibo5DWEmct9kjJUBIID2xJDU7NbUgtQhmHBMH
	p1QDY8Tli7Ubbr2ayBnnFFmWI9TzgnOG6o3z3z+2/PfaH//6fqgo19SZrRW/jrfvmNCk93GK
	MqPhy93Fj4XYWnMeyhmH7dT/k6A998nP/PiYMha7SbeCC64saN90pjerpmlb7fIv89oSgk/f
	mt8lyXySUeBYuONSo4VvZd62CnNcm+U7/+4v01PffJRYijMSDbWYi4oTAdxuQyL2AgAA
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


