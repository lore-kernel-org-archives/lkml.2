Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab1GYIR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:17:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45349 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1GYIRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:17:23 -0400
Subject: Re: On migrate_disable() and latencies
From: Peter Zijlstra <peterz@infradead.org>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Carsten Emde <ce@ceag.ch>,
        Clark Williams <williams@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kumar Gala <galak@gate.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, rostedt <rostedt@goodmis.org>
In-Reply-To: <20110722174500.GB32014@opentech.at>
References: <1311329992.27400.23.camel@twins>
	 <20110722174500.GB32014@opentech.at>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 10:21:50 +0200
Message-ID: <1311582110.2617.40.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-22 at 19:45 +0200, Nicholas Mc Guire wrote:

> > Therefore the worst case latency is in the order of
> > max-migrate-disable-period * nr-cpus.
> 
> + something like sum of (interrupt rate [n] /
> max-migrate-disable-period * nr-cpus) * top-half handler [n]. if you
> go on with theoretical WCET analysis on multicore systems you will
> always end up at the conclusion that only UP is suitable for RT....

+ preemption cost + migration costs etc.. :-)

> > Currently we have no means of measuring these latencies, this is
> > something we need to grow, I think Steven can fairly easy craft a
> > migrate_disable runtime tracer -- it needs to use t->se.sum_exec_runtime
> > for measure so as to only count the actual time spend on the task and
> > ignore any time it was blocked.
>  
> well this is a similar problem as with the WCET "calculations" - you can
> calculate theoretical worst cases - but the question is what the actual
> distribution of "stacking" is and thus what the probability is that you
> manage to stack tasks in this way.

Sure, and yes those are thing to look at.

> One could I guess put some relatively simple instrumentation in to monitor
> this stacking problem - quit independant of actually measuring the times 

Yes, that would be very easy to do.

> > Once we have this, its back to the old game of 'lock'-breaking.
> >
> if the stacking problem does not practically exist then it might not be worth
> the effort to resolve it with elaborate lock breaking.

Fully agreed, its just that I wanted to share my understanding of the
problem space (both Thomas and I thought on-list email was a better
location that private IRC logs ;-), and we need to get the know the
problem before we can decide to ignore it ;-)

Ignoring unknowns always leads to surprises.

