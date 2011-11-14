Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab1KNRE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 12:04:27 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47826 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366Ab1KNRE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 12:04:26 -0500
Date: Mon, 14 Nov 2011 08:50:39 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 1/2] v3.2-rc1-52e4c2a05-rt1 fix for compile break
Message-ID: <20111114165039.GA2372@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1321235083-21756-1-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1321235083-21756-1-git-send-email-jkacur@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11111416-8974-0000-0000-000002003898
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 02:44:42AM +0100, John Kacur wrote:
> kernel/rcutorture.c:492: error: ‘synchronize_rcu_bh’ undeclared here (not in a function)
> 
> In CONFIG_PREEMPT_RT_FULL
> doesn't cover function pointer assignment unless we remove the brackets.
> 
> Compile-tested.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

I have not yet queued this because mainline does not yet fold RCU and
RCU-bh together.

							Thanx, Paul

> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  include/linux/rcutree.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> index 800b840..6e503a3 100644
> --- a/include/linux/rcutree.h
> +++ b/include/linux/rcutree.h
> @@ -60,7 +60,7 @@ static inline void exit_rcu(void)
>  #ifndef CONFIG_PREEMPT_RT_FULL
>  extern void synchronize_rcu_bh(void);
>  #else
> -# define synchronize_rcu_bh()	synchronize_rcu()
> +# define synchronize_rcu_bh	synchronize_rcu
>  #endif
>  extern void synchronize_sched_expedited(void);
>  extern void synchronize_rcu_expedited(void);
> -- 
> 1.7.2.3
> 

