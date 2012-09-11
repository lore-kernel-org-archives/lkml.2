Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab2IKJNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 05:13:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58505 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab2IKJNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 05:13:16 -0400
Message-ID: <504F009D.3050208@ti.com>
Date: Tue, 11 Sep 2012 11:13:01 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <rnayak@ti.com>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] arm: omap: hwmod: add a new addr space in otg
 for writing to control module
References: <1347354580-5895-1-git-send-email-kishon@ti.com> <1347354580-5895-2-git-send-email-kishon@ti.com>
In-Reply-To: <1347354580-5895-2-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 11:09 AM, Kishon Vijay Abraham I wrote:
> The mailbox register for usb otg in omap is present in control module.
> On detection of any events VBUS or ID, this register should be written
> to send the notification to musb core.
> 
> Till we have a separate control module driver to write to control module,
> omap2430 will handle the register writes to control module by itself. So
> a new address space to represent this control module register is added
> to usb_otg_hs.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Acked-by: Benoit Cousson <b-cousson@ti.com>

> ---
>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> index 242aee4..3c19120 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> @@ -5890,6 +5890,12 @@ static struct omap_hwmod_addr_space omap44xx_usb_otg_hs_addrs[] = {
>  		.pa_end		= 0x4a0ab003,
>  		.flags		= ADDR_TYPE_RT
>  	},
> +	{
> +		/* XXX: Remove this once control module driver is in place */
> +		.pa_start	= 0x4a00233c,
> +		.pa_end		= 0x4a00233f,
> +		.flags		= ADDR_TYPE_RT
> +	},
>  	{ }
>  };
>  
> 

