Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab0EaN4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 09:56:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:60003 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754191Ab0EaN4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 09:56:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/bg1wDnrTbd0ZAgRASvA8O0SZ30B33rmI0BRBi47
	LTJgAFTW1uIFOx
Subject: Re: commit e9e9250b: sync wakeup bustage when waker is an RT task
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1275306978.27810.22357.camel@twins>
References: <1273924628.10630.24.camel@marge.simson.net>
	 <1273925052.1674.138.camel@laptop>
	 <1273943222.8752.7.camel@marge.simson.net>
	 <1273994510.7873.10.camel@marge.simson.net>
	 <1275306978.27810.22357.camel@twins>
Content-Type: text/plain
Date: Mon, 31 May 2010 15:56:49 +0200
Message-Id: <1275314209.17599.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 13:56 +0200, Peter Zijlstra wrote:
> On Sun, 2010-05-16 at 09:21 +0200, Mike Galbraith wrote:
> > sched: RT waker sync wakeup bugfix
> > 
> > An RT waker's weight is not on the runqueue, but we try to subrtact it anyway
> > in the sync wakeup case,  sending this_load negative.  This leads to affine
> > wakeup failure in cases where it should succeed.  This was found while testing
> > an PREEMPT_RT kernel with lmbench's lat_udp.  In a PREEMPT_RT kernel, softirq
> > threads act as a ~proxy for the !RT buddy.  Approximate !PREEMPT_RT sync wakeup
> > behavior by looking at the buddy instead, and subtracting the maximum task weight
> > that will not send this_load negative. 
> 
> 
> Does the below work?

Had to make a dinky adjustment for x86-tip-rt33, but yeah, the horrid
latencies are gone.  (hm, skinnier than expected too)

	-Mike

