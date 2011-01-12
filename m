Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab1ALBYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 20:24:51 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58431 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab1ALBYt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 20:24:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fMxNCzouitpuABjiFbHYE1r5vaVYvt71j1Mnyzm5a1rjWQfLg4LEGg7KNxYTDw2CIL
         MhQxoRoDZmsNVNB9ReaWcBXFrr98WajoCf/6SjPjvtreSKIfJtrycwnh56VzTO3WrEzt
         v0dpSdLyDrY08dqm/RFaZwvm8u7ZlBCU0GaIY=
MIME-Version: 1.0
In-Reply-To: <1294749833-32019-7-git-send-email-jamie@jamieiles.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
	<1294749833-32019-7-git-send-email-jamie@jamieiles.com>
Date: Wed, 12 Jan 2011 09:24:47 +0800
Message-ID: <AANLkTingg+wm8jy4kRL=ubLFrCDXq17jZQkD3v3M4h+Y@mail.gmail.com>
Subject: Re: [PATCH 06/16] nuc900fb: don't treat NULL clk as an error
From: Wan ZongShun <mcuos.com@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/11 Jamie Iles <jamie@jamieiles.com>:
> clk_get() returns a struct clk cookie to the driver and some platforms
> may return NULL if they only support a single clock.  clk_get() has only
> failed if it returns a ERR_PTR() encoded pointer.
>
> Cc: Wan ZongShun <mcuos.com@gmail.com>
> Cc: linux-fbdev@vger.kernel.org
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> ---
>  drivers/video/nuc900fb.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/video/nuc900fb.c b/drivers/video/nuc900fb.c
> index 81687ed..62498bd 100644
> --- a/drivers/video/nuc900fb.c
> +++ b/drivers/video/nuc900fb.c
> @@ -15,6 +15,7 @@
>  */
>  #include <linux/module.h>
>  #include <linux/kernel.h>
> +#include <linux/err.h>
>  #include <linux/errno.h>
>  #include <linux/string.h>
>  #include <linux/mm.h>
> @@ -597,9 +598,9 @@ static int __devinit nuc900fb_probe(struct platform_device *pdev)
>        }
>
>        fbi->clk = clk_get(&pdev->dev, NULL);
> -       if (!fbi->clk || IS_ERR(fbi->clk)) {
> +       if (IS_ERR(fbi->clk)) {
>                printk(KERN_ERR "nuc900-lcd:failed to get lcd clock source\n");
> -               ret = -ENOENT;
> +               ret = PTR_ERR(fbi->clk);
>                goto release_irq;
>        }
>
Hi,

Thanks for your patch.

Acked-by: Wan ZongShun <mcuos.com@gmail.com>

> --
> 1.7.3.4
>
>



-- 
*linux-arm-kernel mailing list
mail addr:linux-arm-kernel@lists.infradead.org
you can subscribe by:
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

* linux-arm-NUC900 mailing list
mail addr:NUC900@googlegroups.com
main web: https://groups.google.com/group/NUC900
you can subscribe it by sending me mail:
mcuos.com@gmail.com
