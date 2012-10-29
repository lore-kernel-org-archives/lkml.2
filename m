Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab2J2F1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 01:27:15 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42791 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab2J2F1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 01:27:14 -0400
Date: Mon, 29 Oct 2012 10:57:07 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] uprobes/powerpc: Don't clear TIF_UPROBE in
	do_notify_resume()
Message-ID: <20121029052707.GA3400@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20121028173900.GA14621@redhat.com> <20121028173925.GA14642@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121028173925.GA14642@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102905-8974-0000-0000-0000104194FC
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00186576; UDB=6.00042264; UTC=2012-10-29
 05:27:12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 06:39:25PM +0100, Oleg Nesterov wrote:

Hi Oleg,

> Cleanup. No need to clear TIF_UPROBE, do_notify_resume() does this.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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

But this _is_ do_notify_resume()... I don't see this flag cleared
anywhere else.

Did you have something else in mind?

Ananth

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

