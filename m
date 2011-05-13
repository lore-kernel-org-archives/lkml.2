Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab1EMPob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:44:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38833 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab1EMPoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:44:30 -0400
Date: Fri, 13 May 2011 17:44:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Ahern <dsahern@gmail.com>
Cc: Wim Heirman <wim@heirman.net>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: perf-stat per thread results
Message-ID: <20110513154410.GA6373@elte.hu>
References: <BANLkTimTOTz4qNwYPa6Ey7=QRjOhQHWt-Q@mail.gmail.com>
 <4DCD4FC5.8020608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCD4FC5.8020608@gmail.com>
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


* David Ahern <dsahern@gmail.com> wrote:

> On 05/13/11 09:14, Wim Heirman wrote:
> > Hi all,
> > 
> > I'm using perf-stat to look at hardware performance counters for a
> > parallel program. Is there a way to get counter values for each thread
> > individually, rather than aggregated for the whole process? I know I
> > can attach to a specific thread using --tid=, but due to the time
> > required to find the tid and attach/detach this isn't accurate for
> > short-running programs.
> 
> perf-stat requires changes to dump counters per thread; it currently
> sums all threads into a single value.
> 
> > Or, alternatively, can I use perf record --stat and get an exact count
> > for each performance counter?
> 
> perf-record does not read values from hardware counters.

It's supposed to do that if --stat is specified, and it used to work - see this 
commit:

  8d51327090ac: perf report: Fix and improve the displaying of per-thread event counters

and the output there:

     #  PID   TID  cache-misses  cache-references
       4658  4659        495581           3238779
       4658  4662        498246           3236823
       4658  4663        499531           3243162

which appears to be roughly what Wim is asking for, AFAICT.

But this seems to have regressed meanwhile.

Thanks,

	Ingo
