Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751000Ab1ITPR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:17:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44654 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab1ITPR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:17:56 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=3kNrfhY1ZosA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=XqwhGrQx-02lpYbzHRMA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <alpine.DEB.2.00.1109200957500.8056@router.home>
References: <20110919212040.745370781@goodmis.org>
	 <alpine.DEB.2.00.1109191644190.19059@router.home>
	 <1316487977.29966.32.camel@gandalf.stny.rr.com>
	 <27409.1316522696@turing-police.cc.vt.edu>
	 <alpine.LFD.2.02.1109201549520.2723@ionos>
	 <alpine.DEB.2.00.1109200957500.8056@router.home>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 20 Sep 2011 11:17:54 -0400
Message-ID: <1316531874.29966.63.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 09:58 -0500, Christoph Lameter wrote:
> On Tue, 20 Sep 2011, Thomas Gleixner wrote:
> 
> > > What's the latency hit on those very few locations if we simply put our
> > > collective foot down and not support a preemptable version of this_cpu_*()?
> > > "Yes, you *could* preempt here, but for our collective sanity that's not
> > > supported"...
> >
> > Full ack.
> 
> Latency hit could be very significant in various critical kernel paths.
> Especially network subsystem, vm event counters etc.

Latency hit is better than incorrect behavior. I tell people working on
-rt all the time. A bug/kernel crash is much worse than a hit in
latency, as a bug/kernel crash causes a much bigger latency hit than
anything else.

-- Steve



