Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab1I3Nu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 09:50:27 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:5516 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab1I3NuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 09:50:22 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4R8275bhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,13,
X-WSS-ID: 0LSC8XU-01-E3O-02
X-M-MSG: 
Date: Fri, 30 Sep 2011 15:46:43 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Kukjin Kim <kgene.kim@samsung.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Russell King'" <rmk+kernel@arm.linux.org.uk>,
        "'Ohad Ben-Cohen'" <ohad@wizery.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "younglak1004.kim@samsung.com" <younglak1004.kim@samsung.com>
Subject: Re: [PATCH v2 5/5] iommu/exynos: Use bus_set_iommu instead of
 register_iommu
Message-ID: <20110930134643.GS2138@amd.com>
References: <017001cc7f43$04a2db60$0de89220$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <017001cc7f43$04a2db60$0de89220$%kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 03:31:49AM -0400, Kukjin Kim wrote:
> From: KyongHo Cho <pullip.cho@samsung.com>
> 
> This replaces register_iommu() with bus_set_iommu() according to the
> suggestion of Joerg Roedel.

This should be part of patch 3 already when the bus_set_iommu() change
is merged. Otherwise it breaks bisectability too.

	Joerg

> 
> Cc: Joerg Roedel <joerg.roedel@amd.com>
> Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
> Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
> ---
>  drivers/iommu/exynos_iommu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/iommu/exynos_iommu.c b/drivers/iommu/exynos_iommu.c
> index d355a2e..e36f7b2 100644
> --- a/drivers/iommu/exynos_iommu.c
> +++ b/drivers/iommu/exynos_iommu.c
> @@ -912,7 +912,7 @@ static int __init exynos_iommu_init(void)
>  	if (!l2table_cachep)
>  		return -ENOMEM;
>  
> -	register_iommu(&exynos_iommu_ops);
> +	bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
>  
>  	return 0;
>  }
> -- 
> 1.7.1
> 
> 

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

