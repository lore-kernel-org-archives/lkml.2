Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab2E2SQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 14:16:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694Ab2E2SQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 14:16:15 -0400
Date: Tue, 29 May 2012 20:15:02 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 08/35] autonuma: introduce kthread_bind_node()
Message-ID: <20120529181502.GM21339@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
 <1337965359-29725-9-git-send-email-aarcange@redhat.com>
 <1338295753.26856.60.camel@twins>
 <20120529161157.GE21339@redhat.com>
 <1338311091.26856.146.camel@twins>
 <20120529174423.GK21339@redhat.com>
 <1338313686.26856.164.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338313686.26856.164.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 07:48:06PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-05-29 at 19:44 +0200, Andrea Arcangeli wrote:
> > 
> > But it'd be totally bad not to do the hard bindings to the cpu_s_ of
> > the node, and not using PF_THREAD_BOUND would just allow userland to
> > shoot itself in the foot. I mean if PF_THREAD_BOUND wouldn't exist
> > already I wouldn't add it, but considering somebody bothered to
> > implement it for the sake to make userland root user "safer", it'd be
> > really silly not to take advantage of that for knuma_migrated too
> > (even if it binds to more than 1 CPU). 
> 
> No, I'm absolutely ok with the user shooting himself in the foot. The
> thing exists because you can crash stuff if you get it wrong with
> per-cpu.
> 
> Crashing is not good, worse performance is his own damn fault.

Some people don't like root to write to /dev/mem or rm -r /
either. I'm not in that camp, but if you're not in that camp, then you
should _never_ care to set PF_THREAD_BOUND, no matter if it's about
crashing or just slowing down the kernel.

If such a thing exists, well using it to avoid the user either to crash or
to screw with the system performance, can only be a bonus.
