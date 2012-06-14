Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab2FNPIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 11:08:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:58362 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab2FNPIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 11:08:10 -0400
Date: Thu, 14 Jun 2012 17:08:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
In-Reply-To: <20120614150118.GC2458@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1206141707420.3086@ionos>
References: <20120613185748.GF2427@linux.vnet.ibm.com> <alpine.LFD.2.02.1206132101440.3086@ionos> <20120613191745.GG2427@linux.vnet.ibm.com> <20120613204725.GA9858@linux.vnet.ibm.com> <20120614045125.GA30257@linux.vnet.ibm.com> <alpine.LFD.2.02.1206141234400.3086@ionos>
 <20120614125939.GC2443@linux.vnet.ibm.com> <alpine.LFD.2.02.1206141527580.3086@ionos> <alpine.LFD.2.02.1206141545510.3086@ionos> <alpine.LFD.2.02.1206141610090.3086@ionos> <20120614150118.GC2458@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012, Paul E. McKenney wrote:
> On Thu, Jun 14, 2012 at 04:12:14PM +0200, Thomas Gleixner wrote:
> > > > Btw, if that simpler yield approach is working and I can't see why it
> > > > shouldn't then you can get rid of the node task as well. The only
> > > > purpose of it is to push up the priority of yielding tasks, right?
> > > 
> > > Ah, missed that it calls rcu_initiate_boost() as well....
> > 
> > And looking further, I really don't understand why it's doing
> > that. That node thread is only woken by these weird yield timers.
> 
> If your patch works out, it indeed might be possible to get rid of
> ->node_kthread_task.  The ->boost_kthread_task needs to stay, however.

That's right.
