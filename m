Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab1ATNGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 08:06:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45434 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab1ATNGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 08:06:51 -0500
Date: Thu, 20 Jan 2011 14:06:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH -v10 0/4] Lock-less list
Message-ID: <20110120130625.GA14436@elte.hu>
References: <1295245019-7816-1-git-send-email-ying.huang@intel.com>
 <20110119135546.bb7e8f62.akpm@linux-foundation.org>
 <1295484358.15213.25.camel@yhuang-dev>
 <20110119165247.cca2f434.akpm@linux-foundation.org>
 <1295520247.28776.152.camel@laptop>
 <AANLkTimR6xd1PxCP6jmuNwFkANrGPdTf2wpiGsBXGpKx@mail.gmail.com>
 <1295522876.28776.158.camel@laptop>
 <AANLkTin3_NuGG_E0Juy7=1Q7PcMJ6id1ZU-Gngfp_=dg@mail.gmail.com>
 <20110120121455.GA7680@elte.hu>
 <AANLkTikv3h_QoHs4uj6CNJdC7tb_-e0osKa47KWEJvFV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikv3h_QoHs4uj6CNJdC7tb_-e0osKa47KWEJvFV@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* huang ying <huang.ying.caritas@gmail.com> wrote:

> On Thu, Jan 20, 2011 at 8:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * huang ying <huang.ying.caritas@gmail.com> wrote:
> >
> >> > But will all that stuff be accepted? Please stop sending infrastructure bits and
> >> > focus on your larger RAS picture, once you have consensus on that from all
> >> > parties involved, then, and only then, does it make sense to submit everything,
> >> > including infrastructure.
> >>
> >> I am not sending hardware error reporting infrastructure.  As far as I know, Linus
> >> and Andrew suggest to use printk for hardware error reporting.  And now, I just
> >> try to write APEI driver and reporting hardware error with printk.  Is it
> >> acceptable?  Do you have some other idea about hardware error reporting?
> >
> > Erm, how could you possible have missed the perf based RAS daemon work of Boris,
> > which we've pointed out about half a dozen times already?
> 
> Even if there is some other hardware error reporting infrastructure
> such as perf based, I think we still need printk too. After all, as
> Linus pointed out, printk is the most popular error reporting
> mechanism so far. Do you think so?

Of course, that's why the upstream EDAC code uses printk too. In fact it does all 
sorts of in-kernel decoding to make the printk output more useful - the /dev/mcelog 
method of pushing all decoding to user-space is fundamentally flawed.

So yes, printk is the primary output channel and having a readable printk output 
pretty much overrides any other concern.

But that is not what you are doing. I get the impression that you are using printk 
as an _excuse_ to not have to work with the RAS people and run some parallel 
framework so that you do not have to work with them or listen to them. It is rather 
counter-productive. Working together is useful.

Thanks,

	Ingo
