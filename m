Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab2LTXH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 18:07:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6428 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2LTXHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 18:07:47 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=kMKUP9VcE-gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ErkLabmjQQoA:10 a=kJ3d0gFlza_WgqKZI2YA:9 a=PUjeQqilurYA:10 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1356044865.5896.78.camel@gandalf.local.home>
Subject: Re: [PATCH] sched/rt: Move cpu rq properties from "struct rt_rq" to
 "struct rq"
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 20 Dec 2012 18:07:45 -0500
In-Reply-To: <401821356041818@web4f.yandex.ru>
References: <4807701355857948@web19f.yandex.ru>
	 <alpine.LFD.2.02.1212201852060.3148@ionos>
	 <401821356041818@web4f.yandex.ru>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-21 at 02:16 +0400, Kirill Tkhai wrote:
> 20.12.2012, 21:53, "Thomas Gleixner" <tglx@linutronix.de>:
> > On Tue, 18 Dec 2012, Kirill Tkhai wrote:
> >
> >>  The members rt_nr_total, rt_nr_migratory, overloaded and pushable_tasks are
> >>  properties of cpu runqueue, not group rt_rq.
> >
> > Why?
> 
> Because, they depend on number and properties of all processes of rq, not of nested rt_rq.
> 

You're answer is still confusing.

	struct rq {
		[...]
		struct rt_rq rt;


rt_rq is just a part of rq. What's the point?

	rq = container_of(rt_rq, struct rt_rq, rt);

As the comment above struct rt_rq says:

/* Real-Time classes' related field in a runqueue: */

Those look like fields related to the Real-Time class. I don't see them
used outside of kernel/sched/rt.c

-- Steve

> >
> > Thanks,
> >
> >         tglx


