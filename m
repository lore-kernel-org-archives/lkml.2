Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510Ab2HIToM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:44:12 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58802 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759376Ab2HIToJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:44:09 -0400
Date: Thu, 9 Aug 2012 20:44:05 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        devicetree-discuss@lists.ozlabs.org,
        broonie@opensource.wolfsonmicro.com,
        STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH 1/8] of/irq: Create stub for of_irq_find_parent when
 !CONFIG_OF
Message-ID: <20120809194403.GB9966@gmail.com>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
 <1344527635-6163-2-git-send-email-lee.jones@linaro.org>
 <5023E366.9010603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5023E366.9010603@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 11:20:54AM -0500, Rob Herring wrote:
> On 08/09/2012 10:53 AM, Lee Jones wrote:
> > of_irq_find_parent is a handy function to use outside the confines of
> > the Open Firmware subsystem. One such use-case is when the IRQ Domain
> > wishes to find an IRQ domain for a given device node. Currently it can
> > not take any notice of the 'interrupt-parent' property. Instead it
> > just uses the first IRQ controller as it climbs the Device Tree. If
> > we were to use this as a precursor the resultant controller is more
> > likely to be correct.
> 
> Where are you using this? I don't have all the patches in the series.

Sorry Rob. Here:

https://lkml.org/lkml/2012/8/9/373

> > CC: Rob Herring <rob.herring@calxeda.com>
> > CC: devicetree-discuss@lists.ozlabs.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  include/linux/of_irq.h |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
> > index 1717cd9..b8e2411 100644
> > --- a/include/linux/of_irq.h
> > +++ b/include/linux/of_irq.h
> > @@ -83,6 +83,11 @@ static inline unsigned int irq_of_parse_and_map(struct device_node *dev,
> >  {
> >  	return 0;
> >  }
> > +
> > +static inline void *of_irq_find_parent(struct device_node *child)
> > +{
> > +	return NULL;
> > +}
> >  #endif /* !CONFIG_OF */
> >  
> >  #endif /* __OF_IRQ_H */
> > 
> 

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
