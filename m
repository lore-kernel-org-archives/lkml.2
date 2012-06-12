Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab2FLGR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 02:17:56 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44988 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab2FLGRz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 02:17:55 -0400
MIME-Version: 1.0
In-Reply-To: <000c01cd4766$b013b410$103b1c30$%han@samsung.com>
References: <000c01cd4766$b013b410$103b1c30$%han@samsung.com>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Tue, 12 Jun 2012 08:17:33 +0200
Message-ID: <CAH9NwWd2yRw2U2OJUWKosqtiswmRZiguRFEashxugfdWysJyLQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3][RESEND] backlight: ot200_bl: use devm_ functions
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

looks fine

Acked-by: Christian Gmeiner <christian.gmeiner@gmail.com>

---
Christian Gmeiner, MSc


2012/6/11 Jingoo Han <jg1.han@samsung.com>:
> The devm_ functions allocate memory that is released when a driver
> detaches. This patch uses devm_kzalloc of these functions
>
> Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/ot200_bl.c |   12 ++++--------
>  1 files changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/video/backlight/ot200_bl.c b/drivers/video/backlight/ot200_bl.c
> index f519d55..ef637ff 100644
> --- a/drivers/video/backlight/ot200_bl.c
> +++ b/drivers/video/backlight/ot200_bl.c
> @@ -97,10 +97,10 @@ static int ot200_backlight_probe(struct platform_device *pdev)
>                goto error_mfgpt_alloc;
>        }
>
> -       data = kzalloc(sizeof(*data), GFP_KERNEL);
> +       data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
>        if (!data) {
>                retval = -ENOMEM;
> -               goto error_kzalloc;
> +               goto error_devm_kzalloc;
>        }
>
>        /* setup gpio */
> @@ -122,16 +122,14 @@ static int ot200_backlight_probe(struct platform_device *pdev)
>        if (IS_ERR(bl)) {
>                dev_err(&pdev->dev, "failed to register backlight\n");
>                retval = PTR_ERR(bl);
> -               goto error_backlight_device_register;
> +               goto error_devm_kzalloc;
>        }
>
>        platform_set_drvdata(pdev, bl);
>
>        return 0;
>
> -error_backlight_device_register:
> -       kfree(data);
> -error_kzalloc:
> +error_devm_kzalloc:
>        cs5535_mfgpt_free_timer(pwm_timer);
>  error_mfgpt_alloc:
>        gpio_free(GPIO_DIMM);
> @@ -141,7 +139,6 @@ error_mfgpt_alloc:
>  static int ot200_backlight_remove(struct platform_device *pdev)
>  {
>        struct backlight_device *bl = platform_get_drvdata(pdev);
> -       struct ot200_backlight_data *data = bl_get_data(bl);
>
>        backlight_device_unregister(bl);
>
> @@ -154,7 +151,6 @@ static int ot200_backlight_remove(struct platform_device *pdev)
>        cs5535_mfgpt_free_timer(pwm_timer);
>        gpio_free(GPIO_DIMM);
>
> -       kfree(data);
>        return 0;
>  }
>
> --
> 1.7.1
>
>
