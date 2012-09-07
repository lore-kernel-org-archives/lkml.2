Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2IGEtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:49:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52452 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab2IGEtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:49:18 -0400
MIME-Version: 1.0
In-Reply-To: <1346950163-17590-1-git-send-email-msb@chromium.org>
References: <CAAQKjZPGefy9333AGTN1iwxWuCiPvi85raDE7ijDmRcm9PPWWw@mail.gmail.com>
	<1346950163-17590-1-git-send-email-msb@chromium.org>
Date: Fri, 7 Sep 2012 13:49:17 +0900
X-Google-Sender-Auth: Ey767tUR3ze4tAByNHSfgOwBFnU
Message-ID: <CAAQKjZMeTq0nci1c-_ZaUiH=fWmpC4Uimrh8=URn4KzKwJ_O4g@mail.gmail.com>
Subject: Re: [PATCH] drm/exynos: fix double call of drm_prime_(init/destroy)_file_private
From: Inki Dae <inki.dae@samsung.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        =?ISO-8859-1?Q?St=E9phane_Marchesin?= <marcheu@chromium.org>,
        Pawel Osciak <posciak@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

Thanks,
Inki Dae

2012/9/7 Mandeep Singh Baines <msb@chromium.org>:
> The double invocations are incorrect but seem to be safe so I don't
> think this will fix any bugs.
>
> Before:
>
> [    7.639366] drm_prime_init_file ee3675d0
> [    7.639377] drm_prime_init_file ee3675d0
> [    7.639507] drm_prime_destroy_file ee3675d0
> [    7.639518] drm_prime_destroy_file ee3675d0
> [    7.639802] drm_prime_init_file ee372390
> [    7.639810] drm_prime_init_file ee372390
> [    8.473316] drm_prime_init_file ee356390
> [    8.473331] drm_prime_init_file ee356390
>
> After:
>
> [    6.363842] drm_prime_init_file edc2e5d0
> [    6.363994] drm_prime_destroy_file edc2e5d0
> [    6.364260] drm_prime_init_file edc2e750
> [    8.004837] drm_prime_init_file ee36ded0
>
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_drv.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> index ebacec6..a27b8ff 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> @@ -160,7 +160,6 @@ static int exynos_drm_open(struct drm_device *dev, struct drm_file *file)
>         if (!file_priv)
>                 return -ENOMEM;
>
> -       drm_prime_init_file_private(&file->prime);
>         file->driver_priv = file_priv;
>
>         return exynos_drm_subdrv_open(dev, file);
> @@ -184,7 +183,6 @@ static void exynos_drm_preclose(struct drm_device *dev,
>                         e->base.destroy(&e->base);
>                 }
>         }
> -       drm_prime_destroy_file_private(&file->prime);
>         spin_unlock_irqrestore(&dev->event_lock, flags);
>
>         exynos_drm_subdrv_close(dev, file);
> --
> 1.7.7.3
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
