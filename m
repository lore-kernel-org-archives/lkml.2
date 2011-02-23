Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab1BWSRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 13:17:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38248 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab1BWSRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 13:17:11 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=x5lYFldHaXAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=vTbKMTivceGsy1XHpasA:9 a=UTtHXfCJuaE6F14tHVXHnMGh4AsA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, "Paul E. McKenney" <paul.mckenney@linaro.org>
In-Reply-To: <alpine.DEB.2.00.1102231132140.562@router.home>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
	 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20110223161645.GA1819@nowhere>
	 <1298479302.7666.94.camel@gandalf.stny.rr.com>
	 <BLU0-SMTP65F733B8D1D704C7EA1F8796DB0@phx.gbl>
	 <alpine.DEB.2.00.1102231132140.562@router.home>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 23 Feb 2011 13:17:07 -0500
Message-ID: <1298485027.7666.98.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 11:34 -0600, Christoph Lameter wrote:

> > > True, but we could also argue that the multiple checks for being preempt
> > > can also be an issue.
> >
> > At least on x86 preemption don't actually need to be disabled: selection
> > of the right per-cpu memory location is done atomically with the rest of
> > the instruction by the segment selector.
> 
> Right.

But a test still needs to be made. Because three access of this_cpu_*()
that gets preempted and scheduled on another CPU can access a different
CPU var for each access. This does not matter how atomic the
this_cpu_*() code is.

IOW, the use of this_cpu_*() without preemption disabled is 99% of the
time a bug.

-- Steve


