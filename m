Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158Ab1AaFBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 00:01:31 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:44888 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698Ab1AaFBa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 00:01:30 -0500
MIME-Version: 1.0
In-Reply-To: <1296415587-4524-1-git-send-email-weil@mail.berlios.de>
References: <1296415587-4524-1-git-send-email-weil@mail.berlios.de>
Date: Mon, 31 Jan 2011 10:31:27 +0530
Message-ID: <AANLkTi=iqgCG_ZyzZ-EoPu6OGxtnJc0CRrLDPHOQZ90-@mail.gmail.com>
Subject: Re: [PATCH] arm: Fix possible memory leak
From: "Gulati, Shweta" <shweta.gulati@ti.com>
To: Stefan Weil <weil@mail.berlios.de>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked. Will make sure there is no Memory Leak issue in Smartreflex Driver.

On Mon, Jan 31, 2011 at 12:56 AM, Stefan Weil <weil@mail.berlios.de> wrote:
> sr_info was allocated and needs a kfree before returning.
>
> This error was reported by cppcheck:
> arch/arm/mach-omap2/smartreflex.c:837: error: Memory leak: sr_info
>
> To: Tony Lindgren <tony@atomide.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-omap@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Stefan Weil <weil@mail.berlios.de>
> ---
>  arch/arm/mach-omap2/smartreflex.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
> index af39d17..07324607 100644
> --- a/arch/arm/mach-omap2/smartreflex.c
> +++ b/arch/arm/mach-omap2/smartreflex.c
> @@ -832,7 +832,8 @@ static int __init omap_sr_probe(struct platform_device *pdev)
>
>        if (!pdata) {
>                dev_err(&pdev->dev, "%s: platform data missing\n", __func__);
> -               return -EINVAL;
> +               ret = -EINVAL;
> +               goto err_free_devinfo;
>        }
>
>        mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> --
> 1.7.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Thanks,
Regards,
Shweta
