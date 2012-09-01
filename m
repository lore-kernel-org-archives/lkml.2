Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab2IAAFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 20:05:33 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48710 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab2IAAFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 20:05:32 -0400
X-Originating-IP: 217.70.178.142
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 17:05:25 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 26/26] ia64: Add missing RCU idle APIs on
 idle loop
Message-ID: <20120901000525.GX11771@jtriplet-mobl1>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346360743-3628-26-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346360743-3628-26-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 02:05:43PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> Traditionally, the entire idle task served as an RCU quiescent state.
> But when RCU read side critical sections started appearing within the
> idle loop, this traditional strategy became untenable.  The fix was to
> create new RCU APIs named rcu_idle_enter() and rcu_idle_exit(), which
> must be called by each architecture's idle loop so that RCU can tell
> when it is safe to ignore a given idle CPU.
> 
> Unfortunately, this fix was never applied to ia64, a shortcoming remedied
> by this commit.
> 
> Reported by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Tested by: Tony Luck <tony.luck@intel.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  arch/ia64/kernel/process.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
> index dd6fc14..3e316ec 100644
> --- a/arch/ia64/kernel/process.c
> +++ b/arch/ia64/kernel/process.c
> @@ -29,6 +29,7 @@
>  #include <linux/kdebug.h>
>  #include <linux/utsname.h>
>  #include <linux/tracehook.h>
> +#include <linux/rcupdate.h>
>  
>  #include <asm/cpu.h>
>  #include <asm/delay.h>
> @@ -279,6 +280,7 @@ cpu_idle (void)
>  
>  	/* endless idle loop with no priority at all */
>  	while (1) {
> +		rcu_idle_enter();
>  		if (can_do_pal_halt) {
>  			current_thread_info()->status &= ~TS_POLLING;
>  			/*
> @@ -309,6 +311,7 @@ cpu_idle (void)
>  			normal_xtp();
>  #endif
>  		}
> +		rcu_idle_exit();
>  		schedule_preempt_disabled();
>  		check_pgt_cache();
>  		if (cpu_is_offline(cpu))
> -- 
> 1.7.8
> 
