Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab2JJOeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:34:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42826 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab2JJOeB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:34:01 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Porter, Matt" <mporter@ti.com>, Tony Lindgren <tony@atomide.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>
CC: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ARM: OMAP2+: AM33XX: clock data: fix mcasp entries
Thread-Topic: [PATCH] ARM: OMAP2+: AM33XX: clock data: fix mcasp entries
Thread-Index: AQHNpvO8RH9wZ4vwgUO0GPwPepOn8peymeZw
Date: Wed, 10 Oct 2012 14:33:54 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EB3B5BD@DBDE01.ent.ti.com>
References: <1349879449-22657-1-git-send-email-mporter@ti.com>
In-Reply-To: <1349879449-22657-1-git-send-email-mporter@ti.com>
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

On Wed, Oct 10, 2012 at 20:00:49, Porter, Matt wrote:
> 6ea74cb ARM: OMAP2+: hwmod: get rid of all omap_clk_get_by_name usage
> exposes a bug in the AM33XX clock data for mcasp. After moving to
> clk_get() usage, the _init() of all registered hwmods fails on mcasp0
> due to incorrect clock data causing clk_get() to fail. This causes all
> successive hwmods to fail to _init() leaving them in a bad state.
> 
> This patch updates the mcasp clock entries so clk_get() will succeed.
> It is tested on BeagleBone and is needed for 3.7-rc1 to fix AM33xx
> boot.
> 

Matt,

I have already submitted patch for this and it is accepted and merged in 
Tony's pull request.

https://patchwork.kernel.org/patch/1499271/


Thanks,
Vaibhav

> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  arch/arm/mach-omap2/clock33xx_data.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/clock33xx_data.c b/arch/arm/mach-omap2/clock33xx_data.c
> index b87b88c..0a64139 100644
> --- a/arch/arm/mach-omap2/clock33xx_data.c
> +++ b/arch/arm/mach-omap2/clock33xx_data.c
> @@ -1033,8 +1033,8 @@ static struct omap_clk am33xx_clks[] = {
>  	CLK("481d0000.d_can",	NULL,		&dcan1_fck,	CK_AM33XX),
>  	CLK(NULL,	"debugss_ick",		&debugss_ick,	CK_AM33XX),
>  	CLK(NULL,	"pruss_ocp_gclk",	&pruss_ocp_gclk,	CK_AM33XX),
> -	CLK("davinci-mcasp.0",  NULL,           &mcasp0_fck,    CK_AM33XX),
> -	CLK("davinci-mcasp.1",  NULL,           &mcasp1_fck,    CK_AM33XX),
> +	CLK(NULL,	"mcasp0_fck",		&mcasp0_fck,    CK_AM33XX),
> +	CLK(NULL,	"mcasp1_fck",		&mcasp1_fck,    CK_AM33XX),
>  	CLK("NULL",	"mmc2_fck",		&mmc2_fck,	CK_AM33XX),
>  	CLK(NULL,	"mmu_fck",		&mmu_fck,	CK_AM33XX),
>  	CLK(NULL,	"smartreflex0_fck",	&smartreflex0_fck,	CK_AM33XX),
> -- 
> 1.7.9.5
> 
> 

