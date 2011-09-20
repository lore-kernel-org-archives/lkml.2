Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab1ITSyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:54:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37761 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab1ITSyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:54:03 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=3kNrfhY1ZosA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=Nmux7nRh03_HI-qwSxUA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <alpine.DEB.2.00.1109201109470.8056@router.home>
References: <20110919212040.745370781@goodmis.org>
	 <alpine.DEB.2.00.1109191644190.19059@router.home>
	 <1316487977.29966.32.camel@gandalf.stny.rr.com>
	 <20110920154610.GB28952@Krystal>
	 <1316534441.29966.79.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1109201109470.8056@router.home>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 20 Sep 2011 14:54:01 -0400
Message-ID: <1316544841.29966.121.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 11:10 -0500, Christoph Lameter wrote:
> On Tue, 20 Sep 2011, Steven Rostedt wrote:
> 
> > I really mean all other users of this_cpu_*(), including the cmpxchg and
> > friends, still need to have preemption disabled.
> 
> This is argument against the basic design of this_cpu_ops. They were
> designed to avoid having to disable preemption for single operations on
> per cpu data. I think this shows a basic misunderstanding of what you are
> dealing with.
> 

BTW, Can you explain to me where the this_cpu_*() ops were designed to
be used? The only places where "this_cpu_*()" is used in slub.c and
page_alloc.c have irqs disabled on their use. I thought this was for
slub and page_alloc?

Is this_cpu() made just for statistics? I see it used in the inode code
for that, and some accounting in the namespace.c code.

Note and there's places all over the kernel that uses this_cpu_read()
and thinks preemption should be disabled. Just look at
arch/x86/mm/tlb.c:

	/* Caller has disabled preemption */
	sender = this_cpu_read(tlb_vector_offset);

Why the comment?

My argument is that this_cpu_* is just confusing. Rename your use case
and keep this_cpu_*() as what you want __this_cpu_*() to be.

Thanks!

-- Steve



