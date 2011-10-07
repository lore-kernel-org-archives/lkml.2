Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab1JGTFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 15:05:21 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:27537 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab1JGTFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 15:05:20 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+uTCcvA2GxgCrzSsANRu2i
Date: Fri, 7 Oct 2011 12:05:12 -0700
From: Tony Lindgren <tony@atomide.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Leo Yan <leoy@marvell.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Haojian Zhuang <hzhuang1@marvell.com>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH] ARM: mmp: map sram as MT_MEMORY rather than MT_DEVICE
Message-ID: <20111007190512.GL6324@atomide.com>
References: <1313377794-26721-1-git-send-email-leoy@marvell.com>
 <1313377794-26721-2-git-send-email-leoy@marvell.com>
 <20110822164740.5682541b@queued.net>
 <20110823000755.GE3895@n2100.arm.linux.org.uk>
 <20110822191335.3dbe99b9@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822191335.3dbe99b9@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andres Salomon <dilinger@queued.net> [110822 18:40]:
> On Tue, 23 Aug 2011 01:07:55 +0100
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> [...]
> > > @@ -87,7 +88,8 @@ static int __devinit sram_probe(struct
> > > platform_device *pdev) 
> > >  	info->sram_phys   = (phys_addr_t)res->start;
> > >  	info->sram_size   = resource_size(res);
> > > -	info->sram_virt   = ioremap(info->sram_phys,
> > > info->sram_size);
> > > +	info->sram_virt   = __arm_ioremap(info->sram_phys,
> > > info->sram_size,
> > > +					  MT_MEMORY);
> > 
> > Not a good idea fiddling about under the covers like that.  The reason
> > that MT_MEMORY is not in asm/io.h is to stop it being used like this -
> > MT_MEMORY etc are not meant for general purpose use.
> > 
> > It needs to be looked at properly rather than working behind the APIs,
> > and making my life a misery by doing so, preventing me from making
> > changes where necessary by this kind of back-door use.
> > 
> > I guess we need a new ioremap_xxx() variant to cope with this.
> 
> Something like ioremap_exec()?  I have no idea what the related MT_
> entry would be (as someone who's new to the ARM world, it's not
> entirely clear what the semantic distinctions are between the various
> MT_ entries).

Andres, care to ack this patch:

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7126/1

Looks like that should do what you want. And after the related
SRAM/map_io fixes for omap, it really seems that we could have
a generic SRAM driver..

Regards,

Tony
