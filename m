Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab2IFPfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:35:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36019 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab2IFPfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:35:30 -0400
Message-ID: <5048C2A2.2020104@ti.com>
Date: Thu, 6 Sep 2012 21:04:58 +0530
From: Vaibhav Hiremath <hvaibhav@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/3] arm: omap: hwmod: add a new addr space in otg for
 writing to control module
References: <1346943331-18120-1-git-send-email-kishon@ti.com> <1346943331-18120-2-git-send-email-kishon@ti.com>
In-Reply-To: <1346943331-18120-2-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 9/6/2012 8:25 PM, Kishon Vijay Abraham I wrote:
> The mailbox register for usb otg in omap is present in control module.
> On detection of any events VBUS or ID, this register should be written
> to send the notification to musb core.
> 
> Till we have a separate control module driver to write to control module,
> omap2430 will handle the register writes to control module by itself. So
> a new address space to represent this control module register is added
> to usb_otg_hs.
> 
> Cc: Benoit Cousson <b-cousson@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> index 242aee4..02341bc 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> @@ -5890,6 +5890,11 @@ static struct omap_hwmod_addr_space omap44xx_usb_otg_hs_addrs[] = {
>  		.pa_end		= 0x4a0ab003,
>  		.flags		= ADDR_TYPE_RT
>  	},
> +	{
> +		.pa_start	= 0x4a00233c,
> +		.pa_end		= 0x4a00233f,
> +		.flags		= ADDR_TYPE_RT
> +	},

I do not have any objection/comment here, but I believe this is control
module address space required for USB module, right?
I am not sure this is right way of accessing control module space.
Actually Control Module Access required for drivers is one of the
blocking issue we have currently.

Also there was some effort put up by 'Konstantine' to convert Control
module to MFD driver, I haven't seen any further update on it. But it
would be good to check with him.

Thanks,
Vaibhav
>  	{ }
>  };
>  
> 
