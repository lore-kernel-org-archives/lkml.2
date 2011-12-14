Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab1LNVQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:16:32 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:33481 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab1LNVQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:16:31 -0500
MIME-Version: 1.0
In-Reply-To: <1323876538-20406-6-git-send-email-robherring2@gmail.com>
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com> <1323876538-20406-6-git-send-email-robherring2@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 14 Dec 2011 14:16:09 -0700
X-Google-Sender-Auth: w9y1cfSrRUtKDHSIK3Iast5MI_Q
Message-ID: <CACxGe6ujBaRLxo9JSW-vMHz1TZs+poKacHQbvC=aAjUsSq=m4g@mail.gmail.com>
Subject: Re: [PATCH 5/9] gpio: pl061: convert to use 0 for no irq
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, shawn.guo@freescale.com,
        Kukjin Kim <kgene.kim@samsung.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>, Barry Song <baohua.song@csr.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 8:28 AM, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> We don't want drivers using NO_IRQ, so remove its use. For now, 0 or
> -1 means no irq until platforms are converted to use 0.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> Cc: Linus Walleij <linus.ml.walleij@gmail.com>
> ---
>  drivers/gpio/gpio-pl061.c  |    8 ++++----
>  include/linux/amba/pl061.h |    2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/gpio/gpio-pl061.c b/drivers/gpio/gpio-pl061.c
> index 0f718f9..fe19dec 100644
> --- a/drivers/gpio/gpio-pl061.c
> +++ b/drivers/gpio/gpio-pl061.c
> @@ -53,7 +53,7 @@ struct pl061_gpio {
>        spinlock_t              irq_lock;       /* IRQ registers */
>
>        void __iomem            *base;
> -       unsigned                irq_base;
> +       int                     irq_base;
>        struct gpio_chip        gc;
>  };
>
> @@ -119,7 +119,7 @@ static int pl061_to_irq(struct gpio_chip *gc, unsigned offset)
>  {
>        struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
>
> -       if (chip->irq_base == NO_IRQ)
> +       if (chip->irq_base <= 0)
>                return -EINVAL;
>
>        return chip->irq_base + offset;
> @@ -250,7 +250,7 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
>                chip->irq_base = pdata->irq_base;
>        } else if (dev->dev.of_node) {
>                chip->gc.base = -1;
> -               chip->irq_base = NO_IRQ;
> +               chip->irq_base = 0;
>        } else {
>                ret = -ENODEV;
>                goto free_mem;
> @@ -290,7 +290,7 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
>         * irq_chip support
>         */
>
> -       if (chip->irq_base == NO_IRQ)
> +       if (chip->irq_base <= 0)
>                return 0;
>
>        writeb(0, chip->base + GPIOIE); /* disable irqs */
> diff --git a/include/linux/amba/pl061.h b/include/linux/amba/pl061.h
> index 2412af9..fb83c04 100644
> --- a/include/linux/amba/pl061.h
> +++ b/include/linux/amba/pl061.h
> @@ -7,7 +7,7 @@ struct pl061_platform_data {
>        unsigned        gpio_base;
>
>        /* number of the first IRQ.
> -        * If the IRQ functionality in not desired this must be set to NO_IRQ.
> +        * If the IRQ functionality in not desired this must be set to 0.
>         */
>        unsigned        irq_base;
>
> --
> 1.7.5.4
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
