Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab1KISEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 13:04:14 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8522 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab1KISEN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 13:04:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 09 Nov 2011 10:03:47 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>
CC: Jon Medhurst <tixy@yxit.co.uk>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sumit Bhattacharya <sumitb@nvidia.com>
Date: Wed, 9 Nov 2011 10:03:46 -0800
Subject: RE: [PATCH] arm: dma:  Drop GFP_COMP for DMA memory allocations
Thread-Topic: [PATCH] arm: dma:  Drop GFP_COMP for DMA memory allocations
Thread-Index: AcybOcLVon/rnySgQNGSWjC4H8zhFAD0AWBA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174080512F@HQMAIL01.nvidia.com>
References: <1320442539-7753-1-git-send-email-swarren@nvidia.com>
In-Reply-To: <1320442539-7753-1-git-send-email-swarren@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren wrote at Friday, November 04, 2011 3:36 PM:
> dma_alloc_coherent wants to split pages after allocation in order to
> reduce the memory footprint. This does not work well with GFP_COMP
> pages, so drop this flag before allocation.
> 
> This patch is ported from arch/avr32
> (commit 3611553ef985ef7c5863c8a94641738addd04cff).
> 
> Signed-off-by: Sumit Bhattacharya <sumitb@nvidia.com>
> Tested-by: Varun Colbert <vcolbert@nvidia.com>
> [swarren: s/HUGETLB_PAGE/HUGETLBFS/ in comment, minor comment cleanup]
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Russell, does this look good to go in the patch system now?

> ---
>  arch/arm/mm/dma-mapping.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index e4e7f6c..68d64b4 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -332,6 +332,15 @@ __dma_alloc(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp,
>  	struct page *page;
>  	void *addr;
> 
> +	/*
> +	 * Following is a work-around (a.k.a. hack) to prevent pages
> +	 * with __GFP_COMP being passed to split_page() which cannot
> +	 * handle them.  The real problem is that this flag probably
> +	 * should be 0 on ARM as it is not supported on this
> +	 * platform; see CONFIG_HUGETLBFS.
> +	 */
> +	gfp &= ~(__GFP_COMP);
> +
>  	*handle = ~0;
>  	size = PAGE_ALIGN(size);
> 
> --
> 1.7.0.4

-- 
nvpublic

