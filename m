Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934160Ab0EUSHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 14:07:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934087Ab0EUSHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 14:07:42 -0400
Date: Fri, 21 May 2010 14:07:13 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] perf, trace: Remove IRQ-disable from perf/tracepoint interaction
Message-ID: <20100521180713.GA12662@redhat.com>
References: <20100521090201.326791353@chello.nl> <20100521090710.419716197@chello.nl> <y0maartf8ve.fsf@fche.csb> <1274464380.26328.3992.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274464380.26328.3992.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Fri, May 21, 2010 at 01:53:00PM -0400, Steven Rostedt wrote:
> [...]
> > > -	struct pt_regs *__regs = &get_cpu_var(perf_trace_regs);		\
> > > -	[...]
> > > +	struct pt_regs __regs;						\
> > >  [...]
> > 
> > To what extent are you worried about something the size of struct
> > pt_regs being auto/stack allocated?
> 
> Isn't pt_regs already allocated on the stack when interrupted?

Maybe, but here we're about to ask for another multi-hundred-byte one.
Does your stack-frame-size ftrace widget gripe about this change?

- FChE
