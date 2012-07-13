Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab2GMSyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 14:54:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329Ab2GMSyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 14:54:18 -0400
Date: Fri, 13 Jul 2012 14:54:02 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Darren Hart <darren@dvhart.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: 3.5-rc6 futex_wait_requeue_pi oops.
Message-ID: <20120713185402.GA1707@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Darren Hart <darren@dvhart.com>,
	Peter Zijlstra <peterz@infradead.org>
References: <20120713180823.GA24972@redhat.com>
 <alpine.LFD.2.02.1207132032330.32033@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1207132032330.32033@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 08:47:38PM +0200, Thomas Gleixner wrote:
 > On Fri, 13 Jul 2012, Dave Jones wrote:
 > 
 > > Looks like calling futex() with garbage makes things unhappy.
 > 
 >                 WARN_ON(!&q.pi_state);
 >                 pi_mutex = &q.pi_state->pi_mutex;
 >                 ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
 >                 debug_rt_mutex_free_waiter(&rt_waiter);
 > 
 > So there is some weird way which causes q.pi_state = NULL. Dave, did
 > you see the warning before the oops happened ?

No, that didn't seem to trigger.

	Dave

