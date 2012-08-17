Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab2HQRJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:09:21 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:37181 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab2HQRJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:09:10 -0400
X-IronPort-AV: E=Sophos;i="4.77,785,1336348800"; 
   d="scan'208";a="14064569"
Date: Fri, 17 Aug 2012 18:08:51 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 1/5] xen/swiotlb: Simplify the logic.
In-Reply-To: <1345132488-27323-2-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1208171808350.15568@kaball.uk.xensource.com>
References: <1345132488-27323-1-git-send-email-konrad.wilk@oracle.com> <1345132488-27323-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2012, Konrad Rzeszutek Wilk wrote:
> Its pretty easy:
>  1). We only check to see if we need Xen SWIOTLB for PV guests.
>  2). If swiotlb=force or iommu=soft is set, then Xen SWIOTLB will
>      be enabled.
>  3). If it is an initial domain, then Xen SWIOTLB will be enabled.
>  4). Native SWIOTLB must be disabled for PV guests.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/x86/xen/pci-swiotlb-xen.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
> index 967633a..b6a5340 100644
> --- a/arch/x86/xen/pci-swiotlb-xen.c
> +++ b/arch/x86/xen/pci-swiotlb-xen.c
> @@ -34,19 +34,20 @@ static struct dma_map_ops xen_swiotlb_dma_ops = {
>  int __init pci_xen_swiotlb_detect(void)
>  {
>  
> +	if (!xen_pv_domain())
> +		return 0;
> +
>  	/* If running as PV guest, either iommu=soft, or swiotlb=force will
>  	 * activate this IOMMU. If running as PV privileged, activate it
>  	 * irregardless.
>  	 */
> -	if ((xen_initial_domain() || swiotlb || swiotlb_force) &&
> -	    (xen_pv_domain()))
> +	if ((xen_initial_domain() || swiotlb || swiotlb_force))
>  		xen_swiotlb = 1;
>  
>  	/* If we are running under Xen, we MUST disable the native SWIOTLB.
>  	 * Don't worry about swiotlb_force flag activating the native, as
>  	 * the 'swiotlb' flag is the only one turning it on. */
> -	if (xen_pv_domain())
> -		swiotlb = 0;
> +	swiotlb = 0;
>  
>  	return xen_swiotlb;
>  }
> -- 
> 1.7.7.6
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
> 
