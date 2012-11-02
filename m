Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab2KBFJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 01:09:03 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36672 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab2KBFJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 01:09:00 -0400
Date: Fri, 2 Nov 2012 10:32:18 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anton Arapov <anton@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] uprobes/powerpc: Don't clear TIF_UPROBE in
 do_notify_resume()
Message-ID: <20121102050218.GD11125@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121028173900.GA14621@redhat.com>
 <20121028173925.GA14642@redhat.com>
 <20121029052707.GA3400@in.ibm.com>
 <20121029124325.GA31397@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121029124325.GA31397@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110204-5930-0000-0000-00000DB6BD01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH 1/4] uprobes/powerpc: Don't clear TIF_UPROBE in do_notify_resume()
> 
> Cleanup. No need to clear TIF_UPROBE, uprobe_notify_resume() does this.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>


Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  arch/powerpc/kernel/signal.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
> index a2dc757..3b99711 100644
> --- a/arch/powerpc/kernel/signal.c
> +++ b/arch/powerpc/kernel/signal.c
> @@ -158,10 +158,8 @@ static int do_signal(struct pt_regs *regs)
> 
>  void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
>  {
> -	if (thread_info_flags & _TIF_UPROBE) {
> -		clear_thread_flag(TIF_UPROBE);
> +	if (thread_info_flags & _TIF_UPROBE)
>  		uprobe_notify_resume(regs);
> -	}
> 
>  	if (thread_info_flags & _TIF_SIGPENDING)
>  		do_signal(regs);
> -- 
> 1.5.5.1
> 
> 

