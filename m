Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab1EaBah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 21:30:37 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:9236 "EHLO
	VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755747Ab1EaBae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 21:30:34 -0400
X-SpamScore: -19
X-BigFish: VS-19(zz1447R1432N98dKzz1202hzz8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 31 May 2011 09:35:16 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Olof Johansson <olof@lixom.net>
CC: Shawn Guo <shawn.guo@linaro.org>, <linux-kernel@vger.kernel.org>,
        <grant.likely@secretlab.ca>, <arnd@arndb.de>, <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <patches@linaro.org>
Subject: Re: [PATCH 1/4] gpio: gpio-mxc: add gpio driver for Freescale MXC
 architecture
Message-ID: <20110531013515.GA31928@S2100-06.ap.freescale.net>
References: <1306767139-24763-1-git-send-email-shawn.guo@linaro.org>
 <1306767139-24763-2-git-send-email-shawn.guo@linaro.org>
 <20110531005315.GC3411@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110531005315.GC3411@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

Thanks for the review.

On Mon, May 30, 2011 at 05:53:15PM -0700, Olof Johansson wrote:
> Hi,
> 
> On Mon, May 30, 2011 at 10:52:16PM +0800, Shawn Guo wrote:
> > Add gpio-mxc driver by copying arch/arm/plat-mxc/gpio.c into
> > drivers/gpio with the following changes.
> > 
> >  * Use readl/writel to replace mach-specific accessors
> >    __raw_readl/__raw_writel
> > 
> >  * Migrate to platform driver by adding .probe function
> > 
> >  * Add a list to save all mx2 ports references, so that
> >    mx2_gpio_irq_handler can walk through all interrupt status
> >    registers
> > 
> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> > ---
> >  arch/arm/plat-mxc/include/mach/gpio.h |    2 +
> >  drivers/gpio/Makefile                 |    1 +
> >  drivers/gpio/gpio-mxc.c               |  423 +++++++++++++++++++++++++++++++++
> >  3 files changed, 426 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/gpio/gpio-mxc.c
> > 
> > diff --git a/arch/arm/plat-mxc/include/mach/gpio.h b/arch/arm/plat-mxc/include/mach/gpio.h
> > index a2747f1..87bd4ef 100644
> > --- a/arch/arm/plat-mxc/include/mach/gpio.h
> > +++ b/arch/arm/plat-mxc/include/mach/gpio.h
> > @@ -37,7 +37,9 @@
> >  #define irq_to_gpio(irq)	((irq) - MXC_GPIO_IRQ_START)
> >  
> >  struct mxc_gpio_port {
> > +	struct list_head node;
> >  	void __iomem *base;
> > +	int id;
> 
> What's id for? You assign it based on pdev->id in the probe function but
> never use it anywhere else.
> 
Yes, it is only used in probe function right now, and can be removed.
I feel it will be needed someday when more cleanup and consolidation
works happen, but we can add it back then.  So, yes, I will remove it
for now.

-- 
Regards,
Shawn

