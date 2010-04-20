Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab0DTOfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 10:35:01 -0400
Received: from mail.openrapids.net ([64.15.138.104]:35291 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754836Ab0DTOe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:34:59 -0400
Date: Tue, 20 Apr 2010 10:34:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Greg KH <greg@kroah.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       stable <stable@kernel.org>
Subject: Re: [stable] [PATCH] modules fix incorrect percpu usage
Message-ID: <20100420143457.GB14622@Krystal>
References: <20100330033211.GC7683@Krystal> <20100330033617.GE7683@Krystal> <1269955201.19685.5867.camel@gandalf.stny.rr.com> <20100330135047.GB20673@Krystal> <20100419182822.GH32347@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419182822.GH32347@kroah.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:34:04 up 87 days, 17:11,  7 users,  load average: 0.02, 0.05,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (greg@kroah.com) wrote:
> On Tue, Mar 30, 2010 at 09:50:47AM -0400, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > On Mon, 2010-03-29 at 23:36 -0400, Mathieu Desnoyers wrote:
> > > > * Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> > > > > Should use per_cpu_ptr() to obfuscate the per cpu pointers (RELOC_HIDE is needed
> > > > > for per cpu pointers).
> > > > > 
> > > > > Introduced by commit:
> > > > > 
> > > > > module.c: commit 6b588c18f8dacfa6d7957c33c5ff832096e752d3
> > > > > 
> > > > > This patch should be queued for the stable branch, for kernels 2.6.29.x to
> > > > > 2.6.33.x.
> > > > > (tested on 2.6.33.1 x86_64)
> > > > 
> > > > It's actually needed for mainline too (2.6.34-rc2).
> > > 
> > > Then all you need to do is submit it for mainline with a 
> > > "Cc: stable@kernel.org" as you did below. It will then automatically be
> > > added to the stable queue when Linus pulls it.
> > 
> > OK, thanks for the info.
> 
> And I need to wait until it goes into Linus's tree before it can be
> applied to the stable tree.  This hasn't happened yet, right?
> 
> thanks,
> 
> greg k-h

Same here, for module.c fix. Feel free to choose between this fix or the
corresponding refactoring from Tejun.


modules fix incorrect percpu usage

Should use per_cpu_ptr() to obfuscate the per cpu pointers (RELOC_HIDE is needed
for per cpu pointers).

Introduced by commit:

module.c: commit 6b588c18f8dacfa6d7957c33c5ff832096e752d3

This patch should be queued for the stable branch, for kernels 2.6.29.x to
2.6.33.x.  (tested on 2.6.33.1 x86_64)

Mainline does not need this fix, as commit
259354deaaf03d49a02dbb9975d6ec2a54675672 fixed the problem by refactoring.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>
CC: Eric Dumazet <dada1@cosmosbay.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: stable <stable@kernel.org>
---
 kernel/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux.trees.git/kernel/module.c
===================================================================
--- linux.trees.git.orig/kernel/module.c	2010-03-27 11:27:23.000000000 -0400
+++ linux.trees.git/kernel/module.c	2010-03-30 09:48:41.000000000 -0400
@@ -405,7 +405,7 @@ static void percpu_modcopy(void *pcpudes
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		memcpy(pcpudest + per_cpu_offset(cpu), from, size);
+		memcpy(per_cpu_ptr(pcpudest, cpu), from, size);
 }
 
 #else /* ... !CONFIG_SMP */


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
