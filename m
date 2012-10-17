Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab2JQBtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 21:49:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43964 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab2JQBtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 21:49:12 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-a1-507e0e96e22f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Ryan Mallon'" <rmallon@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <008901cdab77$d2538800$76fa9800$%han@samsung.com>
 <CACRpkdbBuiae=+AXfAEargz0cJEDxa0-yVETw0zpNt_pOkuF4g@mail.gmail.com>
In-reply-to: <CACRpkdbBuiae=+AXfAEargz0cJEDxa0-yVETw0zpNt_pOkuF4g@mail.gmail.com>
Subject: Re: [PATCH V2 RESEND] gpio: samsung: use pr_* instead of printk
Date: Wed, 17 Oct 2012 10:49:10 +0900
Message-id: <002701cdac09$9a3b67c0$ceb23740$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rxEj7toa1Ocd2TtaF7hHC4cqQjwARA0OQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQd1pfHUBBl86DS0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKOf+5kLfjMWXHg8SH2BsYz7F2MnBwSAiYSncdnsELY
	YhIX7q1n62Lk4hASmM4osXL5FXYI5xejxOWZR8Cq2ATUJL58OQzWLSKgJ/HmawtYEbPAI0aJ
	jc8PM0F0tDBKdGxbC+RwcHAKBEt8fxcE0iAs4CEx8+lLRhCbRUBV4veaNUwgNq+ArcTc9rks
	ELagxI/J98BsZgEtic3bmlghbHmJzWveMoOMlBBQl3j0VxfEFBEwkrgxTxWiQkRi34t3jBMY
	hWYhGTQLyaBZSAbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwSD+T2sG4ssHi
	EKMAB6MSD++H2bUBQqyJZcWVuYcYJTiYlUR4zRuBQrwpiZVVqUX58UWlOanFhxilOViUxHmb
	PVIChATSE0tSs1NTC1KLYLJMHJxSDYwavvnlk0/bO6lwpE7oFjASvh/wn/dRk67pjOBDn8Wy
	lL4nH9avyV6S/211olrHlNbVpz9GfQ29eLjg7N5P0fEdd0tK3rjJKT/I+7Rd9aZ3SPXlGY9k
	bu9gFHlVur7WvOy5S0bo1O7tXg4///i08qYx8168tNhgaTOrvWnC1Jv7nHI0p86c+12JpTgj
	0VCLuag4EQAC2sWsZQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 17, 2012 2:33 AM Linus Walleij wrote:
> 
> On Tue, Oct 16, 2012 at 10:25 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> 
> >  int samsung_gpio_setpull_updown(struct samsung_gpio_chip *chip,
> >                                 unsigned int off, samsung_gpio_pull_t pull)
> >  {
> > @@ -599,7 +593,7 @@ static int samsung_gpiolib_4bit_input(struct gpio_chip *chip,
> >         con &= ~(0xf << con_4bit_shift(offset));
> >         __raw_writel(con, base + GPIOCON_OFF);
> >
> > -       gpio_dbg("%s: %p: CON now %08lx\n", __func__, base, con);
> > +       pr_debug("%s: %p: CON now %08lx\n", __func__, base, con);
> 
> Does your struct gpio_chip provide a valid dev pointer so you can use:
> 
> dev_dbg(chip->dev, "%s: %p: CON now %08lx\n", __func__, base, con);
> 
> In that case use the dev_* print macros everywhere instead.
> 

No, a valid dev pointer is not provided yet.
After a valid dev pointer is available, I will change
pr_debug to dev_dbg.

Best regards,
Jingoo Han

> Yours,
> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

