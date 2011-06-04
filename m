Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab1FDJvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 05:51:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57998 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754725Ab1FDJvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 05:51:41 -0400
Date: Sat, 4 Jun 2011 10:51:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Milton Miller <miltonm@bga.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: genirq: Ensure we locate the passed IRQ in irq_alloc_descs()
Message-ID: <20110604095138.GA708@opensource.wolfsonmicro.com>
References: <1307037313-15733-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <nack-locate@mdm.bga.com>
 <20110603104217.GA4777@opensource.wolfsonmicro.com>
 <locate-from-more@mdm.bga.com>
 <20110603150636.GA9492@opensource.wolfsonmicro.com>
 <alpine.LFD.2.02.1106031823310.3078@ionos>
 <irq-locate-ack@mdm.bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <irq-locate-ack@mdm.bga.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 07:23:24PM -0500, Milton Miller wrote:
> On Fri, 3 Jun 2011 about 16:06:36 +0100, Mark Brown wrote:

> > I need either a specific IRQ or an allocated one.  This is just a very
> > standard driver with an interrupt controller 

> I don't know that I'd call an interrupt controller a standard driver
> today, but agree we are heading towards that.

Pretty much any modern ARM system will have a PMIC with an interrupt
controller in it.

> > The driver assumes it's going to get a contiguous range, it'd be a lot
> > of bookkeeping for no gain to have to cope with them being splattered
> > all over the place.

> The irq domain concept addresses mapping, but a simple fully allocated
> block will be one of the options.  Having 60 irqdesc might be 
> pushing the limit for some platforms but that can be addressed later
> when irq domains are upstream.

I'm not really sure what an IRQ domain is (the patch series you pointed
at before does rather appear to assume one knows already) but given that
we're allocating from within a 32 bit type it seems like we should be
using a few orders of magnitude more interrupts in a system than we do
presently before this becomes much of an issue.

> > If the user cares they can just pick a number for the base; if they're
> > going to pick a number they may as well pick the actual number.

> I'd argue the user is the wrong level to make this decision.  However,
> saying the platform decides is valid, and the excerpt you had earlier
> implied you were getting the irq argument from platform data, not the
> user (eg via a module parameter)..

It's platform data.  Having interrupt numbers specified as module
parameters strikes me as insane - the particular integers we map
individual interrupts onto are very much an implementation decision of
the kernel.

> I should point out that several archtectures currently allocate irqs
> in a architecture layer before calling the irq allocator asking for
> the exact irq they choose on what they thought was free.  Among these
> are x86 and powerpc.   Not calling the architecture layer will causein
> all future allocations by other drivers using the architecture layer
> to fail..

That sounds like we should join the two IRQ allocators up with each
other.
