Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab1FIORZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 10:17:25 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56104 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab1FIORY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:17:24 -0400
Date: Thu, 9 Jun 2011 07:17:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 03/28] rcu: Streamline code produced by
 __rcu_read_unlock()
Message-ID: <20110609141714.GA2285@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110608192943.GA13211@linux.vnet.ibm.com>
 <1307561407-13809-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110609034507.GC6167@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609034507.GC6167@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 08:45:07PM -0700, Josh Triplett wrote:
> On Wed, Jun 08, 2011 at 12:29:42PM -0700, Paul E. McKenney wrote:
> > Given some common flag combinations, particularly -Os, gcc will inline
> > rcu_read_unlock_special() despite its being in an unlikely() clause.
> > Use noline to prohibit this misoptimization.
> 
> If rcu_read_unlock_special only gets called in the one place, why does
> it hurt to inline it, as long as the inlined code stays on the cold
> path?  Might as well remove the overhead of the function call.

One problem with inlining rcu_read_unlock_special() is that it
increases the icache footprint on the fast path.  Because the call to
rcu_read_unlock_special() occurs only rarely (if the reader blocked
or took too long), it is better to take the overhead of the call in
the uncommon case than to take the additional cache-miss overhead
in the common case.

Or did I miss your point?

							Thanx, Paul
