Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab2I0QOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 12:14:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35752 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299Ab2I0QOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 12:14:07 -0400
Date: Thu, 27 Sep 2012 17:13:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Fabio Estevam <festevam@gmail.com>, sameo@linux.intel.com, marex@denx.de,
        ashish.jangam@kpitcummins.com, dchen@diasemi.com,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] mfd: da9052-core: Fix request_threaded_irq() parameter
Message-ID: <20120927161359.GA4428@opensource.wolfsonmicro.com>
References: <1348718135-10300-1-git-send-email-festevam@gmail.com>
 <20120927140843.GX4428@opensource.wolfsonmicro.com>
 <201209271434.45516.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209271434.45516.arnd@arndb.de>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 02:34:45PM +0000, Arnd Bergmann wrote:
> On Thursday 27 September 2012, Mark Brown wrote:

> > The driver shouldn't be relying on irq_base at all, it should use
> > regmap_get_virq() to look up the interrupt number.  If it relies on
> > irq_base then the user is forced to assign one (or rely on automatic
> > assignment, which is a bit erratic.  Otherwise it can use a linear
> > domain which doesn't rely on being able to allocate a big block of
> > interrupt numbers.

> For all I can tell, the driver implements the automatic assignment
> correctly, but I was also going to ask for removing the da9052->irq_base
> variable and using the linear domain instead.

It's possible, IIRC last time I looked at it for API updates I decided
it was so clearly never going to work due to requesting without using
irq_base that I just ignored it for the purposes of compliation.

> We don't have any platforms actually setting the irq_base in the
> mainline kernel (I assume some of out tree platforms do this), but there

It's relatively rare to use the GPIOs as IRQs which is the only reason
you'd need to do this.  That said I'm frankly unconvinced that the
driver has ever been tested given the general pain with the original
submission process.

> are a few drivers that need to be adapted to use regmap_irq_get_virq
> or irq_to_desc(irq)->hw_irq, respectively:

> drivers/gpio/gpio-da9052.c:     return da9052->irq_base + DA9052_IRQ_GPI0 + offset;

Yeah, they all ought to be converted.
