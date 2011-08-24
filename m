Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab1HXG57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:57:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54719 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956Ab1HXG56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:57:58 -0400
Message-ID: <4E54A0EA.1080102@ti.com>
Date: Wed, 24 Aug 2011 09:57:46 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Keshava Munegowda <keshava_mgowda@ti.com>, <b-cousson@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>, <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        <khilman@ti.com>, <paul@pwsan.com>, <johnstul@us.ibm.com>,
        <vishwanath.bs@ti.com>, <tom.leiming@gmail.com>,
        <toddpoynor@google.com>
Subject: Re: [PATCH 1/5 v5] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
References: <1313581439-4279-1-git-send-email-keshava_mgowda@ti.com> <1313581439-4279-2-git-send-email-keshava_mgowda@ti.com>
In-Reply-To: <1313581439-4279-2-git-send-email-keshava_mgowda@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/17/2011 02:43 PM, Keshava Munegowda wrote:
> From: Benoit Cousson <b-cousson@ti.com>
> 
> Following 4 hwmod strcuture are added:
> UHH hwmod of usbhs with uhh base address and functional clock,
> EHCI hwmod with irq and base address,
> OHCI hwmod with irq and base address,
> TLL hwmod of usbhs with the TLL base address and irq.
> 
> Signed-off-by: Benoit Cousson <b-cousson@ti.com>
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
> ---
>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  244 ++++++++++++++++++++++++++++
>  1 files changed, 244 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> index 6201422..d8f08fa 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> @@ -68,6 +68,10 @@ static struct omap_hwmod omap44xx_mmc2_hwmod;
>  static struct omap_hwmod omap44xx_mpu_hwmod;
>  static struct omap_hwmod omap44xx_mpu_private_hwmod;
>  static struct omap_hwmod omap44xx_usb_otg_hs_hwmod;
> +static struct omap_hwmod omap44xx_usb_host_hs_hwmod;
> +static struct omap_hwmod omap44xx_usbhs_ohci_hwmod;
> +static struct omap_hwmod omap44xx_usbhs_ehci_hwmod;
> +static struct omap_hwmod omap44xx_usb_tll_hs_hwmod;
>  
>  /*
>   * Interconnects omap_hwmod structures
> @@ -5336,6 +5340,242 @@ static struct omap_hwmod omap44xx_wd_timer3_hwmod = {
>  	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
>  };
>  
> +/*
> + * 'usb_host_hs' class
> + * high-speed multi-port usb host controller
> + */
> +static struct omap_hwmod_ocp_if omap44xx_usb_host_hs__l3_main_2 = {
> +	.master		= &omap44xx_usb_host_hs_hwmod,
> +	.slave		= &omap44xx_l3_main_2_hwmod,
> +	.clk		= "l3_div_ck",
> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
> +static struct omap_hwmod_class_sysconfig omap44xx_usb_host_hs_sysc = {
> +	.rev_offs	= 0x0000,
> +	.sysc_offs	= 0x0010,
> +	.syss_offs	= 0x0014,
> +	.sysc_flags	= (SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE),

what about SYSC_HAS_SOFTRESET?

> +	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |

Did you intentionally miss out SIDLE_SMART_WKUP ?

> +			   MSTANDBY_FORCE | MSTANDBY_NO | MSTANDBY_SMART |
> +				MSTANDBY_SMART_WKUP),
> +	.sysc_fields	= &omap_hwmod_sysc_type2,
> +};
> +

...
<snip>
...

> +
> +/*
> + * 'usb_tll_hs' class
> + * usb_tll_hs module is the adapter on the usb_host_hs ports
> + */
> +static struct omap_hwmod_class_sysconfig omap44xx_usb_tll_hs_sysc = {
> +	.rev_offs	= 0x0000,
> +	.sysc_offs	= 0x0010,
> +	.syss_offs	= 0x0014,
> +	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_SIDLEMODE),

what about SYSC_HAS_SOFTRESET, SYSC_HAS_ENAWAKEUP and
SYSC_HAS_CLOCKACTIVITY?

> +	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
> +	.sysc_fields	= &omap_hwmod_sysc_type1,
> +};
> +
> +static struct omap_hwmod_class omap44xx_usb_tll_hs_hwmod_class = {
> +	.name = "usbhs_tll",
> +	.sysc = &omap44xx_usb_tll_hs_sysc,
> +};
> +

...


regards,
-roger
