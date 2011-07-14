Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab1GNF02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 01:26:28 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56560 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab1GNF01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 01:26:27 -0400
Date: Wed, 13 Jul 2011 22:26:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: lockdep circular locking error (rcu_node_level_0 vs rq->lock)
Message-ID: <20110714052622.GA5366@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110711231932.GB20367@redhat.com>
 <1310502014.2309.7.camel@laptop>
 <20110712205126.GM2326@linux.vnet.ibm.com>
 <1310507047.2309.10.camel@laptop>
 <20110712225443.GS2326@linux.vnet.ibm.com>
 <1310545448.14978.40.camel@twins>
 <20110713163309.GC2355@linux.vnet.ibm.com>
 <20110714042932.GA2932@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110714042932.GA2932@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 09:29:32PM -0700, Paul E. McKenney wrote:
> On Wed, Jul 13, 2011 at 09:33:09AM -0700, Paul E. McKenney wrote:

[ . . . ]

> Hmmm...  Something is confused.  I get boot time hangs with the
> occasional stack overflow, whether or not I add my patch on top.
> Left to myself, I would try applying your patch incrementally, and
> also disabling irqs before rcu_read_lock() and enabling them after
> rcu_read_unlock(), as this prevents rcu_read_unlock() from ever getting
> to the rcu_read_unlock_special() slowpath.

And the real question...  Why did the rcu_read_unlock() called from
cpuacct_charge() enter rcu_read_unlock_special() in the first place?
If the runqueue lock is held, irqs should be disabled, so how did the
task get blocked or interrupted?

I need to get some sleep then figure out what is going on here.

							Thanx, Paul
