Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab0HCNqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:46:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56510 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab0HCNqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:46:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=az4VpATKFrlpIVOIRZ3kN2akF+0ec63WrH487g6KEhWuityxBWxC/iBFxG82tXEvWx
         UgskQ9N7SdDFAcgVGwTYZCCx0o1LnNsnK6ccgxYwA3wZmUrc1TAY/l4mPZO+VL92+pBB
         gcE6M+1Crk9EuisRKFzyJC89rBj80mDAk77Hc=
MIME-Version: 1.0
In-Reply-To: <1280805041.27646.1.camel@mola>
References: <1280805041.27646.1.camel@mola>
From: Ian Molton <ian@mnementh.co.uk>
Date: Tue, 3 Aug 2010 14:45:40 +0100
X-Google-Sender-Auth: Apq8ZQwlZVGk5_H2c_jgrbx0sMw
Message-ID: <AANLkTik5Tvr_7v1gB55h3kwxB8yihwhnSMVT-=T=a44_@mail.gmail.com>
Subject: Re: [PATCH] tc6393xb: fix wrong goto labels for error handling
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Ian Molton <ian.molton@mnementh.co.uk>

On 3 August 2010 04:10, Axel Lin <axel.lin@gmail.com> wrote:
> This patch corrects the error handling path.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/tc6393xb.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
> index fcf9068..ef6c42c 100644
> --- a/drivers/mfd/tc6393xb.c
> +++ b/drivers/mfd/tc6393xb.c
> @@ -732,9 +732,9 @@ err_gpio_add:
>        if (tc6393xb->gpio.base != -1)
>                temp = gpiochip_remove(&tc6393xb->gpio);
>        tcpd->disable(dev);
> -err_clk_enable:
> -       clk_disable(tc6393xb->clk);
>  err_enable:
> +       clk_disable(tc6393xb->clk);
> +err_clk_enable:
>        iounmap(tc6393xb->scr);
>  err_ioremap:
>        release_resource(&tc6393xb->rscr);
> --
> 1.5.4.3
>
>
>
>
