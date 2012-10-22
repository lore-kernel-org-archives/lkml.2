Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab2JVWFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 18:05:50 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:4430 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932143Ab2JVWFt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 18:05:49 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h944hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1155h)
Date: Mon, 22 Oct 2012 17:05:31 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 2/3 v3] iommu/fsl: Add iommu domain attributes required
 by fsl PAMU driver.
To: Varun Sethi <Varun.Sethi@freescale.com>
CC: <joerg.roedel@amd.com>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Varun Sethi <Varun.Sethi@freescale.com>
References: <1350495170-4593-1-git-send-email-Varun.Sethi@freescale.com>
	<1350495170-4593-3-git-send-email-Varun.Sethi@freescale.com>
In-Reply-To: <1350495170-4593-3-git-send-email-Varun.Sethi@freescale.com>
	(from Varun.Sethi@freescale.com on Wed Oct 17 12:32:49 2012)
X-Mailer: Balsa 2.4.11
Message-ID: <1350943531.30970.8@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 12:32:49 PM, Varun Sethi wrote:
> Added the following domain attributes required by FSL PAMU driver:
> 1. Subwindows field added to the iommu domain geometry attribute.
> 2. Added new iommu stash attribute, which allows setting of the
>    LIODN specific stash id parameter through IOMMU API.
> 3. Added an attribute for enabling/disabling DMA to a particular
>    memory window.
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> ---
> change in v3:
> -renamed the stash attribute targets
> 
>  include/linux/iommu.h |   35 +++++++++++++++++++++++++++++++++++
>  1 files changed, 35 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index f3b99e1..c3b9d73 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -44,6 +44,33 @@ struct iommu_domain_geometry {
>  	dma_addr_t aperture_start; /* First address that can be  
> mapped    */
>  	dma_addr_t aperture_end;   /* Last address that can be  
> mapped     */
>  	bool force_aperture;       /* DMA only allowed in mappable  
> range? */
> +
> +	/* The subwindows field indicates number of DMA subwindows  
> supported
> +	 * by the geometry. Following is the interpretation of
> +	 * values for this field:
> +	 * 0 : This implies that the supported geometry size is 1 MB
> +         * with each subwindow size being 4KB. Thus number of  
> subwindows

Whitespace

> +	 * being = 1MB/4KB = 256.
> +	 * 1 : Only one DMA window i.e. no subwindows.
> +	 * value other than 0 or 1 would indicate actual number of  
> subwindows.
> +	 */

This language is way too specific for the generic geometry struct  
(especially when you start talking about specific sizes).  Please  
explain in implementation-neutral terms what this field means.

> @@ -60,6 +87,14 @@ struct iommu_domain {
>  enum iommu_attr {
>  	DOMAIN_ATTR_MAX,
>  	DOMAIN_ATTR_GEOMETRY,
> +	/* Set the IOMMU hardware stashing
> +	 * parameters.
> +	 */
> +	DOMAIN_ATTR_STASH,
> +	/* Explicity enable/disable DMA for a
> +         * particular memory window.
> +         */
> +	DOMAIN_ATTR_ENABLE,
>  };

Whitespace

-Scott
