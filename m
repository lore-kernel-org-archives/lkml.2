Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab2KHJzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:55:55 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:49896 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab2KHJzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:55:52 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-1e-509b81a67cfe
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 2/4] ARM: EXYNOS: PL330 MDMA1 fix for revision 0 of
 Exynos4210 SOC
Date: Thu, 08 Nov 2012 10:54:41 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, jassisinghbrar@gmail.com,
        vinod.koul@intel.com, rob.herring@calxeda.com, dinguyen@altera.com,
        pawel.moll@arm.com, t.figa@samsung.com, kyungmin.park@samsung.com
References: <1351504796-24788-1-git-send-email-b.zolnierkie@samsung.com>
 <201210300956.23102.b.zolnierkie@samsung.com>
 <0cea01cdbd6c$7ace7200$706b5600$%kim@samsung.com>
In-reply-to: <0cea01cdbd6c$7ace7200$706b5600$%kim@samsung.com>
MIME-version: 1.0
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201211081054.41649.b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t9jAd1ljbMDDHa3iVlc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWcXH+aueCIXMXbrYvZGxjvSnYxcnJICJhIrPq8lx3C
	FpO4cG89WxcjF4eQwCJGibfzHrJAOC1MEuv7uxlBqtgErCQmtq8Cs0UE1CR6Fm8Fs4UFIiSW
	7ZrAAmKzCKhKvOmZxApiiwo4SHROnQA2lVlgApPEitXnoaauYZTYMfk52G5OATuJww8hunkF
	BCV+TL4HZjMLaEk0v9nECGHLS2xe85YZosZSorHtP9MERoFZSFpmIWmZhaRlASPzKkbR1ILk
	guKk9FxDveLE3OLSvHS95PzcTYzggHwmtYNxZYPFIUYBDkYlHl4NydkBQqyJZcWVuYcYJTiY
	lUR4lzkDhXhTEiurUovy44tKc1KLDzFKc7AoifM2e6QECAmkJ5akZqemFqQWwWSZODilGhj9
	G439nE877M27W3vow89t95O+PJc+G3PqDLPz3vZDOf8+d3DMlOSJtFy2fkOpvLu/+C/+WZIq
	5xm+7Y/T+HHmVKh8xJYZv1bphfD7fDlc/f20SfMSt9lTtx2qZHb5covR3iO+8WPkKnevkLsT
	bnG+MKjO2+C5L5/jvPD2Ce9sost1p84tdpyqxFKckWioxVxUnAgA/FMeKUQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2012 05:49:47 Kukjin Kim wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > 
> > > Hmm...above change and adding definition of EXYNOS_PA_S_MDMA1 address
> > > can fix the problem you commented on EXYNOS4210 Rev0 without others?...
> > 
> > The problem is affecting only EXYNOS4210 Rev0 and the fix is applied only
> > for case when soc_is_exynos4210() && samsung_rev() == EXYNOS4210_REV_0,
> > or did you mean something else?
> > 
> Yeah, I know. I mean just adding secure mdma1 address is enough for
> exynos4210 rev0.
> 
> 8<-----
> @@ -275,6 +275,9 @@ static int __init exynos_dma_init(void)
>  		exynos_pdma1_pdata.nr_valid_peri =
>  			ARRAY_SIZE(exynos4210_pdma1_peri);
>  		exynos_pdma1_pdata.peri_id = exynos4210_pdma1_peri;
> +
> +		if (samsung_rev() == EXYNOS4210_REV_0)
> +			exynos_mdma1_device.res.start = EXYNOS4_PA_S_MDMA1;
>  	} else if (soc_is_exynos4212() || soc_is_exynos4412()) {
>  		exynos_pdma0_pdata.nr_valid_peri =
>  			ARRAY_SIZE(exynos4212_pdma0_peri);
> diff --git a/arch/arm/mach-exynos/include/mach/map.h
> b/arch/arm/mach-exynos/include/mach/map.h
> index 8480849..0abfe78 100644
> --- a/arch/arm/mach-exynos/include/mach/map.h
> +++ b/arch/arm/mach-exynos/include/mach/map.h
> @@ -90,6 +90,7 @@
>  
>  #define EXYNOS4_PA_MDMA0		0x10810000
>  #define EXYNOS4_PA_MDMA1		0x12850000
> +#define EXYNOS4_PA_S_MDMA1		0x12840000
>  #define EXYNOS4_PA_PDMA0		0x12680000
>  #define EXYNOS4_PA_PDMA1		0x12690000
>  #define EXYNOS5_PA_MDMA0		0x10800000
> 8<----

Ah, okay.  Here is full simplified patch.

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v2] ARM: EXYNOS: PL330 MDMA1 fix for revision 0 of Exynos4210 SOC

Commit 8214513 ("ARM: EXYNOS: fix address for EXYNOS4 MDMA1")
changed EXYNOS specific setup of PL330 DMA engine to use 'non-secure'
mdma1 address instead of 'secure' one (from 0x12840000 to 0x12850000)
to fix issue with some Exynos4212 SOCs.  Unfortunately it brakes
PL330 setup for revision 0 of Exynos4210 SOC (mdma1 device cannot
be found at 'non-secure' address):

[    0.566245] dma-pl330 dma-pl330.2: PERIPH_ID 0x0, PCELL_ID 0x0 !
[    0.566278] dma-pl330: probe of dma-pl330.2 failed with error -22

Fix it by using 'secure' mdma1 address on Exynos4210 revision 0 SOC.

Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/dma.c              |    3 +++
 arch/arm/mach-exynos/include/mach/map.h |    1 +
 2 files changed, 4 insertions(+)

Index: b/arch/arm/mach-exynos/dma.c
===================================================================
--- a/arch/arm/mach-exynos/dma.c	2012-11-07 18:20:36.561743865 +0100
+++ b/arch/arm/mach-exynos/dma.c	2012-11-08 10:48:23.445067606 +0100
@@ -275,6 +275,9 @@ static int __init exynos_dma_init(void)
 		exynos_pdma1_pdata.nr_valid_peri =
 			ARRAY_SIZE(exynos4210_pdma1_peri);
 		exynos_pdma1_pdata.peri_id = exynos4210_pdma1_peri;
+
+		if (samsung_rev() == EXYNOS4210_REV_0)
+			exynos_mdma1_device.res.start = EXYNOS4_PA_S_MDMA1;
 	} else if (soc_is_exynos4212() || soc_is_exynos4412()) {
 		exynos_pdma0_pdata.nr_valid_peri =
 			ARRAY_SIZE(exynos4212_pdma0_peri);
Index: b/arch/arm/mach-exynos/include/mach/map.h
===================================================================
--- a/arch/arm/mach-exynos/include/mach/map.h	2012-11-07 18:20:44.801743862 +0100
+++ b/arch/arm/mach-exynos/include/mach/map.h	2012-11-08 10:48:40.597067605 +0100
@@ -92,6 +92,7 @@
 
 #define EXYNOS4_PA_MDMA0		0x10810000
 #define EXYNOS4_PA_MDMA1		0x12850000
+#define EXYNOS4_PA_S_MDMA1		0x12840000
 #define EXYNOS4_PA_PDMA0		0x12680000
 #define EXYNOS4_PA_PDMA1		0x12690000
 #define EXYNOS5_PA_MDMA0		0x10800000
