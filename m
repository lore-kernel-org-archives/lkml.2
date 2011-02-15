Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab1BONdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 08:33:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56613 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab1BONdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 08:33:10 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=ZI4DeYlhuOkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=btlA89zPW8Da7_ujYoQA:9 a=sMsz__o7elaV570pGkUA:7 a=x4QOyu2W5xQzBtZhTdrrDKHBS94A:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 00/14] [GIT PULL][v2.6.39] tracing/filter: More robust
 filtering
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20110215044425.GA9994@elte.hu>
References: <20110208015617.902200587@goodmis.org>
	 <20110215044425.GA9994@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 15 Feb 2011 08:33:07 -0500
Message-ID: <1297776787.23343.104.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 05:44 +0100, Ingo Molnar wrote:
> hi Steve,
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Steven Rostedt (14):
> >       tracing/filter: Have no filter return a match
> >       tracing/filter: Move OR and AND logic out of fn() method
> >       tracing/filter: Dynamically allocate preds
> >       tracing/filter: Call synchronize_sched() just once for system filters
> >       tracing/filter: Allocate the preds in an array
> >       tracing/filter: Free pred array on disabling of filter
> >       tracing/filter: Use a tree instead of stack for filter_match_preds()
> >       tracing/filter: Optimize short ciruit check
> >       tracing/filter: Check the created pred tree
> >       tracing/filter: Optimize filter by folding the tree
> >       tracing/filter: Move MAX_FILTER_PRED to local tracing directory
> >       tracing/filter: Increase the max preds to 2^14
> >       tracing/filter: Swap entire filter of events
> >       tracing/filter: Remove synchronize_sched() from __alloc_preds()
> 
> I finally got around testing the various tracing filter features we have.
> 

[ snip all the perf output ]

> So ... i have to say that this tracing filter business is unusable crap from a user 
> POV right now and i see no reason to pull *anything* in this area until it does not 
> get improved to *much* better levels of usability and utility.
> 
> Nobody could *ever* have tested this with a 'naive but curious user' hat on and this 
> is really sad. We need to do much better!

Sorry I did not work with perf in writing this code. I was using the
debugfs directly. I figured that any improvement I made there would also
improve perf as I tried to make sure the perf hooks into that code were
updated too.

My question is, did this patch set cause any of the perf problems or did
these problems always exist?

I'm just saying that perf is not the only user. And to deny improvements
in the code because one user does not currently work well with them is
just hindering progress.

There happens to be real users out in the world that are still using
ftrace. I see no reason to stop improving it because your goal is to
have everyone move to perf.

Thanks for letting me waste three days on developing this. I even posted
an RFC a while back, and no one complained then.

-- Steve


