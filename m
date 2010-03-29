Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab0C2JLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 05:11:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:49172 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab0C2JLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 05:11:39 -0400
Subject: Re: [PATCHSET] cpuhog: implement and use cpuhog
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, torvalds@linux-foundation.org, mingo@elte.hu,
       dipankar@in.ibm.com, josh@freedesktop.org, paulmck@linux.vnet.ibm.com,
       oleg@redhat.com, akpm@linux-foundation.org
In-Reply-To: <4B99B15B.8060002@kernel.org>
References: <1268063603-7425-1-git-send-email-tj@kernel.org>
	 <1268249155.5279.128.camel@twins>  <4B99B15B.8060002@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 11:11:28 +0200
Message-ID: <1269853888.12097.191.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 12:13 +0900, Tejun Heo wrote:
> Hello, Peter.
> 
> On 03/11/2010 04:25 AM, Peter Zijlstra wrote:
> > cpuhog as a name doesn't work for me, stop-machine had a name that
> > described its severity and impact, cpuhog makes me think of while(1);.
> >
> > Can't we keep the stop_machine name and make that a workqueue interface
> > like you propose?
> >
> > That way we'd end up with something like:
> > 
> > kernel/stop_machine.c
> >   int stop_cpu(int cpu, stop_fn_t fn, void *arg)
> >   int stop_machine(struct cpumask *mask, stop_fn_t fn, void *arg)
> 
> The distinction would be diabling of IRQ on each CPU.
> hog_[one_]cpu[s]() schedule highest priority task to, well, hog the
> cpu but doesn't affect contextless part of the cpu (irq, bh, whatnot).
> In that sense, it is the lowest bottom of upper half but not quite
> stopping the cpu and I think the distinction is rather important to
> make.  With the proposed preemption disabling around the callback, it
> pretty much behaves like a complete hog too.

Its a pretty minor difference, shouldn't we simply audit all existing
kstopmachine users and fix that up, having two similar but not quite
identical interfaces in the kernel sounds like trouble.

> > alternatively, something like schedule_primary_work*() might work I
> > guess.
> 
> I wanted to avoid verbs associatffed with the traditional workqueue -
> schedule and queue, while emphasizing that this is something that you
> don't want to abuse - so the verb hog.  monopolize_cpu() was the
> second choice but hog is shorter, sweeter and can also be used as a
> noun as-is, so I chose hog.
> 
> So, those were my rationales.  What do you think?

Still don't like the name fwiw.

