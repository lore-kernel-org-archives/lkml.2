Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab0C3UYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:24:25 -0400
Received: from mail.openrapids.net ([64.15.138.104]:57152 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752822Ab0C3UYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:24:24 -0400
Date: Tue, 30 Mar 2010 16:24:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>, stable <stable@kernel.org>
Subject: Re: [PATCH] modules fix incorrect percpu usage
Message-ID: <20100330202421.GA28800@Krystal>
References: <20100330135208.GC20673@Krystal> <20100330125304.53f079db.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100330125304.53f079db.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:08:42 up 66 days, 22:45,  5 users,  load average: 0.15, 0.08,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Tue, 30 Mar 2010 09:52:08 -0400
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > Should use per_cpu_ptr() to obfuscate the per cpu pointers (RELOC_HIDE is needed
> > for per cpu pointers).
> > 
> > Introduced by commit:
> > 
> > module.c: commit 6b588c18f8dacfa6d7957c33c5ff832096e752d3
> > 
> > It applies to mainline as of 2.6.34-rc2. This patch should be queued for the
> > stable branch, for kernels 2.6.29.x to 2.6.33.x.
> > (based on 2.6.33.1, also applies to 2.6.34-rc2 -tip)
> 
> Why do you beleive this should be backported to -stable?  What are the
> user-visible effects of this change?
> 

As for the user-visible impact of this specific patch, I guess nobody noticed
any problem because we've been lucky enough that the compiler did not generate
the inappropriate optimization pattern there.

This inappropriate use of per_cpu_ptr() elsewhere (in __module_ref_addr() from
module.h) caused a NULL pointer exception on Randy's machine.

So either we consider that the code is better left untouched, or we apply this
patch to module.c in order to prevent compiler optimizations from subtly
breaking the generated assembly with specific configurations of the current or
future versions of the compiler. At that level, it becomes a policy question
about what should go in -stable, for which I will defer to Greg and you. I would
perfectly understand if you consider that it does not belong to -stable, because
there is no perceived user impact so far.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
