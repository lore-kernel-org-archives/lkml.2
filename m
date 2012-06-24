Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab2FXK33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 06:29:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:39405 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab2FXK32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 06:29:28 -0400
Date: Sun, 24 Jun 2012 12:29:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 5/5] infiniband: ehca: Use hotplug thread
 infrastructure
In-Reply-To: <alpine.LFD.2.02.1206181003240.3086@ionos>
Message-ID: <alpine.LFD.2.02.1206241224410.2853@ionos>
References: <20120613102823.373180763@linutronix.de> <20120613105815.416416492@linutronix.de> <87y5nlyvwn.fsf@rustcorp.com.au> <alpine.LFD.2.02.1206181003240.3086@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012, Thomas Gleixner wrote:
> > Your infrastructure is a really weird mix.  On the one hand, it's a set
> > of callbacks: setup, cleanup, park, unpark.  Cool.
> > 
> > On the other hand, instead of a 'run' callback, you've got a thread_fn,
> > which has to loop and call smpboot_thread_check_parking().
> > 
> > If you just had the thread_fn, it'd be trivial to follow program flow.
> > If you just had the callbacks, it'd still be pretty easy, though it
> > seems like a little too much help.

I reread your reply with less sleep depriviation and now I understood
your suggestion for using a run callback :)

Yep, that makes sense as it moves the loop into the generic code. Will
have a go on that.

Thanks,

	tglx



