Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab2ITO0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:26:18 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50282 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687Ab2ITO0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:26:08 -0400
Date: Thu, 20 Sep 2012 19:36:34 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] uprobes: Move clear_thread_flag(TIF_UPROBE) to
 uprobe_notify_resume()
Message-ID: <20120920140634.GE27880@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120914171513.GA29599@redhat.com>
 <20120914171603.GA29652@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120914171603.GA29652@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12092014-7182-0000-0000-000002AA4D38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-14 19:16:03]:

> Move clear_thread_flag(TIF_UPROBE) from do_notify_resume() to
> uprobe_notify_resume() for !CONFIG_UPROBES case.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  arch/x86/kernel/signal.c |    4 +---
>  kernel/events/uprobes.c  |    2 ++
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index b280908..0041e5a 100644
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -785,10 +785,8 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
>  		mce_notify_process();
>  #endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
> 
> -	if (thread_info_flags & _TIF_UPROBE) {
> -		clear_thread_flag(TIF_UPROBE);
> +	if (thread_info_flags & _TIF_UPROBE)
>  		uprobe_notify_resume(regs);
> -	}
> 
>  	/* deal with pending signal delivery */
>  	if (thread_info_flags & _TIF_SIGPENDING)
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 4ea0f0b..14c2e99 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1558,6 +1558,8 @@ void uprobe_notify_resume(struct pt_regs *regs)
>  {
>  	struct uprobe_task *utask;
> 
> +	clear_thread_flag(TIF_UPROBE);
> +
>  	utask = current->utask;
>  	if (utask && utask->active_uprobe)
>  		handle_singlestep(utask, regs);
> -- 
> 1.5.5.1
> 

