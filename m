Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab0I3Tlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 15:41:45 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48610 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab0I3Tlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 15:41:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=i2kCDGcIAHZVpLfEBQ5BMR4XTXIThzsSE9u+vqyJ4GExzKlsDjLa871MVv5qiBqygn
         96yzRlfYDvUHVEw8Cqy3Dc0v9XGcDShQyLCRu/jo8YDFTE4BigoqfE8arb/Ze1ftix8k
         MfOXQbkKSJcGMmV77ncqIzea7N0/zswzMUIFI=
MIME-Version: 1.0
In-Reply-To: <1284900921-24814-1-git-send-email-segooon@gmail.com>
References: <1284900921-24814-1-git-send-email-segooon@gmail.com>
Date: Thu, 30 Sep 2010 21:41:43 +0200
X-Google-Sender-Auth: tN0ebPnUPB-2xgJxvVKrcMdLqvo
Message-ID: <AANLkTik9amOXStCu=MJdV7BsYWUbShFDUH1iM0DMT0M8@mail.gmail.com>
Subject: Re: [PATCH 14/14] zorro: fix device_register() error handling
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 14:55, Vasiliy Kulikov <segooon@gmail.com> wrote:
> If device_register() fails then call put_device().
> See comment to device_register.
>
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Thanks, applied to m68k tree, queued for 2.6.37.

> ---
>  I cannot compile this driver, so it is not tested at all.
>
>  drivers/zorro/zorro.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/zorro/zorro.c b/drivers/zorro/zorro.c
> index 6455f3a..e0c2807 100644
> --- a/drivers/zorro/zorro.c
> +++ b/drivers/zorro/zorro.c
> @@ -142,6 +142,7 @@ static int __init amiga_zorro_probe(struct platform_device *pdev)
>        error = device_register(&bus->dev);
>        if (error) {
>                pr_err("Zorro: Error registering zorro_bus\n");
> +               put_device(&bus->dev);
>                kfree(bus);
>                return error;
>        }
> @@ -175,6 +176,7 @@ static int __init amiga_zorro_probe(struct platform_device *pdev)
>                if (error) {
>                        dev_err(&bus->dev, "Error registering device %s\n",
>                                z->name);
> +                       put_device(&z->dev);
>                        continue;
>                }
>                error = zorro_create_sysfs_dev_files(z);
> --
> 1.7.0.4

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
