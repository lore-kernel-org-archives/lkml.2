Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab0DFHVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 03:21:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59414 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376Ab0DFHU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 03:20:59 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] sched: Fix sched_getaffinity
Cc: kosaki.motohiro@jp.fujitsu.com, Sharyathi Nagesh <sharyath@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Russ Anderson <rja@sgi.com>,
       Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100406070218.GM5594@kryten>
References: <20100406070218.GM5594@kryten>
Message-Id: <20100406161723.7E51.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  6 Apr 2010 16:20:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> taskset on 2.6.34-rc3 fails on one of my ppc64 test boxes with the following
> error:
> 
> sched_getaffinity(0, 16, 0x10029650030) = -1 EINVAL (Invalid argument)
> 
> This box has 128 threads and 16 bytes is enough to cover it. Commit
> cd3d8031eb4311e516329aee03c79a08333141f1 (sched: sched_getaffinity(): Allow
> less than NR_CPUS length) is comparing this 16 bytes agains nr_cpu_ids.
> 
> Fix it by comparing nr_cpu_ids to the number of bits in the cpumask we pass in.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Oops, yes yes, thanks to correct my moron ;-) 
I'll stop all todays job and will get sleeping soon.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> ---
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 49d2fa7..0c1ec87 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4902,7 +4902,7 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
>  	int ret;
>  	cpumask_var_t mask;
>  
> -	if (len < nr_cpu_ids)
> +	if ((len * BITS_PER_BYTE) < nr_cpu_ids)
>  		return -EINVAL;
>  	if (len & (sizeof(unsigned long)-1))
>  		return -EINVAL;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



