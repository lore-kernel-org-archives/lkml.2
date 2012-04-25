Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2DYNAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:00:25 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:49245 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab2DYNAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:00:23 -0400
Message-ID: <4F97F530.8090005@linux.vnet.ibm.com>
Date: Wed, 25 Apr 2012 18:29:28 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "he, bo" <bo.he@intel.com>
CC: akpm@linux-foundation.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        rusty@rustcorp.com.au, william.douglas@intel.com,
        linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
        yanmin.zhang@intel.com
Subject: Re: [PATCH] sched: fix OOPS when build_sched_domains percpu allocation
 fails
References: <1335355161.5892.17.camel@hebo>
In-Reply-To: <1335355161.5892.17.camel@hebo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12042512-2000-0000-0000-0000073EABE5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 05:29 PM, he, bo wrote:

> From: "he, bo" <bo.he@intel.com>
> 
> Under extreme memory used up situation, percpu allocation
> might fails. We hit it when system go to suspend-to-ram.
> 
> EIP: [<c124411a>] build_sched_domains+0x23a/0xad0
> SS:ESP 0068:de725d04
> CR2: 0000000034811000
> ---[ end trace d6086359b670b975 ]---
> Kernel panic - not syncing: Fatal exception
> Pid: 3026, comm: kworker/u:3 Tainted: G      D W
> 3.0.8-137473-gf42fbef #1
> Call Trace:
>  [<c18cc4f2>] panic+0x66/0x16c
>  [<c12521a1>] ? oops_exit+0x61/0x90
>  [<c1205f89>] oops_end+0xb9/0xd0
>  [<c1227796>] no_context+0xc6/0x1f0
>  [<c1227958>] __bad_area_nosemaphore+0x98/0x140
>  [<c1204ebf>] ? dump_trace+0x7f/0xf0
>  [<c1227d30>] ? pgtable_bad+0x130/0x130
>  [<c1227a17>] bad_area_nosemaphore+0x17/0x20
>  [<c1227fa0>] do_page_fault+0x270/0x3c0
>  [<c1306afa>] ? pcpu_alloc+0x12ca/0x1300
>  [<c1227d30>] ? pgtable_bad+0x130/0x130
>  [<c1227d30>] ? pgtable_bad+0x130/0x130
>  [<c18d09d3>] error_code+0x5f/0x64
>  [<c13000d8>] ? shmem_setattr+0x198/0x230
>  [<c1227d30>] ? pgtable_bad+0x130/0x130
>  [<c124411a>] ? build_sched_domains+0x23a/0xad0
>  [<c18d01a6>] ? _raw_spin_unlock_irqrestore+0x26/0x50
>  [<c1244c37>] partition_sched_domains+0x287/0x4b0
>  [<c12a77be>] cpuset_update_active_cpus+0x1fe/0x210
>  [<c1673017>] ? __cpufreq_remove_dev+0x167/0x360
>  [<c18cf03c>] ? down_write+0x1c/0x40
>  [<c123712d>] cpuset_cpu_inactive+0x1d/0x30
>  [<c127dff2>] notifier_call_chain+0x52/0x90
>  [<c127e04e>] __raw_notifier_call_chain+0x1e/0x30
>  [<c18b37c9>] _cpu_down+0x89/0x230
>  [<c12547f9>] disable_nonboot_cpus+0x79/0x100
>  [<c1299fb3>] suspend_devices_and_enter+0x133/0x2e0
>  [<c129a27d>] enter_state+0x11d/0x180
>  [<c129a307>] pm_suspend+0x27/0x70
>  [<c129b8b6>] suspend+0x96/0x1d0
>  [<c1271aa3>] process_one_work+0x103/0x400
>  [<c129b820>] ? power_suspend_late+0x90/0x90
>  [<c12728ac>] worker_thread+0x12c/0x4b0
>  [<c123748d>] ? sub_preempt_count+0x3d/0x50
>  [<c18d01a6>] ? _raw_spin_unlock_irqrestore+0x26/0x50
>  [<c1272780>] ? manage_workers+0x520/0x520
>  [<c1276f44>] kthread+0x74/0x80
>  [<c1276ed0>] ? __init_kthread_worker+0x30/0x30
>  [<c18d113a>] kernel_thread_helper+0x6/0x10
> 
> Signed-off-by: he, bo <bo.he@intel.com>
> Reviewed-by: Zhang, Yanmin <yanmin.zhang@intel.com>


Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>


Regards,
Srivatsa S. Bhat

