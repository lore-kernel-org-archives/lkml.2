Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab2H3Pbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 11:31:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:22261 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab2H3Pbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 11:31:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,341,1344236400"; 
   d="scan'208";a="216256346"
Date: Thu, 30 Aug 2012 08:22:36 -0700
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: INFO: suspicious RCU usage in rcu_torture_writer()
Message-ID: <20120830152236.GC11964@localhost>
References: <20120825033623.GA19330@localhost>
 <20120826000149.GG3436@linux.vnet.ibm.com>
 <20120827044052.GA16267@localhost>
 <20120827181750.GJ6122@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120827181750.GJ6122@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 11:17:51AM -0700, Paul E. McKenney wrote:
> On Mon, Aug 27, 2012 at 12:40:52PM +0800, Fengguang Wu wrote:
> > On Sat, Aug 25, 2012 at 05:01:49PM -0700, Paul E. McKenney wrote:
> > > On Sat, Aug 25, 2012 at 11:36:23AM +0800, Fengguang Wu wrote:
> > > > Greetings,
> > > > 
> > > > I got this warning on 3.6.0-rc2. Full dmesg/config attached.
> > > > 
> > > > [    3.051375] Initializing RT-Tester: OK
> > > > [    3.052491] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stut
> > > > ter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/1 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
> > > > [    3.059084] 
> > > > [    3.059451] ===============================
> > > > [    3.060454] [ INFO: suspicious RCU usage. ]
> > > > [    3.061482] 3.6.0-rc2-00010-g4c58c42 #59 Not tainted
> > > > [    3.062686] -------------------------------
> > > > [    3.063744] /c/kernel-tests/src/stable/kernel/rcutorture.c:990 suspicious rcu_dereference_check() usage!
> > > > 
> > > >  982         do {
> > > >  983                 schedule_timeout_uninterruptible(1);
> > > >  984                 rp = rcu_torture_alloc();
> > > >  985                 if (rp == NULL)
> > > >  986                         continue;
> > > >  987                 rp->rtort_pipe_count = 0;
> > > >  988                 udelay(rcu_random(&rand) & 0x3ff);
> > > >  989                 old_rp = rcu_dereference_check(rcu_torture_current,
> > > > >990                                                current == writer_task);
> > > >  991                 rp->rtort_mbtest = 1;
> > > >  992                 rcu_assign_pointer(rcu_torture_current, rp);
> > > >  993                 smp_wmb(); /* Mods to old_rp must follow rcu_assign_pointer() */
> > > >  994                 if (old_rp) {
> > > 
> > > 
> > > Does the following clear this up?
> > 
> > Sorry I'm still trying to reproduce this. It must be a rare bug
> > because it only showed up in several of the tens of thousands of test
> > boots. To reproduce it, I've done near 1000 boots however still not
> > caught it yet. Let's run it for more time...
> 
> I will push the fix up for 3.7, if something else is happening, we can
> debug when it comes up.  ;-)

Good idea! Since it's a really hard to reproduce problem that only
shows up after thousands of boots, it's easier to push the obvious fix
first. If ever it's not really fixed, the bug will show up again some
day and caught by the test system ;-)

Thanks,
Fengguang
