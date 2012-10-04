Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2JDHmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 03:42:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48836 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab2JDHmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 03:42:42 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-91-506d3df15606
Message-id: <506D3DE4.8090207@samsung.com>
Date: Thu, 04 Oct 2012 16:42:28 +0900
From: Donghwa Lee <dh09.lee@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Inki Dae <inki.dae@samsung.com>, kernel-janitors@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers/video/exynos/exynos_mipi_dsi.c: fix error
 return code
References: <1349268044-32616-2-git-send-email-peter.senna@gmail.com>
In-reply-to: <1349268044-32616-2-git-send-email-peter.senna@gmail.com>
Content-type: text/plain; charset=EUC-KR
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQd2PtrkBBq17xCy23pK2ONH3gdXi
	8q45bA7MHp83yQUwRnHZpKTmZJalFunbJXBlXL0+j7VgLX/FhHM9TA2MDTxdjJwcEgImEjvm
	zGGEsMUkLtxbz9bFyMUhJDCdUeLpnQ52COclo8TZTU/YQKp4BbQkjuzYww5iswioSnxc8p8F
	xGYT0JA4fe8+WFxUIEBiY+sZdoh6QYkfk++B1YgIGEj83XOVGWQos8AzRonPD36CJYQFIiRW
	/OljBrGFBFwlOmd1gMU5Bdwkdv15DmYzAy2Y+vo0I4QtL7F5zVvmCYwCs5DsmIWkbBaSsgWM
	zKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgsPymfQOxlUNFocYBTgYlXh4LSblBAixJpYV
	V+YeYpTgYFYS4d2smBsgxJuSWFmVWpQfX1Sak1p8iFGag0VJnLfZIyVASCA9sSQ1OzW1ILUI
	JsvEwSnVwLiusXzN5ll7Kmcz6+dksO3x+vmivJGrjEM0dV5KQdCG7e8XRzKoX5omUPjtTuJU
	PTfm9+ec5CQmTJS0l2d9O0H4zOXAvxX7PU43Wz8XtCmd4c/wQnTtJqXeoC/dl1+3l7x+MOVz
	hNeqP6cdAzhf7zjA3W7whyNy4rrIE7c/Hilb9IiJrS5tb58SS3FGoqEWc1FxIgAr3K/FRwIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, Oct 03, 2012 at 21:40, Peter Senna Tschudin wrote

> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Convert a nonnegative error return code to a negative one, as returned
> elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> // </smpl>
> 


I agree with you. Other codes is already used negative error return codes.

> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> ---
>  drivers/video/exynos/exynos_mipi_dsi.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/video/exynos/exynos_mipi_dsi.c b/drivers/video/exynos/exynos_mipi_dsi.c
> index c4f25de..07d70a3 100644
> --- a/drivers/video/exynos/exynos_mipi_dsi.c
> +++ b/drivers/video/exynos/exynos_mipi_dsi.c
> @@ -375,6 +375,7 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
>  	dsim->clock = clk_get(&pdev->dev, "dsim0");
>  	if (IS_ERR(dsim->clock)) {
>  		dev_err(&pdev->dev, "failed to get dsim clock source\n");
> +		ret = -ENODEV;
>  		goto err_clock_get;
>  	}
>  
> @@ -383,6 +384,7 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!res) {
>  		dev_err(&pdev->dev, "failed to get io memory region\n");
> +		ret = -ENODEV;
>  		goto err_platform_get;
>  	}
>  
> @@ -407,6 +409,7 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
>  	dsim_ddi = exynos_mipi_dsi_bind_lcd_ddi(dsim, dsim_pd->lcd_panel_name);
>  	if (!dsim_ddi) {
>  		dev_err(&pdev->dev, "mipi_dsim_ddi object not found.\n");
> +		ret = -EINVAL;
>  		goto err_bind;
>  	}
>  
> 
> 


