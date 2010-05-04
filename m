Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab0EDSWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:22:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45630 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760168Ab0EDSWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:22:46 -0400
X-Authority-Analysis: v=1.1 cv=Ebn0m7KaSvUJV60GCOzUqyhjUj7QmnsyUUVbVvk8w6o= c=1 sm=0 a=Ha1kYoaTZc4A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=Pg-sk_kN8vQcpfpBBNIA:9 a=g06kDNDPYKC4rjJkFl8A:7 a=dDESds9ybX9LgQ2iuw2K2qTjr4UA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 04/12] perf: add @rq to perf_event_task_sched_out()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu, efault@gmx.de,
       avi@redhat.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <4BE057EB.80604@kernel.org>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
	 <1272976724-14312-5-git-send-email-tj@kernel.org>
	 <1272993090.1642.184.camel@laptop>  <4BE057EB.80604@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 04 May 2010 14:22:43 -0400
Message-ID: <1272997363.9739.232.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 19:22 +0200, Tejun Heo wrote:
> Hello,
> 
> On 05/04/2010 07:11 PM, Peter Zijlstra wrote:
> > On Tue, 2010-05-04 at 14:38 +0200, Tejun Heo wrote:
> >> Add @rq to perf_event_task_sched_out() so that its argument matches
> >> those of trace_sched_switch().  This will help unifying notifiers in
> >> sched.
> > 
> > The alternative is dropping rq from the trace events, its not like
> > anybody outside sched.o can do anything sensible with it anyway.
> 
> The comment in include/trace/events/sched.h says...
> 
>  * (NOTE: the 'rq' argument is not used by generic trace events,
>  *        but used by the latency tracer plugin. )
> 
> So, I left it there.  It would be great if all those @rq params can be
> removed tho.  The latency tracer thing needs it, right?

I believe the rq was used by the original latency tracer code that was
in the -rt patch set before ftrace. It is most likely there for
historical purposes. I guess it would be fine to just remove it.

-- Steve


