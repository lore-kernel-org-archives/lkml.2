Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab1BWUPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:15:40 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:45129 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab1BWUPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:15:39 -0500
Date: Wed, 23 Feb 2011 12:15:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux.com>, Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
Message-ID: <20110223201534.GX2163@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110223161645.GA1819@nowhere>
 <1298479302.7666.94.camel@gandalf.stny.rr.com>
 <BLU0-SMTP65F733B8D1D704C7EA1F8796DB0@phx.gbl>
 <alpine.DEB.2.00.1102231132140.562@router.home>
 <1298485027.7666.98.camel@gandalf.stny.rr.com>
 <alpine.DEB.2.00.1102231225330.3906@router.home>
 <1298485965.7666.102.camel@gandalf.stny.rr.com>
 <alpine.DEB.2.00.1102231317550.4823@router.home>
 <1298489030.2217.818.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298489030.2217.818.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 08:23:50PM +0100, Peter Zijlstra wrote:
> On Wed, 2011-02-23 at 13:19 -0600, Christoph Lameter wrote:
> 
> > this_cpu_inc is already percpu atomic. On x86 it is an instruction that
> > cannot be interrupted nor preempted while in progress.
> 
> On x86, yes, but is this true for all architectures? I guess the
> fallback is implemented with local_irq_disable() which might be good
> enough for some but not for NMI usage.

Good point!  Thankfully, no worries about NMI usage in this piece of
code.  ;-)

							Thanx, Paul
