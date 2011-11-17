Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab1KQNYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 08:24:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428Ab1KQNYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 08:24:42 -0500
Message-ID: <4EC50B02.1060307@redhat.com>
Date: Thu, 17 Nov 2011 15:24:18 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, Jason Baron <jbaron@redhat.com>,
        rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC] remove jump_label optimization for perf sched events
References: <20111117123029.GB16853@redhat.com>  <1321534159.27735.33.camel@twins> <20111117130032.GC16853@redhat.com> <1321535413.27735.35.camel@twins>
In-Reply-To: <1321535413.27735.35.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 03:10 PM, Peter Zijlstra wrote:
> On Thu, 2011-11-17 at 15:00 +0200, Gleb Natapov wrote:
>
> > > That said, I'd much rather throttle this particular jump label than
> > > remove it altogether, some people really don't like all this scheduler
> > > hot path crap.
> > What about moving perf_event_task_sched() to sched_(in|out)_preempt_notifiers?
> > preempt notifiers checking is already on the scheduler hot path, so no
> > additional overhead for perf case.
>
> Same problem really, some people complain about the overhead of preempt
> notifiers, also not all kernels have those in. 

We could combine the two, sort-circuit preempt notifiers with jump
labels if empty && not much activity on them.

> Futhermore I loathe notifier lists because they obscure wtf is done.

That's life in a general purpose kernel, if everyone gets their hook in
to keep their code clean, the scheduler will bloat.

An advantage of preempt notifiers is that you can make the perf code
modular.

-- 
error compiling committee.c: too many arguments to function

