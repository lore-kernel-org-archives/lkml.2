Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab0ITCAN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 22:00:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60601 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab0ITCAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 22:00:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tye5TKbx0hizLqgoyo3Iai/kgdiVASkFizweg66f1Q6le/ncgukultm9VUisXy7BB7
         mCB/lrenPsFGDApFmCLgBiLIUroiVopMLSGyO64SPFHGb13lPoaQBe+FgVmOy7iS3Zsi
         rujyjo8HVpAJ6ByHNAYtoMGcmC2Lva4rhdv1o=
MIME-Version: 1.0
In-Reply-To: <1284891726.2199.3.camel@phoenix>
References: <1284891726.2199.3.camel@phoenix>
Date: Mon, 20 Sep 2010 10:00:04 +0800
Message-ID: <AANLkTik_by+LJP8-VsXV0s11r8_kotKbEA7ZwkF0HBnf@mail.gmail.com>
Subject: Re: [PATCH] RTC: rtc-ab3100 - Add missing platform_set_drvdata() in ab3100_rtc_probe()
From: Wan ZongShun <mcuos.com@gmail.com>
To: Axel Lin <axel.lin@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        rtc-linux@googlegroups.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel ,

2010/9/19 Axel Lin <axel.lin@gmail.com>:
> Otherwise, calling platform_get_drvdata() in ab3100_rtc_remove() return NULL.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by:Wan ZongShun <mcuos.com@gmail.com>

> ---
>  drivers/rtc/rtc-ab3100.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/rtc/rtc-ab3100.c b/drivers/rtc/rtc-ab3100.c
> index d26780e..261a07e 100644
> --- a/drivers/rtc/rtc-ab3100.c
> +++ b/drivers/rtc/rtc-ab3100.c
> @@ -235,6 +235,7 @@ static int __init ab3100_rtc_probe(struct platform_device *pdev)
>                err = PTR_ERR(rtc);
>                return err;
>        }
> +       platform_set_drvdata(pdev, rtc);
>
>        return 0;
>  }
> @@ -244,6 +245,7 @@ static int __exit ab3100_rtc_remove(struct platform_device *pdev)
>        struct rtc_device *rtc = platform_get_drvdata(pdev);
>
>        rtc_device_unregister(rtc);
> +       platform_set_drvdata(pdev, NULL);
>        return 0;
>  }
>
> --
> 1.7.0.4
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
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
