Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab2KSOIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 09:08:24 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:53404 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab2KSOIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 09:08:24 -0500
Date: Mon, 19 Nov 2012 14:12:24 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, serge@hallyn.com, akpm@linux-foundation.org
Subject: Re: [PATCH] pidns: remove the useless function is_container_init
Message-ID: <20121119141224.GA4321@mail.hallyn.com>
References: <1353321882-30491-1-git-send-email-gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353321882-30491-1-git-send-email-gaofeng@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Gao feng (gaofeng@cn.fujitsu.com):
> since commit 1cdcbec1a3372c0c49c59d292e708fd07b509f18,
> is_container_init has no used for a long time.
> 
> just remove it.

Only thing is it's being exported, so I think it needs to go through
deprecation.

> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> ---
>  include/linux/sched.h |    6 ------
>  kernel/pid.c          |   15 ---------------
>  2 files changed, 0 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 0dd42a0..3fadd26 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1710,12 +1710,6 @@ static inline int is_global_init(struct task_struct *tsk)
>  	return tsk->pid == 1;
>  }
>  
> -/*
> - * is_container_init:
> - * check whether in the task is init in its own pid namespace.
> - */
> -extern int is_container_init(struct task_struct *tsk);
> -
>  extern struct pid *cad_pid;
>  
>  extern void free_task(struct task_struct *tsk);
> diff --git a/kernel/pid.c b/kernel/pid.c
> index aebd4f5..8ccdf0e 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -81,21 +81,6 @@ struct pid_namespace init_pid_ns = {
>  };
>  EXPORT_SYMBOL_GPL(init_pid_ns);
>  
> -int is_container_init(struct task_struct *tsk)
> -{
> -	int ret = 0;
> -	struct pid *pid;
> -
> -	rcu_read_lock();
> -	pid = task_pid(tsk);
> -	if (pid != NULL && pid->numbers[pid->level].nr == 1)
> -		ret = 1;
> -	rcu_read_unlock();
> -
> -	return ret;
> -}
> -EXPORT_SYMBOL(is_container_init);
> -
>  /*
>   * Note: disable interrupts while the pidmap_lock is held as an
>   * interrupt might come in and do read_lock(&tasklist_lock).
> -- 
> 1.7.7.6
