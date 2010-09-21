Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab0IUJqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 05:46:11 -0400
Received: from www.tglx.de ([62.245.132.106]:47171 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756177Ab0IUJqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 05:46:10 -0400
Date: Tue, 21 Sep 2010 11:45:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andres Salomon <dilinger@queued.net>
cc: Ingo Molnar <mingo@elte.hu>, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org, mingo@redhat.com,
        hpa@zytor.com, Mitch Bradley <wmb@laptop.org>,
        linux-kernel@vger.kernel.org,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: Re: [PATCH 2/2] x86: of: define irq functions to allow drivers/of/*
 to build on x86
In-Reply-To: <20100920190604.5a2118da@debxo>
Message-ID: <alpine.LFD.2.00.1009211144070.2416@localhost6.localdomain6>
References: <20100910060151.6613e9c3@debxo> <20100910172538.GC11284@angua.secretlab.ca> <20100910181458.GA7243@elte.hu> <20100910182135.GG11284@angua.secretlab.ca> <20100920190604.5a2118da@debxo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010, Andres Salomon wrote:
> On Fri, 10 Sep 2010 12:21:35 -0600
> Grant Likely <grant.likely@secretlab.ca> wrote:
> 
> > On Fri, Sep 10, 2010 at 08:14:58PM +0200, Ingo Molnar wrote:
> > > 
> > > * Grant Likely <grant.likely@secretlab.ca> wrote:
> > > 
> > > > On Fri, Sep 10, 2010 at 06:01:51AM -0700, Andres Salomon wrote:
> > > > > 
> > > > >  - Define a stub irq_create_of_mapping for x86 as a stop-gap
> > > > > solution until drivers/of/irq is further along.
> > > > >  - Define irq_dispose_mapping for x86 to appease of_i2c.c
> > > > > 
> > > > > Signed-off-by: Andres Salomon <dilinger@queued.net>
> > > > 
> > > > Applied to my test-devicetree branch.  I'll need an ack from the
> > > > x86 maintainers before I put it into my -next branch.
> > > 
> > > The purpose of the patch is not clear to me. What does it do and
> > > why? 
> > 
> > It allows CONFIG_OF to be enabled on x86 without a build failure.
> > 
> > > The changelog says it's a stopgap measure - what exactly is the
> > > long term plan and how long will it take?
> > 
> > It is a stop gap because it performs a trivial direct map of an IRQ
> > number in the device tree data structure to a Linux irq number.  This
> > works for a single IRQ controller, but falls apart when cascaded
> > controller are described in the device tree.  The long term plan is to
> > have the drivers/of/ code handling the mapping intelligently like
> > powerpc currently does.
> > 
> > g.
> > 
> 
> Any additional comments (ACKs, NACKs, etc) on the patches?  If I need
> to rework it (or them), I can certainly make the patch description
> longer.

Fine with me, but you could make the "mapping" function an inline as
well. While at it, some sensible changelog would be helpful :)

Thanks,

	tglx
