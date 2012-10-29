Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446Ab2J2KAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:00:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53741 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758430Ab2J2KAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:00:40 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-6e-508e53c7fb83
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: jassisinghbrar@gmail.com, vinod.koul@intel.com, kgene.kim@samsung.com,
        rob.herring@calxeda.com, dinguyen@altera.com, pawel.moll@arm.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 3/4] ARM: dts: exynos4: add node for PL330 MDMA1 controller
Date: Mon, 29 Oct 2012 10:59:55 +0100
Message-id: <1351504796-24788-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1351504796-24788-1-git-send-email-b.zolnierkie@samsung.com>
References: <1351504796-24788-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsVy+t9jQd3jwX0BBrcPyFtc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVcbrjHVvCBp2L7wjtMDYwPuboYOTkkBEwk7sxbywRh
	i0lcuLeerYuRi0NIYDqjxMTF3YwQTheTRO/vh4wgVWwCVhIT21eB2SIC2RI/vk1mASliFvjG
	KLG5fzEbSEJYwFtiXe89VhCbRUBV4v6WNcwgNq+Ah8TvjpWsEOvkJZ7e7wOr5xTwlDg9cRVY
	jRBQzb9P+9knMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRHs/2dSOxhXNlgcYhTg
	YFTi4W180xsgxJpYVlyZe4hRgoNZSYR3KTdQiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+zR0qA
	kEB6YklqdmpqQWoRTJaJg1OqgZF5RnDRqRcnivLr+1xK5+9elrS15MzTl2reznFHOdOVzVmn
	ZV54cigh0P6om7bdFGNJln9u9/wWKX5b472T0/rj5t92Agyr7s26dCThxukEs6LI+NO8Qdya
	c6zEUlac5Lgm7Lv96f8VH6utDgZumqbXWxVuw8H48arDjS+rdkx7uDghZK9exEslluKMREMt
	5qLiRAAsEbAs+wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing PL330 MDMA1 controller node to the device tree (DT).

[ Currently there is no problem with using 'non-secure' mdma1 address
  instead of 'secure' one on revision 0 of Exynos4210 SOC (as used by
  Universal C210 board) as this SOC revision is unsupported by DT. ]

Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi         | 6 ++++++
 arch/arm/mach-exynos/mach-exynos4-dt.c | 1 +
 2 files changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index a26c3dd..96d4462 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -244,5 +244,11 @@
 			reg = <0x12690000 0x1000>;
 			interrupts = <0 36 0>;
 		};
+
+		mdma1: mdma@12850000 {
+			compatible = "arm,pl330", "arm,primecell";
+			reg = <0x12850000 0x1000>;
+			interrupts = <0 34 0>;
+		};
 	};
 };
diff --git a/arch/arm/mach-exynos/mach-exynos4-dt.c b/arch/arm/mach-exynos/mach-exynos4-dt.c
index eadf4b5..d737968 100644
--- a/arch/arm/mach-exynos/mach-exynos4-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
@@ -77,6 +77,7 @@ static const struct of_dev_auxdata exynos4_auxdata_lookup[] __initconst = {
 				"exynos4210-spi.2", NULL),
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS4_PA_PDMA0, "dma-pl330.0", NULL),
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS4_PA_PDMA1, "dma-pl330.1", NULL),
+	OF_DEV_AUXDATA("arm,pl330", EXYNOS4_PA_NS_MDMA1, "dma-pl330.2", NULL),
 	{},
 };
 
-- 
1.8.0

