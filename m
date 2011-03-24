Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab1CXGbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 02:31:00 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:43580 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab1CXGa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 02:30:59 -0400
Date: Thu, 24 Mar 2011 12:01:26 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 02/15] sched: validate CFS quota hierarchies
Message-ID: <20110324063126.GA2721@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110323030326.789836913@google.com>
 <20110323030448.853861319@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323030448.853861319@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 08:03:28PM -0700, Paul Turner wrote:
> Add constraints validation for CFS bandwidth hierachies.
> 
> +static u64 normalize_cfs_quota(struct task_group *tg,
> +		               struct cfs_schedulable_data *d)
> +{
> +	u64 quota, period;
> +	struct load_weight lw;
> +
> +	if (tg == d->tg) {
> +		period = d->period;
> +		quota = d->quota;
> +	} else {
> +		period = tg_get_cfs_period(tg);
> +		quota = tg_get_cfs_quota(tg);
> +	}
> +
> +	if (quota == RUNTIME_INF)
> +		return RUNTIME_INF;
> +
> +	lw.weight = period;
> +	lw.inv_weight = 0;
> +
> +	return calc_delta_mine(quota, max_cfs_quota_period, &lw) - 1;

Time to rename calc_delta_mine to something more meaningful ?

Regards,
Bharata.
