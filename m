Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab2EUIky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:40:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33047 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840Ab2EUIkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:40:52 -0400
Date: Mon, 21 May 2012 10:40:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, pjt@google.com, cl@linux.com,
        riel@redhat.com, bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
Message-ID: <20120521084046.GB31407@gmail.com>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
 <alpine.DEB.2.00.1205191922250.24674@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205191922250.24674@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

> On Fri, 18 May 2012, tip-bot for Peter Zijlstra wrote:
> 
> > Commit-ID:  3a0fea961b98d1838f35dba51a639d40f4a5589f
> > Gitweb:     http://git.kernel.org/tip/3a0fea961b98d1838f35dba51a639d40f4a5589f
> > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > AuthorDate: Thu, 8 Mar 2012 17:56:08 +0100
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Fri, 18 May 2012 08:16:27 +0200
> > 
> > sched/numa: Introduce sys_numa_{t,m}bind()
> > 
> 
> This depends on 931ea9d1a6e0 ("rcu: Implement per-domain 
> single-threaded call_srcu() state machine") from core/rcu.

Indeed ...

I'll rebase it to a (by that time probably upstream) srcu commit 
after the merge window, once we have more fixes, have 
incorporated suggestions, etc. - but it's still essentially an 
RFC topic: [*]

Fundamentally, do people agree with the 'single home node' 
approach to begin with? We could turn it into a node mask,
but that complicates things.

For example if there's a hierarchy of nodes, low latency and 
high latency ones, then it might be valid to limit to a high 
level (high latency) node and not specify the lower level node - 
while the kernel would still know about the lower level nodes as 
well.

Managing locality in a non-trivial cache hierarchy is hard :-/

Thanks,

	Ingo

[*] I should probably move this to the tip:RFC/sched/numa 
    branch, to make it clear what the status of the branch is,
    from the commit notification emails.
