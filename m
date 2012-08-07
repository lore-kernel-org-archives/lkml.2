Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab2HGSlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:41:17 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:16894 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab2HGSlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:41:14 -0400
Date: Tue, 7 Aug 2012 14:31:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        catalin.marinas@arm.com, arnd@arndb.de
Subject: Re: [PATCH v2 17/23] xen/arm: implement
 alloc/free_xenballooned_pages with alloc_pages/kfree
Message-ID: <20120807183135.GT15053@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
 <1344263246-28036-17-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344263246-28036-17-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 03:27:20PM +0100, Stefano Stabellini wrote:
> Only until we get the balloon driver to work.

OK. Acked-by be.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/xen/enlighten.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 87b17f0..c244583 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -140,3 +140,21 @@ static int __init xen_init_events(void)
>  	return 0;
>  }
>  postcore_initcall(xen_init_events);
> +
> +/* XXX: only until balloon is properly working */
> +int alloc_xenballooned_pages(int nr_pages, struct page **pages, bool highmem)
> +{
> +	*pages = alloc_pages(highmem ? GFP_HIGHUSER : GFP_KERNEL,
> +			get_order(nr_pages));
> +	if (*pages == NULL)
> +		return -ENOMEM;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(alloc_xenballooned_pages);
> +
> +void free_xenballooned_pages(int nr_pages, struct page **pages)
> +{
> +	kfree(*pages);
> +	*pages = NULL;
> +}
> +EXPORT_SYMBOL_GPL(free_xenballooned_pages);
> -- 
> 1.7.2.5
