Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab2ALPxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 10:53:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33448 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab2ALPxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 10:53:51 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=hQRVNFTGe2sA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=iIWngvWHzs49rFgqiyMA:9 a=PUjeQqilurYA:10 a=p7h8OIQwX_BSd_h5:21 a=ty3WvMWkKbx1OJ4T:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326383629.7642.85.camel@gandalf.stny.rr.com>
Subject: Re: [lttng-dev] Perf ABI (was: Re: [PATCH 09/11] sched: export
 task_prio to GPL modules)
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        devel@driverdev.osuosl.org, "Ted Ts'o" <tytso@mit.edu>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>, lttng-dev@lists.lttng.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 12 Jan 2012 10:53:49 -0500
In-Reply-To: <20120112153957.GA20514@Krystal>
References: <20111208232709.GA19820@kroah.com>
	 <20111219104915.GA19861@elte.hu> <20111219153053.GA21548@Krystal>
	 <20111220110813.GA19105@elte.hu> <20111223164629.GA30474@Krystal>
	 <20111223172155.GA14117@thunk.org> <20111223181641.GA12681@Krystal>
	 <20111225174613.GA12732@thunk.org> <20120112140905.GA30377@Krystal>
	 <1326380042.7642.73.camel@gandalf.stny.rr.com>
	 <20120112153957.GA20514@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-12 at 10:39 -0500, Mathieu Desnoyers wrote:

> pipe()/pipe2()
> dup()/dup2()/dup3()
> umount()/umount2()
> mmap()/mmap2()
> madvise()/madvise1()
> eventfd()/eventfd2()
> 
> Those look very much like major version numbers to me. And these are
> entirely compatible with your statement above about using -ENOSYS to
> detect if the major version number is implemented or not.

That's a stretch in calling version numbers. All but the madvise case
above are how many parameters it takes, not really a "version" number.

It's adding a new syscall, not updating a version and then deprecating
the old one. As I believe all the above are still supported.

> 
> If your only concern is that the major version number should be part of
> the ABI name (as in the examples above), that can be arranged.

> > 
> > We've done this without version numbers. Just look at all the udev
> > changes.
> 
> Are you seriously refering to udev as an example of how to handle
> changes, or as one of the worse ABI breakage mess that happened in the
> Linux kernel history ? My own experience as a Linux users (in the
> era around 2.6.12 kernels if my memory serves me right) lead me to think
> it's the latter. And because udev is part of the runtime support, that
> indeed led to non-bootable systems and lots of frustrated users.

Yeah, I know it sucked, as I got burned by it too. But having "version"
numbers wouldn't have helped at all. In fact, it should have kept both
ways working much longer, or at least had the new udev support both. 

What udev did is more like what you want to do than what I did with
trace-cmd.

-- Steve


