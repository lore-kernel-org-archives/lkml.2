Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab2KTGlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 01:41:04 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33295 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2KTGlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 01:41:03 -0500
Message-ID: <50AB25D8.4030203@oracle.com>
Date: Tue, 20 Nov 2012 01:40:24 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121112 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
        penberg@kernel.org
Subject: Re: [PATCH] lockdep: be nice about building from userspace
References: <1352753446-24109-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1352753446-24109-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On 11/12/2012 03:50 PM, Sasha Levin wrote:
> Lockdep is an awesome piece of code which detects locking issues which are
> relevant both to userspace and kernelspace. We can easily make lockdep
> work in userspace since there is really no kernel spacific magic going
> on in the code.
> 
> All we need is to wrap two functions which are used by lockdep and are
> very kernel specific.
> 
> Doing that will allow tools located in tools/ to easily utilize lockdep's
> code for their own use.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  kernel/lockdep.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 7981e5b..e898cfe 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -584,6 +584,7 @@ static int very_verbose(struct lock_class *class)
>  /*
>   * Is this the address of a static object:
>   */
> +#ifdef __KERNEL__
>  static int static_obj(void *obj)
>  {
>  	unsigned long start = (unsigned long) &_stext,
> @@ -610,6 +611,7 @@ static int static_obj(void *obj)
>  	 */
>  	return is_module_address(addr) || is_module_percpu_address(addr);
>  }
> +#endif
>  
>  /*
>   * To make lock name printouts unique, we calculate a unique
> @@ -4109,6 +4111,7 @@ void debug_check_no_locks_held(struct task_struct *task)
>  		print_held_locks_bug(task);
>  }
>  
> +#ifdef __KERNEL__
>  void debug_show_all_locks(void)
>  {
>  	struct task_struct *g, *p;
> @@ -4166,6 +4169,7 @@ retry:
>  		read_unlock(&tasklist_lock);
>  }
>  EXPORT_SYMBOL_GPL(debug_show_all_locks);
> +#endif
>  
>  /*
>   * Careful: only use this function if you are sure that
> 

