Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab2KVTKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:10:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:31704 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2KVTKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:10:35 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-a8-50ae0577dec0
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ARM: dts: exynos4: add node for PL330 MDMA1 controller
Date: Thu, 22 Nov 2012 11:57:26 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        jassisinghbrar@gmail.com, vinod.koul@intel.com, kgene.kim@samsung.com,
        rob.herring@calxeda.com, dinguyen@altera.com, pawel.moll@arm.com,
        t.figa@samsung.com, kyungmin.park@samsung.com
References: <1351504796-24788-1-git-send-email-b.zolnierkie@samsung.com>
 <1351504796-24788-4-git-send-email-b.zolnierkie@samsung.com>
In-reply-to: <1351504796-24788-4-git-send-email-b.zolnierkie@samsung.com>
MIME-version: 1.0
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201211221157.26615.b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t9jQd1y1nUBBpN+qlhc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGW07PnCXPBWoOLojJcsDYwz+boYOTkkBEwkXt76wwJh
	i0lcuLeerYuRi0NIYDqjxPbzfYwQTguTxPV5PUwgVWwCVhIT21cxgtgiAgoSm3ufsYLYwgL+
	Et+3vAerYRFQlfi6ZT47iC0q4CDROXUC2FRmgU4mif337kCtaGeU6N7wh7mLkYODU8BT4vCW
	OJAGXgFBiR+T74GdxCygJdH8ZhMjhC0vsXnNW2aIGkuJp883MU1gFJiFpGUWkpZZSFoWMDKv
	YhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAgOx2dSOxhXNlgcYhTgYFTi4dV0XhsgxJpYVlyZ
	e4hRgoNZSYQ34TlQiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+zR0qAkEB6YklqdmpqQWoRTJaJ
	g1OqgbHT6tr3/xw8dpwbJvMsVOS8HrGlWefwirVP9mh8UufdP7Ho5msBFTN1hw9L6rUv9UqK
	T8jbaJC8TtVeVzhKeY1C1BkV7V2TzC82TTtfVx74InfnUYGTZz/NXvhaKWd3efVJ6dBGbv4r
	ieznfoX8qkqYOZ1bwv9J+kW/ZyWpnXpicaV2T/esT1FiKc5INNRiLipOBAA2cT9lQwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Kukjin,

Could you also apply this patch?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center


From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v2] ARM: dts: exynos4: add node for PL330 MDMA1 controller

Add missing PL330 MDMA1 controller node to the device tree (DT).

[ Currently there is no problem with using 'non-secure' mdma1 address
  instead of 'secure' one on revision 0 of Exynos4210 SOC (as used by
  Universal C210 board) as this SOC revision is unsupported by DT. ]

Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v2: refreshed againt next-20121115 and added Reviewed-by tag

 arch/arm/boot/dts/exynos4.dtsi         |    6 ++++++
 arch/arm/mach-exynos/mach-exynos4-dt.c |    1 +
 2 files changed, 7 insertions(+)

Index: b/arch/arm/boot/dts/exynos4.dtsi
===================================================================
--- a/arch/arm/boot/dts/exynos4.dtsi	2012-11-22 11:40:51.000000000 +0100
+++ b/arch/arm/boot/dts/exynos4.dtsi	2012-11-22 11:53:29.520815274 +0100
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
Index: b/arch/arm/mach-exynos/mach-exynos4-dt.c
===================================================================
--- a/arch/arm/mach-exynos/mach-exynos4-dt.c	2012-11-22 11:40:51.000000000 +0100
+++ b/arch/arm/mach-exynos/mach-exynos4-dt.c	2012-11-22 11:53:55.248815271 +0100
@@ -77,6 +77,7 @@ static const struct of_dev_auxdata exyno
 				"exynos4210-spi.2", NULL),
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS4_PA_PDMA0, "dma-pl330.0", NULL),
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS4_PA_PDMA1, "dma-pl330.1", NULL),
+	OF_DEV_AUXDATA("arm,pl330", EXYNOS4_PA_MDMA1, "dma-pl330.2", NULL),
 	OF_DEV_AUXDATA("samsung,exynos4210-tmu", EXYNOS4_PA_TMU,
 				"exynos-tmu", NULL),
 	{},
