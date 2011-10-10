Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab1JJNGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:06:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65247 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1JJNGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:06:05 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=Q0RNhdNGvDcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=q272qnZpA1TpuxEHVsMA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 0/3][RFC] trace_printk() using percpu buffers
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 10 Oct 2011 09:06:03 -0400
In-Reply-To: <1318251799.14400.28.camel@laptop>
References: <20111008170227.792806635@goodmis.org>
	 <1318244697.14400.18.camel@laptop>
	 <1318249909.7904.70.camel@gandalf.stny.rr.com>
	 <1318251799.14400.28.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318251964.7904.81.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 15:03 +0200, Peter Zijlstra wrote:
> On Mon, 2011-10-10 at 08:31 -0400, Steven Rostedt wrote:
> 
> > > > By default, it still uses the single buffer protected by a spinlock
> > > > and an atomic (for NMIs). The NMI case can cause dropped prints if
> > > > the NMI happens while a trace_printk() is processing.
> > > 
> > > Why bother keeping that?
> > 
> > Because very few developers debug nmi's. printk is known not to work
> > there.
> > 
> > I still find it useful to have without having to switch on a config
> > option or kernel command line.
> 
> But its also a massive scalability fail. There's simply no sane reason
> to keep the shared buffer trace_printk() implementation.

It was created as a "fast printk". Printk has the same scalability
issues, and other issues as well. It matters what you are debugging and
in most cases the single buffer has worked fine.

Nobody has yet to complain about it. Except for you when I told you how
it worked. ;)



> > That way, you could set this option and forget about it.
> 
> Well, if all we have is the per-cpu option I'm fine either way.

Good! This patch set improves trace_printk() from what it currently is
to something that will work for you and not break the way it use to work
for others.

I'll keep this patchset as is.

Thanks!

-- Steve


