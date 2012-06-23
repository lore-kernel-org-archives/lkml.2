Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2FWULL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 16:11:11 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52266 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab2FWULJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 16:11:09 -0400
Date: Sat, 23 Jun 2012 13:11:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BUG: tracer_alloc_buffers returned with preemption imbalance
Message-ID: <20120623201103.GK2516@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120623101251.GA10162@localhost>
 <20120623170147.GI2516@linux.vnet.ibm.com>
 <20120623174830.GA5617@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120623174830.GA5617@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062320-7282-0000-0000-00000A3CAD5D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 01:48:30AM +0800, Fengguang Wu wrote:
> > >  static inline int rcu_blocking_is_gp(void)
> > >  {
> > >         might_sleep();  /* Check for RCU read-side critical section. */
> > > +       preempt_disable();
> > >         return num_online_cpus() <= 1;
> > > +       preempt_enable();
> > >  }
> > 
> > Thank you!  I have no idea how a preempt_disable() causes that badness
> > to happen, but this commit is not yet critically important, so I will
> > drop it.
> 
> preempt_enable() becomes dead code because of the return statement?
> I wonder why gcc didn't issue a warning (or I failed to catch it)...

Color me blind and stupid!!!  Thank you, will fix.

							Thanx, Paul

