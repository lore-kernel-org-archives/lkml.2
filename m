Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab0EGTKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 15:10:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40475 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab0EGTKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 15:10:14 -0400
X-Authority-Analysis: v=1.1 cv=GuuPm/R9MDBdMhOgsQZYzj+bBK5woo0X8cuc0sTVRtI= c=1 sm=0 a=KHh1y0iU_6MA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=uxs2kEub1nenenzZ89kA:9 a=LpW8Q7GGtFwITvnhphwA:7 a=-1_ijWrJI5q6-Nq0H32qJDZkdZcA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/9 - v2][RFC] tracing: Let tracepoints have data
 passed to tracepoint callbacks
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20100507180628.GB5401@nowhere>
References: <20100504034045.085822814@goodmis.org>
	 <20100504034201.896240097@goodmis.org> <20100507035230.GB8069@nowhere>
	 <1273241371.22438.81.camel@gandalf.stny.rr.com>
	 <20100507180628.GB5401@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 07 May 2010 15:10:12 -0400
Message-ID: <1273259412.22438.420.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 20:06 +0200, Frederic Weisbecker wrote:

> No, what I meant is that you have:
> 
> #ifdef CONFIG_TRACEPOINTS
> [...]
> +#define DECLARE_TRACE_NOARGS(name)                                       \
>       __DECLARE_TRACE(name, void, , void *__data, __data)
> 
> #define DECLARE_TRACE(name, proto, args)                         \
>       __DECLARE_TRACE(name, PARAMS(proto), PARAMS(args),      \
>                       PARAMS(proto, void *__data),            \
>                       PARAMS(args, __data))
> [...]
> #else
> [...]
> +#define DECLARE_TRACE_NOARGS(name)                                       \
>       __DECLARE_TRACE(name, void, , void *__data, __data)
> 
> #define DECLARE_TRACE(name, proto, args)                         \
>       __DECLARE_TRACE(name, PARAMS(proto), PARAMS(args),      \
>                       PARAMS(proto, void *__data),            \
>                       PARAMS(args, __data)
> [...]
> #endif
> 
> 
> See? They seem to be the exact same version, so this could be only
> one version outside the ifdef.
> And the CONFIG_TRACEPOINTS on/off case is dealt from __DECLARE_TRACE().

Ah, I see (said the blind man as he slipped and fell on the ice).

-- Steve



