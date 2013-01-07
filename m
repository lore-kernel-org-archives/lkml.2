Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab3AGQy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:54:59 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54399 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3AGQy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:54:57 -0500
X-Originating-IP: 217.70.178.140
X-Originating-IP: 50.43.39.152
Date: Mon, 7 Jan 2013 08:54:49 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 05/14] rcu: Distinguish "rcuo" kthreads by
 RCU flavor
Message-ID: <20130107165449.GB12229@leaf>
References: <20130105174844.GA14172@linux.vnet.ibm.com>
 <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1357408144-15830-5-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357408144-15830-5-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 09:48:55AM -0800, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> Currently, the per-no-CBs-CPU kthreads are named "rcuo" followed by
> the CPU number, for example, "rcuo".  This is problematic given that

I think the quoted string on this second line wanted to have a CPU
number in it.

> there are either two or three RCU flavors, each of which gets a per-CPU
> kthread with exactly the same name.  This commit therefore introduces
> a one-letter abbreviation for each RCU flavor, namely 'b' for RCU-bh,
> 'p' for RCU-preempt, and 's' for RCU-sched.  This abbreviation use used
> to distinguish the "rcuo" kthreads, for example, for CPU 0 we would have
> "rcuo0b", "rcuo0p", and "rcuo0s".

Don't per-CPU kthreads normally have a name ending in /$cpunum ?, rather
than just $cpunum?  For instance, kworker/0, kworker/1, and so on?
Seems like these threads should follow that convention.

- Josh Triplett
