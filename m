Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab2JPRc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:32:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39126 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab2JPRc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:32:57 -0400
MIME-Version: 1.0
In-Reply-To: <008901cdab77$d2538800$76fa9800$%han@samsung.com>
References: <008901cdab77$d2538800$76fa9800$%han@samsung.com>
Date: Tue, 16 Oct 2012 19:32:55 +0200
Message-ID: <CACRpkdbBuiae=+AXfAEargz0cJEDxa0-yVETw0zpNt_pOkuF4g@mail.gmail.com>
Subject: Re: [PATCH V2 RESEND] gpio: samsung: use pr_* instead of printk
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ryan Mallon <rmallon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 10:25 AM, Jingoo Han <jg1.han@samsung.com> wrote:

>  int samsung_gpio_setpull_updown(struct samsung_gpio_chip *chip,
>                                 unsigned int off, samsung_gpio_pull_t pull)
>  {
> @@ -599,7 +593,7 @@ static int samsung_gpiolib_4bit_input(struct gpio_chip *chip,
>         con &= ~(0xf << con_4bit_shift(offset));
>         __raw_writel(con, base + GPIOCON_OFF);
>
> -       gpio_dbg("%s: %p: CON now %08lx\n", __func__, base, con);
> +       pr_debug("%s: %p: CON now %08lx\n", __func__, base, con);

Does your struct gpio_chip provide a valid dev pointer so you can use:

dev_dbg(chip->dev, "%s: %p: CON now %08lx\n", __func__, base, con);

In that case use the dev_* print macros everywhere instead.

Yours,
Linus Walleij
