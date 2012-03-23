Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449Ab2CWS2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 14:28:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:46029 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab2CWS17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 14:27:59 -0400
Date: Fri, 23 Mar 2012 19:27:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        kernel-hardening@lists.openwall.com, spender@grsecurity.net
Subject: Re: [PATCH] futex: mark get_robust_list as deprecated
In-Reply-To: <20120323175855.GA23668@www.outflux.net>
Message-ID: <alpine.LFD.2.02.1203231926000.2542@ionos>
References: <20120323175855.GA23668@www.outflux.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2012, Kees Cook wrote:

> Notify get_robust_list users that the syscall is going away.

That want's an entry in Documentation/feature-removal-schedule.txt as
well.

That's on top of your previous one, right ?

Thanks,

	tglx
 
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  kernel/futex.c        |    2 ++
>  kernel/futex_compat.c |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 439440d..545d7a3 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2449,6 +2449,8 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
>  	if (!futex_cmpxchg_enabled)
>  		return -ENOSYS;
>  
> +	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
> +
>  	rcu_read_lock();
>  
>  	ret = -ESRCH;
> diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
> index a9642d5..83e368b 100644
> --- a/kernel/futex_compat.c
> +++ b/kernel/futex_compat.c
> @@ -142,6 +142,8 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
>  	if (!futex_cmpxchg_enabled)
>  		return -ENOSYS;
>  
> +	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
> +
>  	rcu_read_lock();
>  
>  	ret = -ESRCH;
> -- 
> 1.7.0.4
> 
> -- 
> Kees Cook
> ChromeOS Security
> 
