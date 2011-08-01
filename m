Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab1HALz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 07:55:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33264 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab1HALzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 07:55:53 -0400
Date: Mon, 1 Aug 2011 12:55:49 +0100
From: Grant Likely <grant.likely@secretlab.ca>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/2] of: address: use resource_size helper
Message-ID: <20110801115549.GA4566@ponder.secretlab.ca>
References: <1311364042-8325-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311364042-8325-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 10:47:21PM +0300, Felipe Balbi wrote:
> that should be the approved way of calculating
> the size of resources. No functional changes.
> 
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Felipe Balbi <balbi@ti.com>

Applied, thanks.

> ---
>  drivers/of/address.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index deefc0c..6e7b2cf 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -624,6 +624,6 @@ void __iomem *of_iomap(struct device_node *np, int index)
>  	if (of_address_to_resource(np, index, &res))
>  		return NULL;
>  
> -	return ioremap(res.start, 1 + res.end - res.start);
> +	return ioremap(res.start, resource_size(&res));
>  }
>  EXPORT_SYMBOL(of_iomap);
> -- 
> 1.7.6
> 
