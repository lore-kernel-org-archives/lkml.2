Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab1H3DR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 23:17:27 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45640 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab1H3DR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 23:17:26 -0400
Date: Mon, 29 Aug 2011 20:17:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frank Rowand <frank.rowand@am.sony.com>
Cc: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE] 3.0.1-rt11
Message-ID: <20110830031720.GC2218@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1313232790.25267.7.camel@twins>
 <4E559039.8060209@am.sony.com>
 <20110826235507.GJ2342@linux.vnet.ibm.com>
 <4E5BEF21.6040908@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5BEF21.6040908@am.sony.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 12:57:21PM -0700, Frank Rowand wrote:
> On 08/26/11 16:55, Paul E. McKenney wrote:
> > On Wed, Aug 24, 2011 at 04:58:49PM -0700, Frank Rowand wrote:
> >> On 08/13/11 03:53, Peter Zijlstra wrote:
> >>>
> >>> Whee, I can skip release announcements too!
> >>>
> >>> So no the subject ain't no mistake its not, 3.0.1-rt11 is there for the
> >>> grabs.
> >>>
> >>> Changes include (including the missing -rt10):
> >>>
> >>>   - hrtimer fix that should make RT_GROUP work again
> >>>   - RCU fixes that should make the RCU stalls go away
> >>>   - fixes SMP=n builds after breaking them in -rt9
> >>
> >> I have a consistent (every boot) hang on boot.  With a few
> >> hacks to get console output, I get the
> >>
> >>   rcu_preempt_state detected stalls on CPUs/tasks
> >>
> >> messages in the attached console log.
> 
> < snip >
> 
> > 
> > Hmmm...  The last few that I have seen that looked like this were
> > due to my messing up rcutorture so that the RCU-boost testing kthreads
> > ran CPU-bound at real-time priority.
> > 
> > Is it possible that something similar is happening on your system?
> > 
> >                                                         Thanx, Paul
> 
> I don't think so.  That would require CONFIG_RCU_TORTURE_TEST, correct?
> And that is not set:
> 
> < way big snip >
> 
> >> # CONFIG_RCU_TORTURE_TEST is not set
> >> CONFIG_RCU_CPU_STALL_TIMEOUT=60
> >> CONFIG_RCU_CPU_STALL_VERBOSE=y
> 
> I'm finally getting back to this today, so I'm starting to learn about
> the RCU stall detector, so maybe I can make some more sense of this.

This condition does not require CONFIG_RCU_TORTURE_TEST, rather, my
bug in CONFIG_RCU_TORTURE_TEST was one way to make this happen.  Any
condition that prevents RCU_SOFTIRQ from ever executing can cause these
symptoms.

							Thanx, Paul
