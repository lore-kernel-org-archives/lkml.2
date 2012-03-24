Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2CYAbf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 20:31:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65297 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab2CYAbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 20:31:06 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: PCA GPIO interrupt triggers
To: Peter Rusko <rusko.peter@prolan.hu>, David Jander <david@protonic.nl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4F6B4C11.4000608@prolan.hu>
References: <4F6B4C11.4000608@prolan.hu>
Date: Sat, 24 Mar 2012 17:02:12 +0000
Message-Id: <20120324170212.C68A43E09EE@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2012 16:58:09 +0100, Peter Rusko <rusko.peter@prolan.hu> wrote:
> Hi,
> 
> I'm using a GPIO chip (PCA9554) for a matrix-keypad. The keypad driver 
> itself needs interrupts for both rising and falling edges. The PCA 
> driver (gpio-pca953x.c) doesn't support it, but I don't understand why.
> 
> I think, this patch should work:

Can someone with hardware review this patch please?  David perhaps?

g.

> 
> diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
> index 147df8a..be9aff4 100644
> --- a/drivers/gpio/gpio-pca953x.c
> +++ b/drivers/gpio/gpio-pca953x.c
> @@ -356,12 +356,6 @@ static int pca953x_irq_set_type(struct irq_data *d, 
> unsigned int type)
>          uint16_t level = d->irq - chip->irq_base;
>          uint16_t mask = 1 << level;
> 
> -       if (!(type & IRQ_TYPE_EDGE_BOTH)) {
> -               dev_err(&chip->client->dev, "irq %d: unsupported type %d\n",
> -                       d->irq, type);
> -               return -EINVAL;
> -       }
> -
>          if (type & IRQ_TYPE_EDGE_FALLING)
>                  chip->irq_trig_fall |= mask;
>          else
> 
> I think that the other parts of the code checks for rising and falling 
> edges correctly. Am I missing something?
> 
> -- 
> Ruskó Péter
> Fejlesztőmérnök
> 
> Prolan Zrt. / Prolan Co.
> Hungary 2011 Budakalász, Szentendrei út 1-3.
> Tel./Phone: +36 20 954 3118
> Fax: +36 26 540 420
> E-mail: rusko.peter@prolan.hu
> Web: www.prolan.hu
> Timezone:CET

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
