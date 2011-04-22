Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab1DVJXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 05:23:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36030 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734Ab1DVJXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 05:23:42 -0400
Date: Fri, 22 Apr 2011 11:23:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
Message-ID: <20110422092322.GA1948@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
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


* Stephane Eranian <eranian@google.com> wrote:

> On Fri, Apr 22, 2011 at 10:06 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> This needs to be a *lot* more user friendly. Users do not want to type in
> >> stupid hexa magic numbers to get profiling. We have moved beyond the oprofile
> >> era really.
> >>
> >> Unless there's proper generalized and human usable support i'm leaning
> >> towards turning off the offcore user-space accessible raw bits for now, and
> >> use them only kernel-internally, for the cache events.
>
> Generic cache events are a myth. They are not usable. I keep getting 
> questions from users because nobody knows what they are actually counting, 
> thus nobody knows how to interpret the counts. You cannot really hide the 
> micro-architecture if you want to make any sensible measurements.

Well:

 aldebaran:~> perf stat --repeat 10 -e instructions -e L1-dcache-loads -e L1-dcache-load-misses -e LLC-misses ./hackbench 10
 Time: 0.125
 Time: 0.136
 Time: 0.180
 Time: 0.103
 Time: 0.097
 Time: 0.125
 Time: 0.104
 Time: 0.125
 Time: 0.114
 Time: 0.158

 Performance counter stats for './hackbench 10' (10 runs):

     2,102,556,398 instructions             #      0.000 IPC     ( +-   1.179% )
       843,957,634 L1-dcache-loads            ( +-   1.295% )
       130,007,361 L1-dcache-load-misses      ( +-   3.281% )
         6,328,938 LLC-misses                 ( +-   3.969% )

        0.146160287  seconds time elapsed   ( +-   5.851% )

It's certainly useful if you want to get ballpark figures about cache behavior 
of an app and want to do comparisons.

There are inconsistencies in our generic cache events - but that's not really a 
reason to obcure their usage behind nonsensical microarchitecture-specific 
details.

But i'm definitely in favor of making these generalized events more consistent 
across different CPU types. Can you list examples of inconsistencies that we 
should resolve? (and which you possibly consider impossible to resolve, right?)

Thanks,

	Ingo
