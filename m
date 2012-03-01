Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908Ab2CADLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 22:11:37 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65148 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932689Ab2CADLe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 22:11:34 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of thomas.abraham@linaro.org designates 10.52.68.206 as permitted sender) smtp.mail=thomas.abraham@linaro.org
MIME-Version: 1.0
In-Reply-To: <1330527107-21222-3-git-send-email-k.lewandowsk@samsung.com>
References: <1330527107-21222-1-git-send-email-k.lewandowsk@samsung.com>
	<1330527107-21222-3-git-send-email-k.lewandowsk@samsung.com>
Date: Thu, 1 Mar 2012 08:41:33 +0530
Message-ID: <CAJuYYwSxb6kqtcdF+ifODTw+h657shEqgDuY3O70bph7GxKwwg@mail.gmail.com>
Subject: Re: [PATCH 2/3] [media] s5p-tv: Add initial DT-support for HDMIPHY
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: t.stanislaws@samsung.com, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 February 2012 20:21, Karol Lewandowski <k.lewandowsk@samsung.com> wrote:
> Make it possible to instantiate driver from device tree description.
>
> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/s5p-tv/hdmiphy_drv.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/s5p-tv/hdmiphy_drv.c b/drivers/media/video/s5p-tv/hdmiphy_drv.c
> index 6693f4a..77f5caa 100644
> --- a/drivers/media/video/s5p-tv/hdmiphy_drv.c
> +++ b/drivers/media/video/s5p-tv/hdmiphy_drv.c
> @@ -18,6 +18,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/irq.h>
>  #include <linux/err.h>
> +#include <linux/of.h>
>
>  #include <media/v4l2-subdev.h>
>
> @@ -165,10 +166,19 @@ static const struct i2c_device_id hdmiphy_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, hdmiphy_id);
>
> +#ifdef CONFIG_OF
> +static struct of_device_id hdmiphy_dt_match[] = {
> +       { .compatible = "samsung,exynos4210-hdmiphy" },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(of, hdmiphy_dt_match);
> +#endif
> +
>  static struct i2c_driver hdmiphy_driver = {
>        .driver = {
>                .name   = "s5p-hdmiphy",
>                .owner  = THIS_MODULE,
> +               .of_match_table = of_match_ptr(hdmiphy_dt_match),
>        },
>        .probe          = hdmiphy_probe,
>        .remove         = __devexit_p(hdmiphy_remove),
> --
> 1.7.8.3
>

Reviewed-by: Thomas Abraham <thomas.abraham@linaro.org>
