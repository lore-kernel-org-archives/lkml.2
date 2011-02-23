Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab1BWTjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:39:41 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56183 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab1BWTjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:39:40 -0500
Date: Wed, 23 Feb 2011 11:39:33 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
Message-ID: <20110223193933.GW2163@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110223013917.GA20996@linux.vnet.ibm.com>
 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110223161645.GA1819@nowhere>
 <1298479302.7666.94.camel@gandalf.stny.rr.com>
 <BLU0-SMTP65F733B8D1D704C7EA1F8796DB0@phx.gbl>
 <alpine.DEB.2.00.1102231132140.562@router.home>
 <20110223191043.GU2163@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1102231320050.4823@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102231320050.4823@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 01:22:02PM -0600, Christoph Lameter wrote:
> On Wed, 23 Feb 2011, Paul E. McKenney wrote:
> 
> > These do introduce redundant preempt_disable()/preempt_enable() calls, but
> > this is not on a fastpath, so should be OK, and the improved readability
> > is certainly nice.  The read and the write do need to happen on the same
> > CPU, FWIW.
> 
> this_cpu_xxx only use preempt_enable/disable() on platforms that do not
> support per cpu atomic instructions. On x86 no preempt enable/disable will
> be inserted.
> 
> You can also use the __this_cpu_xxx operations which never add preempt
> disable/enable because they expect the caller to deal with preemption.

Those make a lot of sense in this case, as I need to use __get_cpu_var()
anyway.

Thank you for all the info!

							Thanx, Paul
