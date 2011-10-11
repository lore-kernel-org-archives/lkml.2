Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab1JKAiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 20:38:13 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:37828 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab1JKAiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 20:38:11 -0400
Date: Mon, 10 Oct 2011 18:38:10 -0600 (MDT)
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
Message-ID: <alpine.DEB.2.00.1110101835070.5205@utopia.booyaka.com>
References: <1317901123-2546-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

so I just noticed another problem with these hwmods:

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

...

> +static struct omap_hwmod_ocp_if omap34xx_ick_cfg__usb_tll_hs = {

This interface is missing a .master and .slave.  It must have both.  So, 
dropping this patch until it's fixed.

Clearly we also need to modify the hwmod code needs to reject any 
instances where either .master or .slave is NULL.


- Paul
