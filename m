Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab1CBBH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 20:07:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757586Ab1CBBH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 20:07:57 -0500
Date: Tue, 1 Mar 2011 17:07:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Youquan Song <youquan.song@linux.intel.com>
Cc: davej@redhat.com, arjan@linux.intel.com, venki@google.com,
        youquan.song@intel.com, cpufreq-list@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: Fix ondemand governor powersave_bias execution
 time misuse
Message-Id: <20110301170740.2b4a8288.akpm@linux-foundation.org>
In-Reply-To: <20101105151951.GA10743@linux-youquan.bj.intel.com>
References: <20101105151951.GA10743@linux-youquan.bj.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Nov 2010 11:19:51 -0400
Youquan Song <youquan.song@linux.intel.com> wrote:

> Ondemand governor use powersave_bias tunable to do aggressive power save by
> decrease CPU average frequency. The average frequency achieve by adjust low and
> high frequency's execution time proportion during one sample time interval.  
> 
> Current kernel, only the high frequency executes in time proportion, but the low
> frequency wrongly execute in one whole sample time interval when powersave_bias
> is set.  
> 
> The patch fix it by set low frequency execution time to it deserved. 
> 
> Signed-off-by: Youquan Song <youquan.song@intel.com>
> ---
> 
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index c631f27..01d84fa 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -666,6 +666,8 @@ static void do_dbs_timer(struct work_struct *work)
>  	} else {
>  		__cpufreq_driver_target(dbs_info->cur_policy,
>  			dbs_info->freq_lo, CPUFREQ_RELATION_H);
> +		if (dbs_info->sample_type == DBS_SUB_SAMPLE)
> +			delay = dbs_info->freq_lo_jiffies;
>  	}
>  	queue_delayed_work_on(cpu, kondemand_wq, &dbs_info->work, delay);
>  	mutex_unlock(&dbs_info->timer_mutex);

Where are we with this patch?  Still needed in curent mainline?

Thnks.
