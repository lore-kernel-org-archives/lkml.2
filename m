Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab0HYFzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 01:55:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:56148 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751862Ab0HYFzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 01:55:52 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19g/M5oSAtgCI5yR/I63RqPLKsYBPhtqAe5So+4wK
	UfYISSTJsAJw/O
Subject: Re: 2.6.32 cgroup regression
From: Mike Galbraith <efault@gmx.de>
To: Josh Hunt <johunt@akamai.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <4C74274D.9060300@akamai.com>
References: <4C74274D.9060300@akamai.com>
Content-Type: text/plain
Date: Wed, 25 Aug 2010 07:56:01 +0200
Message-Id: <1282715761.20033.23.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 13:10 -0700, Josh Hunt wrote:
> This commit makes the ltp cpuctl latency test #2 hang indefinitely:
> 
> commit b5d9d734a53e0204aab0089079cbde2a1285a38f
> Author: Mike Galbraith <efault@gmx.de>
> Date:   Tue Sep 8 11:12:28 2009 +0200
> 
>     sched: Ensure that a child can't gain time over it's parent after fork()

Ouch.  Yeah, that commit is buggy, and never got fixed up in stable.
Reverting it will restore a slightly less buggy, but not very good
situation.  Getting the fork problems all fixed up took a while.
(quick fix vs revert didn't help your testcase)

> When I revert this commit the test progresses as it did in 2.6.31. I
> have seen this issue on 2.6.32 and 2.6.32.19. The hang goes away in
> 2.6.33 starting with this commit:
> 
> commit 88ec22d3edb72b261f8628226cd543589a6d5e1b
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Wed Dec 16 18:04:41 2009 +0100
> 
>     sched: Remove the cfs_rq dependency from set_task_cpu()

Excellent timing you have.  I have a tree of backports, but I wasn't
counting this commit as a must have, merely highly desirable.  This
testcase showed that it's a needed fix.
  
> Even though this appears to be resolved in 2.6.33, I am reporting it
> because 2.6.32 is the "long-term stable release".

Yeah, there are a _lot_ of fixes that should wander back to 32-stable.

> My test system is a single socket dual core amd -
> model name	: Dual Core AMD Opteron(tm) Processor 180
> with 4GB of RAM.
> Kernel config file attached.
> 
> The issue is easily reproducible for me by downloading and building ltp,
> then running
> testcases/kernel/controllers/cpuctl/run_cpuctl_latency_test.sh 2
> 
> Please let me know if you need any other information to help reproduce
> this issue.

No, the testcase works well.  Thanks.

	-Mike


