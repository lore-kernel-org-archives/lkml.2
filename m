Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab1BRGwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 01:52:34 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:41476 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab1BRGwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 01:52:32 -0500
Date: Fri, 18 Feb 2011 12:22:24 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Nikhil Rao <ncrao@google.com>
Subject: Re: [CFS Bandwidth Control v4 3/7] sched: throttle cfs_rq entities
 which exceed their local quota
Message-ID: <20110218065224.GD2648@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110216031831.571628191@google.com>
 <20110216031841.068673650@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110216031841.068673650@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Turner <pjt@google.com> [2011-02-15 19:18:34]:

> In account_cfs_rq_quota() (via update_curr()) we track consumption versus a
> cfs_rq's local quota and whether there is global quota available to continue
> enabling it in the event we run out.
> 
> This patch adds the required support for the latter case, throttling entities
> until quota is available to run.  Throttling dequeues the entity in question
> and sends a reschedule to the owning cpu so that it can be evicted.
> 
> The following restrictions apply to a throttled cfs_rq:
> - It is dequeued from sched_entity hierarchy and restricted from being
>   re-enqueued.  This means that new/waking children of this entity will be
>   queued up to it, but not past it.
> - It does not contribute to weight calculations in tg_shares_up
> - In the case that the cfs_rq of the cpu we are trying to pull from is throttled
>   it is  is ignored by the loadbalancer in __load_balance_fair() and
>   move_one_task_fair().
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> Signed-off-by: Nikhil Rao <ncrao@google.com>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>


Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 
-- 
	Three Cheers,
	Balbir
