Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab0JDQqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 12:46:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38305 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab0JDQqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 12:46:03 -0400
Date: Mon, 4 Oct 2010 10:46:00 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [patch 46/47] powerpc: Use new irq allocator
Message-ID: <20101004164600.GB13749@angua.secretlab.ca>
References: <20100930221351.682772535@linutronix.de>
 <20100930221743.014571381@linutronix.de>
 <1285893737.2463.4.camel@pasglop>
 <alpine.LFD.2.00.1010011504380.2416@localhost6.localdomain6>
 <m1bp7bfc9n.fsf@fess.ebiederm.org>
 <1286146459.2463.308.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286146459.2463.308.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 09:54:19AM +1100, Benjamin Herrenschmidt wrote:
> On Sun, 2010-10-03 at 09:53 -0700, Eric W. Biederman wrote:
> > Thomas Gleixner <tglx@linutronix.de> writes:
> > 
> > >> That would make things much cleaner and in fact move one large step
> > >> toward being able to make powerpc virq scheme generic, which seems to be
> > >> a good idea from what I've heard :-)
> > >
> > > Yep.
> > 
> > I'm not certain about making the ppc virq scheme generic.  Maybe it is
> > just my distorted impression but I have the understanding that ppc irq
> > numbers mean nothing and are totally unstable whereas on x86 irq numbers
> > in general are stable (across kernel upgrades and changes in device
> > probe order) and the irq number has a useful hardware meaning.  Which
> > means you don't have to go through several layers of translation tables
> > to figure out which hardware pin you are talking about.
[...]
>
> The main deal I'd say is that in embedded land (and to some extent I
> suspect that's going to happen more with x86), you quickly end up with
> multiple interrupt domains, via cascaded controllers of all kinds etc...
[...]
>  - Appart from the risk of breaking crap that parses /proc/interrupts,
> adding the HW irq information there would be trivial and solve your
> problem.
> 
> So overall, I don't see a problem at all. And it makes handling of
> arbitrary combinations of interrupt domains (cascaded PICs) very very
> easy indeed.

Right, the stability of irq numbers is more of a user-interface
problem than a technical deficiency with virq, and a solvable one at
that.  If fact, I'd go as far as saying that having irq numbers mean
nothing is a *virtue* of the approach because it forces developers to
look at the real irq controller attachment rather than some
hwirq==linux-irq assumption.

As mentioned in my other reply, I'd be perfectly happy to stop exposing
linux irq numbers to userspace entirely, but I realize that would
break /proc/interrupts users.  However, I do completely agree that
exposing the hwirq information is very much required.

g.
