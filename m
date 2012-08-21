Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab2HUMCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:02:54 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52444 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936Ab2HUMCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:02:51 -0400
Date: Tue, 21 Aug 2012 13:02:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 5/8] mfd: Provide the PRCMU with its own IRQ domain
Message-ID: <20120821120243.GF26899@gmail.com>
References: <20120820083640.GH8450@gmail.com>
 <20120820121055.GA26991@opensource.wolfsonmicro.com>
 <20120820125531.GA20242@gmail.com>
 <20120820162923.GF26991@opensource.wolfsonmicro.com>
 <20120820164949.GB22749@gmail.com>
 <20120820175155.GH26991@opensource.wolfsonmicro.com>
 <20120821085618.GA26899@gmail.com>
 <20120821095026.GU26991@opensource.wolfsonmicro.com>
 <20120821105413.GD26899@gmail.com>
 <20120821110329.GA7995@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120821110329.GA7995@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 12:03:29PM +0100, Mark Brown wrote:
> On Tue, Aug 21, 2012 at 11:54:14AM +0100, Lee Jones wrote:
> > On Tue, Aug 21, 2012 at 10:50:27AM +0100, Mark Brown wrote:
> 
> > > What makes you say this?  This is just a convenience for finding a
> > > domain, irqdomains are *completely* indepentant of device tree.
> 
> > How can you say that? I think you mean _can_ be independent of DT. If
> > that's what you mean then yes, that's true. All I'm saying is we need
> 
> No, I really mean what I'm saying.  Device tree builds on irqdomains,
> not the other way around.

This is just semantics.
 
> > another way to get hold of the domain, because the only way to obtain
> > it without having direct access is via a device node.
> 
> This doesn't actually hold.

Okay, besides irq_find_host(struct device_node *np), how else can you fetch
a domain from the irqdomain?

> > > > - I know that you have interest in pushing the functionality into the
> > > > IRQ domain subsystem, but I'm struggling to see how. It's calling into
> > > > the IRQ domain where we're seeing issues in the first place, specifically
> > > > irq_create_mapping(). How about if we passed 'irq_domain' as a parameter
> > > > when requesting the IRQ? That way we can pass the correct IRQ without
> > > > worry of conversion. If 'irq_domain' is !NULL the IRQ management subsystem
> > > > can do the necessary conversions. If 'irq_domain' is NULL it continues to
> > > > use the requested IRQ as a virq.
> 
> > > This is totally orthogonal to doing the mapping in the MFD subsystem
> > > which is the issue here.
> 
> > Again, I only mentioned this because you said you wanted it to be handled
> > by the irqdomain.
> 
> The *mapping* should be being handled in irqdomain.
> 
> > I'll code up the second suggestion now.
> 
> I've already done this.

What have you done already? 

Why make suggestions if you're just going to do the work yourself?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
