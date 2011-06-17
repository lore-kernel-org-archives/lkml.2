Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136Ab1FQVBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 17:01:01 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57204 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437Ab1FQVA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 17:00:57 -0400
Date: Fri, 17 Jun 2011 14:00:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH rcu/urgent] Banishing kthreads
Message-ID: <20110617210039.GK2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110617000019.GA15881@linux.vnet.ibm.com>
 <BLU0-SMTP59C2BC46DCAC5743FE5229966D0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU0-SMTP59C2BC46DCAC5743FE5229966D0@phx.gbl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 04:35:23PM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > This patchset banishes RCU kthreads from non-RCU_BOOST kernel threads.
> > The two patches are as follows:
> > 
> > 1.	Minimal patch that #ifdefs out the kthread code.
> > 
> > 2.	Code-movement patch that puts the code #ifdefed out above
> > 	under existing #ifdefs in kernel/rcutree_plugin.h.
> 
> Hi Paul,
> 
> I'm wondering about the impact of this change: so I guess that before
> the change, it was OK to go on a waitqueue (might_sleep()) within a
> call_rcu callback, but since the execution now moves to a softirq
> handler in non-RCU_BOOST kernels, it's not allowed anymore. I might be
> missing something though: was sleeping within call_rcu handlers already
> prohibited ? (never had to sleep in those, so I never had to check if it
> was allowed)

The callbacks are still executed in BH context, so any attempt to
sleep should get a warning message.  Also, it switched to kthread quite
recently, so there hasn't been time for anyone to get used to it.  ;-)

							Thanx, Paul
