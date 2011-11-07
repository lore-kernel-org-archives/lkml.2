Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177Ab1KGRzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:55:53 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45625 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932732Ab1KGRzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:55:52 -0500
Date: Mon, 7 Nov 2011 09:55:23 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, eric.dumazet@gmail.com,
        shaohua.li@intel.com, ak@linux.intel.com, mhocko@suse.cz,
        alex.shi@intel.com, efault@gmx.de, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.1
Message-ID: <20111107175523.GK2332@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4EAA14A1.5060204@cn.fujitsu.com>
 <20111029182710.GG6160@linux.vnet.ibm.com>
 <4EAE57AF.1060706@cn.fujitsu.com>
 <20111031093256.GI6160@linux.vnet.ibm.com>
 <4EAF5B68.8090005@cn.fujitsu.com>
 <1320678902.18053.63.camel@twins>
 <CABPqkBTbWE6wVkg_sFnoVL0r4_yi6gCwCoUXzC97kxcxC47zYQ@mail.gmail.com>
 <1320683756.17809.28.camel@twins>
 <20111107165603.GD2332@linux.vnet.ibm.com>
 <1320685789.17809.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320685789.17809.30.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11110717-8974-0000-0000-0000018B39CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 06:09:49PM +0100, Peter Zijlstra wrote:
> On Mon, 2011-11-07 at 08:56 -0800, Paul E. McKenney wrote:
> > 
> > If this really is a false positive, what should be used to get rid of
> > the splats? 
> 
> 
> Probably something slightly less horrid than the below.. ;-)

Hmmm...  Could the "1" below be replaced by the task's reference count?
Probabilistic, but should eventually catch it.

							Thanx, Paul

> ---
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index d1a1bee..8f05201 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -229,7 +229,7 @@ static void perf_ctx_unlock(struct perf_cpu_context *cpuctx,
>  static inline struct perf_cgroup *
>  perf_cgroup_from_task(struct task_struct *task)
>  {
> -	return container_of(task_subsys_state(task, perf_subsys_id),
> +	return container_of(task_subsys_state_check(task, perf_subsys_id, 1),
>  			struct perf_cgroup, css);
>  }
>  
> 

