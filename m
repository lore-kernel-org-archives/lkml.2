Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab1GVLGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 07:06:47 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:36361 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab1GVLGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 07:06:44 -0400
Date: Fri, 22 Jul 2011 16:36:27 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Jason Baron <jbaron@redhat.com>
Subject: Re: [patch 01/18] sched: (fixlet) dont update shares twice on on_rq
 parent
Message-ID: <20110722110627.GA20315@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20110721164325.231521704@google.com>
 <20110721184756.783631070@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110721184756.783631070@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Turner <pjt@google.com> [2011-07-21 09:43:26]:

> In dequeue_task_fair() we bail on dequeue when we encounter a parenting entity
> with additional weight.  However, we perform a double shares update on this
> entity as we continue the shares update traversal from this point, despite
> dequeue_entity() having already updated its queuing cfs_rq.
> Avoid this by starting from the parent when we resume.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> ---
>  kernel/sched_fair.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: tip/kernel/sched_fair.c
> ===================================================================
> --- tip.orig/kernel/sched_fair.c
> +++ tip/kernel/sched_fair.c
> @@ -1370,6 +1370,9 @@ static void dequeue_task_fair(struct rq 
>  			 */
>  			if (task_sleep && parent_entity(se))
>  				set_next_buddy(parent_entity(se));
> +
> +			/* avoid re-evaluating load for this entity */
> +			se = parent_entity(se);
>  			break;
>  		}
>  		flags |= DEQUEUE_SLEEP;
> 
this patch has been merged into tip

commit 9598c82dcacadc3b9daa8170613fd054c6124d30
Author: Paul Turner <pjt@google.com>
Date:   Wed Jul 6 22:30:37 2011 -0700

    sched: Don't update shares twice on on_rq parent

