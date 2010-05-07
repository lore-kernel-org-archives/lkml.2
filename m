Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab0EGM7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 08:59:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45494 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab0EGM7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 08:59:07 -0400
X-Authority-Analysis: v=1.1 cv=OMZqYO3L41gFG4eI735GctFZkIqa2t9YKv4cWfI71LE= c=1 sm=0 a=8LHCb4_oiB0A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=E6pNk5DXc5hTfzv0XAwA:9 a=ojLlRFdJrGcCxutc6ligmHQ9NGsA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 3/9 - v2][RFC] tracing: Remove per event trace
 registering
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
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <4BE3CD51.4050406@cn.fujitsu.com>
References: <20100504034045.085822814@goodmis.org>
	 <20100504034202.282030521@goodmis.org>  <4BE3CD51.4050406@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 07 May 2010 08:59:05 -0400
Message-ID: <1273237145.22438.75.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 16:20 +0800, Li Zefan wrote:
> > @@ -935,11 +947,11 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
> >  		return -1;
> >  	}
> >  
> > -	if (call->regfunc)
> > +	if (call->class->probe || call->class->reg)
> >  		trace_create_file("enable", 0644, call->dir, call,
> >  				  enable);
> >  
> > -	if (call->id && call->perf_event_enable)
> > +	if (call->id && (call->class->perf_probe || call->class->reg))
> >  		trace_create_file("id", 0444, call->dir, call,
> >  		 		  id);
> >  
> 
> Accessing of ->perf_probe needs to be guarded with CONFIG_PERF_EVENTS,
> otherwise it won't pass compile.
> 
> The original code is fine, because ->perf_event_enable is always there
> regardless of CONFIG_PERF_EVENTS.

Good catch! I wanted to test the !CONFIG_PERF_EVENTS but that needs to
be done on a non x86 box. I'll need to do that before posting my non-RFC
patch set.

-- Steve


