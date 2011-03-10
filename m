Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab1CJXwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:52:22 -0500
Received: from www.tglx.de ([62.245.132.106]:50975 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab1CJXwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:52:21 -0500
Date: Fri, 11 Mar 2011 00:51:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: David Daney <ddaney@caviumnetworks.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Jason Baron <jbaron@redhat.com>, peterz@infradead.org, hpa@zytor.com,
        mingo@elte.hu, andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 0/2] jump label: update for .39
In-Reply-To: <1299800584.15854.520.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1103110047360.2787@localhost6.localdomain6>
References: <1299780241.15854.393.camel@gandalf.stny.rr.com>  <20110310182000.GB2906@redhat.com>  <1299782143.15854.402.camel@gandalf.stny.rr.com>  <4D791CAA.7090108@caviumnetworks.com>  <1299783236.15854.405.camel@gandalf.stny.rr.com>  <4D791F31.6040100@caviumnetworks.com>
  <1299785143.15854.407.camel@gandalf.stny.rr.com>  <1299786329.15854.409.camel@gandalf.stny.rr.com>  <BLU0-SMTP311155BEBE5F141636A6E596C80@phx.gbl>  <1299793339.15854.430.camel@gandalf.stny.rr.com>  <BLU0-SMTP101D168109508CC1B82F0E496C80@phx.gbl> 
 <1299798970.15854.484.camel@gandalf.stny.rr.com>  <4D795DCE.7050807@caviumnetworks.com>  <alpine.LFD.2.00.1103110029090.2787@localhost6.localdomain6> <1299800584.15854.520.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011, Steven Rostedt wrote:
> On Fri, 2011-03-11 at 00:32 +0100, Thomas Gleixner wrote:
> 
> > > It should work, but it hurts my eyes to see the source code forcing a 64-bit
> > > word to 32-bit alignment.
> > 
> > We solved such stuff with macros in other places already.
> > 
> > #ifdef 64bit
> > # define BLA 8
> > #else
> > # define BLA 4
> > #endif
> > 
> > and then use 
> > 
> > .aling BLA
> > 
> > Where is the problem?
> 
> That's basically the solution that Jason came up with, and what I
> expected. What caught my eye was that David Miller had .align 4 for this
> on sparc which is the one arch that is truly picky about such things. As
> I understood more about this, I see that would work for both archs.

I doubt that sparc will barf when we make this 64/32bit aware. If it
does, we have some bigger fish to fry.
 
> That doesn't mean I'm against the .align BLA solution.

As hpa pointed out in some unreadable mail, we have _ASM_ALIGN on x86
already exactly for this purpose.

Thanks,

	tglx
