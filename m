Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab0D0P2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:28:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44333 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab0D0P2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:28:30 -0400
X-Authority-Analysis: v=1.1 cv=elpKMhBbP+pQyLZqL930WohJ6E0KICKd8OrLrcMNK78= c=1 sm=0 a=3VUK4oP7sswA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=IWmWwyhzs3ykze0S288A:9 a=LDqZyG7kUHfnfqjeYI8FyxmUSmkA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 02/10][RFC] tracing: Let tracepoints have data passed
 to tracepoint callbacks
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <4BD6A98D.6010706@cn.fujitsu.com>
References: <20100426195024.256424113@goodmis.org>
	 <20100426200241.631945432@goodmis.org>  <4BD6A98D.6010706@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 27 Apr 2010 11:28:26 -0400
Message-ID: <1272382106.9739.45.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-27 at 17:08 +0800, Li Zefan wrote:
> Steven Rostedt wrote:

> > Because of the data parameter, tracepoints declared this way can not have
> > no args. That is:
> > 
> >   DECLARE_TRACE_DATA(mytracepoint, TP_PROTO(void), TP_ARGS());
> > 
> > will cause an error, but the original DECLARE_TRACE still allows for this.
> > 
> > The DECLARE_TRACE_DATA() will be used by TRACE_EVENT() so that it
> > can reuse code and bring the size of the tracepoint footprint down.
> > This means that TRACE_EVENT()s must have at least one argument defined.
> 
> We have to define at least on argument in TRACE_EVENT() even without
> this patch, otherwise it'll cause compile error while expanding the
> macros.

OK, good to know that this is not a regression. The DECLARE_TRACE()
still allows now arguments, I spent a bit of time (more than I wanted
to) to make that work. Since I added a new DECLARE_TRACE_DATA() that
must have at least one argument, it is not a regression, because it is
new :-)

Thanks,

-- Steve

P.S.

I'll let these patches sit out for a week waiting for comments, and if
there are none, I'll repackage them (rebase as well) and send them out
for real.


