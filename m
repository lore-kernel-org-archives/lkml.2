Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab1FFDog (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 23:44:36 -0400
Received: from mail4.comsite.net ([205.238.176.238]:59085 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab1FFDoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 23:44:34 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
Subject: Re: [1/4] rcu: Detect uses of rcu read side in extended quiescent states
To: Frederic Weisbecker <fweisbec@gmail.com>
Message-Id: <rcu-splat-split-printk@mdm.bga.com>
In-Reply-To: <1307329858-14999-3-git-send-email-fweisbec@gmail.com>
References: <1307329858-14999-3-git-send-email-fweisbec@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 05 Jun 2011 22:44:33 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Jun 2011 about 03:10:55 -0000, Frederic Weisbecker wrote:
> @@ -3994,8 +3995,13 @@ void lockdep_rcu_dereference(const char *file, const int line)
>  	printk("\n===================================================\n");
>  	printk(  "[ INFO: suspicious rcu_dereference_check() usage. ]\n");
>  	printk(  "---------------------------------------------------\n");
> -	printk("%s:%d invoked rcu_dereference_check() without protection!\n",
> -			file, line);
> +	printk("%s:%d invoked rcu_dereference_check() ", file, line);
> +
> +	if (type == RCU_WARN_UNPROTECTED)
> +		printk("without protection!\n");
> +	else if (type == RCU_WARN_EXT_QS)
> +		printk("while in RCU extended quiescent state!\n");
> +
>  	printk("\nother info that might help us debug this:\n\n");
>  	printk("\nrcu_scheduler_active = %d, debug_locks = %d\n", rcu_scheduler_active, debug_locks);
>  	lockdep_print_held_locks(curr);

Can we keep the above in one printk?   That way the printing is
guaranteed to come out on one line.  Probably the easiest way would
be add char *why = "" then assign a string based on the current
conditions.  Do all of that before the first printk which gets the
a %s added.

Thanks,
milton
