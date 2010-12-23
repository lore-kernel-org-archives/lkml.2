Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab0LWIgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 03:36:53 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:51546 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752411Ab0LWIgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 03:36:51 -0500
Date: Thu, 23 Dec 2010 10:36:44 +0200
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Anand Gadiyar <gadiyar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org
Subject: Re: linux-next: manual merge of the usb tree with the omap tree
Message-ID: <20101223083643.GA2375@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20101223171859.f6842045.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20101223171859.f6842045.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Thu, Dec 23, 2010 at 05:18:59PM +1100, Stephen Rothwell wrote:
>Today's linux-next merge of the usb tree got a conflict in
>arch/arm/mach-omap2/clock3xxx_data.c and
>arch/arm/mach-omap2/clock44xx_data.c between various commits from the omap
>tree and various commits from the usb tree.
>
>I did a quick fix (which may be completely wrong - see below).

could you check if the below fix is good enough. The musb part seems to
be fine.

>diff --cc arch/arm/mach-omap2/clock3xxx_data.c
>index 9ab817e,0579604..0000000
>--- a/arch/arm/mach-omap2/clock3xxx_data.c
>+++ b/arch/arm/mach-omap2/clock3xxx_data.c
>@@@ -3275,17 -3267,18 +3275,18 @@@ static struct omap_clk omap3xxx_clks[]
>  	CLK(NULL,	"gfx_l3_ick",	&gfx_l3_ick,	CK_3430ES1),
>  	CLK(NULL,	"gfx_cg1_ck",	&gfx_cg1_ck,	CK_3430ES1),
>  	CLK(NULL,	"gfx_cg2_ck",	&gfx_cg2_ck,	CK_3430ES1),
> -	CLK(NULL,	"sgx_fck",	&sgx_fck,	CK_3430ES2 | CK_3517),
> -	CLK(NULL,	"sgx_ick",	&sgx_ick,	CK_3430ES2 | CK_3517),
> +	CLK(NULL,	"sgx_fck",	&sgx_fck,	CK_3430ES2PLUS | CK_3517 | CK_36XX),
> +	CLK(NULL,	"sgx_ick",	&sgx_ick,	CK_3430ES2PLUS | CK_3517 | CK_36XX),
>  	CLK(NULL,	"d2d_26m_fck",	&d2d_26m_fck,	CK_3430ES1),
> -	CLK(NULL,	"modem_fck",	&modem_fck,	CK_343X),
> -	CLK(NULL,	"sad2d_ick",	&sad2d_ick,	CK_343X),
> -	CLK(NULL,	"mad2d_ick",	&mad2d_ick,	CK_343X),
> +	CLK(NULL,	"modem_fck",	&modem_fck,	CK_34XX | CK_36XX),
> +	CLK(NULL,	"sad2d_ick",	&sad2d_ick,	CK_34XX | CK_36XX),
> +	CLK(NULL,	"mad2d_ick",	&mad2d_ick,	CK_34XX | CK_36XX),
>  	CLK(NULL,	"gpt10_fck",	&gpt10_fck,	CK_3XXX),
>  	CLK(NULL,	"gpt11_fck",	&gpt11_fck,	CK_3XXX),
> -	CLK(NULL,	"cpefuse_fck",	&cpefuse_fck,	CK_3430ES2 | CK_AM35XX),
> -	CLK(NULL,	"ts_fck",	&ts_fck,	CK_3430ES2 | CK_AM35XX),
> -	CLK(NULL,	"usbtll_fck",	&usbtll_fck,	CK_3430ES2 | CK_AM35XX),
> +	CLK(NULL,	"cpefuse_fck",	&cpefuse_fck,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
> +	CLK(NULL,	"ts_fck",	&ts_fck,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
> +	CLK(NULL,	"usbtll_fck",	&usbtll_fck,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>+ 	CLK("ehci-omap.0",	"usbtll_fck",	&usbtll_fck,	CK_3430ES2 | CK_AM35XX),
>  	CLK("omap-mcbsp.1",	"prcm_fck",	&core_96m_fck,	CK_3XXX),
>  	CLK("omap-mcbsp.5",	"prcm_fck",	&core_96m_fck,	CK_3XXX),
>  	CLK(NULL,	"core_96m_fck",	&core_96m_fck,	CK_3XXX),
>@@@ -3309,26 -3302,27 +3310,27 @@@
>  	CLK(NULL,	"core_12m_fck",	&core_12m_fck,	CK_3XXX),
>  	CLK("omap_hdq.0", "fck",	&hdq_fck,	CK_3XXX),
>  	CLK(NULL,	"ssi_ssr_fck",	&ssi_ssr_fck_3430es1,	CK_3430ES1),
> -	CLK(NULL,	"ssi_ssr_fck",	&ssi_ssr_fck_3430es2,	CK_3430ES2),
> +	CLK(NULL,	"ssi_ssr_fck",	&ssi_ssr_fck_3430es2,	CK_3430ES2PLUS | CK_36XX),
>  	CLK(NULL,	"ssi_sst_fck",	&ssi_sst_fck_3430es1,	CK_3430ES1),
> -	CLK(NULL,	"ssi_sst_fck",	&ssi_sst_fck_3430es2,	CK_3430ES2),
> +	CLK(NULL,	"ssi_sst_fck",	&ssi_sst_fck_3430es2,	CK_3430ES2PLUS | CK_36XX),
>  	CLK(NULL,	"core_l3_ick",	&core_l3_ick,	CK_3XXX),
>- 	CLK("musb_hdrc",	"ick",	&hsotgusb_ick_3430es1,	CK_3430ES1),
>- 	CLK("musb_hdrc",	"ick",	&hsotgusb_ick_3430es2,	CK_3430ES2PLUS | CK_36XX),
>+ 	CLK("musb-omap2430",	"ick",	&hsotgusb_ick_3430es1,	CK_3430ES1),
> -	CLK("musb-omap2430",	"ick",	&hsotgusb_ick_3430es2,	CK_3430ES2),
>++	CLK("musb-omap2430",	"ick",	&hsotgusb_ick_3430es2,	CK_3430ES2PLUS | CK_36XX),
>  	CLK(NULL,	"sdrc_ick",	&sdrc_ick,	CK_3XXX),
>  	CLK(NULL,	"gpmc_fck",	&gpmc_fck,	CK_3XXX),
> -	CLK(NULL,	"security_l3_ick", &security_l3_ick, CK_343X),
> -	CLK(NULL,	"pka_ick",	&pka_ick,	CK_343X),
> +	CLK(NULL,	"security_l3_ick", &security_l3_ick, CK_34XX | CK_36XX),
> +	CLK(NULL,	"pka_ick",	&pka_ick,	CK_34XX | CK_36XX),
>  	CLK(NULL,	"core_l4_ick",	&core_l4_ick,	CK_3XXX),
> -	CLK(NULL,	"usbtll_ick",	&usbtll_ick,	CK_3430ES2 | CK_AM35XX),
> +	CLK(NULL,	"usbtll_ick",	&usbtll_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>+ 	CLK("ehci-omap.0",	"usbtll_ick",	&usbtll_ick,	CK_3430ES2 | CK_AM35XX),
> -	CLK("mmci-omap-hs.2",	"ick",	&mmchs3_ick,	CK_3430ES2 | CK_AM35XX),
> -	CLK(NULL,	"icr_ick",	&icr_ick,	CK_343X),
> -	CLK("omap-aes",	"ick",	&aes2_ick,	CK_343X),
> -	CLK("omap-sham",	"ick",	&sha12_ick,	CK_343X),
> -	CLK(NULL,	"des2_ick",	&des2_ick,	CK_343X),
> +	CLK("mmci-omap-hs.2",	"ick",	&mmchs3_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
> +	CLK(NULL,	"icr_ick",	&icr_ick,	CK_34XX | CK_36XX),
> +	CLK("omap-aes",	"ick",	&aes2_ick,	CK_34XX | CK_36XX),
> +	CLK("omap-sham",	"ick",	&sha12_ick,	CK_34XX | CK_36XX),
> +	CLK(NULL,	"des2_ick",	&des2_ick,	CK_34XX | CK_36XX),
>  	CLK("mmci-omap-hs.1",	"ick",	&mmchs2_ick,	CK_3XXX),
>  	CLK("mmci-omap-hs.0",	"ick",	&mmchs1_ick,	CK_3XXX),
> -	CLK(NULL,	"mspro_ick",	&mspro_ick,	CK_343X),
> +	CLK(NULL,	"mspro_ick",	&mspro_ick,	CK_34XX | CK_36XX),
>  	CLK("omap_hdq.0", "ick",	&hdq_ick,	CK_3XXX),
>  	CLK("omap2_mcspi.4", "ick",	&mcspi4_ick,	CK_3XXX),
>  	CLK("omap2_mcspi.3", "ick",	&mcspi3_ick,	CK_3XXX),
>@@@ -3361,14 -3355,17 +3363,17 @@@
>  	CLK("omapdss",	"video_fck",	&dss_96m_fck,	CK_3XXX),
>  	CLK("omapdss",	"dss2_fck",	&dss2_alwon_fck, CK_3XXX),
>  	CLK("omapdss",	"ick",		&dss_ick_3430es1,	CK_3430ES1),
> -	CLK("omapdss",	"ick",		&dss_ick_3430es2,	CK_3430ES2 | CK_AM35XX),
> -	CLK(NULL,	"cam_mclk",	&cam_mclk,	CK_343X),
> -	CLK(NULL,	"cam_ick",	&cam_ick,	CK_343X),
> -	CLK(NULL,	"csi2_96m_fck",	&csi2_96m_fck,	CK_343X),
> -	CLK(NULL,	"usbhost_120m_fck", &usbhost_120m_fck, CK_3430ES2 | CK_AM35XX),
> +	CLK("omapdss",	"ick",		&dss_ick_3430es2,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
> +	CLK(NULL,	"cam_mclk",	&cam_mclk,	CK_34XX | CK_36XX),
> +	CLK(NULL,	"cam_ick",	&cam_ick,	CK_34XX | CK_36XX),
> +	CLK(NULL,	"csi2_96m_fck",	&csi2_96m_fck,	CK_34XX | CK_36XX),
> +	CLK(NULL,	"usbhost_120m_fck", &usbhost_120m_fck, CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>+ 	CLK("ehci-omap.0",	"hs_fck", &usbhost_120m_fck, CK_3430ES2 | CK_AM35XX),
> -	CLK(NULL,	"usbhost_48m_fck", &usbhost_48m_fck, CK_3430ES2 | CK_AM35XX),
> +	CLK(NULL,	"usbhost_48m_fck", &usbhost_48m_fck, CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>+ 	CLK("ehci-omap.0",	"fs_fck", &usbhost_48m_fck, CK_3430ES2 | CK_AM35XX),
> -	CLK(NULL,	"usbhost_ick",	&usbhost_ick,	CK_3430ES2 | CK_AM35XX),
> +	CLK(NULL,	"usbhost_ick",	&usbhost_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>+ 	CLK("ehci-omap.0",	"usbhost_ick",	&usbhost_ick,	CK_3430ES2 | CK_AM35XX),
> -	CLK(NULL,	"usim_fck",	&usim_fck,	CK_3430ES2),
> +	CLK(NULL,	"usim_fck",	&usim_fck,	CK_3430ES2PLUS | CK_36XX),
>  	CLK(NULL,	"gpt1_fck",	&gpt1_fck,	CK_3XXX),
>  	CLK(NULL,	"wkup_32k_fck",	&wkup_32k_fck,	CK_3XXX),
>  	CLK(NULL,	"gpio1_dbck",	&gpio1_dbck,	CK_3XXX),
>diff --cc arch/arm/mach-omap2/clock44xx_data.c
>index c426adc,bfcd19f..0000000
>--- a/arch/arm/mach-omap2/clock44xx_data.c
>+++ b/arch/arm/mach-omap2/clock44xx_data.c
>@@@ -3198,6 -2937,10 +3198,7 @@@ static struct omap_clk omap44xx_clks[]
>  	CLK(NULL,	"uart3_fck",			&uart3_fck,	CK_443X),
>  	CLK(NULL,	"uart4_fck",			&uart4_fck,	CK_443X),
>  	CLK(NULL,	"usb_host_fs_fck",		&usb_host_fs_fck,	CK_443X),
>+ 	CLK("ehci-omap.0",	"fs_fck",		&usb_host_fs_fck,	CK_443X),
> -	CLK(NULL,	"usb_host_hs_utmi_p3_clk",	&usb_host_hs_utmi_p3_clk,	CK_443X),
> -	CLK(NULL,	"usb_host_hs_hsic60m_p1_clk",	&usb_host_hs_hsic60m_p1_clk,	CK_443X),
> -	CLK(NULL,	"usb_host_hs_hsic60m_p2_clk",	&usb_host_hs_hsic60m_p2_clk,	CK_443X),
>  	CLK(NULL,	"utmi_p1_gfclk",		&utmi_p1_gfclk,	CK_443X),
>  	CLK(NULL,	"usb_host_hs_utmi_p1_clk",	&usb_host_hs_utmi_p1_clk,	CK_443X),
>  	CLK(NULL,	"utmi_p2_gfclk",		&utmi_p2_gfclk,	CK_443X),

-- 
balbi
