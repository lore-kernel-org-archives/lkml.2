Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab0JSXBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 19:01:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754960Ab0JSXBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 19:01:48 -0400
Date: Tue, 19 Oct 2010 16:00:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Florian Fainelli <florian@openwrt.org>,
        David Brownell <david-b@pacbell.net>, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Miguel Gaio <miguel.gaio@efixo.com>, dbrownell@users.sourceforge.net,
        Juhos Gabor <juhosg@openwrt.org>
Subject: Re: [PATCH v5] GPIO: add support for 74x164 serial-in/parallel-out
 8-bit shift register
Message-Id: <20101019160010.45750e1c.akpm@linux-foundation.org>
In-Reply-To: <AANLkTinS+bH+u-x0jEcMgN+uK-__65TNNGg6uQA55TSv@mail.gmail.com>
References: <201010182135.09506.florian@openwrt.org>
	<AANLkTinS+bH+u-x0jEcMgN+uK-__65TNNGg6uQA55TSv@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 09:26:42 +0200
Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:

> On Mon, Oct 18, 2010 at 9:35 PM, Florian Fainelli <florian@openwrt.org> wrote:
> > From: Miguel Gaio <miguel.gaio@efixo.com>
> >
> > This patch adds support for generic 74x164 serial-in/parallel-out 8-bits
> > shift register. This driver can be used as a GPIO output expander.
> >
> ...
> > +struct gen_74x164_chip {
> > +       struct spi_device       *spi;
> > +       struct gpio_chip        gpio_chip;
> > +       struct mutex            lock;
> > +       u8                      port_config;
> > +};
> ...
> > +static void gen_74x164_set_value(struct gpio_chip *gc,
> > +               unsigned offset, int val)
> > +{
> > +       struct gen_74x164_chip *chip = gpio_to_chip(gc);
> > +       bool refresh;
> > +
> > +       mutex_lock(&chip->lock);
> > +       if (val)
> > +               chip->port_config |= (1 << offset);
> > +       else
> > +               chip->port_config &= ~(1 << offset);
> 
> set_bit(), clear_bit() ?

They're only to be used on `unsigned long' types, and `port_config' is
u8.
