Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab1KHMKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 07:10:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43611 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab1KHMKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 07:10:03 -0500
Date: Tue, 8 Nov 2011 13:07:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vince@deater.net>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, "Ted Ts'o" <tytso@mit.edu>,
        Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test
 kernels
Message-ID: <20111108120755.GB571@elte.hu>
References: <4EB6BAED.2030400@redhat.com>
 <4EB6BEFA.6000303@codemonkey.ws>
 <20111106183132.GA4500@thunk.org>
 <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com>
 <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com>
 <20111106231953.GD4500@thunk.org>
 <alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
 <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
 <20111107175942.GA9395@elte.hu>
 <alpine.DEB.2.02.1111072358190.8884@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1111072358190.8884@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Vince Weaver <vince@deater.net> wrote:

> On Mon, 7 Nov 2011, Ingo Molnar wrote:

> > I think we needed to do only one revert along the way in the past 
> > two years, to fix an unintended ABI breakage in PowerTop. 
> > Considering the total complexity of the perf ABI our 
> > compatibility track record is *very* good.
> 
> There have been more breakages, as you know.  It's just they 
> weren't caught in time so they were declared to be grandfathered in 
> rather than fixed.

I remember one such instance were you reported a 'regression' that 
spanned several -stable kernel releases - and unless the fix is easy 
and obvious that's the regular upstream treatment.

As Linus said it too on the recent Kernel Summit an ABI is only an 
ABI if it's actually *used*.

But there's more, you've repeatedly rejected our offer to extend 
'perf test' to cover the functionality that your library relies on. 
If you refuse to timely test newer upstream kernels while you rely on 
obscure details that nobody else uses and if you refuse to make your 
testcases more prominent it becomes *your* problem.

There's not much we can do if you refuse to test and refuse to push 
your testcases upstream ...

> > ... and you have argued against perf from the very first day on, 
> > when you were one of the perfmon developers - and IMO in 
> > hindsight you've been repeatedly wrong about most of your design 
> > arguments.
> 
> I can't find an exact e-mail, but I seem to recall my arguments 
> were that Pentium 4 support would be hard (it was), [...]

To the contrary, a single person implemented most of it, out of 
curiosity.

> [...] that in-kernel generalized events were a bad idea (I still 
> think that, try talking to the ARM guys sometime about that) [...]

To the contrary, generalized events work very well and they are one 
of the reasons why the perf tooling is so usable.

> [...] and that making access to raw events hard (by not using a 
> naming library) was silly. [...]

To the contrary, by 'making it easy' you mean 'translate hexa codes 
to vendor specific gibberish' which is hardly any better to actual 
users of the tool and gives the false appearance of being a solution.

All in one you advocated all the oprofile design mistakes and you 
have been proven thoroughly wrong by reality.

> > The PAPI project has the (fundamental) problem that you are still 
> > doing it in the old-style sw design fashion, with many months 
> > long delays in testing, and then you are blaming the problems you 
> > inevitably meet with that model on *us*.
> 
> The fundamental problem with the PAPI project is that we only have 
> 3 full-time developers, and we have to make sure PAPI runs on about 
> 10 different platforms, of which perf_events/Linux is only one.
> 
> Time I waste tracking down perf_event ABI regressions and DoS bugs 
> takes away from actual useful userspace PAPI development.

If people are not interested in even testing the basic test-suite of 
PAPI on a recent kernel then i'm afraid there must be something very 
wrong with the PAPI project structure.

Somehow that testing is not missing from the perf tool, despite it 
being a much younger and smaller project. Did you ever stop to think 
why that is so?

> > There was one PAPI incident i remember where it took you several 
> > *months* to report a regression in a regular PAPI test-case (no 
> > actual app affected as far as i know). No other tester ever ran 
> > the PAPI testcases so nobody else reported it.
> 
> We have a huge userbase.  They run on some pretty amazing machines 
> and do some tests that strain perf libraries to the limit. They 
> also tend to use distro kernels, assuming they even have moved to 
> 2.6.31+ kernels yet.  When these power users report problems, they 
> aren't going to be against the -tip tree.

Nobody expects you to test the -tip tree if you don't want to (it 
would certainly be useful to you if you are interested in PMU 
development), but there's a 2.5 months stabilization window after the 
upstream merge.

> > Nobody but you tests PAPI so you need to become *part* of the 
> > upstream development process, which releases a new upstream 
> > kernel every 3 months.
> 
> PAPI is a free software project, with the devel tree available from 
> CVS. It takes maybe 15 minutes to run the full PAPI regression 
> suite. I encourage you or any perf developer to try it and report 
> any issues.

I will fix what gets reported and neither i nor other regular kernel 
testers actually use it.

You really need to do more testing to fill that gap, expecting others 
to volunteer time into a project they don't actually use is extremely 
backwards...

> I can only be so comprehensive.  I didn't find the current 
> NMI-watchdog regression right away because my git tree builds 
> didn't have it enabled.  It wasn't until there started being 3.0 
> distro kernels that people started reporting the problem to us.
>
> > Also, as i mentioned it several times before, you are free to add 
> > an arbitrary number of ABI test-cases to 'perf test' and we can 
> > promise that we run that. Right now it consists of a few tests:
> 
> as mentioned before I have my own perf_event test suite with 20+ tests.
>   http://web.eecs.utk.edu/~vweaver1/projects/perf-events/validation.html

That should probably be moved into perf test. Arnaldo, any 
objections?

> I do run it often.  It tends to be reactionary though, as I can 
> only add a test for a bug once I know about it.
> 
> I also have more up-to date perf documentation than the kernel does:
>   http://web.eecs.utk.edu/~vweaver1/projects/perf-events/programming.html
> 
> and a cpu compatability matrix:
>   http://web.eecs.utk.edu/~vweaver1/projects/perf-events/support.html
> 
> I didn't really want to turn this into yet another perf flamewar.  

So why then did you launch several malicious, unprovoked, 
passive-aggressive ad hominem attacks against perf developers, like:

  "Never overtly.  They're too clever for that."

and:

  "Unlike the perf developers, we *do* have to maintain backwards
   compatability."

? They were untrue, uncalled for, unfair and outright mean-spirited.

Thanks,

	Ingo
