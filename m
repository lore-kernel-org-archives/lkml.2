Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab1DCD7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 23:59:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52410 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab1DCD7S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 23:59:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Nhh1vTnQqLDXZBjR9opkBRY/CvJhAszZc6BqjOcwC8Rw3mQ5NwEklvxjgBKGNjJug+
         WM34xKrYiMVur1f+lBwNTGEL+yTNvcqFT+2gQxyrpm9LGXOhBZFYTeMW6K0zUV9o/NrF
         OmSqW2q3piVst+A8+AVzrCKpvn1K0tU3c+uBg=
MIME-Version: 1.0
In-Reply-To: <20110401235113.083787a7@absol.kitzblitz>
References: <20110401235113.083787a7@absol.kitzblitz>
From: Rabin Vincent <rabin@rab.in>
Date: Sun, 3 Apr 2011 09:28:37 +0530
X-Google-Sender-Auth: 9LDaQ5PyqbzuZtMeoPs4p-NlmaE
Message-ID: <BANLkTinujPcSq86wjue+SGw5ZMiiLRaT_A@mail.gmail.com>
Subject: Re: [PATCH] arm: nomadik: avoid assigning u32 to bool
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@stericsson.com>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 2, 2011 at 03:21, Nicolas Kaiser <nikai@nikai.net> wrote:
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

Why?  There are dozens of places in the kernel where this done, the code
generated should be the same, and it's pretty obvious what is being done
as it is.
