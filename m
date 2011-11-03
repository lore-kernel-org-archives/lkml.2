Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab1KCVAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:00:45 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57442 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab1KCVAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:00:44 -0400
Date: Thu, 3 Nov 2011 14:00:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 28/28] rcu: Fix idle-task checks
Message-ID: <20111103210005.GK2287@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <1320265849-5744-28-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111103045509.GH2042@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103045509.GH2042@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11110321-8974-0000-0000-00000169EA75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 09:55:09PM -0700, Josh Triplett wrote:
> On Wed, Nov 02, 2011 at 01:30:49PM -0700, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paul.mckenney@linaro.org>
> > 
> > RCU has traditionally relied on idle_cpu() to determine whether a given
> > CPU is running in the context of an idle task, but recent changes have
> > invalidated this approach.  This commit therefore switches from idle_cpu
> > to "current->pid != 0".
> 
> Could you elaborate a bit on "recent changes"?  It looks like you mean
> commit 908a3283728d92df36e0c7cd63304fd35e93a8a9; if so, could you add
> that reference to the commit message?

Will do!

> Also, the hard-coded use of "current->pid != 0" concerns me.  Could this
> use some existing function?  Does idle_task() help?  If no appropriate
> predicate exists, perhaps it should.  is_idle_task(current)?

I could use idle_task(), but that does quite a bit more work.
The hard-coded "current->pid != 0" is used in a number of other places
in the kernel, so there is precedent.  Might be worth fixing globally
as a separate fix, though.

							Thanx, Paul

