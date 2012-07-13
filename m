Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566Ab2GMTMC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 15:12:02 -0400
Received: from www.linutronix.de ([62.245.132.108]:46241 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587Ab2GMTMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 15:12:01 -0400
Date: Fri, 13 Jul 2012 21:11:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Darren Hart <darren@dvhart.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: 3.5-rc6 futex_wait_requeue_pi oops.
In-Reply-To: <20120713185402.GA1707@redhat.com>
Message-ID: <alpine.LFD.2.02.1207132108340.32033@ionos>
References: <20120713180823.GA24972@redhat.com> <alpine.LFD.2.02.1207132032330.32033@ionos> <20120713185402.GA1707@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012, Dave Jones wrote:

> On Fri, Jul 13, 2012 at 08:47:38PM +0200, Thomas Gleixner wrote:
>  > On Fri, 13 Jul 2012, Dave Jones wrote:
>  > 
>  > > Looks like calling futex() with garbage makes things unhappy.
>  > 
>  >                 WARN_ON(!&q.pi_state);
>  >                 pi_mutex = &q.pi_state->pi_mutex;
>  >                 ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
>  >                 debug_rt_mutex_free_waiter(&rt_waiter);
>  > 
>  > So there is some weird way which causes q.pi_state = NULL. Dave, did
>  > you see the warning before the oops happened ?
> 
> No, that didn't seem to trigger.

Yuck. The rt_mutex is embedded in pi_state and not a pointer and the
thing explodes in __lock_acquire if the raw lock protecting the
rtmutex internals. 

Can you decode the exact code line ?

Thanks,

	tglx


