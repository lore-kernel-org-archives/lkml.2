Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab1ATNg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 08:36:28 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57907 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628Ab1ATNg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 08:36:27 -0500
Date: Thu, 20 Jan 2011 14:36:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH -v10 0/4] Lock-less list
Message-ID: <20110120133621.GA314@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@elte.hu>,
	huang ying <huang.ying.caritas@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Huang Ying <ying.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	"Luck, Tony" <tony.luck@intel.com>
References: <20110119135546.bb7e8f62.akpm@linux-foundation.org>
 <1295484358.15213.25.camel@yhuang-dev>
 <20110119165247.cca2f434.akpm@linux-foundation.org>
 <1295520247.28776.152.camel@laptop>
 <AANLkTimR6xd1PxCP6jmuNwFkANrGPdTf2wpiGsBXGpKx@mail.gmail.com>
 <1295522876.28776.158.camel@laptop>
 <AANLkTin3_NuGG_E0Juy7=1Q7PcMJ6id1ZU-Gngfp_=dg@mail.gmail.com>
 <20110120121455.GA7680@elte.hu>
 <AANLkTikv3h_QoHs4uj6CNJdC7tb_-e0osKa47KWEJvFV@mail.gmail.com>
 <20110120130625.GA14436@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110120130625.GA14436@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Tony.

On Thu, Jan 20, 2011 at 02:06:25PM +0100, Ingo Molnar wrote:
> 
> * huang ying <huang.ying.caritas@gmail.com> wrote:
> 
> > On Thu, Jan 20, 2011 at 8:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > * huang ying <huang.ying.caritas@gmail.com> wrote:
> > >
> > >> > But will all that stuff be accepted? Please stop sending infrastructure bits and
> > >> > focus on your larger RAS picture, once you have consensus on that from all
> > >> > parties involved, then, and only then, does it make sense to submit everything,
> > >> > including infrastructure.
> > >>
> > >> I am not sending hardware error reporting infrastructure.  As far as I know, Linus
> > >> and Andrew suggest to use printk for hardware error reporting.  And now, I just
> > >> try to write APEI driver and reporting hardware error with printk.  Is it
> > >> acceptable?  Do you have some other idea about hardware error reporting?
> > >
> > > Erm, how could you possible have missed the perf based RAS daemon work of Boris,
> > > which we've pointed out about half a dozen times already?
> > 
> > Even if there is some other hardware error reporting infrastructure
> > such as perf based, I think we still need printk too. After all, as
> > Linus pointed out, printk is the most popular error reporting
> > mechanism so far. Do you think so?
> 
> Of course, that's why the upstream EDAC code uses printk too. In fact it does all 
> sorts of in-kernel decoding to make the printk output more useful - the /dev/mcelog 
> method of pushing all decoding to user-space is fundamentally flawed.

True story. And yet google folk still do that, unfortunately:
https://lkml.org/lkml/2011/1/10/419

I think printk should be used in the most cases, where the home user
runs Linux on his machine and it freezes and when he tries to catch the
MCA info, he simply collects serial console or with a persistent storage
device in place, he reboots and then reads out the exact decoded error.

In the big data center, printk might not be that useful anymore and we
might want to have structured log error data - still decoded, mind you,
and properly formatted but sent to userspace over perf and then over
the network or collected by a userspace daemon doing policy decisions
and error trends evaluation. This is, I think, much saner approach than
collecting hardware info from every machine and then using it to decode
the errors. We still need a bunch of work in that direction though.

> So yes, printk is the primary output channel and having a readable printk output 
> pretty much overrides any other concern.
> 
> But that is not what you are doing. I get the impression that you are using printk 
> as an _excuse_ to not have to work with the RAS people and run some parallel 
> framework so that you do not have to work with them or listen to them. It is rather 
> counter-productive. Working together is useful.

So yeah, let me reiterate what Andrew and Ingo said: I don't want to
discuss the merits of all those cool lockless software thingies that
could replace this and that and would be cool if someone used them. I'm
only interested if they can help in a real-world use case - otherwise
it's just a programming exercise.

Yeah, this all IMHO, of course :).

-- 
Regards/Gruss,
Boris.
