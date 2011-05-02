Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1EBKZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 06:25:27 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56489 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab1EBKZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 06:25:26 -0400
Date: Mon, 2 May 2011 03:25:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 07/86] rcu: Force per-rcu_node kthreads
 off of the outgoing CPU
Message-ID: <20110502102515.GD2297@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <1304256126-26015-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110501151034.GA14829@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501151034.GA14829@feather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 08:10:35AM -0700, Josh Triplett wrote:
> On Sun, May 01, 2011 at 06:20:47AM -0700, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paul.mckenney@linaro.org>
> > 
> > The scheduler has had some heartburn in the past when too many real-time
> > kthreads were affinitied to the outgoing CPU.  So, this commit lightens
> > the load by forcing the per-rcu_node and the boost kthreads off of the
> > outgoing CPU.  Note that RCU's per-CPU kthread remains on the outgoing
> > CPU until the bitter end, as it must in order to preserve correctness.
> > 
> > Also avoid disabling hardirqs across calls to set_cpus_allowed_ptr(),
> > given that this function can block.
> 
> This seems like two separate changes in one patch.  The change to
> kernel/rcutree_plugin.h seems entirely separable from the change to
> kernel/rcutree.c here.
> 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Heh, amusingly this actually seems meaningful, if you intend it as a
> "role" approval.

Yep, that is the intent!  ;-)

							Thanx, Paul
