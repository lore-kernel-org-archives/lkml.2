Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402Ab2IFRpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:45:17 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59704 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759335Ab2IFRpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:45:15 -0400
Date: Thu, 6 Sep 2012 10:41:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 07/23] rcu: Provide OOM handler to motivate
 lazy RCU callbacks
Message-ID: <20120906174112.GL2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346939197.18408.10.camel@twins>
 <1346939573.1680.18.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346939573.1680.18.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090617-2398-0000-0000-00000A58FDBE
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00171842; UDB=6.00038974; UTC=2012-09-06
 17:45:08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 09:52:53AM -0400, Steven Rostedt wrote:
> On Thu, 2012-09-06 at 15:46 +0200, Peter Zijlstra wrote:
> > On Thu, 2012-08-30 at 11:18 -0700, Paul E. McKenney wrote:
> > > +       get_online_cpus();
> > > +       for_each_online_cpu(cpu)
> > > +               for_each_rcu_flavor(rsp)
> > > +                       smp_call_function_single(cpu, rcu_oom_notify_cpu,
> > > +                                                rsp, 1);
> > > +       put_online_cpus(); 
> > 
> > I guess blasting IPIs around is better than OOM but still.. do you
> > really need to wait for each cpu individually, or would a construct
> > using on_each_cpu() be possible, or better yet, on_each_cpu_cond()?

I rejected on_each_cpu_cond() because it disables preemption across
a scan of all CPUs.  Probably need to fix that at some point...

> Also, what about having the rcu_oom_notify_cpu handler do the
> for_each_rcu_flavor() and not send an IPI multiple times to a single
> CPU?

Fair enough!

							Thanx, Paul

