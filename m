Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab2KWLFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:05:16 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52560 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab2KWLFM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:05:12 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "paul@pwsan.com" <paul@pwsan.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>
CC: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
Subject: RE: [PATCH v3 02/10] ARM: am33xx: clk: Add optional clock for EHRPWM
Thread-Topic: [PATCH v3 02/10] ARM: am33xx: clk: Add optional clock for
 EHRPWM
Thread-Index: AQHNxt1/4fSQcf0ywkKe2Yk19VSmxpf3ReWA
Date: Fri, 23 Nov 2012 11:03:50 +0000
Deferred-Delivery: Fri, 23 Nov 2012 11:03:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9EEA70@DBDE01.ent.ti.com>
References: <1353387831-31538-1-git-send-email-avinashphilip@ti.com>
 <1353387831-31538-3-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1353387831-31538-3-git-send-email-avinashphilip@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 10:33:43, Philip, Avinash wrote:
> EHRPWM module requires explicit clock gating from control module.
> Hence add clock node in clock tree for EHRPWM modules.
> 

Is there any review on this patch?
This patch depends on EHRPWM to work in am335x.

Thanks
Avinash
> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> ---
> :100644 100644 17e3de5... 833260f... M	arch/arm/mach-omap2/clock33xx_data.c
> :100644 100644 a89e825... c0e34e6... M	arch/arm/mach-omap2/control.h
>  arch/arm/mach-omap2/clock33xx_data.c |   37 ++++++++++++++++++++++++++++++++++
>  arch/arm/mach-omap2/control.h        |    8 +++++++
>  2 files changed, 45 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/clock33xx_data.c b/arch/arm/mach-omap2/clock33xx_data.c
> index 17e3de5..833260f 100644
> --- a/arch/arm/mach-omap2/clock33xx_data.c
> +++ b/arch/arm/mach-omap2/clock33xx_data.c
> @@ -995,6 +995,40 @@ static struct clk wdt1_fck = {
>  };
>  
>  /*
> + * PWMSS Time based module clock node. This node is
> + * requred to enable clock gating for EHRPWM TBCLK.
> + */
> +static struct clk ehrpwm0_tbclk = {
> +	.name		= "ehrpwm0_tbclk",
> +	.clkdm_name	= "l4ls_clkdm",
> +	.enable_reg	= AM33XX_CTRL_REGADDR(AM33XX_PWMSS_TBCLK_CLKCTRL),
> +	.enable_bit	= AM33XX_PWMSS0_TBCLKEN_SHIFT,
> +	.ops		= &clkops_omap2_dflt,
> +	.parent		= &l4ls_gclk,
> +	.recalc		= &followparent_recalc,
> +};
> +
> +static struct clk ehrpwm1_tbclk = {
> +	.name		= "ehrpwm1_tbclk",
> +	.clkdm_name	= "l4ls_clkdm",
> +	.enable_reg	= AM33XX_CTRL_REGADDR(AM33XX_PWMSS_TBCLK_CLKCTRL),
> +	.enable_bit	= AM33XX_PWMSS1_TBCLKEN_SHIFT,
> +	.ops		= &clkops_omap2_dflt,
> +	.parent		= &l4ls_gclk,
> +	.recalc		= &followparent_recalc,
> +};
> +
> +static struct clk ehrpwm2_tbclk = {
> +	.name		= "ehrpwm2_tbclk",
> +	.clkdm_name	= "l4ls_clkdm",
> +	.enable_reg	= AM33XX_CTRL_REGADDR(AM33XX_PWMSS_TBCLK_CLKCTRL),
> +	.enable_bit	= AM33XX_PWMSS2_TBCLKEN_SHIFT,
> +	.ops		= &clkops_omap2_dflt,
> +	.parent		= &l4ls_gclk,
> +	.recalc		= &followparent_recalc,
> +};
> +
> +/*
>   * clkdev
>   */
>  static struct omap_clk am33xx_clks[] = {
> @@ -1074,6 +1108,9 @@ static struct omap_clk am33xx_clks[] = {
>  	CLK(NULL,	"clkout2_ck",		&clkout2_ck,	CK_AM33XX),
>  	CLK(NULL,	"timer_32k_ck",		&clkdiv32k_ick,	CK_AM33XX),
>  	CLK(NULL,	"timer_sys_ck",		&sys_clkin_ck,	CK_AM33XX),
> +	CLK(NULL,	"ehrpwm0_tbclk",	&ehrpwm0_tbclk,	CK_AM33XX),
> +	CLK(NULL,	"ehrpwm1_tbclk",	&ehrpwm1_tbclk,	CK_AM33XX),
> +	CLK(NULL,	"ehrpwm2_tbclk",	&ehrpwm2_tbclk,	CK_AM33XX),
>  };
>  
>  int __init am33xx_clk_init(void)
> diff --git a/arch/arm/mach-omap2/control.h b/arch/arm/mach-omap2/control.h
> index a89e825..c0e34e6 100644
> --- a/arch/arm/mach-omap2/control.h
> +++ b/arch/arm/mach-omap2/control.h
> @@ -357,6 +357,14 @@
>  #define AM33XX_CONTROL_STATUS_SYSBOOT1_WIDTH		0x2
>  #define AM33XX_CONTROL_STATUS_SYSBOOT1_MASK		(0x3 << 22)
>  
> +/* AM33XX PWMSS Control register */
> +#define AM33XX_PWMSS_TBCLK_CLKCTRL			0x664
> +
> +/* AM33XX  PWMSS Control bitfields */
> +#define AM33XX_PWMSS0_TBCLKEN_SHIFT			0
> +#define AM33XX_PWMSS1_TBCLKEN_SHIFT			1
> +#define AM33XX_PWMSS2_TBCLKEN_SHIFT			2
> +
>  /* CONTROL OMAP STATUS register to identify OMAP3 features */
>  #define OMAP3_CONTROL_OMAP_STATUS	0x044c
>  
> -- 
> 1.7.0.4
> 
> 

