Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab1DHQ0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 12:26:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48935 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab1DHQ0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 12:26:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UaWPKt5lCjhFS7I7m2KItOVU3gpRu7Ff5KAPZvvcS5kRh0ehOKwHfv6gyoD47Lwvgc
         Wa9NBv8Q8UHh0x1bHa/VbPy/rbTSOW+5AKnTHZ0/Ku+bykbN4PSjncJhucLaShRVFRe0
         +MR+kW3LuxuQXGGfH/75fmPYB1FviTixn7AAc=
Date: Fri, 8 Apr 2011 20:26:30 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net
Subject: Re: [PATCHv2 6/7] basic_mmio_gpio: support different input/output
 registers
Message-ID: <20110408162630.GA7354@oksana.dev.rtsoft.ru>
References: <1302272211-30242-1-git-send-email-jamie@jamieiles.com>
 <1302272211-30242-7-git-send-email-jamie@jamieiles.com>
 <20110408144628.GC25237@oksana.dev.rtsoft.ru>
 <20110408161113.GG2933@pulham.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110408161113.GG2933@pulham.picochip.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 05:11:13PM +0100, Jamie Iles wrote:
[...]
> > > +++ b/drivers/gpio/basic_mmio_gpio.c
> > > @@ -70,6 +70,7 @@ struct bgpio_chip {
> > >  	void __iomem *reg_dat;
> > >  	void __iomem *reg_set;
> > >  	void __iomem *reg_clr;
> > > +	void __iomem *reg_in;
> > 
> > Btw, I wonder if it makes sense (and more logical) for separate output/
> > input registers case to use "reg_dat" for 'input' and 'reg_set' for
> > output?
> 
> Sounds like a good idea.  Something like this?

Yep, exactly.

[...]
> +	} else if (res_set && !res_clr) {
> +		if (resource_size(res_set) != resource_size(res_dat) ||
> +		    resource_size(res_set) != bgc->bits / 8)

We derive bgc->bits from resource_size(res_dat), so '!= bgc->bits / 8'
condition is uneeded.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
