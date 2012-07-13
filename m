Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab2GMD1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 23:27:53 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37158 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab2GMD1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 23:27:51 -0400
MIME-Version: 1.0
In-Reply-To: <1342000232-10105-1-git-send-email-devendra.aaru@gmail.com>
References: <1342000232-10105-1-git-send-email-devendra.aaru@gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Fri, 13 Jul 2012 11:27:30 +0800
X-Google-Sender-Auth: j4k3OxwtMu9hZyeijjClvFdkGlo
Message-ID: <CAK5ve-+0RHVfjAQjFJmJ=0e3K0JG3zq6uM3oMr-_0JJY0EM-pg@mail.gmail.com>
Subject: Re: [PATCH] leds/leds-s3c24xx: use devm_gpio_request
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 5:50 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:
> why?
> because if the led_classdev_register fails we wont do gpio free
> because using devm_ functions, there is no need for error paths
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
> Bryan,
>
>         This patch is not even compile tested, since my machine crashed, and
> didn't have the ARM toolchain, sorry ..
>

Thanks, I built it successfully. It looks fine to me. I will apply
this to my for-next branch.

-Bryan

>         And i think this patch is legit not as that pci_set_drvdata one :(
>  drivers/leds/leds-s3c24xx.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c
> index e120640..942f0ea 100644
> --- a/drivers/leds/leds-s3c24xx.c
> +++ b/drivers/leds/leds-s3c24xx.c
> @@ -65,7 +65,6 @@ static int s3c24xx_led_remove(struct platform_device *dev)
>         struct s3c24xx_gpio_led *led = pdev_to_gpio(dev);
>
>         led_classdev_unregister(&led->cdev);
> -       gpio_free(led->pdata->gpio);
>
>         return 0;
>  }
> @@ -92,7 +91,7 @@ static int s3c24xx_led_probe(struct platform_device *dev)
>
>         led->pdata = pdata;
>
> -       ret = gpio_request(pdata->gpio, "S3C24XX_LED");
> +       ret = devm_gpio_request(&dev->dev, pdata->gpio, "S3C24XX_LED");
>         if (ret < 0)
>                 return ret;
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-leds" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
