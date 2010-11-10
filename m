Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab0KJNxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 08:53:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60100 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0KJNxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 08:53:01 -0500
Date: Wed, 10 Nov 2010 14:52:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, rostedt@goodmis.org,
        andi@firstfloor.org, lwoodman@redhat.com, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] tracing,mm - add kernel pagefault tracepoint for x86
 & x86_64
Message-ID: <20101110135244.GA31638@elte.hu>
References: <1289390172-9730-1-git-send-email-jolsa@redhat.com>
 <1289390172-9730-2-git-send-email-jolsa@redhat.com>
 <20101110132954.GA2101@infradead.org>
 <20101110134436.GD1949@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110134436.GD1949@jolsa.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Wed, Nov 10, 2010 at 08:29:54AM -0500, Christoph Hellwig wrote:
> > On Wed, Nov 10, 2010 at 12:56:11PM +0100, Jiri Olsa wrote:
> > > +	TP_printk("task=%lx, address=%lx, regs=%lx",
> > > +		(unsigned long)__entry->task, (unsigned long)__entry->address,
> > > +			__entry->regs)
> > 
> > How exactly do you use the information in this trace point?  Especially
> > the undecoded pt_regs doesn't seem very useful to me at all.
> 
> agreed, the registers pointer are not very useful in the trace file output,
> and could be taken away.. just wanted to be complete I guess
> 
> but I believe they are useful when you register the mm_kernel_pagefault
> tracepoint and process the information by yourself

That would be expressed in a better and more generic fashion via adding 
PERF_SAMPLE_REGS to perf_event_sample_format, and add a ptregs dump in 
kernel/perf_event.c, perf_output_sample(). That way any tracepoint can request a 
(user-space)ptregs state snapshot, not just the pagefault ones.

Thanks,

	Ingo
