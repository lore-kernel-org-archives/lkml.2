Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab1G1Sdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 14:33:33 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50852 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab1G1Sd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 14:33:27 -0400
Date: Thu, 28 Jul 2011 11:32:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [ANNOUNCE] 3.0-rt4
Message-ID: <20110728183207.GR2403@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LFD.2.02.1107272222420.2660@ionos>
 <20110728174123.GA10751@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1107281942580.2660@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1107281942580.2660@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 07:43:43PM +0200, Thomas Gleixner wrote:
> 
> On Thu, 28 Jul 2011, Paul E. McKenney wrote:
> 
> > On Wed, Jul 27, 2011 at 11:37:09PM +0200, Thomas Gleixner wrote:
> > > Dear RT Folks,
> > > 
> > > I'm pleased to announce the 3.0-rt4 release.
> > 
> > 3.0-rt5 boots single-CPU under KVM on a 32-bit laptop.  Also with "-smp
> > 2".  It even survived a minute or so of rcutorture in both cases.  ;-)
> > 
> > Some weirdness with interactivity -- if the system is idle aside from
> > rcutorture, the rcutorture.stat_interval console messages don't come
> > out unless I hit "enter" on the console.  But if I run "top", they do
> > come out regularly.  Might well be KVM's fault, except that running
> > rcutorture on non-rt kernels doesn't exhibit this behavior.
> 
> Nah, that's my lazy "avoid printing from atomic context" hack :)

Well, then, that does seem to be working...  ;-)

Except that these printk()s are from process level -- rcu_torture_stats()
in kernel/rcutorture.c.

> > I guess I should try RCU_BOOST=y, then...
> 
> Good luck :)

Compiled without error and has been running rcutorture smp=2 for
about 30 minutes now.

							Thanx, Paul
