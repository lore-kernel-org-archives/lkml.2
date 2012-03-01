Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab2CADVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 22:21:05 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59076 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2CADVA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 22:21:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of thomas.abraham@linaro.org designates 10.52.174.162 as permitted sender) smtp.mail=thomas.abraham@linaro.org
MIME-Version: 1.0
In-Reply-To: <1330523672-16453-1-git-send-email-k.lewandowsk@samsung.com>
References: <1330523672-16453-1-git-send-email-k.lewandowsk@samsung.com>
Date: Thu, 1 Mar 2012 08:50:59 +0530
Message-ID: <CAJuYYwQ54idFZGvyujimrhhedSveK9ob8j+686D6ABdavAA_SA@mail.gmail.com>
Subject: Re: [PATCH] [media] s5p-g2d: Make it possible to instantiate driver
 from DT
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: k.debski@samsung.com, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 February 2012 19:24, Karol Lewandowski <k.lewandowsk@samsung.com> wrote:
> This driver requires standard properties only (address and irq)
> which are automatically marshalled into plain old resources by OF core.
>
> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/s5p-g2d/g2d.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-g2d/g2d.c
> index febaa67..e7c0020 100644
> --- a/drivers/media/video/s5p-g2d/g2d.c
> +++ b/drivers/media/video/s5p-g2d/g2d.c
> @@ -20,6 +20,7 @@
>  #include <linux/interrupt.h>
>
>  #include <linux/platform_device.h>
> +#include <linux/of.h>
>  #include <media/v4l2-mem2mem.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
> @@ -795,12 +796,20 @@ static int g2d_remove(struct platform_device *pdev)
>        return 0;
>  }
>
> +#ifdef CONFIG_OF
> +static struct of_device_id g2d_dt_match[] = {
> +       { .compatible = "samsung,exynos4210-g2d" },

The comment about the base version in the previous patch applies here too.

> +       {},
> +};
> +#endif
> +
>  static struct platform_driver g2d_pdrv = {
>        .probe          = g2d_probe,
>        .remove         = g2d_remove,
>        .driver         = {
>                .name = G2D_NAME,
>                .owner = THIS_MODULE,
> +               .of_match_table = of_match_ptr(g2d_dt_match),
>        },
>  };
>
> --
> 1.7.8.3

Reviewed-by: Thomas Abraham <thomas.abraham@linaro.org>
