Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2EBHE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 03:04:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40676 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab2EBHE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 03:04:57 -0400
MIME-Version: 1.0
In-Reply-To: <1335935266-25289-6-git-send-email-thomas.abraham@linaro.org>
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
	<1335935266-25289-6-git-send-email-thomas.abraham@linaro.org>
Date: Wed, 2 May 2012 16:04:55 +0900
X-Google-Sender-Auth: rC7Rn23LvyOozk81zX008MSBwJQ
Message-ID: <CAH9JG2UwFc+vo1chsH_1XsgCYypLFV2e3AVOrh0=F+bMRKHBZA@mail.gmail.com>
Subject: Re: [PATCH 5/7] ARM: Samsung: Add support for MSHC controller clocks
From: Kyungmin Park <kmpark@infradead.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

I suggest to split the patches into mmc part and samsung specific
part. As you know previous time there's mismatch between mmc and
samsung. So split the patches and send it  separately to avoid merge
conflict and mismatch.

I think regardless mmc changes, it can be merged into samsung tree directly.

Thank you,
Kyungmin Park

On 5/2/12, Thomas Abraham <thomas.abraham@linaro.org> wrote:
> Add clock instances for bus interface unit clock and card interface unit
> clock of the all four MSHC controller instances.
>
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> ---
>  arch/arm/mach-exynos/clock-exynos5.c |   45
> ++++++++++++----------------------
>  1 files changed, 16 insertions(+), 29 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/clock-exynos5.c
> b/arch/arm/mach-exynos/clock-exynos5.c
> index 7c0f810..4e17131 100644
> --- a/arch/arm/mach-exynos/clock-exynos5.c
> +++ b/arch/arm/mach-exynos/clock-exynos5.c
> @@ -524,35 +524,30 @@ static struct clk exynos5_init_clocks_off[] = {
>  		.enable		= exynos5_clk_ip_peris_ctrl,
>  		.ctrlbit	= (1 << 19),
>  	}, {
> -		.name		= "hsmmc",
> -		.devname	= "exynos4-sdhci.0",
> +		.name		= "biu",
> +		.devname	= "dw_mmc.0",
>  		.parent		= &exynos5_clk_aclk_200.clk,
>  		.enable		= exynos5_clk_ip_fsys_ctrl,
>  		.ctrlbit	= (1 << 12),
>  	}, {
> -		.name		= "hsmmc",
> -		.devname	= "exynos4-sdhci.1",
> +		.name		= "biu",
> +		.devname	= "dw_mmc.1",
>  		.parent		= &exynos5_clk_aclk_200.clk,
>  		.enable		= exynos5_clk_ip_fsys_ctrl,
>  		.ctrlbit	= (1 << 13),
>  	}, {
> -		.name		= "hsmmc",
> -		.devname	= "exynos4-sdhci.2",
> +		.name		= "biu",
> +		.devname	= "dw_mmc.2",
>  		.parent		= &exynos5_clk_aclk_200.clk,
>  		.enable		= exynos5_clk_ip_fsys_ctrl,
>  		.ctrlbit	= (1 << 14),
>  	}, {
> -		.name		= "hsmmc",
> -		.devname	= "exynos4-sdhci.3",
> +		.name		= "biu",
> +		.devname	= "dw_mmc.3",
>  		.parent		= &exynos5_clk_aclk_200.clk,
>  		.enable		= exynos5_clk_ip_fsys_ctrl,
>  		.ctrlbit	= (1 << 15),
>  	}, {
> -		.name		= "dwmci",
> -		.parent		= &exynos5_clk_aclk_200.clk,
> -		.enable		= exynos5_clk_ip_fsys_ctrl,
> -		.ctrlbit	= (1 << 16),
> -	}, {
>  		.name		= "sata",
>  		.devname	= "ahci",
>  		.enable		= exynos5_clk_ip_fsys_ctrl,
> @@ -882,8 +877,8 @@ static struct clksrc_clk exynos5_clk_sclk_uart3 = {
>
>  static struct clksrc_clk exynos5_clk_sclk_mmc0 = {
>  	.clk	= {
> -		.name		= "sclk_mmc",
> -		.devname	= "exynos4-sdhci.0",
> +		.name		= "ciu",
> +		.devname	= "dw_mmc.0",
>  		.parent		= &exynos5_clk_dout_mmc0.clk,
>  		.enable		= exynos5_clksrc_mask_fsys_ctrl,
>  		.ctrlbit	= (1 << 0),
> @@ -893,8 +888,8 @@ static struct clksrc_clk exynos5_clk_sclk_mmc0 = {
>
>  static struct clksrc_clk exynos5_clk_sclk_mmc1 = {
>  	.clk	= {
> -		.name		= "sclk_mmc",
> -		.devname	= "exynos4-sdhci.1",
> +		.name		= "ciu",
> +		.devname	= "dw_mmc.1",
>  		.parent		= &exynos5_clk_dout_mmc1.clk,
>  		.enable		= exynos5_clksrc_mask_fsys_ctrl,
>  		.ctrlbit	= (1 << 4),
> @@ -904,8 +899,8 @@ static struct clksrc_clk exynos5_clk_sclk_mmc1 = {
>
>  static struct clksrc_clk exynos5_clk_sclk_mmc2 = {
>  	.clk	= {
> -		.name		= "sclk_mmc",
> -		.devname	= "exynos4-sdhci.2",
> +		.name		= "ciu",
> +		.devname	= "dw_mmc.2",
>  		.parent		= &exynos5_clk_dout_mmc2.clk,
>  		.enable		= exynos5_clksrc_mask_fsys_ctrl,
>  		.ctrlbit	= (1 << 8),
> @@ -915,8 +910,8 @@ static struct clksrc_clk exynos5_clk_sclk_mmc2 = {
>
>  static struct clksrc_clk exynos5_clk_sclk_mmc3 = {
>  	.clk	= {
> -		.name		= "sclk_mmc",
> -		.devname	= "exynos4-sdhci.3",
> +		.name		= "ciu",
> +		.devname	= "dw_mmc.3",
>  		.parent		= &exynos5_clk_dout_mmc3.clk,
>  		.enable		= exynos5_clksrc_mask_fsys_ctrl,
>  		.ctrlbit	= (1 << 12),
> @@ -927,14 +922,6 @@ static struct clksrc_clk exynos5_clk_sclk_mmc3 = {
>  static struct clksrc_clk exynos5_clksrcs[] = {
>  	{
>  		.clk	= {
> -			.name		= "sclk_dwmci",
> -			.parent		= &exynos5_clk_dout_mmc4.clk,
> -			.enable		= exynos5_clksrc_mask_fsys_ctrl,
> -			.ctrlbit	= (1 << 16),
> -		},
> -		.reg_div = { .reg = EXYNOS5_CLKDIV_FSYS3, .shift = 8, .size = 8 },
> -	}, {
> -		.clk	= {
>  			.name		= "sclk_fimd",
>  			.devname	= "s3cfb.1",
>  			.enable		= exynos5_clksrc_mask_disp1_0_ctrl,
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
