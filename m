Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab1KTXXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 18:23:52 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41262 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab1KTXXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 18:23:49 -0500
Date: Sun, 20 Nov 2011 15:23:42 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: Re: [PATCH 2/5] rcu: Fix macro substitution for
 synchronize_rcu_bh() on RT
Message-ID: <20111120232341.GC17982@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111119044510.811163517@goodmis.org>
 <20111119044831.614814511@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111119044831.614814511@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112023-9360-0000-0000-000000C7F9F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 11:45:12PM -0500, Steven Rostedt wrote:
> From: John Kacur <jkacur@redhat.com>
> 
> kernel/rcutorture.c:492: error: ‘synchronize_rcu_bh’ undeclared here (not in a function)
> 
> synchronize_rcu_bh() is not just called as a normal function, but can
> also be referenced as a function pointer. When CONFIG_PREEMPT_RT_FULL
> is enabled, synchronize_rcu_bh() is defined as synchronize_rcu(), but
> needs to be defined without the parenthesis because the compiler will
> complain when synchronize_rcu_bh is referenced as a function pointer
> and not a function.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
> Cc: stable-rt@vger.kernel.org
> Link: http://lkml.kernel.org/r/1321235083-21756-1-git-send-email-jkacur@redhat.com
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  include/linux/rcutree.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> index 7a25aea..3bf47dc 100644
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
> 1.7.7.1
> 
> 


