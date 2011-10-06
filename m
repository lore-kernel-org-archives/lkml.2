Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965135Ab1JFQfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 12:35:05 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:37528 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935869Ab1JFQfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 12:35:04 -0400
Date: Thu, 6 Oct 2011 10:35:02 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, khilman@ti.com,
        b-cousson@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Subject: Re: [PATCH 2/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
In-Reply-To: <1317901123-2546-1-git-send-email-keshava_mgowda@ti.com>
Message-ID: <alpine.DEB.2.00.1110061030490.4611@utopia.booyaka.com>
References: <1317901123-2546-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keshava,

On Thu, 6 Oct 2011, Keshava Munegowda wrote:

> Following 2 hwmod structures are added
>     1. usb_host_hs
>          The hwmod of usbhs with uhh, ehci and ohci base addresses
>          functional clock and ehci, ohci irqs
> 
>     2. usb_tll_hs
>           hwmod of usbhs with the TLL base address and irq.
> 
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
> Reviewed-by: Partha Basak <parthab@india.ti.com>
> ---
>  arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  227 ++++++++++++++++++++++++++++
>  1 files changed, 227 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> index 59fdb9f..b8ca690 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> @@ -84,6 +84,8 @@ static struct omap_hwmod omap3xxx_mcbsp4_hwmod;

...

> +static struct omap_hwmod_ocp_if omap34xx_usb_host_hs__ick = {
> +	.master         = &omap3xxx_l4_core_hwmod,
> +	.slave          = &omap34xx_usb_host_hs_hwmod,
> +	.clk		= "usbhost_ick",
> +	.addr		= omap34xx_usb_host_hs_addrs,
> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
> +/*
> + * This clock should be on/off only with main clock; If auto idle is set,
> + * the usbhs controller prevents the omap to enter in to low power mode,
> + * hence don't use auto idle here.
> + */
> +	.flags		= OCPIF_SWSUP_IDLE,

This is still unclear to me.  Doesn't this interface clock support 
interface clock auto-idle?  If so, then when the UHH's target port is 
forced idle and its initiator port is forced to standby, then shouldn't 
the PRCM automatically idle this interface clock?

Or is there some hardware problem where the PRCM won't auto-idle this 
clock when the UHH is in idle + standby?

> +};
> +

...

> +static struct omap_hwmod_ocp_if omap34xx_ick_cfg__usb_tll_hs = {
> +	.clk		= "usbtll_ick",
> +	.addr		= omap34xx_usb_tll_hs_addrs,
> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
> +/*
> + * This clock should be on/off only with main clock; If auto idle is set,
> + * the usbhs controller prevents the omap to enter in to low power mode,
> + * hence don't use auto idle here.
> + */
> +	.flags		= OCPIF_SWSUP_IDLE,

Same comment here, with the exception of the part about standby since the 
TLL doesn't have an initiator port.


- Paul
