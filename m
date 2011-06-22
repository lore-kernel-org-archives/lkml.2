Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1FVFnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 01:43:45 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:35724 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab1FVFno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 01:43:44 -0400
Date: Wed, 22 Jun 2011 11:13:40 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 04/16] sched: validate CFS quota hierarchies
Message-ID: <20110622054340.GA2985@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110621071649.862846205@google.com>
 <20110621071700.092877579@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621071700.092877579@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 12:16:53AM -0700, Paul Turner wrote:
> Add constraints validation for CFS bandwidth hierarchies.
> 
> Validate that:
>    max(child bandwidth) <= parent_bandwidth
> 
> In a quota limited hierarchy, an unconstrained entity
> (e.g. bandwidth==RUNTIME_INF) inherits the bandwidth of its parent.
> 
> This constraint is chosen over sum(child_bandwidth) as notion of over-commit is
> valuable within SCHED_OTHER.  Some basic code from the RT case is re-factored
> for reuse.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> 
> ---
>  kernel/sched.c |  109 ++++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 96 insertions(+), 13 deletions(-)
> 
> Index: tip/kernel/sched.c
> ===================================================================
> --- tip.orig/kernel/sched.c
> +++ tip/kernel/sched.c
> @@ -249,6 +249,7 @@ struct cfs_bandwidth {
>  	raw_spinlock_t lock;
>  	ktime_t period;
>  	u64 quota;
> +	s64 hierarchal_quota;

You mean hierarchical I suppose.

Regards,
Bharata.
