Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab0ELRPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:15:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34219 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab0ELRPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:15:15 -0400
X-Authority-Analysis: v=1.1 cv=GuuPm/R9MDBdMhOgsQZYzj+bBK5woo0X8cuc0sTVRtI= c=1 sm=0 a=zNANCjgXmV0A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=xYUoWpwdCExSnjRkWKAA:9 a=ht26MLmJu2XiB8F7bGvtjlLs89AA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC] PyTimechart
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Pierre Tardy <tardyp@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
       arjan@infradead.org, ziga.mahkovec@gmail.com
In-Reply-To: <20100512165947.GA11921@elte.hu>
References: <AANLkTilJLcdfK-vgqGdXyaZ_bQ1BDFmQl619egtGAA4i@mail.gmail.com>
	 <20100511213625.GD5422@nowhere>
	 <AANLkTikumkBKwYTYIK63mT2i_hI4SAo-Eua0cx9OCHnD@mail.gmail.com>
	 <20100512144811.GA5405@nowhere>
	 <1273678596.27703.30.camel@gandalf.stny.rr.com>
	 <20100512165947.GA11921@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 12 May 2010 13:15:11 -0400
Message-ID: <1273684511.27703.37.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 18:59 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Wed, 2010-05-12 at 16:48 +0200, Frederic Weisbecker wrote:
> > > On Wed, May 12, 2010 at 03:37:27PM +0200, Pierre Tardy wrote:
> > 
> > > But we don't yet support trace_printk in perf. May be we could wrap
> > > them in trace events.
> > 
> > Hmm, do we really want to do that?
> > 
> > We really need to get the perf and ftrace trace buffers combined. I 
> > understand why perf chose to do the mmap buffers for the counting, but for 
> > live streaming, it is very inefficient compared to splice.
> 
> The thing is that for a very long time ftrace didnt have splice support and 
> survived just fine. Even today most of the ftrace usage isnt utilizing splice.

Actually, trace-cmd implements the splice interface and is used by
several people. I find myself using trace-cmd 90% of the time that I use
ftrace, specifically because of this speedup.

> 
> Yes, splice might help in some situations but on average it's an independent 
> speedup on the order of magnitude of a few percents, not a 'must have' item.

I'll have start running benchmarks to see what the actual speed up is.
I'm guessing it may be more than a few percent. It allows for zero copy
overhead and reuse of the data page.

-- Steve


