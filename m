Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab1C0PsA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 11:48:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:43185 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab1C0Pr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 11:47:59 -0400
Date: Sun, 27 Mar 2011 17:47:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sergei Shtylyov <sshtylyov@mvista.com>
cc: LKML <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [patch 17/23] arm: at91: Cleanup irq chip
In-Reply-To: <4D8F5186.5030109@ru.mvista.com>
Message-ID: <alpine.LFD.2.00.1103271747360.31464@localhost6.localdomain6>
References: <20110325131617.258789658@linutronix.de> <20110325132048.996818347@linutronix.de> <alpine.LFD.2.00.1103252202440.31464@localhost6.localdomain6> <4D8F5186.5030109@ru.mvista.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-443207482-1301240877=:31464"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-443207482-1301240877=:31464
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 27 Mar 2011, Sergei Shtylyov wrote:

> Hello.
> 
> On 26-03-2011 0:03, Thomas Gleixner wrote:
> 
> > > Avoid the whole lazy disable dance in the demux handler by providing a
> > > irq_disable() callback.
> 
> > > Use the proper accessor functions and tidy up gpio_irq_handler()
> 
> > > Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
> [...]
> 
> > > Index: linux-2.6-tip/arch/arm/mach-at91/gpio.c
> > > ===================================================================
> > > --- linux-2.6-tip.orig/arch/arm/mach-at91/gpio.c
> > > +++ linux-2.6-tip/arch/arm/mach-at91/gpio.c
> [...]
> > > @@ -384,16 +385,14 @@ static struct irq_chip gpio_irqchip = {
> > >   static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
> > >   {
> > >   	unsigned	pin;
> > > -	struct irq_desc	*gpio;
> > > -	struct at91_gpio_chip *at91_gpio;
> > > -	void __iomem	*pio;
> > > +	struct irq_data *idata = irq_desc_get_irq_data(desc);
> > > +	struct irq_chip *chip = irq_data_get_chip(data);
> > > +	struct at91_gpio_chip *at91_gpio = irq_data_get_chip_data(data);
> 
> > Sorry, needs to be
> 
> > +	struct at91_gpio_chip *at91_gpio = irq_data_get_irq_chip_data(data);
> 
> > Will fix and resend.
> 
>    You also don't have 'data' defined anywhere, maybe you meant 'ídata'?

I know, the compiler already slapped me.
---1463795968-443207482-1301240877=:31464--
