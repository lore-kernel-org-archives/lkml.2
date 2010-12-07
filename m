Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab0LGC7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:59:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60200 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab0LGC7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 21:59:30 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=jAmd2lEfFiEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=NjpT9bTW6eP9w94t9HMA:9 a=7OPfRzbDybB0LMw3NAIA:7 a=MThi-yi2Udpu2dFfra0qslQ6A_UA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 04/10] sched: Change pick_next_task_rt from
 unlikely to likely
From: Steven Rostedt <rostedt@goodmis.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4CFD59CD0200005A00077F6C@novprvoes0310.provo.novell.com>
References: <20101207015834.196176991@goodmis.org>
	 <20101207021329.185936860@goodmis.org>
	 <4CFD59CD0200005A00077F6C@novprvoes0310.provo.novell.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 06 Dec 2010 21:59:28 -0500
Message-ID: <1291690769.16223.136.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-06 at 19:46 -0700, Gregory Haskins wrote:
> >>> On 12/6/2010 at 08:58 PM, in message <20101207021329.185936860@goodmis.org>,
> Steven Rostedt <rostedt@goodmis.org> wrote: 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The if (unlikely(!rt_rq->rt_nr_running)) test in pick_next_task_rt()
> > tests if there is another rt task ready to run. If so, then pick it.
> > 
> > In most systems, only one RT task runs at a time most of the time.
> > Running the branch unlikely annotator profiler on a system doing average
> > work "running firefox, evolution, xchat, distcc builds, etc", it showed the
> > following:
> 
> My feeling is that generally speaking, if the branch is workload
> dependent, we should probably not annotate it at all and let the CPUs
> branch-predictor do its thing.  I guess what I am not 100% clear on is
> how these annotations affect the BPU.  I.e. is it a static decision
> point or can the BPU still "learn" if the annotation is particularly
> wrong for a given workload?  For the former, I think we should just
> remove this particular annotation (and there are others that need
> review).  For the latter, this is obviously the right annotation we
> should be using in this particular case.

I'm fine with just removing the likely() here. It is a bit workload
dependent. We can't assume that we are running a lot of RT tasks on a
single CPU, but we also should not assume that we are not doing so.
Considering that we are just coming out of an RT task, I doubt it will
hurt anything to just keep the annotation off.

I don't think gcc does anything special for x86 with regards to the BPU.
But I do believe that gcc will add special ops for likely()'s on other
archs.

-- Steve


