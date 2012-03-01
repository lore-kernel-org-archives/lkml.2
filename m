Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485Ab2CADSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 22:18:33 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55857 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962Ab2CADSR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 22:18:17 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of thomas.abraham@linaro.org designates 10.52.96.70 as permitted sender) smtp.mail=thomas.abraham@linaro.org
MIME-Version: 1.0
In-Reply-To: <1330527107-21222-4-git-send-email-k.lewandowsk@samsung.com>
References: <1330527107-21222-1-git-send-email-k.lewandowsk@samsung.com>
	<1330527107-21222-4-git-send-email-k.lewandowsk@samsung.com>
Date: Thu, 1 Mar 2012 08:48:15 +0530
Message-ID: <CAJuYYwSYtSzbxjtCBbXxHp33Zo+-4=YrA+LVZvOe=X8-c+vxJQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] [media] s5p-tv: Add initial DT-support for TV mixer
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: t.stanislaws@samsung.com, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 February 2012 20:21, Karol Lewandowski <k.lewandowsk@samsung.com> wrote:
> ---
>  drivers/media/video/s5p-tv/mixer_drv.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/s5p-tv/mixer_drv.c b/drivers/media/video/s5p-tv/mixer_drv.c
> index a2c0c25..6bf4a9e 100644
> --- a/drivers/media/video/s5p-tv/mixer_drv.c
> +++ b/drivers/media/video/s5p-tv/mixer_drv.c
> @@ -448,6 +448,14 @@ static int __devexit mxr_remove(struct platform_device *pdev)
>        return 0;
>  }
>
> +#ifdef CONFIG_OF
> +static const struct of_device_id mxr_dt_match[] = {
> +       { .compatible = "samsung,exynos4210-tvmixer" },

If the tvmixer module is also available in SoC's prior to Exynos4210,
and if tvmixer in Exynos4210 is similar to tvmixer found on prior
SoC's, the base version should indicate that. For instance, if the
tvmixer started to appear from s5pv210 onwards, then the compatible
value should be "samsung,s5pv210-tvmixer". The compatible string
should indicate the base version.

> +       { },
> +};
> +MODULE_DEVICE_TABLE(of, mxr_dt_match);
> +#endif
> +
>  static struct platform_driver mxr_driver __refdata = {
>        .probe = mxr_probe,
>        .remove = __devexit_p(mxr_remove),
> @@ -455,6 +463,7 @@ static struct platform_driver mxr_driver __refdata = {
>                .name = MXR_DRIVER_NAME,
>                .owner = THIS_MODULE,
>                .pm = &mxr_pm_ops,
> +               .of_match_table = of_match_ptr(mxr_dt_match),
>        }
>  };
>
> --
> 1.7.8.3
>

Reviewed-by: Thomas Abraham <thomas.abraham@linaro.org>
