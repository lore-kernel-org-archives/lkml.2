Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933710Ab2GDHlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:41:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44678 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932986Ab2GDHlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:41:02 -0400
MIME-Version: 1.0
In-Reply-To: <1341378617-10386-16-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com> <1341378617-10386-16-git-send-email-bryan.wu@canonical.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 4 Jul 2012 15:40:41 +0800
X-Google-Sender-Auth: sgf5NYAVS17ZNyTwL5Zt2gXul2A
Message-ID: <CAK5ve-LeSWx=SRqswg1uiFrbZDwK_F-3iKZkg0BaNKp1+5-aOA@mail.gmail.com>
Subject: Re: [PATCH 15/25] leds: convert ADP5520 LED driver to devm_kzalloc()
 and cleanup error exit path
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 1:10 PM, Bryan Wu <bryan.wu@canonical.com> wrote:
> Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> ---
>  drivers/leds/leds-adp5520.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/leds/leds-adp5520.c b/drivers/leds/leds-adp5520.c
> index b1400db..72b110f 100644
> --- a/drivers/leds/leds-adp5520.c
> +++ b/drivers/leds/leds-adp5520.c
> @@ -119,7 +119,8 @@ static int __devinit adp5520_led_probe(struct platform_device *pdev)
>                 return -EFAULT;
>         }
>
> -       led = kzalloc(sizeof(*led) * pdata->num_leds, GFP_KERNEL);
> +       led = devm_kzalloc(&pdev->dev, sizeof(*led) * pdata->num_leds,
> +                               GFP_KERNEL);
>         if (led == NULL) {
>                 dev_err(&pdev->dev, "failed to alloc memory\n");
>                 return -ENOMEM;
> @@ -129,7 +130,7 @@ static int __devinit adp5520_led_probe(struct platform_device *pdev)
>
>         if (ret) {
>                 dev_err(&pdev->dev, "failed to write\n");
> -               goto err_free;
> +               return ret
Missed one ";" at end of this line. I've fixed it in my devel branch.

Thanks,
-Bryan

>         }
>
>         for (i = 0; i < pdata->num_leds; ++i) {
> @@ -179,8 +180,6 @@ err:
>                 }
>         }
>
> -err_free:
> -       kfree(led);
>         return ret;
>  }
>
> @@ -200,7 +199,6 @@ static int __devexit adp5520_led_remove(struct platform_device *pdev)
>                 cancel_work_sync(&led[i].work);
>         }
>
> -       kfree(led);
>         return 0;
>  }
>
> --
> 1.7.10.4
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
