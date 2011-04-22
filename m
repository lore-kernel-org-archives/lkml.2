Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1DVTy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 15:54:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51511 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab1DVTy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 15:54:56 -0400
Date: Fri, 22 Apr 2011 21:54:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
Message-ID: <20110422195445.GA17583@elte.hu>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
 <1303407662-15564-2-git-send-email-acme@infradead.org>
 <20110422063429.GA16643@elte.hu>
 <20110422162248.GC10755@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422162248.GC10755@tassilo.jf.intel.com>
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


* Andi Kleen <ak@linux.intel.com> wrote:

> On Fri, Apr 22, 2011 at 08:34:29AM +0200, Ingo Molnar wrote:
> > This needs to be a *lot* more user friendly. Users do not want to type in 
> > stupid hexa magic numbers to get profiling. We have moved beyond the oprofile 
> > era really.
> 
> I agree that the raw events are quite user unfriendly.
> 
> Unfortunately they are the way of life in perf -- unlike oprofile -- 
> currently if you want any CPU specific events like this.

Not sure where you take that blanket statement from, but no, raw events are not 
really the 'way of life' - judging by the various user feedback we get they 
come up pretty rarely.

The thing is, most people just use the default 'perf record' and that's it - 
they do not even care about a *single* event - they just want to profile their 
code somehow.

Then the second most popular event category are the generalized events, the 
ones you can see in perf list output:

  cpu-cycles OR cycles                       [Hardware event]
  instructions                               [Hardware event]
  cache-references                           [Hardware event]
  cache-misses                               [Hardware event]
  branch-instructions OR branches            [Hardware event]
  branch-misses                              [Hardware event]
  bus-cycles                                 [Hardware event]

  cpu-clock                                  [Software event]
  task-clock                                 [Software event]
  page-faults OR faults                      [Software event]
  minor-faults                               [Software event]
  major-faults                               [Software event]
  context-switches OR cs                     [Software event]
  cpu-migrations OR migrations               [Software event]
  alignment-faults                           [Software event]
  emulation-faults                           [Software event]

  L1-dcache-loads                            [Hardware cache event]
  L1-dcache-load-misses                      [Hardware cache event]
  L1-dcache-stores                           [Hardware cache event]
  L1-dcache-store-misses                     [Hardware cache event]
  L1-dcache-prefetches                       [Hardware cache event]
  L1-dcache-prefetch-misses                  [Hardware cache event]
  L1-icache-loads                            [Hardware cache event]
  L1-icache-load-misses                      [Hardware cache event]
  L1-icache-prefetches                       [Hardware cache event]
  L1-icache-prefetch-misses                  [Hardware cache event]
  LLC-loads                                  [Hardware cache event]
  LLC-load-misses                            [Hardware cache event]
  LLC-stores                                 [Hardware cache event]
  LLC-store-misses                           [Hardware cache event]
  LLC-prefetches                             [Hardware cache event]
  LLC-prefetch-misses                        [Hardware cache event]
  dTLB-loads                                 [Hardware cache event]
  dTLB-load-misses                           [Hardware cache event]
  dTLB-stores                                [Hardware cache event]
  dTLB-store-misses                          [Hardware cache event]
  dTLB-prefetches                            [Hardware cache event]
  dTLB-prefetch-misses                       [Hardware cache event]
  iTLB-loads                                 [Hardware cache event]
  iTLB-load-misses                           [Hardware cache event]
  branch-loads                               [Hardware cache event]
  branch-load-misses                         [Hardware cache event]

These are useful but are used less frequently.

Then come tracepoint based events - and as a distant last, come raw events. 
Yes, they raw events are useful occasionally, just like modifying applications 
via a hexa editor is useful occasionally. If done often we better abstract it 
out.

> Really to make sense out of all this you need per CPU full event lists.

To make sense out of what? You are making very sweeping yet vague statements.

> I have an own wrapper to make it more user friendly, but its functionality 
> should arguably migrate into perf.

Uhm, no - your patch seem to reintroduce oprofile's horrible events files. We 
really learned from that mistake and do not want to step back ...

Please see the detailed mails i wrote in this thread, what we want is to extend 
and improve existing generalizations of events. The useful bits of the offcore 
PMU fit nicely into that scheme.

Thanks,

	Ingo
