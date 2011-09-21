Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab1IUMP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 08:15:28 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:12539
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751606Ab1IUMP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 08:15:27 -0400
X-SpamScore: -11
X-BigFish: VS-11(zcb8kz1447M1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 21 Sep 2011 20:23:41 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Jamie Iles <jamie@jamieiles.com>
CC: Shawn Guo <shawn.guo@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <patches@linaro.org>
Subject: Re: [PATCH] gpio/mxc: make it work with imx6q
Message-ID: <20110921122340.GH28907@S2100-06.ap.freescale.net>
References: <1316423432-18333-1-git-send-email-shawn.guo@linaro.org>
 <20110920130508.GE2962@pulham.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110920130508.GE2962@pulham.picochip.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 02:05:09PM +0100, Jamie Iles wrote:
> Hi Shawn,
> 
> On Mon, Sep 19, 2011 at 05:10:32PM +0800, Shawn Guo wrote:
> > The imx6q is a Cortex-A9 Quad Core SoC, which has GIC as the primary
> > interrupt controller.  GIC requires gpio irq handler to signal EOI,
> > otherwise system will hang whenever there is a gpio irq triggered.
> > 
> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> > ---
> >  drivers/gpio/gpio-mxc.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
> > index 4340aca..00b4c9c 100644
> > --- a/drivers/gpio/gpio-mxc.c
> > +++ b/drivers/gpio/gpio-mxc.c
> > @@ -233,6 +233,9 @@ static void mx3_gpio_irq_handler(u32 irq, struct irq_desc *desc)
> >  	u32 irq_stat;
> >  	struct mxc_gpio_port *port = irq_get_handler_data(irq);
> >  
> > +	if (desc->irq_data.chip->irq_eoi)
> > +		desc->irq_data.chip->irq_eoi(&desc->irq_data);
> > +
> >  	irq_stat = readl(port->base + GPIO_ISR) & readl(port->base + GPIO_IMR);
> >  
> >  	mxc_gpio_irq_handler(port, irq_stat);
> > -- 
> > 1.7.4.1
> 
> Could this make use of the chained_irq_enter/chained_irq_exit functions 
> added in 10a8c38 (ARM: 6806/1: irq: introduce entry and exit functions 
> for chained handlers)?
> 
Yes.  Will respin the patch to use it.

Thanks for the point, Jamie.

-- 
Regards,
Shawn

