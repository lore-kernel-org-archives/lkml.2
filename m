Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab1JKAkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 20:40:15 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:37849 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab1JKAkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 20:40:12 -0400
Date: Mon, 10 Oct 2011 18:40:11 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, khilman@ti.com,
        b-cousson@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
In-Reply-To: <1317901099-2519-1-git-send-email-keshava_mgowda@ti.com>
Message-ID: <alpine.DEB.2.00.1110101838500.5205@utopia.booyaka.com>
References: <1317901099-2519-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

and some comments on this one ...

On Thu, 6 Oct 2011, Keshava Munegowda wrote:

> From: Benoit Cousson <b-cousson@ti.com>
> 
> Following 2 hwmod structures are added
> 1. usb_host_hs
>      The hwmod of usbhs with uhh, ehci and ohci base addresses
>      functional clock and ehci, ohci irqs
> 
> 2. usb_tll_hs
>       hwmod of usbhs with the TLL base address and irq.
> 
> Signed-off-by: Benoit Cousson <b-cousson@ti.com>
> 
> - rebased to kernel version 3.0
> - Workarounds for hardware issues
> 
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
> Reviewed-by: Partha Basak <parthab@india.ti.com>
> ---
>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  206 +++++++++++++++++++++++++++-
>  1 files changed, 205 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> index 6201422..e404fd6 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c

...

> +static struct omap_hwmod_ocp_if omap44xx_l4_cfg__usb_tll_hs = {
> +	.master		= &omap44xx_l4_cfg_hwmod,
> +	.slave		= &omap44xx_usb_tll_hs_hwmod,
> +	.addr		= omap44xx_usb_tll_hs_addrs,
> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
> +};

This one has the .master pointing to something reasonable, but is missing 
a .clk entry.


- Paul
