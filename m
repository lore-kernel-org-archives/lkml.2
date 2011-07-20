Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab1GTRRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 13:17:05 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60305 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab1GTRRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 13:17:03 -0400
Date: Wed, 20 Jul 2011 10:15:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ed Tomlinson <edt@aei.ca>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org,
        edward.tomlinson@aero.bombardier.com
Subject: Re: [PATCH rcu/urgent 0/6] Fixes for RCU/scheduler/irq-threads
 trainwreck
Message-ID: <20110720171532.GB2313@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110720001738.GA16369@linux.vnet.ibm.com>
 <201107192130.02080.edt@aei.ca>
 <201107192207.33813.edt@aei.ca>
 <20110720044435.GB2400@linux.vnet.ibm.com>
 <CA+55aFyaCY=qzFKswi2NR097KZtb5x98sba3rHJ7B0rchtzm2g@mail.gmail.com>
 <20110720133443.GG2400@linux.vnet.ibm.com>
 <4E270A0E.6090902@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E270A0E.6090902@candelatech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 10:02:06AM -0700, Ben Greear wrote:
> On 07/20/2011 06:34 AM, Paul E. McKenney wrote:
> >On Tue, Jul 19, 2011 at 10:03:05PM -0700, Linus Torvalds wrote:
> >>On Tue, Jul 19, 2011 at 9:44 PM, Paul E. McKenney
> >><paulmck@linux.vnet.ibm.com>  wrote:
> >>>On Tue, Jul 19, 2011 at 10:07:32PM -0400, Ed Tomlinson wrote:
> >>>>On Tuesday 19 July 2011 21:30:00 Ed Tomlinson wrote:
> >>>>>On Tuesday 19 July 2011 20:17:38 Paul E. McKenney wrote:
> >>>>
> >>>>Paul,
> >>>>
> >>>>Two things to add.  Its possible an eariler error is missing from the log below.  My serial console was missing
> >>>>entries from before '0 and 40ish' and I did think I saw a bunch of FFFFFFFs scroll by eariler...
> >>>>
> >>>>Second, booting with threadirqs and boost enabled in .config with patches 2,5,6 is ok so far.
> >>>
> >>>Patches 3 and 4 resulted in failures?  (Patch 1 certainly did.)
> >>
> >>Gaah. Any possibility of getting this resolved soon?
> >
> >I believe that we are very close.  These failures all involve unusual
> >configurations, which is why they showed up so late.
> 
> What is strange about my configuration?  Just that I enabled the
> RCU boost and other new RCU features?

RCU boost is new and counts as strange for another few days at least.
And I do very much appreciate your testing efforts.  For whatever reason,
you are finding things that my testing did not.  Which means that my
testing needs to improve, but getting these bugs fixed is higher priority
for the moment.

> Surely it's not that I'm just doing lots of mounts and unmounts
> and file-io with lots of processes....
> 
> And I was posting lockdep warnings on this since -rc1 or so, though granted
> I was running a few extra patches and having other bugs at the same time....

Indeed, there were other bugs that were hiding the ones that we are
now hunting down.

							Thanx, Paul
