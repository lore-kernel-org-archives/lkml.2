Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960Ab0JSNBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:01:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64895 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab0JSNBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:01:02 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=O21JH8oWZ5MA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=JfrnYn6hAAAA:8 a=AJUQ-QFif1ApY4tZ6VgA:9 a=gkJ2RUpPjYaHxpEGvSD5t06anVsA:4 a=PUjeQqilurYA:10 a=3Rfx1nUSh_UA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched_rt: Removes extra checking for nr_cpus_allowed
 when calling find_lowest_rq
From: Steven Rostedt <rostedt@goodmis.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Rakib Mullick <rakib.mullick@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4CBD5D680200005A0007492F@soto.provo.novell.com>
References: <AANLkTinoaJX3M2zU_zZOpmFm9Ekxpw-LUVUf_TU8yuSq@mail.gmail.com>
	 <1287486167.1994.1.camel@twins>
	 <4CBD5D680200005A0007492F@soto.provo.novell.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 19 Oct 2010 09:01:00 -0400
Message-ID: <1287493260.16971.364.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 06:57 -0600, Gregory Haskins wrote:
> >>> On 10/19/2010 at 07:02 AM, in message <1287486167.1994.1.camel@twins>, Peter
> Zijlstra <peterz@infradead.org> wrote: 
> > On Tue, 2010-10-19 at 16:57 +0600, Rakib Mullick wrote:
> 
> [snip]
> 
> >> --- linus-rc8/kernel/sched_rt.c	2010-10-15 05:26:43.000000000 +0600
> >> +++ rakib-rc8/kernel/sched_rt.c	2010-10-19 16:22:30.000000000 +0600
> >> @@ -971,8 +971,7 @@ select_task_rq_rt(struct rq *rq, struct
> >>  	 * that is just being woken and probably will have
> >>  	 * cold cache anyway.
> >>  	 */
> >> -	if (unlikely(rt_task(rq->curr)) &&
> >> -	    (p->rt.nr_cpus_allowed > 1)) {
> 
> I think the motivation here was that checking nr_cpus_allowed is far
> cheaper than taking the hit on a function call in this particularly
> hot path.  As Steven points out in a follow-up reply, the function
> call has additional overhead before the equivalent check is made
> again.  We could possibly optimize this with some of the suggestions
> he made, but I am not sure if it is worth it (alone) as the call
> overhead would still be present.  OTOH, the cases where
> nr_cpus_allowed <= 1 are probably rare in the grand scheme of things.
> 
> My opinion is the check should probably remain (if but perhaps with a
> comment to explain its existence) unless someone (Rakib, hint hint) is
> willing to do some benchmarking to demonstrate that it doesn't
> actually have any positive impact.  It probably also makes sense to
> take Steve's suggested changes to improve the places that use the
> function without external optimization.

Yeah, it probably is not worth removing the check here, as a function
call will add overhead.

And do not think that it is a unlikely case to have an RT task pinned to
a CPU. In true RT systems, that should be the norm. Any benchmark should
test the impact on tasks that are pinned to a CPU, not a general
scenario.

-- Steve


