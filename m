Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab0C2EoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 00:44:12 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55698 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab0C2EoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 00:44:10 -0400
Date: Sun, 28 Mar 2010 21:44:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: remove needless struct notifier_block
 predeclaration
Message-ID: <20100329044405.GC2343@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BB01182.2090301@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB01182.2090301@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 10:33:38AM +0800, Lai Jiangshan wrote:
> 
> cleanup: remove needless struct notifier_block predeclaration 

Good catch!

These forward declarations used to be essential.  ;-)

If they have been made available on purpose, I am all for applying
this patch.  But if their appearance is accidental, perhaps to
disappear again in the next release, I would keep the forward
declarations.

Could you please check?

						Thanx, Paul

> diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
> index a519587..ae7b05e 100644
> --- a/include/linux/rcutiny.h
> +++ b/include/linux/rcutiny.h
> @@ -86,8 +86,6 @@ static inline void synchronize_rcu_bh_expedited(void)
>  	synchronize_sched();
>  }
> 
> -struct notifier_block;
> -
>  #ifdef CONFIG_NO_HZ
> 
>  extern void rcu_enter_nohz(void);
> diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> index 42cc3a0..3be62e1 100644
> --- a/include/linux/rcutree.h
> +++ b/include/linux/rcutree.h
> @@ -30,8 +30,6 @@
>  #ifndef __LINUX_RCUTREE_H
>  #define __LINUX_RCUTREE_H
> 
> -struct notifier_block;
> -
>  extern void rcu_sched_qs(int cpu);
>  extern void rcu_bh_qs(int cpu);
>  extern int rcu_needs_cpu(int cpu);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
