Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0D1Uio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 16:38:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39284 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab0D1Uin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 16:38:43 -0400
X-Authority-Analysis: v=1.1 cv=elpKMhBbP+pQyLZqL930WohJ6E0KICKd8OrLrcMNK78= c=1 sm=0 a=W2oApCp1y6kA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=n10ygTZf28Hk0uZRpVwA:9 a=scgTcczb0_NsoiC0dbsA:7 a=UtUhmZSGbGgm-p6fWapqRpuOF2EA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 01/10][RFC] tracing: Create class struct for events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20100428202225.GB8591@Krystal>
References: <20100426195024.256424113@goodmis.org>
	 <20100426200241.373124697@goodmis.org>  <20100428202225.GB8591@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 28 Apr 2010 16:38:38 -0400
Message-ID: <1272487118.9739.79.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-28 at 16:22 -0400, Mathieu Desnoyers wrote:

> >  #undef DEFINE_EVENT
> >  #define DEFINE_EVENT(template, name, proto, args)	\
> >  	static struct ftrace_event_call			\
> > @@ -430,22 +433,6 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
> >   *
> >   * Override the macros in <trace/trace_events.h> to include the following:
> >   *
> > - * static void ftrace_event_<call>(proto)
> > - * {
> > - *	event_trace_printk(_RET_IP_, "<call>: " <fmt>);
> > - * }
> > - *
> > - * static int ftrace_reg_event_<call>(struct ftrace_event_call *unused)
> > - * {
> > - *	return register_trace_<call>(ftrace_event_<call>);
> > - * }
> > - *
> > - * static void ftrace_unreg_event_<call>(struct ftrace_event_call *unused)
> > - * {
> > - *	unregister_trace_<call>(ftrace_event_<call>);
> > - * }
> > - *
> > - *
> >   * For those macros defined with TRACE_EVENT:
> >   *
> >   * static struct ftrace_event_call event_<call>;
> 
> So.. just wondering, why are you removing these comments ? What's
> replacing them ?
> 
> Maybe you meant to remove this in a following patch ?

 I found a lot of stale comments, these were added with cut and paste
before, and I just removed them here.

-- Steve


