Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab1KNQwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 11:52:32 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40981 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab1KNQwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 11:52:30 -0500
Date: Mon, 14 Nov 2011 08:51:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 2/2] Compile error with allmodconfig and
 CONFIG_PREEMPT_RT_FULL=y
Message-ID: <20111114165148.GB2372@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1321235083-21756-1-git-send-email-jkacur@redhat.com>
 <1321235083-21756-2-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321235083-21756-2-git-send-email-jkacur@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11111416-5806-0000-0000-00000484030D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 02:44:43AM +0100, John Kacur wrote:
> ERROR: "in_serving_softirq" [net/sched/cls_cgroup.ko] undefined!
> 
> The above can be fixed by exporting in_serving_softirq
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> 
> The above patch was originally for 3.0.9-rt25
> But I also needed to cherry-pick it for 3.2-rc1-rt1
> ---
>  kernel/softirq.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 3db1d6f..5452432 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -447,6 +447,7 @@ int in_serving_softirq(void)
>  	preempt_enable();
>  	return res;
>  }
> +EXPORT_SYMBOL(in_serving_softirq);

Why not EXPORT_SYMBOL_GPL?

With that change,

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Not yet ready for mainline, because mainline does not yet have
in_serving_softirq().  Therefore not queued for -rcu.

							Thanx, Paul

>  /*
>   * Called with bh and local interrupts disabled. For full RT cpu must
> -- 
> 1.7.2.3
> 

