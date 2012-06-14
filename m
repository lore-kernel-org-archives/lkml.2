Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab2FNQT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:19:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:58850 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab2FNQTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:19:55 -0400
Date: Thu, 14 Jun 2012 18:19:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
In-Reply-To: <20120614153828.GA31135@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1206141817180.3086@ionos>
References: <20120613105815.206105518@linutronix.de> <20120613185748.GF2427@linux.vnet.ibm.com> <alpine.LFD.2.02.1206132101440.3086@ionos> <20120613191745.GG2427@linux.vnet.ibm.com> <20120613204725.GA9858@linux.vnet.ibm.com> <20120614045125.GA30257@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206141234400.3086@ionos> <20120614125939.GC2443@linux.vnet.ibm.com> <alpine.LFD.2.02.1206141527580.3086@ionos> <20120614145038.GB2458@linux.vnet.ibm.com> <20120614153828.GA31135@linux.vnet.ibm.com>
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

> On Thu, Jun 14, 2012 at 07:50:38AM -0700, Paul E. McKenney wrote:
> > On Thu, Jun 14, 2012 at 03:32:19PM +0200, Thomas Gleixner wrote:
> > > On Thu, 14 Jun 2012, Paul E. McKenney wrote:
> > > > On Thu, Jun 14, 2012 at 01:20:39PM +0200, Thomas Gleixner wrote:
> > > > > I gave it a quick shot, but I was not able to reproduce the hang yet.
> > > > 
> > > > Really?  I have a strictly Western-Hemisphere bug?  ;-)
> > > 
> > > I guess I need to fire up rcu torture to make it surface.
> > 
> > A simple offline was triggering it for me.  Perhaps some of my debug
> > code was inappropriate, will retry.
> 
> And removing my debug code did the trick.  I guess some of it was really
> just bug code.  In any case, it now passes short rcutorture testing for
> me as well.
> 
> However, I do see the splat shown below.  The splat confuses me greatly,
> as I thought that this kthread should be affinitied to a single CPU and
> thus smp_processor_id() should refrain from splatting.  I don't see any
> sort of "I broke affinity" message from the scheduler.

Hmm. Is that reproducible ?
