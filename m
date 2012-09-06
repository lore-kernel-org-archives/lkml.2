Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab2IFRzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:55:38 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40883 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130Ab2IFRzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:55:36 -0400
Date: Thu, 6 Sep 2012 10:53:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 13/23] rcu: Control grace-period duration
 from sysfs
Message-ID: <20120906175324.GN2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-13-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346940930.18408.14.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346940930.18408.14.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090617-7282-0000-0000-00000CB79A33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 04:15:30PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-08-30 at 11:18 -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > Some uses of RCU benefit from shorter grace periods, while others benefit
> > more from the greater efficiency provided by longer grace periods.
> > Therefore, this commit allows the durations to be controlled from sysfs.
> > There are two sysfs parameters, one named "jiffies_till_first_fqs" that
> > specifies the delay in jiffies from the end of grace-period initialization
> > until the first attempt to force quiescent states, and the other named
> > "jiffies_till_next_fqs" that specifies the delay (again in jiffies)
> > between subsequent attempts to force quiescent states.  They both default
> > to three jiffies, which is compatible with the old hard-coded behavior.
> 
> A number of questions:
> 
>  - how do I know if my workload wants a longer or shorter forced qs
>    period?

Almost everyone can do just fine with the defaults.  If you have more
than about 1,000 CPUs, you might need a longer period.  Some embedded
systems might need a shorter period -- the only specific example I know
of is network diagnostic equipment running wireshark, which starts up
slowly due to grace-period length.

>  - the above implies a measure of good/bad-ness associated with fqs,
>    can one formulate this?

Maybe.  I do not yet have enough data on really big systems to have a
good formula just yet.

>  - if we can, should we not do this 'automagically' and avoid burdening
>    our already hard pressed sysads of the world with trying to figure
>    this out?

I do expect to get there at some point.

> Also, whatever made you want to provide this 'feature' in the first
> place?

Complaints from the two groups called out above.

							Thanx, Paul

