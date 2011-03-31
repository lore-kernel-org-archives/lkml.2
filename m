Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537Ab1CaO7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:59:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49342 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758138Ab1CaO7d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:59:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aWp9uEDOXYbGla1/xUVMElOj2O92DH2fB9cdKsoguuaME9g/0Br1pVyFrYz9XbB97d
         RKP7ynp5S0dMP9UgP676XFnZ8jjghJj/0HA7Svv6+6ccWQkvMGroMh6sNhPIiOXD1VdK
         JG4xvdjamoizkb9rZK8WHWlSqEBnsXNCKpi1I=
MIME-Version: 1.0
In-Reply-To: <20110330202700.7d8142e8@absol.kitzblitz>
References: <20110330181201.29e473bf@absol.kitzblitz>
	<4D935C56.4060903@metafoo.de>
	<20110330202700.7d8142e8@absol.kitzblitz>
Date: Thu, 31 Mar 2011 22:59:31 +0800
Message-ID: <AANLkTinDYgJBG8VUn6w6pJ==743WEf9PFuQ3jErwjo0a@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH] drivers/rtc/rtc-jz4740.c: fix error check v2
From: Wan ZongShun <mcuos.com@gmail.com>
To: rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>
Cc: Nicolas Kaiser <nikai@nikai.net>, Lars-Peter Clausen <lars@metafoo.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/31 Nicolas Kaiser <nikai@nikai.net>:
> Checking 'rtc->irq < 0' doesn't work because 'rtc->irq' is unsigned.
>
> v2: return error code from platform_get_irq() instead of -ENOENT.
>
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
>  drivers/rtc/rtc-jz4740.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/rtc/rtc-jz4740.c b/drivers/rtc/rtc-jz4740.c
> index b647363..efd9691 100644
> --- a/drivers/rtc/rtc-jz4740.c
> +++ b/drivers/rtc/rtc-jz4740.c
> @@ -220,12 +220,12 @@ static int __devinit jz4740_rtc_probe(struct platform_device *pdev)
>        if (!rtc)
>                return -ENOMEM;
>
> -       rtc->irq = platform_get_irq(pdev, 0);
> -       if (rtc->irq < 0) {
> -               ret = -ENOENT;
> +       ret = platform_get_irq(pdev, 0);
> +       if (ret < 0) {
>                dev_err(&pdev->dev, "Failed to get platform irq\n");
>                goto err_free;
>        }
> +       rtc->irq = ret;
>

This patch looks good to me.

Acked-by: Wan ZongShun <mcuos.com@gmail.com>

>        rtc->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>        if (!rtc->mem) {
> --
> 1.7.3.4
>
> --
> You received this message because you are subscribed to "rtc-linux".
> Membership options at http://groups.google.com/group/rtc-linux .
> Please read http://groups.google.com/group/rtc-linux/web/checklist
> before submitting a driver.



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
