Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab2JJMfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:35:11 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44958 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753512Ab2JJMfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:35:06 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18L9zwVbAALvwOeFtpJhpKPlbgpDYNCSH11w/cet7
	ZGjKIgtO/q+0nJ
Message-ID: <50756B6D.8070308@gmx.de>
Date: Wed, 10 Oct 2012 12:34:53 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: Inki Dae <inki.dae@samsung.com>, kernel-janitors@vger.kernel.org,
        Donghwa Lee <dh09.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers/video/exynos/exynos_mipi_dsi.c: fix error
 return code
References: <1349268044-32616-2-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1349268044-32616-2-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 12:40 PM, Peter Senna Tschudin wrote:
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
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Applied.


Thanks,

Florian Tobias Schandinat


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

