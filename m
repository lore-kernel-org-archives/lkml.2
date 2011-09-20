Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab1ITQ4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:56:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34414 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab1ITQ4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:56:50 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=3kNrfhY1ZosA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=DoyG_meiaGEJMSIeqQIA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1316536260.29966.93.camel@gandalf.stny.rr.com>
References: <20110919212040.745370781@goodmis.org>
	 <alpine.DEB.2.00.1109191644190.19059@router.home>
	 <1316487977.29966.32.camel@gandalf.stny.rr.com>
	 <27409.1316522696@turing-police.cc.vt.edu>
	 <alpine.DEB.2.00.1109200955190.8056@router.home>
	 <1316531987.29966.65.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1109201108080.8056@router.home>
	 <1316536260.29966.93.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 20 Sep 2011 12:56:48 -0400
Message-ID: <1316537808.29966.98.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 12:31 -0400, Steven Rostedt wrote:

> I personally believe that we shouldn't even have a modification version
> of the snapshot code. But perhaps it is fine for inc and dec and
> cmpxchg. Put "snapshot" in the name to document that this is a hack to
> make things work, and let all other users in the kernel use a name that
> is not confusing.

Looking at some of the uses that this_cpu() is used outside of
preemption seems to be just statistic counters (or buggy). Talking with
Peter and Thomas on IRC, we come to realize that the entire problem with
your API is the "this_cpu". Because it has nothing to do with the
current CPU.

Here are some names that we should change it to:

snapshot_cpu_*()  // my idea

random_cpu_*()    // Thomas's idea

any_cpu_*()       // Thomas's idea


Basically, the English term of "this_cpu" is patently wrong. It has
nothing to do with this cpu as you could be on any cpu at the time.

Lets rename the this_cpu() to something not so confusing and use them in
really the only locations that need them, and change all the
__this_cpu() users into this_cpu() which is exactly what they mean, and
also include the debug checking that we lost with the initial
conversions.

-- Steve


