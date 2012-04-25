Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab2DYR6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 13:58:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:46634 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756717Ab2DYR6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 13:58:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="133735705"
Subject: Re: load balancing regression since commit 367456c7
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Alex Shi <alex.shi@intel.com>,
        Ying <ying.huang@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1335375798.28150.271.camel@twins>
References: <1334106376.19157.89.camel@schen9-DESK>
	 <1334664553.28150.87.camel@twins>  <1334681054.3796.28.camel@schen9-DESK>
	 <1334930421.2463.60.camel@laptop>  <1334940042.3796.48.camel@schen9-DESK>
	 <1334940837.2463.70.camel@laptop>  <1334942012.3796.50.camel@schen9-DESK>
	 <1334943202.2463.71.camel@laptop>  <1335365763.28150.267.camel@twins>
	 <1335375537.3796.55.camel@schen9-DESK>  <1335375798.28150.271.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Apr 2012 10:58:46 -0700
Message-ID: <1335376726.3796.58.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 19:43 +0200, Peter Zijlstra wrote:
> Gargh.. lost the change to kernel/sched/features.h, now included.
> 
> Sorry for that.
> 
> ---
> Subject: sched: Fix more load-balance fallout
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue Apr 17 13:38:40 CEST 2012
> 
> Commits 367456c756a6 ("sched: Ditch per cgroup task lists for
> load-balancing") and 5d6523ebd ("sched: Fix load-balance wreckage")
> left some more wreckage.
> 
> By setting loop_max unconditionally to ->nr_running load-balancing
> could take a lot of time on very long runqueues (hackbench!). So keep
> the sysctl as max limit of the amount of tasks we'll iterate.
> 
> Furthermore, the min load filter for migration completely fails with
> cgroups since inequality in per-cpu state can easily lead to such
> small loads :/
> 
> Furthermore the change to add new tasks to the tail of the queue
> instead of the head seems to have some effect.. not quite sure I
> understand why.
> 
> Combined these fixes solve the huge hackbench regression reported by
> Tim when hackbench is ran in a cgroup.
> 
> Reported-by: Tim Chen <tim.c.chen@linux.intel.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/r/1335365763.28150.267.camel@twins

The patch fixed the regression for me.  

Acked-by: Tim Chen <tim.c.chen@linux.intel.com>


