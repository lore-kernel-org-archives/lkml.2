Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab2FNOux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:50:53 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49483 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451Ab2FNOuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:50:51 -0400
Date: Thu, 14 Jun 2012 07:50:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
Message-ID: <20120614145038.GB2458@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120613102823.373180763@linutronix.de>
 <20120613105815.206105518@linutronix.de>
 <20120613185748.GF2427@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206132101440.3086@ionos>
 <20120613191745.GG2427@linux.vnet.ibm.com>
 <20120613204725.GA9858@linux.vnet.ibm.com>
 <20120614045125.GA30257@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206141234400.3086@ionos>
 <20120614125939.GC2443@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206141527580.3086@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1206141527580.3086@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061414-5806-0000-0000-00001634A366
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 03:32:19PM +0200, Thomas Gleixner wrote:
> On Thu, 14 Jun 2012, Paul E. McKenney wrote:
> > On Thu, Jun 14, 2012 at 01:20:39PM +0200, Thomas Gleixner wrote:
> > > I gave it a quick shot, but I was not able to reproduce the hang yet.
> > 
> > Really?  I have a strictly Western-Hemisphere bug?  ;-)
> 
> I guess I need to fire up rcu torture to make it surface.

A simple offline was triggering it for me.  Perhaps some of my debug
code was inappropriate, will retry.

> > > But looking at the thread function made me look into rcu_yield() and I
> > > really wonder what kind of drug induced that particular piece of
> > > horror.
> > 
> > When you are working on something like RCU priority boosting, no other
> > drug is in any way necessary.  ;-)
> 
> And how do we protect minors from that ?

We rely on their own sense of self-preservation preventing them from
getting involved in such insanity.

> > > I can't figure out why this yield business is necessary at all. The
> > > commit logs are as helpful as the missing code comments :)
> > > 
> > > I suspect that it's some starvation issue. But if we need it, then
> > > can't we replace it with something sane like the (untested) patch
> > > below?
> > 
> > Yep, starvation.  I will take a look at your approach after I wake
> > up a bit more.
> 
> Btw, if that simpler yield approach is working and I can't see why it
> shouldn't then you can get rid of the node task as well. The only
> purpose of it is to push up the priority of yielding tasks, right?

It also boosts the priority of preempted RCU read-side critical sections.

							Thanx, Paul

