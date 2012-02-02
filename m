Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab2BBE6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 23:58:49 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38000 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab2BBE6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 23:58:45 -0500
Date: Wed, 1 Feb 2012 21:58:44 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irq_domain: fix the irq number of imx5 tzic
Message-ID: <20120202045844.GK15343@ponder.secretlab.ca>
References: <1327700179-17454-15-git-send-email-grant.likely@secretlab.ca>
 <1328075214-25700-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328075214-25700-1-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 01:46:54PM +0800, Shawn Guo wrote:
> The tzic controller found on imx51 and imx53 gets 128 irq lines rather
> than 32.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>

Applied, thanks.

g.

> ---
>  arch/arm/mach-mx5/imx51-dt.c |    2 +-
>  arch/arm/mach-mx5/imx53-dt.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-mx5/imx51-dt.c b/arch/arm/mach-mx5/imx51-dt.c
> index e1b5edf..1e03ef4 100644
> --- a/arch/arm/mach-mx5/imx51-dt.c
> +++ b/arch/arm/mach-mx5/imx51-dt.c
> @@ -47,7 +47,7 @@ static const struct of_dev_auxdata imx51_auxdata_lookup[] __initconst = {
>  static int __init imx51_tzic_add_irq_domain(struct device_node *np,
>  				struct device_node *interrupt_parent)
>  {
> -	irq_domain_add_legacy(np, 32, 0, 0, &irq_domain_simple_ops, NULL);
> +	irq_domain_add_legacy(np, 128, 0, 0, &irq_domain_simple_ops, NULL);
>  	return 0;
>  }
>  
> diff --git a/arch/arm/mach-mx5/imx53-dt.c b/arch/arm/mach-mx5/imx53-dt.c
> index 89de5d4..fd5be0f 100644
> --- a/arch/arm/mach-mx5/imx53-dt.c
> +++ b/arch/arm/mach-mx5/imx53-dt.c
> @@ -51,7 +51,7 @@ static const struct of_dev_auxdata imx53_auxdata_lookup[] __initconst = {
>  static int __init imx53_tzic_add_irq_domain(struct device_node *np,
>  				struct device_node *interrupt_parent)
>  {
> -	irq_domain_add_legacy(np, 32, 0, 0, &irq_domain_simple_ops, NULL);
> +	irq_domain_add_legacy(np, 128, 0, 0, &irq_domain_simple_ops, NULL);
>  	return 0;
>  }
>  
> -- 
> 1.7.4.1
> 
> 
