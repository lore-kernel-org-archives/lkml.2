Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1HEIUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 04:20:24 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:38250 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1HEIUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 04:20:20 -0400
Date: Fri, 5 Aug 2011 16:20:08 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <mgalbraith@suse.de>,
        Luis Claudio =?utf-8?B?Ui4gR29u77+9YWx2ZXM=?= 
	<lgoncalv@redhat.com>,
        Matthew Hank Sabins <msabins@linux.vnet.ibm.com>,
        Gregory Haskins <gregory.haskins@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] sched/cpupri: Remove the vec->lock
Message-ID: <20110805082008.GA6628@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1312317372.18583.101.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1312317372.18583.101.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 04:36:12PM -0400, Steven Rostedt wrote:
> diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
> index 9fc7d38..6b4cd17 100644
> --- a/kernel/sched_cpupri.h
> +++ b/kernel/sched_cpupri.h
> @@ -12,9 +12,8 @@
>  /* values 2-101 are RT priorities 0-99 */
>  
>  struct cpupri_vec {
> -	raw_spinlock_t lock;
> -	int        count;
> -	cpumask_var_t mask;
> +	atomic_t	count;
> +	cpumask_var_t	mask;
>  };
>  
>  struct cpupri {

So cpupri->pri_active and macro CPUPRI_NR_PRI_WORDS is not needed any more?

Thanks,
Yong

-- 
Only stand for myself
