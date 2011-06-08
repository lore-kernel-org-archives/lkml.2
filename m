Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab1FHTlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:41:18 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41678 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab1FHTlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:41:17 -0400
Date: Wed, 8 Jun 2011 12:41:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 4/4] sched: Generalize sleep inside spinlock detection
Message-ID: <20110608194114.GG2324@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1307555315-30989-1-git-send-email-fweisbec@gmail.com>
 <1307555315-30989-5-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1307555315-30989-5-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 07:48:35PM +0200, Frederic Weisbecker wrote:
> The sleeping inside spinlock detection is actually used
> for more general sleeping inside atomic sections
> debugging: preemption disabled, rcu read side critical
> sections, interrupts, interrupt disabled, etc...
> 
> Change the name of the config and its help section to
> reflect its more general role.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  Documentation/DocBook/kernel-hacking.tmpl  |    2 +-
>  Documentation/SubmitChecklist              |    2 +-
>  Documentation/development-process/4.Coding |    2 +-
>  Documentation/ja_JP/SubmitChecklist        |    2 +-
>  Documentation/zh_CN/SubmitChecklist        |    2 +-
>  include/linux/kernel.h                     |    2 +-
>  kernel/sched.c                             |    2 +-
>  lib/Kconfig.debug                          |    8 +++++---
>  8 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/DocBook/kernel-hacking.tmpl b/Documentation/DocBook/kernel-hacking.tmpl
> index 7b3f493..07a9c48 100644
> --- a/Documentation/DocBook/kernel-hacking.tmpl
> +++ b/Documentation/DocBook/kernel-hacking.tmpl
> @@ -409,7 +409,7 @@ cond_resched(); /* Will sleep */
> 
>    <para>
>     You should always compile your kernel
> -   <symbol>CONFIG_DEBUG_SPINLOCK_SLEEP</symbol> on, and it will warn
> +   <symbol>CONFIG_DEBUG_ATOMIC_SLEEP</symbol> on, and it will warn
>     you if you break these rules.  If you <emphasis>do</emphasis> break
>     the rules, you will eventually lock up your box.
>    </para>
> diff --git a/Documentation/SubmitChecklist b/Documentation/SubmitChecklist
> index da0382d..7b13be4 100644
> --- a/Documentation/SubmitChecklist
> +++ b/Documentation/SubmitChecklist
> @@ -53,7 +53,7 @@ kernel patches.
> 
>  12: Has been tested with CONFIG_PREEMPT, CONFIG_DEBUG_PREEMPT,
>      CONFIG_DEBUG_SLAB, CONFIG_DEBUG_PAGEALLOC, CONFIG_DEBUG_MUTEXES,
> -    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_SPINLOCK_SLEEP all simultaneously
> +    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_ATOMIC_SLEEP all simultaneously
>      enabled.
> 
>  13: Has been build- and runtime tested with and without CONFIG_SMP and
> diff --git a/Documentation/development-process/4.Coding b/Documentation/development-process/4.Coding
> index f3f1a46..83f5f5b 100644
> --- a/Documentation/development-process/4.Coding
> +++ b/Documentation/development-process/4.Coding
> @@ -244,7 +244,7 @@ testing purposes.  In particular, you should turn on:
>   - DEBUG_SLAB can find a variety of memory allocation and use errors; it
>     should be used on most development kernels.
> 
> - - DEBUG_SPINLOCK, DEBUG_SPINLOCK_SLEEP, and DEBUG_MUTEXES will find a
> + - DEBUG_SPINLOCK, DEBUG_ATOMIC_SLEEP, and DEBUG_MUTEXES will find a
>     number of common locking errors.
> 
>  There are quite a few other debugging options, some of which will be
> diff --git a/Documentation/ja_JP/SubmitChecklist b/Documentation/ja_JP/SubmitChecklist
> index 2df4576..cb5507b 100644
> --- a/Documentation/ja_JP/SubmitChecklist
> +++ b/Documentation/ja_JP/SubmitChecklist
> @@ -68,7 +68,7 @@ Linux カーネルパッチ投稿者向けチェックリスト
> 
>  12: CONFIG_PREEMPT, CONFIG_DEBUG_PREEMPT, CONFIG_DEBUG_SLAB,
>      CONFIG_DEBUG_PAGEALLOC, CONFIG_DEBUG_MUTEXES, CONFIG_DEBUG_SPINLOCK,
> -    CONFIG_DEBUG_SPINLOCK_SLEEP これら全てを同時に有効にして動作確認を
> +    CONFIG_DEBUG_ATOMIC_SLEEP これら全てを同時に有効にして動作確認を
>      行ってください。
> 
>  13: CONFIG_SMP, CONFIG_PREEMPT を有効にした場合と無効にした場合の両方で
> diff --git a/Documentation/zh_CN/SubmitChecklist b/Documentation/zh_CN/SubmitChecklist
> index 951415b..4c741d6 100644
> --- a/Documentation/zh_CN/SubmitChecklist
> +++ b/Documentation/zh_CN/SubmitChecklist
> @@ -67,7 +67,7 @@ Linux
> 
>  12???Ѿ?ͨ??CONFIG_PREEMPT, CONFIG_DEBUG_PREEMPT,
>      CONFIG_DEBUG_SLAB, CONFIG_DEBUG_PAGEALLOC, CONFIG_DEBUG_MUTEXES,
> -    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_SPINLOCK_SLEEP???ԣ?????ͬʱ??
> +    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_ATOMIC_SLEEP???ԣ?????ͬʱ??
>      ʹ?ܡ?
> 
>  13???Ѿ???????????ʹ?û??߲?ʹ?? CONFIG_SMP ?? CONFIG_PREEMPT????ִ??ʱ?䡣
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index fb0e732..24b489f 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -121,7 +121,7 @@ extern int _cond_resched(void);
>  # define might_resched() do { } while (0)
>  #endif
> 
> -#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
> +#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
>    void __might_sleep(const char *file, int line, int preempt_offset);
>  /**
>   * might_sleep - annotation for functions that can sleep
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 90ad7cf..a5f318b 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8018,7 +8018,7 @@ void __init sched_init(void)
>  	scheduler_running = 1;
>  }
> 
> -#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
> +#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
>  static inline int preempt_count_equals(int preempt_offset)
>  {
>  	int nested = (preempt_count() & ~PREEMPT_ACTIVE) + rcu_preempt_depth();
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index a7dd7b5..81a4f33 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -648,13 +648,15 @@ config TRACE_IRQFLAGS
>  	  Enables hooks to interrupt enabling and disabling for
>  	  either tracing or lock debugging.
> 
> -config DEBUG_SPINLOCK_SLEEP
> -	bool "Spinlock debugging: sleep-inside-spinlock checking"
> +config DEBUG_ATOMIC_SLEEP
> +	bool "Sleep inside atomic section checking"
>  	select PREEMPT_COUNT
>  	depends on DEBUG_KERNEL
>  	help
>  	  If you say Y here, various routines which may sleep will become very
> -	  noisy if they are called with a spinlock held.
> +	  noisy if they are called inside atomic sections: when a spinlock is
> +	  held, inside an rcu read side critical section, inside preempt disabled
> +	  sections, inside an interrupt, etc...
> 
>  config DEBUG_LOCKING_API_SELFTESTS
>  	bool "Locking API boot-time self-tests"
> -- 
> 1.7.5.4
> 
