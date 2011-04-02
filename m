Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab1DBVCv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 17:02:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58584 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab1DBVCu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 17:02:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fYZ503soV0+OW4DuRXXzpskEMTwITFoZwPKAplhtzWPnCv6msOLVjMwJ+tPisAqhTj
         9qaxaP3zwSAGbs9S9St3qGPIfdTSB+1aahpxyjks6VrCelAEA4hBCRkuXTjaDHC8olfG
         vwGuJ5AQGcH4kFry+0ntTK2tpSuJuZs6aeVq0=
MIME-Version: 1.0
In-Reply-To: <20110401235113.083787a7@absol.kitzblitz>
References: <20110401235113.083787a7@absol.kitzblitz>
Date: Sat, 2 Apr 2011 23:02:49 +0200
X-Google-Sender-Auth: bC4Vr4RmVGgZk1Bd45KimjkqknY
Message-ID: <BANLkTikAG4diz-A6qfFx4cODvyR0c4oQ6g@mail.gmail.com>
Subject: Re: [PATCH] arm: nomadik: avoid assigning u32 to bool
From: Linus Walleij <linus.walleij@linaro.org>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Alessandro Rubini <rubini@unipv.it>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/1 Nicolas Kaiser <nikai@nikai.net>:

> Avoid assigning u32 to the bool 'enabled'.
>
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
>  arch/arm/plat-nomadik/gpio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/plat-nomadik/gpio.c b/arch/arm/plat-nomadik/gpio.c
> index f49748e..8b722f7 100644
> --- a/arch/arm/plat-nomadik/gpio.c
> +++ b/arch/arm/plat-nomadik/gpio.c
> @@ -636,7 +636,7 @@ static int nmk_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>        if (type & IRQ_TYPE_LEVEL_LOW)
>                return -EINVAL;
>
> -       enabled = nmk_chip->enabled & bitmask;
> +       enabled = !!(nmk_chip->enabled & bitmask);

I've learned to live this way of casting stuff into boolean,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Linus Walleij
