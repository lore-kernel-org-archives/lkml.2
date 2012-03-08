Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab2CHVhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:37:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48632 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab2CHVhO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:37:14 -0500
Message-ID: <1331242625.11248.433.camel@twins>
Subject: Re: [ANNOUNCE] 3.2.9-rt17
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 08 Mar 2012 22:37:05 +0100
In-Reply-To: <1331242574.25686.505.camel@gandalf.stny.rr.com>
References: <alpine.LFD.2.02.1203072225020.2742@ionos>
	 <1331230991.25686.452.camel@gandalf.stny.rr.com>
	 <1331231287.11248.396.camel@twins>
	 <1331232159.25686.456.camel@gandalf.stny.rr.com>
	 <1331235579.11248.402.camel@twins>
	 <1331237441.25686.469.camel@gandalf.stny.rr.com>
	 <1331238369.11248.426.camel@twins>
	 <1331240882.25686.499.camel@gandalf.stny.rr.com>
	 <1331241627.11248.430.camel@twins>
	 <1331241940.25686.502.camel@gandalf.stny.rr.com>
	 <1331242104.11248.432.camel@twins>
	 <1331242574.25686.505.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 16:36 -0500, Steven Rostedt wrote:
> On Thu, 2012-03-08 at 22:28 +0100, Peter Zijlstra wrote:
> > On Thu, 2012-03-08 at 16:25 -0500, Steven Rostedt wrote:
> > > 
> > > How would this be different than what mainline does? When the lock is
> > > released, it will wake up the other task. 
> > 
> > mainline has ticket locks, the rt-mutex stuff has equal priority lock
> > stealing, waking up the blocked task will take so long our running loop
> > will have re-acquired ->d_lock again before it even gets to trying.
> 
> And we have adaptive mutexes.
> 
> So we wake up the task (now with the higher priority), by the time it
> wakes up, the original task retook the lock. But because of adaptive
> mutexes, as this task takes the lock it notices that the owner is still
> running, and it will spin and not sleep.
> 
> Now when the original task releases the lock again, the other task can
> take it just like it does on mainline.

Now interleave it with a third task of even higher priority that puts
the spinner to sleep.
