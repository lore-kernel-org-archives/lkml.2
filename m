Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab0JSNHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:07:30 -0400
Received: from soto.provo.novell.com ([137.65.250.214]:35169 "EHLO
	soto.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758235Ab0JSNH3 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ghaskins@novell.com:5:1>);
	Tue, 19 Oct 2010 09:07:29 -0400
Message-Id: <4CBD5FC90200005A00074945@soto.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Tue, 19 Oct 2010 07:07:21 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Rakib Mullick" <rakib.mullick@gmail.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched_rt: Removes extra checking for
 nr_cpus_allowed when calling find_lowest_rq
References: <AANLkTinoaJX3M2zU_zZOpmFm9Ekxpw-LUVUf_TU8yuSq@mail.gmail.com>
 <1287486167.1994.1.camel@twins>
 <4CBD5D680200005A0007492F@soto.provo.novell.com>
 <1287493260.16971.364.camel@gandalf.stny.rr.com>
In-Reply-To: <1287493260.16971.364.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10/19/2010 at 09:01 AM, in message
<1287493260.16971.364.camel@gandalf.stny.rr.com>, Steven Rostedt
<rostedt@goodmis.org> wrote: 
> On Tue, 2010-10-19 at 06:57 -0600, Gregory Haskins wrote:
>> >>> On 10/19/2010 at 07:02 AM, in message <1287486167.1994.1.camel@twins>, Peter
>> Zijlstra <peterz@infradead.org> wrote: 
>> > On Tue, 2010-10-19 at 16:57 +0600, Rakib Mullick wrote:
>> 
>> [snip]
>> 
>> >> --- linus-rc8/kernel/sched_rt.c	2010-10-15 05:26:43.000000000 +0600
>> >> +++ rakib-rc8/kernel/sched_rt.c	2010-10-19 16:22:30.000000000 +0600
>> >> @@ -971,8 +971,7 @@ select_task_rq_rt(struct rq *rq, struct
>> >>  	 * that is just being woken and probably will have
>> >>  	 * cold cache anyway.
>> >>  	 */
>> >> -	if (unlikely(rt_task(rq->curr)) &&
>> >> -	    (p->rt.nr_cpus_allowed > 1)) {
>> 
>> I think the motivation here was that checking nr_cpus_allowed is far
>> cheaper than taking the hit on a function call in this particularly
>> hot path.  As Steven points out in a follow-up reply, the function
>> call has additional overhead before the equivalent check is made
>> again.  We could possibly optimize this with some of the suggestions
>> he made, but I am not sure if it is worth it (alone) as the call
>> overhead would still be present.  OTOH, the cases where
>> nr_cpus_allowed <= 1 are probably rare in the grand scheme of things.
>> 
>> My opinion is the check should probably remain (if but perhaps with a
>> comment to explain its existence) unless someone (Rakib, hint hint) is
>> willing to do some benchmarking to demonstrate that it doesn't
>> actually have any positive impact.  It probably also makes sense to
>> take Steve's suggested changes to improve the places that use the
>> function without external optimization.
> 
> Yeah, it probably is not worth removing the check here, as a function
> call will add overhead.
> 
> And do not think that it is a unlikely case to have an RT task pinned to
> a CPU. In true RT systems, that should be the norm. Any benchmark should
> test the impact on tasks that are pinned to a CPU, not a general
> scenario.
> 

Yes, agreed and excellent point, Steve.

-Greg


