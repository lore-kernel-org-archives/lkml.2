Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab1CXMjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 08:39:09 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:41236 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab1CXMjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 08:39:06 -0400
Date: Thu, 24 Mar 2011 18:08:58 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Pavel Emelyanov <xemul@openvz.org>, Nikhil Rao <ncrao@google.com>
Subject: Re: [patch 01/15] sched: introduce primitives to account for CFS
	bandwidth tracking
Message-ID: <20110324123858.GA27829@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20110323030326.789836913@google.com> <20110323030448.756701159@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110323030448.756701159@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Turner <pjt@google.com> [2011-03-22 20:03:27]:

> In this patch we introduce the notion of CFS bandwidth, partitioned into 
> globally unassigned bandwidth, and locally claimed bandwidth.
> 
> - The global bandwidth is per task_group, it represents a pool of unclaimed
>   bandwidth that cfs_rqs can allocate from.  
> - The local bandwidth is tracked per-cfs_rq, this represents allotments from
>   the global pool bandwidth assigned to a specific cpu.
> 
> Bandwidth is managed via cgroupfs, adding two new interfaces to the cpu subsystem:
> - cpu.cfs_period_us : the bandwidth period in usecs
> - cpu.cfs_quota_us : the cpu bandwidth (in usecs) that this tg will be allowed
>   to consume over period above.
> 
> A per-cfs_bandwidth timer is also introduced to handle future refresh at
> period expiration.  There's some minor refactoring here so that
> start_bandwidth_timer() functionality can be shared
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> Signed-off-by: Nikhil Rao <ncrao@google.com>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---
<snip>

defconfig build on powerpc, with patchset applied on 4bbba111d94 fails

kernel/sched.c: In function 'tg_cfs_bandwidth':
kernel/sched.c:408: error: dereferencing pointer to incomplete type
make[1]: *** [kernel/sched.o] Error 1

CONFIG_CGROUPS=y
CONFIG_CGROUP_SCHED=n
CONFIG_EXPERIMENTAL=y
CONFIG_FAIR_GROUP_SCHED=n
CONFIG_CFS_BANDWIDTH=n

 thanks,
 Kamalesh
