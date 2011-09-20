Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab1ITQuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:50:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:35654 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab1ITQuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:50:22 -0400
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 20 Sep 2011 18:50:03 +0200
In-Reply-To: <alpine.DEB.2.00.1109201109470.8056@router.home>
References: <20110919212040.745370781@goodmis.org>
	  <alpine.DEB.2.00.1109191644190.19059@router.home>
	  <1316487977.29966.32.camel@gandalf.stny.rr.com>
	  <20110920154610.GB28952@Krystal>
	 <1316534441.29966.79.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1109201109470.8056@router.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316537403.13664.59.camel@twins>
Mime-Version: 1.0
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

But part of that design is that its impossible to verify the
correctness. This is the part we object to and you keep avoiding.

There is a reason smp_processor_id() warns if its called in a
preemptible context, all the this_cpu wankery doesn't. It doesn't
provide a single useful debug feature and in places is designed so that
its impossible.

Seriously, how can you defend this shitpile with a straight face? Sure
it make slub go faster, but who gives a flying fuck if it brings the
rest of the kernel to its knees.


