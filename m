Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab0FDFac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 01:30:32 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56740 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab0FDFaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 01:30:16 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+wndDAjjmtU3JHJnBoI5cI
Date: Fri, 4 Jun 2010 08:29:44 +0300
From: Tony Lindgren <tony@atomide.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King <rmk@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
Message-ID: <20100604052943.GE6499@atomide.com>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
 <20100603164623.GM30622@atomide.com>
 <20100603181303.GB25779@flint.arm.linux.org.uk>
 <1275613325.1931.849.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275613325.1931.849.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Herrenschmidt <benh@kernel.crashing.org> [100604 03:56]:
> On Thu, 2010-06-03 at 19:13 +0100, Russell King wrote:
> > On Thu, Jun 03, 2010 at 07:46:23PM +0300, Tony Lindgren wrote:
> > > Compiling in multiple ARM platforms is trickier, we would have to get
> > > rid of the duplicate defines like NR_IRQS, then have some common clock
> > > framework etc. Then figure out some way to get rid of Makefile.boot.
> > > Russell probably has some other things in mind that would have to be
> > > changed to make this happen.
> 
> Ok so multiple platforms in one kernel is a different subject and could
> warrant a different thread. However it's interesting because we do that
> quite well on powerpc :-)
> 
> (Note also that while the device-tree helps make it even easier, it's
> not fundamentally necessary to achieve that goal).

Yeah both platform data and device tree should work just fine.
 
> > - Find someway to handle the wide variety of interrupt controllers.
> 
> We have a very nice and simple interrupt mapping scheme on powerpc that
> makes that quite trivial along with the generic irq changes that went in
> a couple of years ago (which we mostly based on ARM iirc).
> 
> We have a structure that define an interrupt numbering domain (which can
> be associated 1:1 with a given controller but doesn't have to), and
> simple APIs to allocate "linux" interrupt numbers associated with a
> given domain/HW number pair. From there, we support multiple domains,
> arbitrary layout and cascades, etc...
> 
> > - Be able to handle any multitude of V:P translations, including non-linear
> >   alongside linear transations.
> 
> For the kernel "linear" mapping you mean ? Yeah, that's a bit of a sore
> spot, though sparsemem + vmemmap helps a lot. Creative use of dynamic
> patching would do nicely here though it's problematic with XIP kernels
> (though my understanding is that those are getting less common).
> 
> > - Different PAGE_OFFSETs
> 
> Does this have to be a per SoC or mach family ? Users can change
> PAGE_OFFSET on powerpc to change the user/kernel split (for example in
> order to get more ioremap space or avoid turning on HIGHMEM) but it's in
> the domain of the config and a kernel with a lower PAGE_OFFSET can
> always boot all platforms even those that don't require it.
> 
> Alternatively, you can always try to do like we do on ppc64 with fully
> runtime relocatable kernels :-)
>  
> > - Different kernel VM layouts allowing for a variety of different ioremap
> >   region sizes
> > 
> > and so the list goes on...
> 
> That's quite easily done at runtime.

Thanks for all the good info, that will be handy when trying to
figure out how to change things to support multiple ARM platforms.

Regards,

Tony
