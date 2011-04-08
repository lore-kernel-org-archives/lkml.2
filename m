Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab1DHQcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 12:32:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33420 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1DHQco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 12:32:44 -0400
Date: Fri, 8 Apr 2011 17:32:40 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, tglx@linutronix.de, grant.likely@secretlab.ca,
        arnd@arndb.de, nico@fluxnic.net
Subject: Re: [PATCHv2 6/7] basic_mmio_gpio: support different input/output
 registers
Message-ID: <20110408163240.GI2933@pulham.picochip.com>
References: <1302272211-30242-1-git-send-email-jamie@jamieiles.com>
 <1302272211-30242-7-git-send-email-jamie@jamieiles.com>
 <20110408144628.GC25237@oksana.dev.rtsoft.ru>
 <20110408161113.GG2933@pulham.picochip.com>
 <20110408162630.GA7354@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110408162630.GA7354@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 08:26:30PM +0400, Anton Vorontsov wrote:
> On Fri, Apr 08, 2011 at 05:11:13PM +0100, Jamie Iles wrote:
> [...]
> > > > +++ b/drivers/gpio/basic_mmio_gpio.c
> > > > @@ -70,6 +70,7 @@ struct bgpio_chip {
> > > >  	void __iomem *reg_dat;
> > > >  	void __iomem *reg_set;
> > > >  	void __iomem *reg_clr;
> > > > +	void __iomem *reg_in;
> > > 
> > > Btw, I wonder if it makes sense (and more logical) for separate output/
> > > input registers case to use "reg_dat" for 'input' and 'reg_set' for
> > > output?
> > 
> > Sounds like a good idea.  Something like this?
> 
> Yep, exactly.
> 
> [...]
> > +	} else if (res_set && !res_clr) {
> > +		if (resource_size(res_set) != resource_size(res_dat) ||
> > +		    resource_size(res_set) != bgc->bits / 8)
> 
> We derive bgc->bits from resource_size(res_dat), so '!= bgc->bits / 8'
> condition is uneeded.

Doh!  Not sure how I missed that!  I'll fix these up and repost them all 
on Monday.

Thanks,

Jamie
