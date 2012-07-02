Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab2GBNxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:53:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56691 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2GBNxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:53:44 -0400
MIME-Version: 1.0
In-Reply-To: <1341218420-22377-1-git-send-email-devendra.aaru@gmail.com>
References: <1341218420-22377-1-git-send-email-devendra.aaru@gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Mon, 2 Jul 2012 21:53:21 +0800
X-Google-Sender-Auth: VhDa5oKRkJ7806K7a5U63d0LDX8
Message-ID: <CAK5ve-JaNGoWuCTP5ddMEEfpA3ucWNL_ayj5ULU3+++5a02pWw@mail.gmail.com>
Subject: Re: [PATCH] leds-mc13783: set platform data to NULL at mc13783_led_remove
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 4:40 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:
> the platform_set_drvdata (pdev, NULL) to be set at the remove of the
> driver, as we have set the platform data to led at probe.
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>

Nice catch. I applied this patch in my for-next branch.

But I also find the same issue in other LED drivers, are you
interested in fixing them?

Thanks,
-Bryan

> ---
>  drivers/leds/leds-mc13783.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/leds/leds-mc13783.c b/drivers/leds/leds-mc13783.c
> index 4cc6a2e..6515c11 100644
> --- a/drivers/leds/leds-mc13783.c
> +++ b/drivers/leds/leds-mc13783.c
> @@ -372,6 +372,7 @@ static int __devexit mc13783_led_remove(struct platform_device *pdev)
>
>         mc13xxx_unlock(dev);
>
> +       platform_set_drvdata(pdev, NULL);
>         kfree(led);
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
