Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab2FRIuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:50:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:47941 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab2FRIuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:50:10 -0400
Date: Mon, 18 Jun 2012 10:50:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Namhyung Kim <namhyung@kernel.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch V2 2/7] kthread: Implement park/unpark facility
In-Reply-To: <87hau9huwy.fsf@sejong.aot.lge.com>
Message-ID: <alpine.LFD.2.02.1206181048000.3086@ionos>
References: <20120615140217.933711648@linutronix.de> <20120615140714.456322600@linutronix.de> <87hau9huwy.fsf@sejong.aot.lge.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012, Namhyung Kim wrote:
> On Fri, 15 Jun 2012 14:13:21 -0000, Thomas Gleixner wrote:
> > To avoid the full teardown/setup of per cpu kthreads in the case of
> > cpu hot(un)plug, provide a facility which allows to put the kthread
> > into a park position and unpark it when the cpu comes online again.
> >
> 
> Please see a comment below. Other than that, you can add my
> 
>   Reviewed-by: Namhyung Kim <namhyung@kernel.org>
> 
> if you want.

My pleasure.
 
> 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > ---
> >  include/linux/kthread.h |   11 ++
> >  kernel/kthread.c        |  184 +++++++++++++++++++++++++++++++++++++++++++-----
> >  2 files changed, 175 insertions(+), 20 deletions(-)
> [snip]
> >  /**
> > + * kthread_create_on_cpu - Create a cpu bound kthread
> > + * @threadfn: the function to run until signal_pending(current).
> > + * @data: data ptr for @threadfn.
> > + * @cpu: The cpu on which the thread should be bound,
> > + * @namefmt: printf-style name for the thread.
> 
> How about adding a comment that @namefmt can handle a single %u only
> for the cpu number in the current implementation?

Good point!
 
Thanks for taking your time!

       tglx
