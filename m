Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab1CTKyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 06:54:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43583 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab1CTKyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 06:54:44 -0400
Date: Sun, 20 Mar 2011 11:54:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Julia Lawall <julia@diku.dk>
Cc: Pekka Enberg <penberg@kernel.org>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Palix <npalix@diku.dk>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
Message-ID: <20110320105412.GA11266@elte.hu>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
 <20110317211548.646b04d2@tpl.lwn.net>
 <1300419170.16880.956.camel@gandalf.stny.rr.com>
 <AANLkTikZK278BR5o1fP_w2u5PUPbgub9QT4XxzSmEhL5@mail.gmail.com>
 <AANLkTi=2d8S_Pi8kuZMXAmNvHa_2KrOs6K+_FF6P7-pU@mail.gmail.com>
 <Pine.LNX.4.64.1103200852080.28495@ask.diku.dk>
 <AANLkTi=MMKvA-9pFiM1K_JSXjS71JLRCem8THnhu-0=N@mail.gmail.com>
 <Pine.LNX.4.64.1103201007430.28495@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1103201007430.28495@ask.diku.dk>
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


* Julia Lawall <julia@diku.dk> wrote:

> On Sun, 20 Mar 2011, Pekka Enberg wrote:
> 
> > Hi Julia,
> > 
> > On Sun, Mar 20, 2011 at 10:01 AM, Julia Lawall <julia@diku.dk> wrote:
> > > Suggestions for how to make it easier to use or the documentation more
> > > understandable are welcome.
> > 
> > The benefit of scripts/checkpatch.pl is that it doesn't require any
> > setting up to do. I'm personally less likely to use Coccinelle (and
> > Sparse for that matter) on boxes where the software is not installed.
> > I'm not sure how other people feel about it, but I'd personally love
> > to see tools/coccinelle and tools/sparse.
> 
> This was discussed before, and it was felt that perhaps 75000 lines of 
> ocaml code was not really appropriate for the Linux source tree, [...]

We have drivers and rare architectures that have a (much) larger size and which 
are only useful to <0.01% of Linux users.

Coccinelle on the other hand is useful to 100% of Linux users.

We even have C++, perl and python code in the kernel repo so there's no 
language bigotry either - use the language that works best for your project.

> [...] and also that it would too much complicate our development process.

'our' as in the Linux kernel development process? I really don't think it's an 
issue - see above.

or 'our' as in Coccinelle development process? When we brought tools/perf/ into 
the kernel repo all it forced on us were sane Git commits and a predictable, 
(modulo-) 3 months release/stabilization cycle. Both constraints served the 
quality of the perf project very well - but of course your milage may vary.

> One reason for using multiple machines would be to work on multiple 
> architectures.  But Coccinelle is not sensitive to the architecture on 
> which it is run, so perhaps you do't need to have it installed everywhere.

I think the point Pekka tried to make is to have it integrated into the kbuild 
mechanism as well at a certain point. That way it's very easy to use it and we 
maintainers could require frequent patch submitters to use those tools to check 
the quality of their patches. Right now i cannot require that, as it's not part 
of the kernel repo. Requiring a checkpatch.pl check is much easier, as it's 
available to everyone who is writing kernel patches.

'The power of the default' is a very strong force.

Also, IIRC Thomas also sometimes uses Coccinelle to generate *patches*, so 
having it in the kernel would also help that kind of usage.

> > File "/home/penberg/src/linux/scripts/coccinelle/api/memdup_user.cocci",
> > line 32, column 5,  charpos = 747
> >     around = '<+...', whole content = -    <+... when != goto l2;
> > Fatal error: exception Lexer_cocci.Lexical("invalid in a nonempty
> > context: <+...")
> > make[1]: *** [mm/slub.o] Error 1
> > make: *** [mm/slub.o] Error 2
> > 
> > penberg@jaguar:~/src/linux$ dpkg -l|grep coccinelle
> > ii  coccinelle                                      0.2.2.deb-2
> >                                         semantic patching tool for C
> > 
> > [ I'm on Ubuntu 10.10. ]
> 
> Indeed that one seems to be quite out of date.  You can get the most 
> recent version here: https://launchpad.net/~npalix/+archive/coccinelle

With tools/coccinelle/ you would never run into such problems of distributing 
the latest stable version to your fellow kernel developers: it would always be 
available in tools/coccinelle/.

Integration, synergy, availability, distribution and half a dozen other 
buzzwords come to mind as to why it's a good idea to have kernel-focused
tools hosted in the kernel repo :-)

IMO it's an option to consider.

Thanks,

	Ingo
