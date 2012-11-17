Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab2KQSKd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 13:10:33 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:59487 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab2KQSKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 13:10:32 -0500
Message-ID: <50A7D2F0.1050901@linux.vnet.ibm.com>
Date: Sat, 17 Nov 2012 23:39:52 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, pjt@google.com,
        vincent.guittot@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/5] sched: consider runnable load average in wake_affine
 and move_tasks
References: <1353157457-3649-1-git-send-email-alex.shi@intel.com> <1353157457-3649-5-git-send-email-alex.shi@intel.com>
In-Reply-To: <1353157457-3649-5-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12111718-6102-0000-0000-00000295A3D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On 11/17/2012 06:34 PM, Alex Shi wrote:
> Except using runnable load average in background, wake_affine and
> move_tasks is also the key functions in load balance. We need consider
> the runnable load average in them in order to the apple to apple load
> comparison in load balance.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)
> 
> @@ -4229,7 +4233,7 @@ static int move_tasks(struct lb_env *env)
>  		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
>  			goto next;
> 
> -		load = task_h_load(p);
> +		load = task_h_load(p) * p->se.avg.load_avg_contrib;
Shouldn't the above be just load = p->se.avg.load_avg_contrib? This
metric already has considered p->se.load.weight.task_h_load(p) returns
the same.
> 
>  		if (sched_feat(LB_MIN) && load < 16 && !env->failed)
>  			goto next;
> 
Regards
Preeti U Murthy

