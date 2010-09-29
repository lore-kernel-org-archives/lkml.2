Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab0I2SGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 14:06:18 -0400
Received: from www.tglx.de ([62.245.132.106]:45998 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab0I2SGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 14:06:18 -0400
Date: Wed, 29 Sep 2010 20:05:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arthur Kepner <akepner@sgi.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [RFC/PATCHv2] x86/irq: round-robin distribution of irqs to cpus
 w/in node
In-Reply-To: <20100929171941.GH3096@sgi.com>
Message-ID: <alpine.LFD.2.00.1009291959380.2416@localhost6.localdomain6>
References: <20100927203448.GC30050@sgi.com> <alpine.LFD.2.00.1009272236430.2416@localhost6.localdomain6> <20100927220113.GD30050@sgi.com> <alpine.LFD.2.00.1009280003300.2416@localhost6.localdomain6> <m1hbhalo1o.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.1009280957150.2416@localhost6.localdomain6> <m1eicennfu.fsf@fess.ebiederm.org> <20100929171941.GH3096@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010, Arthur Kepner wrote:
> On Mon, Sep 27, 2010 at 05:17:07PM -0700, Eric W. Biederman wrote:
> > Thomas Gleixner <tglx@linutronix.de> writes:
> 
> On Tue, Sep 28, 2010 at 03:59:33AM -0700, Eric W. Biederman wrote:
> > Thomas Gleixner <tglx@linutronix.de> writes:
> > 
> > > On Mon, 27 Sep 2010, Eric W. Biederman wrote:
> > >> > On Mon, 27 Sep 2010, Arthur Kepner wrote:
> > >> The deep bug is that create_irq_nr allocates a vector (which it does
> > >> because at the time there was no better way to mark an irq in use on
> > >> x86).  In the case of msi-x we really don't know the node that irq is
> > >> going to be used on until we get a request irq.  We simply know which
> > >> node the device is on.
> > >
> > > Bah. So the whole per node allocation business is completely useless
> > > at this point.
> > 
> > Probably.
> 
> Huh? No, the patch that started this thread spreads the irqs around 
> and avoids the problem of a single CPU's vectors all being consumed.

I'm talking about the per node memory allocations for sparse. Not the
irq vectors
 
> > 
> > Understood.  It has taken a couple of years before this bug finally
> > bit anyone waiting a release or two to get it fixed properly seems
> > reasonable.
> > ....
> 
> And so what are we to do in the meantime? At the moment we're 
> disabling MSIX, which is a pretty unattractive workaround.

I understand that. The cleanup patches are hopefully ready for the
next kernel, so we can deal with that problem on top of them.

Thanks,

	tglx
