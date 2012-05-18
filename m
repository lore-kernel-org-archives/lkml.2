Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab2ERQFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:05:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36495 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab2ERQFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:05:43 -0400
Message-ID: <1337357128.573.88.camel@twins>
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, pjt@google.com, cl@linux.com,
        bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Fri, 18 May 2012 18:05:28 +0200
In-Reply-To: <4FB66F5D.4020803@redhat.com>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
	  <4FB66756.2060302@redhat.com> <1337355341.573.68.camel@twins>
	 <4FB66F5D.4020803@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 11:48 -0400, Rik van Riel wrote:

> Whether we like it or not, managed runtimes are here,
> and people are using them in droves.
> 
> I believe that the kernel should be able to handle
> NUMA placement for such uses.

Possibly, but it would also help if runtimes grew the capability to
express such relations. That said..  I never said we shouldn't/couldn't
help them eventually.

> > I still have serious concerns about his approach; it very much assumes
> > there's a temporal page<->thread relation to exploit. This might not at
> > all be true for some programs (including JVM) that have hardly any data
> > separation and just point chase their way around the entire object set.
> 
> Neither his approach or your approach will be able to
> help these workloads. I do not see how that should be
> counted against Andrea's approach, though, since it
> does seem to be useful for sane workloads.

Well, if you have a sane workload you often already have strong data
separation in your application, so telling the kernel about it isn't too
much bother, right?

The thing is, I've been traumatized by too much exposure to the
auto-parallelization crazies. I've never seen auto parallelization worth
using, despite lots of presumably smart people wanting to make it
happen.

> > I very much believe in doing the simple thing first, and this is that,
> 
> Leave out your syscalls (which might not be useful for
> managed runtimes), and you actually have the simple
> thing :)

Right, but the virt people could actually trivially use those, and vnuma
doesn't have the scambling issue outlined earlier since the guest kernel
would also try to keep home-node affinity.

Avi already said patching kvm would be like 5 minutes work.

It also absolutely avoids the false sharing issue otherwise present with
per-cpu memory, since you explicitly tell it where it belongs.


