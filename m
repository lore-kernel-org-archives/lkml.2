Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282Ab1IUBdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 21:33:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab1IUBdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 21:33:31 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=3kNrfhY1ZosA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=otERZs4XbTMtsTMrmv8A:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
From: Steven Rostedt <rostedt@goodmis.org>
To: Valdis.Kletnieks@vt.edu
Cc: Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <25599.1316557072@turing-police.cc.vt.edu>
References: <20110919212040.745370781@goodmis.org>
	 <alpine.DEB.2.00.1109191644190.19059@router.home>
	 <1316487977.29966.32.camel@gandalf.stny.rr.com>
	 <27409.1316522696@turing-police.cc.vt.edu>
	 <alpine.DEB.2.00.1109200955190.8056@router.home>
	 <1316531987.29966.65.camel@gandalf.stny.rr.com>
	 <25599.1316557072@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 20 Sep 2011 21:33:27 -0400
Message-ID: <1316568807.29966.122.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 18:17 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 20 Sep 2011 11:19:47 EDT, Steven Rostedt said:
> > On Tue, 2011-09-20 at 09:57 -0500, Christoph Lameter wrote:
> > 
> > > this_cpu_xx functions are made for those locations that have
> > > preemption enabled. If you can use those function (classic case is a
> > > per cpu counter increment in the network subsystem) then you can avoid
> > > preempt disable/enable or get_cpu/put_cpu.
> > 
> > If the variables are used for a very short time, then the latencies
> > introduced by a simple:
> > 
> > 	var = get_cpu_var(my_var);
> > 	if (var)
> > 		do_something_quick();
> > 	put_cpu_var(my_var);
> > 
> > Otherwise if that do_something_quick(); migrates, it may be doing
> > something it shouldn't be doing!
> 
> This has the added advantage of making the calling function take the blame
> in latency traces, doesn't it?

Yes, the preempt off latency tracer would detect the above, if it took
too long.

-- Steve


