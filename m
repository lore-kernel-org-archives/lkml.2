Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1EJJgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:36:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49732 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab1EJJgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:36:02 -0400
Date: Tue, 10 May 2011 11:35:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: Vince Weaver <vweaver1@eecs.utk.edu>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        eranian@google.com, Arun Sharma <asharma@fb.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>
Subject: Re: re-enable Nehalem raw Offcore-Events support
Message-ID: <20110510093538.GA2569@elte.hu>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
 <20110429164227.GA25491@elte.hu>
 <alpine.DEB.2.00.1104291353310.23685@cl320.eecs.utk.edu>
 <20110429185741.GB10217@elte.hu>
 <BANLkTinWxugxrx=7+wJGgoXvT3KGAz28Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinWxugxrx=7+wJGgoXvT3KGAz28Pg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* stephane eranian <eranian@googlemail.com> wrote:

> > Thirdly, and this is my most fundamental objection, i also object to the 
> > timing of this offcore raw access ABI, because past experience is that we 
> > *really* do not want to allow raw PMU details without *first* having 
> > generic abstractions and generic events first.
> 
> I am not opposed to generic events. [...]

Ok - and that's the most important point really.

> [...] But I don't think they're the ultimate solution to all your performance 
> problems: the crystal ball you're trying to sell.

I do not claim that and i'm not selling a crystal ball either.

I just see that 90%+ of our users use generic events (most in fact just use 
whatever comes as a default, which is cycles) and only a tiny niche uses raw 
events. I'm responding to that demand.

[ We saw that with Oprofile already: only an exceedingly small minority *ever* 
  made use of any event but the default Oprofile came with.

  So even with our current generalizations we have more than the typical 
  developer would use for profiling and we try to not define everything and the 
  kitchen sink but respond to demand in a common sense way as we see it. ]

And note that i have no problems with and no prejudices against crazy niches 
(-rt, anyone?), as long as they *know* that they are crazy and as long as they 
help the advancement of the common case!

Really, as a Linux kernel maintainer i'm very easily corrupted by niches: if 
you want me to care about your niche you only need to bribe me with 
improvements to the more common case! :-)

Note that time is running out to get the offcore bits activated even in 
v2.6.40: we are at -rc7 and the merge window is getting closer.

So if you guys care about this code please have a look at Peter's patch and 
help test/finish it (or provide a detailed and convincing technical review of 
his patch to prove why his approach to provide node level events is impossible 
to meet).

Arguing in this thread some more wont help get the code changed i'm afraid!

Thanks,

	Ingo
