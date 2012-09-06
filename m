Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899Ab2IFUoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:44:37 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48090 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131Ab2IFUof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:44:35 -0400
Date: Thu, 6 Sep 2012 13:37:42 -0700
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
Message-ID: <20120906203742.GV2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-13-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346940930.18408.14.camel@twins>
 <20120906175324.GN2448@linux.vnet.ibm.com>
 <1346956101.18408.61.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346956101.18408.61.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090620-2398-0000-0000-00000A5B7790
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00171874; UDB=6.00038979; UTC=2012-09-06
 20:44:33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 08:28:21PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-09-06 at 10:53 -0700, Paul E. McKenney wrote:
> 
> > >  - how do I know if my workload wants a longer or shorter forced qs
> > >    period?
> > 
> > Almost everyone can do just fine with the defaults.  If you have more
> > than about 1,000 CPUs, you might need a longer period. 
> 
> Because the cost of starting a grace period is on the same order (or
> larger) in cost as this period?

Because the overhead of rcu_gp_fqs() can then be multiple jiffies, so
it doesn't make sense to run it so often.  If nothing else, the
rcu_gp_kthread() will start chewing up appreciable CPU time.

> >  Some embedded
> > systems might need a shorter period -- the only specific example I know
> > of is network diagnostic equipment running wireshark, which starts up
> > slowly due to grace-period length.
> 
> But but but 3 jiffies.. however is that too long?

Because wireshark startup runs through a great many grace periods when
starting up, and those 3-jiffy time periods add up.

> > > Also, whatever made you want to provide this 'feature' in the first
> > > place?
> > 
> > Complaints from the two groups called out above.
> 
> Does this really warrant a boot time knob for which even you cannot
> quite explain what values to use when?

If people look at me funny when I explain, I just tell them to leave
it alone.

One alternative at the low end would be to have a sysfs variable that
converted normal grace periods to expedited grace periods.  Would that
be preferable?

							Thanx, Paul

