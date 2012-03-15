Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031700Ab2COQ0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:26:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35592 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031664Ab2COQ0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:26:53 -0400
Subject: Re: [PATCH 6/7] module: add two missing synchronize_sched()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Dennis1.Chen@amd.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1331822941-19938-6-git-send-email-xiyou.wangcong@gmail.com>
References: <1331822941-19938-1-git-send-email-xiyou.wangcong@gmail.com>
	 <1331822941-19938-6-git-send-email-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 09:26:49 -0700
Message-ID: <1331828809.4874.15.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 22:49 +0800, Cong Wang wrote:
> In RCU doc, it said synchronize_sched() is used to mark the end
> of update, so two synchronize_sched() are missing after
> module list add/del.
> 
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  kernel/module.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 06e7dc5..2e7a5c5 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1775,6 +1775,7 @@ static void free_module(struct module *mod)
>  	mutex_lock(&module_mutex);
>  	stop_machine(__unlink_module, mod, NULL);
>  	mutex_unlock(&module_mutex);
> +	synchronize_sched();
>  	mod_sysfs_teardown(mod);
>  
>  	/* Remove dynamic debug info */
> @@ -2928,6 +2929,7 @@ static struct module *load_module(void __user *umod,
>  	module_bug_finalize(info.hdr, info.sechdrs, mod);
>  	list_add_rcu(&mod->list, &modules);
>  	mutex_unlock(&module_mutex);
> +	synchronize_sched();
>  
>  	/* Module is ready to execute: parsing args may do that. */
>  	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp, NULL);

Have a look at stop_machine() first

after list_add_rcu(), there is absolutely no such requirement.



