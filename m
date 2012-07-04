Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685Ab2GDHee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:34:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36370 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933660Ab2GDHe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:34:29 -0400
MIME-Version: 1.0
In-Reply-To: <1341378617-10386-5-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com> <1341378617-10386-5-git-send-email-bryan.wu@canonical.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 4 Jul 2012 15:34:08 +0800
X-Google-Sender-Auth: -PCuB9tRY1RpexWAqAbMJO-ns8A
Message-ID: <CAK5ve-JgiHsz2Vz5a+Vf9L+MbpEo_9iwVr_EcukgHc0M8KXPUw@mail.gmail.com>
Subject: Re: [PATCH 04/25] leds: convert LP3944 LED driver to devm_kzalloc()
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 1:09 PM, Bryan Wu <bryan.wu@canonical.com> wrote:
> Cc: Antonio Ospite <ospite@studenti.unina.it>
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> ---
>  drivers/leds/leds-lp3944.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/leds/leds-lp3944.c b/drivers/leds/leds-lp3944.c
> index b8f9f0a..e8b1021 100644
> --- a/drivers/leds/leds-lp3944.c
> +++ b/drivers/leds/leds-lp3944.c
> @@ -393,7 +393,8 @@ static int __devinit lp3944_probe(struct i2c_client *client,
>                 return -ENODEV;
>         }
>
> -       data = kzalloc(sizeof(struct lp3944_data), GFP_KERNEL);
> +       data = devm_kzalloc(&pdev->dev, sizeof(struct lp3944_data),

Sorry, this should be "devm_kzalloc(&client->dev, sizeof(struct lp3944_data),"
I've put the right version in my devel branch.

Thanks,
-Bryan

> +                       GFP_KERNEL);
>         if (!data)
>                 return -ENOMEM;
>
> @@ -403,10 +404,8 @@ static int __devinit lp3944_probe(struct i2c_client *client,
>         mutex_init(&data->lock);
>
>         err = lp3944_configure(client, data, lp3944_pdata);
> -       if (err < 0) {
> -               kfree(data);
> +       if (err < 0)
>                 return err;
> -       }
>
>         dev_info(&client->dev, "lp3944 enabled\n");
>         return 0;
> @@ -431,8 +430,6 @@ static int __devexit lp3944_remove(struct i2c_client *client)
>                         break;
>                 }
>
> -       kfree(data);
> -
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
