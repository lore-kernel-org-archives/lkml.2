Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2FMMVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:21:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36348 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab2FMMVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:21:44 -0400
MIME-Version: 1.0
In-Reply-To: <000301cd4956$70714920$5153db60$%han@samsung.com>
References: <000301cd4956$70714920$5153db60$%han@samsung.com>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Wed, 13 Jun 2012 14:21:23 +0200
Message-ID: <CAH9NwWd=kZp7Xp+Hxb+jaAC66aJL+R5h9_B_3wbcsFyCMQf-rA@mail.gmail.com>
Subject: Re: [PATCH 2/7] backlight: ot200_bl: use devm_gpio_request()
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>, Axel Lin <axel.lin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/13 Jingoo Han <jg1.han@samsung.com>:
> The devm_ functions allocate memory that is released when a driver
> detaches. This patch uses devm_gpio_request of these functions.
>
> CC: Christian Gmeiner <christian.gmeiner@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/ot200_bl.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/video/backlight/ot200_bl.c b/drivers/video/backlight/ot200_bl.c
> index ef637ff..469cf0f 100644
> --- a/drivers/video/backlight/ot200_bl.c
> +++ b/drivers/video/backlight/ot200_bl.c
> @@ -84,7 +84,8 @@ static int ot200_backlight_probe(struct platform_device *pdev)
>        int retval = 0;
>
>        /* request gpio */
> -       if (gpio_request(GPIO_DIMM, "ot200 backlight dimmer") < 0) {
> +       if (devm_gpio_request(&pdev->dev, GPIO_DIMM,
> +                               "ot200 backlight dimmer") < 0) {
>                dev_err(&pdev->dev, "failed to request GPIO %d\n", GPIO_DIMM);
>                return -ENODEV;
>        }
> @@ -93,8 +94,7 @@ static int ot200_backlight_probe(struct platform_device *pdev)
>        pwm_timer = cs5535_mfgpt_alloc_timer(7, MFGPT_DOMAIN_ANY);
>        if (!pwm_timer) {
>                dev_err(&pdev->dev, "MFGPT 7 not available\n");
> -               retval = -ENODEV;
> -               goto error_mfgpt_alloc;
> +               return -ENODEV;
>        }
>
>        data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
> @@ -131,8 +131,6 @@ static int ot200_backlight_probe(struct platform_device *pdev)
>
>  error_devm_kzalloc:
>        cs5535_mfgpt_free_timer(pwm_timer);
> -error_mfgpt_alloc:
> -       gpio_free(GPIO_DIMM);
>        return retval;
>  }
>
> @@ -149,7 +147,6 @@ static int ot200_backlight_remove(struct platform_device *pdev)
>                MAX_COMP2 - dim_table[100]);
>
>        cs5535_mfgpt_free_timer(pwm_timer);
> -       gpio_free(GPIO_DIMM);
>
>        return 0;
>  }
> --
> 1.7.1
>

Acked-by: Christian Gmeiner <christian.gmeiner@gmail.com>
