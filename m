Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab2GBNwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:52:10 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:63182 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab2GBNwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:52:08 -0400
MIME-Version: 1.0
In-Reply-To: <1341224143-27894-1-git-send-email-devendra.aaru@gmail.com>
References: <1341224143-27894-1-git-send-email-devendra.aaru@gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Mon, 2 Jul 2012 21:51:47 +0800
X-Google-Sender-Auth: 50MEN9f6x9uwm9PKH8SoahpRS70
Message-ID: <CAK5ve-JUG42LRKmX4iGjQO+c7E=6HYVTUe7QjN70DyJTRo6YQg@mail.gmail.com>
Subject: Re: [PATCH] leds-88pm860x: use devm_kzalloc function
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 6:15 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:
> Using devm_kzalloc will remove all the error checks and the frees are automatically done at the driver unload side.
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>

Great, Applied to my for-next branch. Thanks,

-Bryan

> ---
>
> Thanks Bryan for advising me.. ;-)
>
>  drivers/leds/leds-88pm860x.c |    9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/leds/leds-88pm860x.c b/drivers/leds/leds-88pm860x.c
> index 5b61aaf..61897cf 100644
> --- a/drivers/leds/leds-88pm860x.c
> +++ b/drivers/leds/leds-88pm860x.c
> @@ -209,7 +209,7 @@ static int pm860x_led_probe(struct platform_device *pdev)
>                 return -EINVAL;
>         }
>
> -       data = kzalloc(sizeof(struct pm860x_led), GFP_KERNEL);
> +       data = devm_kzalloc(&pdev->dev, sizeof(struct pm860x_led), GFP_KERNEL);
>         if (data == NULL)
>                 return -ENOMEM;
>         strncpy(data->name, res->name, MFD_NAME_SIZE - 1);
> @@ -220,7 +220,6 @@ static int pm860x_led_probe(struct platform_device *pdev)
>         data->port = pdata->flags;
>         if (data->port < 0) {
>                 dev_err(&pdev->dev, "check device failed\n");
> -               kfree(data);
>                 return -EINVAL;
>         }
>
> @@ -233,13 +232,10 @@ static int pm860x_led_probe(struct platform_device *pdev)
>         ret = led_classdev_register(chip->dev, &data->cdev);
>         if (ret < 0) {
>                 dev_err(&pdev->dev, "Failed to register LED: %d\n", ret);
> -               goto out;
> +               return ret;
>         }
>         pm860x_led_set(&data->cdev, 0);
>         return 0;
> -out:
> -       kfree(data);
> -       return ret;
>  }
>
>  static int pm860x_led_remove(struct platform_device *pdev)
> @@ -247,7 +243,6 @@ static int pm860x_led_remove(struct platform_device *pdev)
>         struct pm860x_led *data = platform_get_drvdata(pdev);
>
>         led_classdev_unregister(&data->cdev);
> -       kfree(data);
>
>         return 0;
>  }
> --
> 1.7.9.5
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
