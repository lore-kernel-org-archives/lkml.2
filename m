Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab2GTNg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 09:36:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab2GTNg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 09:36:26 -0400
Date: Fri, 20 Jul 2012 09:35:01 -0400
From: Dave Jones <davej@redhat.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Darren Hart <darren@dvhart.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: 3.5-rc6 futex_wait_requeue_pi oops.
Message-ID: <20120720133501.GA30826@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Darren Hart <dvhart@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Darren Hart <darren@dvhart.com>,
	Peter Zijlstra <peterz@infradead.org>
References: <20120713180823.GA24972@redhat.com>
 <alpine.LFD.2.02.1207132032330.32033@ionos>
 <20120713185402.GA1707@redhat.com>
 <5008969F.5030901@linux.intel.com>
 <5008A847.4070006@linux.intel.com>
 <50090079.1000703@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50090079.1000703@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 11:53:45PM -0700, Darren Hart wrote:

 
 > >> I'll add a fix to that WARN_ON in my futex-fixes branch along with the
 > >> fix for the bug Dan found.
 > > 
 > > I think I have root cause. futex_wait_requeue_pi() doesn't like having
 > > uaddr == uaddr2. The handle_early_wakeup() doesn't detect a problem
 > > because key2 IS the same as key1, I think. I've just discovered this and
 > > quickly hacked in a "if (uaddr==uaddr2) return -EINVAL" fix and the test
 > > continues to run (with just ops 0, 11, 12) for several minutes now
 > > (typically fails in a few seconds). I'll let it run for a few hours and
 > > contemplate the proper fix.
 > 
 > Dave, mind giving this a spin? It seems to be doing the trick here,
 > at least for the *REQUEUE_PI futex op codes in trinity.

Yeah, looks like that does the trick!

thanks,

	Dave
