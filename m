Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369Ab1EaJLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 05:11:53 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:57638 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab1EaJLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 05:11:52 -0400
X-SpamScore: -19
X-BigFish: VS-19(zz1447R1432N98dKzz1202hzz8275dhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 31 May 2011 17:16:42 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Jamie Iles <jamie@jamieiles.com>
CC: Shawn Guo <shawn.guo@linaro.org>, <linux-kernel@vger.kernel.org>,
        <grant.likely@secretlab.ca>, <arnd@arndb.de>, <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <patches@linaro.org>
Subject: Re: [PATCH 1/4] gpio: gpio-mxc: add gpio driver for Freescale MXC
 architecture
Message-ID: <20110531091641.GA32096@S2100-06.ap.freescale.net>
References: <1306767139-24763-1-git-send-email-shawn.guo@linaro.org>
 <1306767139-24763-2-git-send-email-shawn.guo@linaro.org>
 <20110531084424.GA2266@pulham.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110531084424.GA2266@pulham.picochip.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jamie,

On Tue, May 31, 2011 at 09:44:24AM +0100, Jamie Iles wrote:
> Hi Shawn,
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
> 
> Could you use the stuff in drivers/gpio/basic_mmio_gpio.c for 
> implementing the gpio_chip?  I had a go a little while ago [1] but since 
> then we've made it possible to embed the bgpio_chip in your own 
> structure which may be cleaner.
> 
> Jamie
> 
> 1. http://permalink.gmane.org/gmane.linux.ports.arm.kernel/113139
> --

I would like to keep this series as simple as it is, straight moving
plat-mxc/gpio into drivers/gpio, and then start looking at the
possible consolidation, like generic_irq_chip and basic_mmio_gpio you
offered here.  Thanks for the patch.  I will start with it shortly. 

-- 
Regards,
Shawn

