Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab1DCKbE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 06:31:04 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:34802 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750988Ab1DCKbD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 06:31:03 -0400
Date: Sun, 3 Apr 2011 12:26:11 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Rabin Vincent <rabin@rab.in>
Cc: Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@stericsson.com>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: nomadik: avoid assigning u32 to bool
Message-ID: <20110403122611.4cca78b9@absol.kitzblitz>
In-Reply-To: <BANLkTinujPcSq86wjue+SGw5ZMiiLRaT_A@mail.gmail.com>
References: <20110401235113.083787a7@absol.kitzblitz>
 <BANLkTinujPcSq86wjue+SGw5ZMiiLRaT_A@mail.gmail.com>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rabin Vincent <rabin@rab.in>:
> On Sat, Apr 2, 2011 at 03:21, Nicolas Kaiser <nikai@nikai.net> wrote:
> > Avoid assigning u32 to the bool 'enabled'.
> >
> > Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> > ---
> >  arch/arm/plat-nomadik/gpio.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/arm/plat-nomadik/gpio.c b/arch/arm/plat-nomadik/gpio.c
> > index f49748e..8b722f7 100644
> > --- a/arch/arm/plat-nomadik/gpio.c
> > +++ b/arch/arm/plat-nomadik/gpio.c
> > @@ -636,7 +636,7 @@ static int nmk_gpio_irq_set_type(struct irq_data *d, unsigned int type)
> >        if (type & IRQ_TYPE_LEVEL_LOW)
> >                return -EINVAL;
> >
> > -       enabled = nmk_chip->enabled & bitmask;
> > +       enabled = !!(nmk_chip->enabled & bitmask);
> 
> Why?  There are dozens of places in the kernel where this done, the code
> generated should be the same, and it's pretty obvious what is being done
> as it is.

Primarily because we were asked to avoid casts to bool even if
they are safe.
https://lkml.org/lkml/2011/4/1/255

Besides, many of the places I found that do 'bool a = b & c;'
actually do 'bool a = b & 1;'.

Best regards,
Nicolas Kaiser
