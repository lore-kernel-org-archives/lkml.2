Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab0EYHBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 03:01:08 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:44784 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab0EYHBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 03:01:06 -0400
Date: Tue, 25 May 2010 12:30:58 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Paul Turner <pjt@google.com>
Subject: Re: [RFC PATCH 0/4] Finer granularity and task/cgroup irq time
 accounting
Message-ID: <20100525070058.GM3519@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1274746282-21533-1-git-send-email-venki@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1274746282-21533-1-git-send-email-venki@google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Venkatesh Pallipadi <venki@google.com> [2010-05-24 17:11:18]:

> Currently, the softirq and hardirq time reporting is only done at the
> CPU level. There are usecases where reporting this time against task
> or task groups or cgroups will be useful for user/administrator
> in terms of resource planning and utilization charging. Also, as the
> accoounting is already done at the CPU level, reporting the same at
> the task level does not add any significant computational overhead
> other than task level storage (patch 1).
> 
> The softirq/hardirq statistics commonly done based on tick based sampling.
> Though some archs have CONFIG_VIRT_CPU_ACCOUNTING based fine granularity
> accounting. Having similar mechanism to get fine granularity accounting
> on x86 will be a major challenge, given the state of TSC reliability
> on various platforms and also the overhead it may add in common paths
> like syscall entry exit.
> 
> An alternative is to have a generic (sched_clock based) and configurable
> fine-granularity accounting of si and hi time which can be reported
> over the /proc/<pid>/stat API (patch 2).
> 
> Patch 3 and 4 are exporting this info at the cgroup level.
> 
> Does exposing this additional info to user makes sense? Any feedback on
> the way it is done in this patchset?
> 
> This precise irq time based on sched_clock() provides some potential
> opportunities to handle the softirq time charging in a more fair way.
> Specifically cases where an unrelated task is being penalized for
> irq load on that CPU.
> * With network Receive Flow Steering, for example; We can potentially
> do things like not charge receive softirq time to the process that is
> currently running and charge it instead to the actual consumer of
> the receive (in recvmsg, for example).
> * We can reduce the power of the CPU to account for softirq/hardirq
> load, in order to increase the scheduler fairness for tasks running on
> that CPU.

Could you also add to this section or the documentation, what
interfaces are exported or impacted.

> 
> Comments?
> 
> Thanks,
> Venki
> 

-- 
	Three Cheers,
	Balbir
