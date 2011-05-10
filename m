Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab1EJMbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 08:31:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38134 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab1EJMbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 08:31:36 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=UZYI7n2t75YA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=Y0O1ELPRERvcVXXL-7QA:9 a=_xSfFlj33uFFPgYJBK4A:7 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20110510084732.GE27426@elte.hu>
References: <4DC45537.6070609@linux.intel.com>
	 <1304713252.25414.2532.camel@gandalf.stny.rr.com>
	 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
	 <20110507065803.GA23414@elte.hu>
	 <1304765110.25414.2564.camel@gandalf.stny.rr.com>
	 <20110507144402.GC2859@elte.hu> <1304788829.11129.57.camel@frodo>
	 <20110507190033.GA11465@elte.hu> <1304996847.2969.151.camel@frodo>
	 <20110510084732.GE27426@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 06:33:08 -0400
Message-ID: <1305023588.2971.6.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 10:47 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > [...] Thus a library is a perfect solution. [...]
> 
> Btw., just to make things clear, if we indeed have a library to parse things 
> and if all apps use that then the ABI moves to another (library) level.
> 
> The requirement from my maintenance POV is very, very simple: apps should not 
> break on new kernels. If this is achieved by making apps smarter then that's a 
> valid solution.
> 

Great! Because this is what I want. I would also want a way to designate
events as stable. I'll add a TRACE_EVENT_STABLE() that can only have the
events that maintainers agree to maintain. And give the apps an ability
to only see these. Have the other events need either a separate library,
or perhaps just separate calls from within the same library, so the XFS
developers can feel safe that their tracepoints will not be depended on.
And perhaps have two tracepoints for sched_switch such that Peter
Zijlsta is happy that he's not bound by an tracepoint that keeps him
from getting rid of FIFO ;)

I'm happy to write a libperf.so and I can discuss with Arnaldo, Arjan
and yourself what is the best way of doing this.

Thanks,

-- Steve


