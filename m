Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab1BWTfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:35:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45402 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317Ab1BWTfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:35:14 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=x5lYFldHaXAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=41f9gDDPBCUqm97kbLUA:9 a=Pa3ajuvgpB4zC1qcuYKMaYLhE8EA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
In-Reply-To: <1298489030.2217.818.camel@twins>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
	 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20110223161645.GA1819@nowhere>
	 <1298479302.7666.94.camel@gandalf.stny.rr.com>
	 <BLU0-SMTP65F733B8D1D704C7EA1F8796DB0@phx.gbl>
	 <alpine.DEB.2.00.1102231132140.562@router.home>
	 <1298485027.7666.98.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1102231225330.3906@router.home>
	 <1298485965.7666.102.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1102231317550.4823@router.home>
	 <1298489030.2217.818.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 23 Feb 2011 14:35:10 -0500
Message-ID: <1298489710.7666.125.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 20:23 +0100, Peter Zijlstra wrote:
> On Wed, 2011-02-23 at 13:19 -0600, Christoph Lameter wrote:
> 
> > this_cpu_inc is already percpu atomic. On x86 it is an instruction that
> > cannot be interrupted nor preempted while in progress.
> 
> On x86, yes, but is this true for all architectures? I guess the
> fallback is implemented with local_irq_disable() which might be good
> enough for some but not for NMI usage.

IIRC, those archs that can not do an atomic inc or cmpxchg have NMIs
that are basically "The Sh*t hit the fan, bail". Where the NMIs are used
only to dump out the state of the system and not something more advanced
that can do things like profiling.

-- Steve


