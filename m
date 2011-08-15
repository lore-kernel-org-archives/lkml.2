Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab1HOPU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:20:56 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36045 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab1HOPUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:20:54 -0400
Date: Mon, 15 Aug 2011 08:20:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.0-git15 Atomic scheduling in pidmap_init
Message-ID: <20110815152052.GA2389@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110805170805.GB22164@somewhere>
 <20110805222641.GB2245@linux.vnet.ibm.com>
 <20110805231216.GE22164@somewhere>
 <20110808020914.GC2385@linux.vnet.ibm.com>
 <20110808025505.GF29058@somewhere>
 <20110808031014.GE2385@linux.vnet.ibm.com>
 <20110809113514.GA27301@somewhere.redhat.com>
 <20110810124528.GC2566@zod.bos.redhat.com>
 <20110814230453.GP2650@linux.vnet.ibm.com>
 <20110815140416.GB2227@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815140416.GB2227@zod.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 10:04:17AM -0400, Josh Boyer wrote:
> On Sun, Aug 14, 2011 at 04:04:53PM -0700, Paul E. McKenney wrote:
> > > > > > Now rcu_init_percpu_data() still sets rdp->qs_pending to 1, and that
> > > > > > is going to stay as is as long as preemption is disabled.
> > > > > 
> > > > > But setting rdp->qs_pending to 1 in rcu_init_percpu_data() has no effect
> > > > > until a grace period starts.  So, if grace periods are prevented from
> > > 
> > > Er... really?  Because it gets set and __rcu_pending looks at it
> > > unconditionally in the case that is calling set_need_resched.  It
> > > doesn't check if there is anything about a grace period going on or not.
> > 
> > Frederic noted the condition that prevents this at boot time, but it
> > appears that newly onlined CPUs might send themselves needless resched
> > IPIs at runtime if RCU is idle.
> > 
> > > > > starting, no need to mess with rcu_init_percpu_data().  Especially given
> > > > > that rcu_init_percpu_data() is also used at late boot and runtime for
> > > > > CPU hotplug.
> > > > 
> > > > Ok.
> > > > 
> > > > > 
> > > > > So I believe that it is sufficient to change cpu_needs_another_gp()
> > > > > to check for boot being far enough along to allow grace periods.
> > > > 
> > > > Yep, sounds good.
> > > 
> > > I looked at doing this but got lost as to 1) how it would help the
> > > situtation I've reported, and 2) exactly how to do that.
> > 
> > It would prevent control from reaching that point, and that might
> > well be needed for other reasons.  (This bit about RCU needing to
> > work differently at boot time is, well, "interesting".)
> > 
> > > I'd be happy to test, but at the moment the proposed solution is
> > > confusing to me.
> > 
> > Please see the attached.
> 
> Fixed it up quickly to apply on top of -rc2 and it seems to solve the
> problem nicely.  Thanks for the patch.

Good to hear!  I guess I should keep it, then.  ;-)

							Thanx, Paul
