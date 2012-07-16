Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab2GPWRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 18:17:12 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41596 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab2GPWQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 18:16:58 -0400
Date: Mon, 16 Jul 2012 15:15:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 00/11] rcu: Userspace RCU extended quiescent state v2
Message-ID: <20120716221556.GH2403@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1342031200-22731-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342031200-22731-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071622-7282-0000-0000-00000AFA4568
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 08:26:29PM +0200, Frederic Weisbecker wrote:
> Hi,
> 
> There are significant changes this time. I reverted back to using
> a TIF flag to hook on syscalls slow path and put the hooks on
> high level exception handlers instead of low level ones.
> 
> It makes the code more portable between x86-32 and x86-64, it
> makes the hooks clearer and easier to review and the overhead
> is lowered in the off-case. This can be even better if we use
> jump labels later.

Thank you, Frederic, I have queued these:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/idle

I had to rework patch 4 a bit to take into account that I dropped the
rcu_switch_from() patch, please check it to make sure that I didn't
rework it out of existence.

							Thanx, Paul

> Thanks.
> 
> git://github.com/fweisbec/linux-dynticks.git
> 	rcu/user-2
> 
> Frederic Weisbecker (11):
>   rcu: Settle config for userspace extended quiescent state
>   rcu: Allow rcu_user_enter()/exit() to nest
>   rcu: Ignore userspace extended quiescent state by default
>   rcu: Switch task's syscall hooks on context switch
>   x86: Syscall hooks for userspace RCU extended QS
>   x86: Exception hooks for userspace RCU extended QS
>   rcu: Exit RCU extended QS on kernel preemption after irq/exception
>   rcu: Exit RCU extended QS on user preemption
>   x86: Use the new schedule_user API on userspace preemption
>   x86: Exit RCU extended QS on notify resume
>   rcu: Userspace RCU extended QS selftest
> 
>  arch/Kconfig                       |   10 ++++++
>  arch/um/drivers/mconsole_kern.c    |    2 +-
>  arch/x86/Kconfig                   |    1 +
>  arch/x86/include/asm/rcu.h         |   20 +++++++++++
>  arch/x86/include/asm/thread_info.h |   10 ++++--
>  arch/x86/kernel/entry_64.S         |    8 ++--
>  arch/x86/kernel/ptrace.c           |    5 +++
>  arch/x86/kernel/signal.c           |    4 ++
>  arch/x86/kernel/traps.c            |   30 ++++++++++++----
>  arch/x86/mm/fault.c                |   13 ++++++-
>  include/linux/rcupdate.h           |   10 ++++++
>  include/linux/sched.h              |   20 ++++++-----
>  init/Kconfig                       |   18 ++++++++++
>  kernel/rcutree.c                   |   64 +++++++++++++++++++++++++++++++-----
>  kernel/rcutree.h                   |    4 ++
>  kernel/sched/core.c                |   10 +++++-
>  16 files changed, 192 insertions(+), 37 deletions(-)
>  create mode 100644 arch/x86/include/asm/rcu.h
> 
> -- 
> 1.7.5.4
> 

