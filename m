Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab0EMUxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:53:16 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50072 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758645Ab0EMUxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:53:15 -0400
Date: Thu, 13 May 2010 13:53:07 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, Arnd Bergmann <arnd@arndb.de>,
       Christopher Li <sparse@chrisli.org>
Subject: Re: [PATCH RFC tip/core/rcu 02/23] rcu: add __rcu API for later
 sparse checking
Message-ID: <20100513205307.GS31830@count0.beaverton.ibm.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com>
 <1273700022-16523-2-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273700022-16523-2-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 02:33:21PM -0700, Paul E. McKenney wrote:
> This commit defines an __rcu API, but provides only vacuous definitions
> for it.  This breaks dependencies among most of the subsequent patches,
> allowing them to reach mainline asynchronously via whatever trees are
> appropriate.

Seems like a good plan to me.

I know it's not the right time to push it but I am curious to see what,
approximately, you expect a non-vacuous __rcu definition to look like.
(i.e. when it's being run through sparse)

Cheers,
	-Matt Helsley

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Christopher Li <sparse@chrisli.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> ---
>  include/linux/compiler.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index a5a472b..c1a62c5 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -16,6 +16,7 @@
>  # define __release(x)	__context__(x,-1)
>  # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
>  # define __percpu	__attribute__((noderef, address_space(3)))
> +# define __rcu
>  extern void __chk_user_ptr(const volatile void __user *);
>  extern void __chk_io_ptr(const volatile void __iomem *);
>  #else
> @@ -34,6 +35,7 @@ extern void __chk_io_ptr(const volatile void __iomem *);
>  # define __release(x) (void)0
>  # define __cond_lock(x,c) (c)
>  # define __percpu
> +# define __rcu
>  #endif
> 
>  #ifdef __KERNEL__
> -- 
> 1.7.0.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
