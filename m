Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab2DYRi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 13:38:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:45500 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756680Ab2DYRi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 13:38:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="136679140"
Subject: Re: load balancing regression since commit 367456c7
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Alex Shi <alex.shi@intel.com>,
        Ying <ying.huang@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1335365763.28150.267.camel@twins>
References: <1334106376.19157.89.camel@schen9-DESK>
	 <1334664553.28150.87.camel@twins>  <1334681054.3796.28.camel@schen9-DESK>
	 <1334930421.2463.60.camel@laptop>  <1334940042.3796.48.camel@schen9-DESK>
	 <1334940837.2463.70.camel@laptop>  <1334942012.3796.50.camel@schen9-DESK>
	 <1334943202.2463.71.camel@laptop>  <1335365763.28150.267.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Apr 2012 10:38:57 -0700
Message-ID: <1335375537.3796.55.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 16:56 +0200, Peter Zijlstra wrote:
> On Fri, 2012-04-20 at 19:33 +0200, Peter Zijlstra wrote:
> > 
> > OK, I'll go stare at the cgroup part then.. Thanks!
> > 
> Ok, I could reproduce when using cgroups, the below fixes it for me, can
> you confirm?
> 
> ---

Mmm... I got the following error when I try to compile the patch on latest kernel tip:

kernel/sched/fair.c:3263:3: error: implicit declaration of function ‘static_branch_LB_MIN’ [-Werror=implicit-function-declaration]
kernel/sched/fair.c:3263:46: error: ‘__SCHED_FEAT_LB_MIN’ undeclared (first use in this function)
kernel/sched/fair.c:3263:46: note: each undeclared identifier is reported only once for each function it appears in
cc1: some warnings being treated as errors
make[2]: *** [kernel/sched/fair.o] Error 1
make[1]: *** [kernel/sched] Error 2
make: *** [kernel] Error 2

Tim

