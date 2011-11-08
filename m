Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab1KHF3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 00:29:22 -0500
Received: from smtpauth02.mfg.siteprotect.com ([64.26.60.136]:35534 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750970Ab1KHF3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 00:29:19 -0500
Date: Tue, 8 Nov 2011 00:29:06 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, "Ted Ts'o" <tytso@mit.edu>,
        Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test
 kernels
In-Reply-To: <20111107175942.GA9395@elte.hu>
Message-ID: <alpine.DEB.2.02.1111072358190.8884@pianoman.cluster.toy>
References: <4EB6AE34.2000907@redhat.com> <CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com> <4EB6BAED.2030400@redhat.com> <4EB6BEFA.6000303@codemonkey.ws> <20111106183132.GA4500@thunk.org> <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com>
 <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com> <20111106231953.GD4500@thunk.org> <alpine.LFD.2.02.1111070838520.1823@tux.localdomain> <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy> <20111107175942.GA9395@elte.hu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Nov 2011, Ingo Molnar wrote:
> I think we needed to do only one revert along the way in the past two 
> years, to fix an unintended ABI breakage in PowerTop. Considering the 
> total complexity of the perf ABI our compatibility track record is 
> *very* good.

There have been more breakages, as you know.  It's just they weren't 
caught in time so they were declared to be grandfathered in rather
than fixed.

> Pekka, Vince has meanwhile become the resident perf critic on lkml, 
> always in it when it comes to some perf-bashing:

For what it's worth you'll find commits from me in the qemu tree, and I
also oppose the merge of kvm-tool into the Linux tree.

> ... and you have argued against perf from the very first day on, when 
> you were one of the perfmon developers - and IMO in hindsight you've 
> been repeatedly wrong about most of your design arguments.

I can't find an exact e-mail, but I seem to recall my arguments were that
Pentium 4 support would be hard (it was), that in-kernel generalized 
events were a bad idea (I still think that, try talking to the ARM guys 
sometime about that) and that making access to raw events hard (by not 
using a naming library) was silly.  I'm sure I probably said other things
that were eventually addressed.

> The PAPI project has the (fundamental) problem that you are still 
> doing it in the old-style sw design fashion, with many months long 
> delays in testing, and then you are blaming the problems you 
> inevitably meet with that model on *us*.

The fundamental problem with the PAPI project is that we only have 3 
full-time developers, and we have to make sure PAPI runs on about 10 
different platforms, of which perf_events/Linux is only one.

Time I waste tracking down perf_event ABI regressions and DoS bugs
takes away from actual useful userspace PAPI development.

> There was one PAPI incident i remember where it took you several 
> *months* to report a regression in a regular PAPI test-case (no 
> actual app affected as far as i know). No other tester ever ran the 
> PAPI testcases so nobody else reported it.

We have a huge userbase.  They run on some pretty amazing machines and 
do some tests that strain perf libraries to the limit.
They also tend to use distro kernels, assuming they even have moved to 
2.6.31+ kernels yet.  When these power users report problems, they aren't 
going to be against the -tip tree.

> Nobody but you tests PAPI so you need to become *part* of the 
> upstream development process, which releases a new upstream kernel 
> every 3 months.

PAPI is a free software project, with the devel tree available from CVS.
It takes maybe 15 minutes to run the full PAPI regression suite.
I encourage you or any perf developer to try it and report any issues.

I can only be so comprehensive.  I didn't find the current NMI-watchdog 
regression right away because my git tree builds didn't have it enabled.  
It wasn't until there started being 3.0 distro kernels that people started 
reporting the problem to us.

> Also, as i mentioned it several times before, you are free to add an 
> arbitrary number of ABI test-cases to 'perf test' and we can promise 
> that we run that. Right now it consists of a few tests:

as mentioned before I have my own perf_event test suite with 20+ tests.
  http://web.eecs.utk.edu/~vweaver1/projects/perf-events/validation.html

I do run it often.  It tends to be reactionary though, as I can only add a 
test for a bug once I know about it.

I also have more up-to date perf documentation than the kernel does:
  http://web.eecs.utk.edu/~vweaver1/projects/perf-events/programming.html

and a cpu compatability matrix:
  http://web.eecs.utk.edu/~vweaver1/projects/perf-events/support.html

I didn't really want to turn this into yet another perf flamewar.  I just 
didn't want the implication that perf being in kernel is all rainbows
and unicorns to go unchallenged.

Vince
