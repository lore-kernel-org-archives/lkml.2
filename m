Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab0KJPSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:18:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199Ab0KJPSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:18:20 -0500
Date: Wed, 10 Nov 2010 16:17:50 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
        rostedt@goodmis.org, andi@firstfloor.org, lwoodman@redhat.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] tracing,mm - add kernel pagefault tracepoint for x86
 & x86_64
Message-ID: <20101110151750.GA11541@jolsa.brq.redhat.com>
References: <1289390172-9730-1-git-send-email-jolsa@redhat.com>
 <1289390172-9730-2-git-send-email-jolsa@redhat.com>
 <20101110132954.GA2101@infradead.org>
 <20101110134436.GD1949@jolsa.brq.redhat.com>
 <20101110135244.GA31638@elte.hu>
 <20101110150021.GA5750@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110150021.GA5750@nowhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 04:00:25PM +0100, Frederic Weisbecker wrote:
> On Wed, Nov 10, 2010 at 02:52:44PM +0100, Ingo Molnar wrote:
> > 
> > * Jiri Olsa <jolsa@redhat.com> wrote:
> > 
> > > On Wed, Nov 10, 2010 at 08:29:54AM -0500, Christoph Hellwig wrote:
> > > > On Wed, Nov 10, 2010 at 12:56:11PM +0100, Jiri Olsa wrote:
> > > > > +	TP_printk("task=%lx, address=%lx, regs=%lx",
> > > > > +		(unsigned long)__entry->task, (unsigned long)__entry->address,
> > > > > +			__entry->regs)
> > > > 
> > > > How exactly do you use the information in this trace point?  Especially
> > > > the undecoded pt_regs doesn't seem very useful to me at all.
> > > 
> > > agreed, the registers pointer are not very useful in the trace file output,
> > > and could be taken away.. just wanted to be complete I guess
> > > 
> > > but I believe they are useful when you register the mm_kernel_pagefault
> > > tracepoint and process the information by yourself
> > 
> > That would be expressed in a better and more generic fashion via adding 
> > PERF_SAMPLE_REGS to perf_event_sample_format, and add a ptregs dump in 
> > kernel/perf_event.c, perf_output_sample(). That way any tracepoint can request a 
> > (user-space)ptregs state snapshot, not just the pagefault ones.
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> 
> We are going to have that with the dwarf based callchain patchset. I'm cooking
> this.
> 
> Thanks.
> 

I guess I can take the regs out then.. would that patch be acceptable
afterwards..?

thanks,
jirka
