Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab2FNQ6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:58:44 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:47338 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab2FNQ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:58:43 -0400
Date: Thu, 14 Jun 2012 09:48:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
Message-ID: <20120614164825.GH2458@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LFD.2.02.1206132101440.3086@ionos>
 <20120613191745.GG2427@linux.vnet.ibm.com>
 <20120613204725.GA9858@linux.vnet.ibm.com>
 <20120614045125.GA30257@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206141234400.3086@ionos>
 <20120614125939.GC2443@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206141527580.3086@ionos>
 <20120614145038.GB2458@linux.vnet.ibm.com>
 <20120614153828.GA31135@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206141817180.3086@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1206141817180.3086@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061416-7606-0000-0000-0000012001BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 06:19:50PM +0200, Thomas Gleixner wrote:
> On Thu, 14 Jun 2012, Paul E. McKenney wrote:
> 
> > On Thu, Jun 14, 2012 at 07:50:38AM -0700, Paul E. McKenney wrote:
> > > On Thu, Jun 14, 2012 at 03:32:19PM +0200, Thomas Gleixner wrote:
> > > > On Thu, 14 Jun 2012, Paul E. McKenney wrote:
> > > > > On Thu, Jun 14, 2012 at 01:20:39PM +0200, Thomas Gleixner wrote:
> > > > > > I gave it a quick shot, but I was not able to reproduce the hang yet.
> > > > > 
> > > > > Really?  I have a strictly Western-Hemisphere bug?  ;-)
> > > > 
> > > > I guess I need to fire up rcu torture to make it surface.
> > > 
> > > A simple offline was triggering it for me.  Perhaps some of my debug
> > > code was inappropriate, will retry.
> > 
> > And removing my debug code did the trick.  I guess some of it was really
> > just bug code.  In any case, it now passes short rcutorture testing for
> > me as well.
> > 
> > However, I do see the splat shown below.  The splat confuses me greatly,
> > as I thought that this kthread should be affinitied to a single CPU and
> > thus smp_processor_id() should refrain from splatting.  I don't see any
> > sort of "I broke affinity" message from the scheduler.
> 
> Hmm. Is that reproducible ?

Twice so far, will retry.

							Thanx, Paul

