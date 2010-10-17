Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0JQGYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 02:24:22 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49299 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab0JQGYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 02:24:21 -0400
Date: Sun, 17 Oct 2010 10:54:54 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: pjt@google.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC tg_shares_up improvements - v1 00/12] [RFC tg_shares_up -
 v1 00/12] Reducing cost of tg->shares distribution
Message-ID: <20101017052454.GA21273@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101016044349.830426011@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101016044349.830426011@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* pjt@google.com <pjt@google.com> [2010-10-15 21:43:49]:

> Hi all,
> 
> Peter previously posted a patchset that attempted to improve the problem of
> task_group share distribution.  This is something that has been a long-time
> pain point for group scheduling.  The existing algorithm considers
> distributions on a per-cpu-per-domain basis and carries a fairly high update
> overhead, especially on larger machines.
> 
> I was previously looking at improving this using Fenwick trees to allow a
> single sum without the exorbitant cost but then Peter's idea above was better :).
>
> The kernel is that by monitoring the average contribution to load on a
> per-cpu-per-taskgroup basis we can distribute the weight for which we are
> expected to consume.
> 
> This set extends the original posting with a focus on increased fairness and
> reduced convergence (to true average) time.  In particular the case of large
> over-commit in the case of a distributed wake-up is a concern which is now
> fairly well addressed.
> 
> Obviously everything's experimental but it should be stable/fair.
> 
> Some motivation:
> 
> 24 thread intel box, 150 active cgroups, multiple threads/group, load at ~90% (10 second sample):
> tip:
>      2.64%  [k] tg_shares_up <!>
>      0.15%  [k] __set_se_shares
> 
> patched:
>      0.02%  [k] update_cfs_load
>      0.01%  [k] update_cpu_load
>      0.00%  [k] update_cfs_shares
> 
> Some fairness coverage for the above at: http://rs5.risingnet.net/~pjt/patches/shares_data_v1.txt
>

The results do sound interesting, could I recommend that you try to
get 1000 cgroups or so, with half of them as active and half inactive.
I'd also suggest tracking system and user time at the cgroup level.

-- 
	Three Cheers,
	Balbir
