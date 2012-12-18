Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab2LRHzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:55:53 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:52943 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab2LRHzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:55:51 -0500
X-Greylist: delayed 1279 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 02:55:51 EST
Date: Mon, 17 Dec 2012 23:55:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Hillf Danton <dhillf@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: numa: Fix build error if CONFIG_NUMA_BALANCING
 && !CONFIG_TRANSPARENT_HUGEPAGE
In-Reply-To: <20121217140553.GG9887@suse.de>
Message-ID: <alpine.DEB.2.00.1212172353590.29320@chino.kir.corp.google.com>
References: <20121212100338.GS1009@suse.de> <CA+55aFzedbhcuo-WObUjigrXGuG2VGLqDOvh_HFA9Cn_BRkwjQ@mail.gmail.com> <20121217140553.GG9887@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-394423814-1355817350=:29320"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-394423814-1355817350=:29320
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT

On Mon, 17 Dec 2012, Mel Gorman wrote:

> Michal Hocko reported that the following build error occurs if
> CONFIG_NUMA_BALANCING is set without THP support
> 
> kernel/sched/fair.c: In function â??task_numa_workâ??:
> kernel/sched/fair.c:932:55: error: call to â??__build_bug_failedâ?? declared with attribute error: BUILD_BUG failed
> 
> The problem is that HPAGE_PMD_SHIFT triggers a BUILD_BUG() on
> !CONFIG_TRANSPARENT_HUGEPAGE. This patch addresses the problem.
> 
> Reported-by: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: David Rientjes <rientjes@google.com>

Fixes the build issue for me, thanks.
--531381512-394423814-1355817350=:29320--
