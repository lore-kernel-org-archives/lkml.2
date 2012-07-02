Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab2GBJF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 05:05:58 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:33570 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab2GBJF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 05:05:56 -0400
MIME-Version: 1.0
In-Reply-To: <1341217332-21153-1-git-send-email-devendra.aaru@gmail.com>
References: <1341217332-21153-1-git-send-email-devendra.aaru@gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Mon, 2 Jul 2012 17:05:35 +0800
X-Google-Sender-Auth: yh1fF223rUoACtDoWHh5aL13fmE
Message-ID: <CAK5ve-+DUsadniHNe3H+j8xFgpV5gBuivD+u=A-D1k4ginqDYw@mail.gmail.com>
Subject: Re: [PATCH] leds-88pm860x: use the goto label at data->port
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 4:22 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:
> at the goto lable out: we are doing free of the led data, and returning ret.
> the same we are doing at the data->port < 0 case, so use the goto end and
> assign ret to -EINVAL. this will make the common err path for the
> data->port and led_classdev_register functions.
>

This patch is not wrong, but it'd better we replace kzalloc/kfree to
devm_kzalloc. So we don't care about kfree anymore.
Are interested in doing that?

Thanks,
-Bryan

> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>  drivers/leds/leds-88pm860x.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/leds/leds-88pm860x.c b/drivers/leds/leds-88pm860x.c
> index 5b61aaf..538aaa3 100644
> --- a/drivers/leds/leds-88pm860x.c
> +++ b/drivers/leds/leds-88pm860x.c
> @@ -220,8 +220,8 @@ static int pm860x_led_probe(struct platform_device *pdev)
>         data->port = pdata->flags;
>         if (data->port < 0) {
>                 dev_err(&pdev->dev, "check device failed\n");
> -               kfree(data);
> -               return -EINVAL;
> +               ret = -EINVAL;
> +               goto out;
>         }
>
>         data->current_brightness = 0;
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
