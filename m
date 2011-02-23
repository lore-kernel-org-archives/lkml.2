Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab1BWUpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:45:38 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:43411 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab1BWUph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:45:37 -0500
Date: Wed, 23 Feb 2011 12:45:28 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
Message-ID: <20110223204528.GZ2163@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110223013917.GA20996@linux.vnet.ibm.com>
 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110223161645.GA1819@nowhere>
 <1298479302.7666.94.camel@gandalf.stny.rr.com>
 <BLU0-SMTP65F733B8D1D704C7EA1F8796DB0@phx.gbl>
 <alpine.DEB.2.00.1102231132140.562@router.home>
 <1298485027.7666.98.camel@gandalf.stny.rr.com>
 <alpine.DEB.2.00.1102231225330.3906@router.home>
 <20110223191658.GV2163@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1102231323140.4823@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102231323140.4823@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 01:24:34PM -0600, Christoph Lameter wrote:
> On Wed, 23 Feb 2011, Paul E. McKenney wrote:
> 
> > Reschedules can happen in this case due to CPU hotplug events.  :-(
> 
> Lockout cpu hotplug instead of disabling interrupts? Systems that support
> cpu hotplug in hardware are rare and so the cpu hotplug locking may be
> become noop.

Good point!

However, the local_irq_save() is doing two things here: (1) blocking
CPU hotplug and (2) synchronizing with concurrent invocations of
invoke_rcu_cpu_kthread() from irq handlers.

							Thanx, Paul
