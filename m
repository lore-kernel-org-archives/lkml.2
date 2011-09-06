Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab1IFNDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 09:03:42 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42977 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab1IFNDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 09:03:37 -0400
Date: Tue, 6 Sep 2011 15:03:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 13/32] nohz: Adaptive tick stop and restart on nohz cpuset
Message-ID: <20110906130323.GC28205@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-14-git-send-email-fweisbec@gmail.com>
 <1314631536.2816.89.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314631536.2816.89.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 05:25:36PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> > When a CPU is included in a nohz cpuset, try to switch
> > it to nohz mode from the timer interrupt if it is the
> > only non-idle task running.
> > 
> > Then restart the tick if necessary from the wakeup path
> > if we are enqueuing a second task while the timer is stopped,
> > so that the scheduler tick is rearmed.
> 
> Shouldn't you first put the syscall hooks in place before allowing the
> tick to be switched off? It seems this patch is somewhat too early in
> the series.

I don't think it's necessary, that part doesn't depend on userspace hooks.
The whole thing is enabled very late anyway.

 
> > This assumes we are using TTWU_QUEUE sched feature so I need
> > to handle the off case (or actually not handle it but properly),
> > because we need the adaptive tick restart and what will come
> > along in further patches to be done locally and before the new
> > task ever gets scheduled.
> 
> We could certainly remove that feature flag and always use it, it was
> mostly a transition debug switch in case something didn't work or
> performance issues were found due to this.

Ok, good.

> > I also need to look at the ARCH_WANT_INTERRUPTS_ON_CTXW case
> > and the remote wakeups.
> 
> Well, ideally we'd simply get rid of that, rmk has some preliminary
> patches in that direction.

Great!

Thanks.
