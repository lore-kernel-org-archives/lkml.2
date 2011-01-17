Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1AQIkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 03:40:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41337 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab1AQIkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 03:40:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NotrdW7glvEsygf5VrHWJFzx+atjsgKzW+bNWOFdiapPmklUSRJsOFtIl32LGTvrfm
         Ex5lZ5Mv8yVZiPF9zjhYPQ1BpVGntMqY79Rnnpr8js77bYiZ/OygkuJwVk+moxXLleIl
         jbvuP/eQEMp0DA8SXcyU7I8bBmlhhwHLej+o8=
MIME-Version: 1.0
In-Reply-To: <1295253143.12890.3.camel@mola>
References: <1295253143.12890.3.camel@mola>
Date: Mon, 17 Jan 2011 16:40:02 +0800
Message-ID: <AANLkTinXNoxtvobV1go9bLqJohiyic8qzznsoHvyJsh3@mail.gmail.com>
Subject: Re: [PATCH 1/2] video: nuc900fb: fix compile error
From: Wan ZongShun <mcuos.com@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Wang Qiang <rurality.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/17 Axel Lin <axel.lin@gmail.com>:
> >From a4bd940fa4d162f95e51e67c7ec4973b1d5b6866 Mon Sep 17 00:00:00 2001
> From: Axel Lin <axel.lin@gmail.com>
> Date: Mon, 17 Jan 2011 16:24:36 +0800
> Subject: [PATCH 1/2] video: nuc900fb: fix compile error
>
> This patch fixes below compile error:
>
>  CC      drivers/video/nuc900fb.o
> drivers/video/nuc900fb.c: In function 'nuc900fb_suspend':
> drivers/video/nuc900fb.c:726: error: too few arguments to function 'nuc900fb_stop_lcd'
> drivers/video/nuc900fb.c: In function 'nuc900fb_resume':
> drivers/video/nuc900fb.c:743: error: 'bfinfo' undeclared (first use in this function)
> drivers/video/nuc900fb.c:743: error: (Each undeclared identifier is reported only once
> drivers/video/nuc900fb.c:743: error: for each function it appears in.)
> make[2]: *** [drivers/video/nuc900fb.o] Error 1
> make[1]: *** [drivers/video] Error 2
> make: *** [drivers] Error 2
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/video/nuc900fb.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/video/nuc900fb.c b/drivers/video/nuc900fb.c
> index 62498bd..29ef92f 100644
> --- a/drivers/video/nuc900fb.c
> +++ b/drivers/video/nuc900fb.c
> @@ -723,7 +723,7 @@ static int nuc900fb_suspend(struct platform_device *dev, pm_message_t state)
>        struct fb_info     *fbinfo = platform_get_drvdata(dev);
>        struct nuc900fb_info *info = fbinfo->par;
>
> -       nuc900fb_stop_lcd();
> +       nuc900fb_stop_lcd(fbinfo);
>        msleep(1);
>        clk_disable(info->clk);
>        return 0;
> @@ -740,7 +740,7 @@ static int nuc900fb_resume(struct platform_device *dev)
>        msleep(1);
>
>        nuc900fb_init_registers(fbinfo);
> -       nuc900fb_activate_var(bfinfo);
> +       nuc900fb_activate_var(fbinfo);
>
>        return 0;
>  }

Thanks for your patches.
Acked-by: Wan ZongShun <mcuos.com@gmail.com>
> --
> 1.7.2
>
>
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
