Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127Ab1FABmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 21:42:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64221 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568Ab1FABme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 21:42:34 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=HYZG5H_0JlQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=3CgcxbKXWgnqn1PN9W4A:9 a=wQ_yJXd3_1Ume50CMtsA:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] KERNEL: async: Fixed an include coding style issue
From: Steven Rostedt <rostedt@goodmis.org>
To: Paul McQuade <tungstentide@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <4DE596B4.7030904@gmail.com>
References: <4DE596B4.7030904@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 31 May 2011 21:42:32 -0400
Message-ID: <1306892552.10135.16.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I should have told you to Cc this change to Arjan (as I just did), as he
owns this file.

-- Steve


On Wed, 2011-06-01 at 02:32 +0100, Paul McQuade wrote:
> >From 2514174efe73e654c46e669ea2df5169a41d0130 Mon Sep 17 00:00:00 2001
> From: Paul McQuade <tungstentide@gmail.com>
> Date: Tue, 31 May 2011 20:51:55 +0100
> Subject: [PATCH] KERNEL: async: Fixed an include coding style issue
> 
> async:
> Added <linux/atomic.h>,<linux/ktime.h> and Removed <asm/atomic.h>.
> Added KERN_DEBUG to printk() functions.
> 
> Signed-off-by: Paul McQuade <tungstentide@gmail.com>
> ---
>  kernel/async.c        |   13 +++++++------
>  2 files changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/async.c b/kernel/async.c
> index cd9dbb9..91edc17 100644
> --- a/kernel/async.c
> +++ b/kernel/async.c
> @@ -49,12 +49,13 @@ asynchronous and synchronous parts of the kernel.
>  */
> 
>  #include <linux/async.h>
> +#include <linux/atomic.h>
> +#include <linux/ktime.h>
>  #include <linux/module.h>
>  #include <linux/wait.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/workqueue.h>
> -#include <asm/atomic.h>
> 
>  static async_cookie_t next_cookie = 1;
> 
> @@ -128,15 +129,15 @@ static void async_run_entry_fn(struct work_struct
> *work)
> 
>  	/* 2) run (and print duration) */
>  	if (initcall_debug && system_state == SYSTEM_BOOTING) {
> -		printk("calling  %lli_%pF @ %i\n", (long long)entry->cookie,
> -			entry->func, task_pid_nr(current));
> +		printk(KERN_DEBUG "calling  %lli_%pF @ %i\n",
> +			(long long)entry->cookie,
> +			entry->func, task_pid_nr(current));
>  		calltime = ktime_get();
>  	}
>  	entry->func(entry->data, entry->cookie);
>  	if (initcall_debug && system_state == SYSTEM_BOOTING) {
>  		rettime = ktime_get();
>  		delta = ktime_sub(rettime, calltime);
> -		printk("initcall %lli_%pF returned 0 after %lld usecs\n",
> +		printk(KERN_DEBUG "initcall %lli_%pF returned 0 after %lld usecs\n",
>  			(long long)entry->cookie,
>  			entry->func,
>  			(long long)ktime_to_ns(delta) >> 10);
> @@ -270,7 +271,7 @@ void async_synchronize_cookie_domain(async_cookie_t
> cookie,
>  	ktime_t starttime, delta, endtime;
> 
>  	if (initcall_debug && system_state == SYSTEM_BOOTING) {
> -		printk("async_waiting @ %i\n", task_pid_nr(current));
> +		printk(KERN_DEBUG "async_waiting @ %i\n", task_pid_nr(current));
>  		starttime = ktime_get();
>  	}
> 
> @@ -280,7 +281,7 @@ void async_synchronize_cookie_domain(async_cookie_t
> cookie,
>  		endtime = ktime_get();
>  		delta = ktime_sub(endtime, starttime);
> 
> -		printk("async_continuing @ %i after %lli usec\n",
> +		printk(KERN_DEBUG "async_continuing @ %i after %lli usec\n",
>  			task_pid_nr(current),
>  			(long long)ktime_to_ns(delta) >> 10);
>  	}


