Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab0LTMIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 07:08:18 -0500
Received: from mga03.intel.com ([143.182.124.21]:40042 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757350Ab0LTMIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 07:08:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,201,1291622400"; 
   d="scan'208";a="364085625"
Date: Mon, 20 Dec 2010 13:05:11 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sundar Iyer <sundar.iyer@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: linux-next: manual merge of the mfd tree with the ux500-core
 tree
Message-ID: <20101220120510.GE11095@sortiz-mobl>
References: <20101220152148.6fedee0d.sfr@canb.auug.org.au>
 <20101220042344.GB10050@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220042344.GB10050@linux-sh.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 01:23:44PM +0900, Paul Mundt wrote:
> On Mon, Dec 20, 2010 at 03:21:48PM +1100, Stephen Rothwell wrote:
> > The genirq core is being converted to pass struct irq_data to irq_chip
> > operations rather than an IRQ number. Update the tc35892 driver to the
> > new APIs.
> > 
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > Acked-by: Rabin Vincent <rabin.vincent@stericsson.com>
> > Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> 
> Sorry to hijack the thread..
> 
> > diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
> > index 32291fe..dde2d858 100644
> > --- a/drivers/mfd/tc3589x.c
> > +++ b/drivers/mfd/tc3589x.c
> > @@ -170,15 +170,15 @@ again:
> >  	return IRQ_HANDLED;
> >  }
> >  
> > -static void tc3589x_irq_dummy(unsigned int irq)
> > +static void tc3589x_irq_dummy(struct irq_data *data)
> >  {
> >  	/* No mask/unmask at this level */
> >  }
> >  
> >  static struct irq_chip tc3589x_irq_chip = {
> > -	.name	= "tc3589x",
> > -	.mask	= tc3589x_irq_dummy,
> > -	.unmask	= tc3589x_irq_dummy,
> > +	.name		= "tc3589x",
> > +	.irq_mask	= tc3589x_irq_dummy,
> > +	.irq_unmask	= tc3589x_irq_dummy,
> >  };
> >  
> >  static int tc3589x_irq_init(struct tc3589x *tc3589x)
> 
> Is there some reason you don't just kill this off and use dummy_irq_chip?
Good point.
I removed this patch from my branch and sent a fix to LinusW so that he
carries it from his ux500-core branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
