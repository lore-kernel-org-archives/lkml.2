Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030607Ab2HHRRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:17:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030474Ab2HHRRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:17:31 -0400
Date: Wed, 8 Aug 2012 19:17:14 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@kernel.org, riel@redhat.com, oleg@redhat.com, pjt@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, Lee.Schermerhorn@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/19] sched-numa rewrite
Message-ID: <20120808171714.GM10459@redhat.com>
References: <20120731191204.540691987@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731191204.540691987@chello.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On Tue, Jul 31, 2012 at 09:12:04PM +0200, Peter Zijlstra wrote:
> Hi all,
> 
> After having had a talk with Rik about all this NUMA nonsense where he proposed
> the scheme implemented in the next to last patch, I came up with a related
> means of doing the home-node selection.
> 
> I've also switched to (ab)using PROT_NONE for driving the migration faults.

I'm glad we agree on the introduction of the numa hinting page faults.

I run a benchmark to compare your sched-numa rewrite with autonuma22:

http://www.kernel.org/pub/linux/kernel/people/andrea/autonuma/autonuma-vs-sched-numa-rewrite-20120808.pdf

> These patches go on top of tip/master with origin/master (Linus' tree) merged in.

It applied clean (with git am) on top of 3.6-rc1
(0d7614f09c1ebdbaa1599a5aba7593f147bf96ee) which already had a pull of
sched-core from tip and other tip bits. If that's not ok let me know
which commit I should use, and I'll repeat.

I released autonuma22 yesterday to provide an exact commit
(f958aa119a8ec417571ea8bdb527182d8ebe8b68) in case somebody wants to
reproduce the numbers on 2 node systems.

The autonuma-benchmark used to run the benchmark was at commit
65d93e485f09e3c1005e8c55cb5b1f97bd3a9ed8 which matches tag 0.1:

git clone git://gitorious.org/autonuma-benchmark/autonuma-benchmark.git

I'll update the pdf shortly by adding 8 node results too.

Thanks,
Andrea
