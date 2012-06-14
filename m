Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab2FNOMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:12:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:57328 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab2FNOMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:12:18 -0400
Date: Thu, 14 Jun 2012 16:12:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
In-Reply-To: <alpine.LFD.2.02.1206141545510.3086@ionos>
Message-ID: <alpine.LFD.2.02.1206141610090.3086@ionos>
References: <20120613102823.373180763@linutronix.de> <20120613105815.206105518@linutronix.de> <20120613185748.GF2427@linux.vnet.ibm.com> <alpine.LFD.2.02.1206132101440.3086@ionos> <20120613191745.GG2427@linux.vnet.ibm.com> <20120613204725.GA9858@linux.vnet.ibm.com>
 <20120614045125.GA30257@linux.vnet.ibm.com> <alpine.LFD.2.02.1206141234400.3086@ionos> <20120614125939.GC2443@linux.vnet.ibm.com> <alpine.LFD.2.02.1206141527580.3086@ionos> <alpine.LFD.2.02.1206141545510.3086@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012, Thomas Gleixner wrote:
> On Thu, 14 Jun 2012, Thomas Gleixner wrote:
> 
> > On Thu, 14 Jun 2012, Paul E. McKenney wrote:
> > > On Thu, Jun 14, 2012 at 01:20:39PM +0200, Thomas Gleixner wrote:
> > > > I gave it a quick shot, but I was not able to reproduce the hang yet.
> > > 
> > > Really?  I have a strictly Western-Hemisphere bug?  ;-)
> > 
> > I guess I need to fire up rcu torture to make it surface.
> >  
> > > > But looking at the thread function made me look into rcu_yield() and I
> > > > really wonder what kind of drug induced that particular piece of
> > > > horror.
> > > 
> > > When you are working on something like RCU priority boosting, no other
> > > drug is in any way necessary.  ;-)
> > 
> > And how do we protect minors from that ?
> >  
> > > > I can't figure out why this yield business is necessary at all. The
> > > > commit logs are as helpful as the missing code comments :)
> > > > 
> > > > I suspect that it's some starvation issue. But if we need it, then
> > > > can't we replace it with something sane like the (untested) patch
> > > > below?
> > > 
> > > Yep, starvation.  I will take a look at your approach after I wake
> > > up a bit more.
> > 
> > Btw, if that simpler yield approach is working and I can't see why it
> > shouldn't then you can get rid of the node task as well. The only
> > purpose of it is to push up the priority of yielding tasks, right?
> 
> Ah, missed that it calls rcu_initiate_boost() as well....

And looking further, I really don't understand why it's doing
that. That node thread is only woken by these weird yield timers.

Thanks,

	tglx
