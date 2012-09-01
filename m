Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2IAACx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 20:02:53 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45564 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab2IAACv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 20:02:51 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 17:02:43 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        m68k <linux-m68k@vger.kernel.org>, "3.2.x.." <stable@vger.kernel.org>
Subject: Re: [PATCH tip/core/rcu 21/26] m68k: Add missing RCU idle APIs on
 idle loop
Message-ID: <20120901000243.GS11771@jtriplet-mobl1>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346360743-3628-21-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346360743-3628-21-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 02:05:38PM -0700, Paul E. McKenney wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> In the old times, the whole idle task was considered
> as an RCU quiescent state. But as RCU became more and
> more successful overtime, some RCU read side critical
> section have been added even in the code of some
> architectures idle tasks, for tracing for example.
> 
> So nowadays, rcu_idle_enter() and rcu_idle_exit() must
> be called by the architecture to tell RCU about the part
> in the idle loop that doesn't make use of rcu read side
> critical sections, typically the part that puts the CPU
> in low power mode.
> 
> This is necessary for RCU to find the quiescent states in
> idle in order to complete grace periods.
> 
> Add this missing pair of calls in the m68k's idle loop.
> 
> Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: m68k <linux-m68k@lists.linux-m68k.org>
> Cc: 3.2.x.. <stable@vger.kernel.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  arch/m68k/kernel/process.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
> index c488e3c..ac2892e 100644
> --- a/arch/m68k/kernel/process.c
> +++ b/arch/m68k/kernel/process.c
> @@ -25,6 +25,7 @@
>  #include <linux/reboot.h>
>  #include <linux/init_task.h>
>  #include <linux/mqueue.h>
> +#include <linux/rcupdate.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/traps.h>
> @@ -75,8 +76,10 @@ void cpu_idle(void)
>  {
>  	/* endless idle loop with no priority at all */
>  	while (1) {
> +		rcu_idle_enter();
>  		while (!need_resched())
>  			idle();
> +		rcu_idle_exit();
>  		schedule_preempt_disabled();
>  	}
>  }
> -- 
> 1.7.8
> 
