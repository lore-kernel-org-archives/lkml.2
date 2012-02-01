Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab2BAAHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 19:07:11 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38105 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab2BAAHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 19:07:09 -0500
Date: Tue, 31 Jan 2012 17:07:02 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, b-cousson@ti.com,
        Linus Walleij <linus.ml.walleij@gmail.com>
Subject: Re: [PATCH v3 2/2] gpio: pl061: enable interrupts with DT style
 binding
Message-ID: <20120201000702.GL22611@ponder.secretlab.ca>
References: <1327944699-29882-1-git-send-email-robherring2@gmail.com>
 <1327944699-29882-3-git-send-email-robherring2@gmail.com>
 <20120131143609.GA26436@S2101-09.ap.freescale.net>
 <4F27FE43.7090503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F27FE43.7090503@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 08:44:19AM -0600, Rob Herring wrote:
> On 01/31/2012 08:36 AM, Shawn Guo wrote:
> > On Mon, Jan 30, 2012 at 11:31:39AM -0600, Rob Herring wrote:
> > ...
> >> -static void __init pl061_init_gc(struct pl061_gpio *chip, int irq_base)
> >> +static void __init pl061_init_gc(struct pl061_gpio *chip,
> >> +				 struct device_node *node, int irq_base)
> >>  {
> >>  	struct irq_chip_type *ct;
> >>  
> >> @@ -212,15 +212,17 @@ static void __init pl061_init_gc(struct pl061_gpio *chip, int irq_base)
> >>  	ct->chip.irq_set_wake = irq_gc_set_wake;
> >>  	ct->regs.mask = GPIOIE;
> >>  
> >> -	irq_setup_generic_chip(chip->irq_gc, IRQ_MSK(PL061_GPIO_NR),
> >> -			       IRQ_GC_INIT_NESTED_LOCK, IRQ_NOREQUEST, 0);
> >> +	irq_setup_generic_chip_domain(chip->irq_gc, node,
> >> +				      IRQ_MSK(PL061_GPIO_NR),
> >> +				      IRQ_GC_INIT_NESTED_LOCK,
> >> +				      IRQ_NOREQUEST, 0);
> >>  }
> > 
> > The function irq_setup_generic_chip_domain() is wrapped by
> > #ifdef CONFIG_IRQ_DOMAIN in patch #1.  Is it true that pl061 driver
> > will never work with !IRQ_DOMAIN case?
> 
> You're right unless Grant thinks IRQ_DOMAIN should always be enabled for
> ARM? Otherwise, I'll add something like this for !IRQ_DOMAIN:

I think always having IRQ_DOMAIN on are is where we want to get to; or at least
have platforms that use it depend on it or select it.  I don't want to see
interrupt controllers both use irq_domain and also their own open-coded
translation mechanism.  That's just a fail.

If irq_domain isn't acceptable to be enabled all the time, then it needs to be
refactored until it is.

g.
