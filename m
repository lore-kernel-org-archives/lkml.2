Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab2HUOfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 10:35:09 -0400
Received: from plane.gmane.org ([80.91.229.3]:54876 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738Ab2HUOfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 10:35:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Michael Thalmeier <michael.thalmeier@hale.at>
Subject: Re: [PATCH RT 2/2] fix printk flush of messages
Date: Tue, 21 Aug 2012 14:30:18 +0000 (UTC)
Message-ID: <loom.20120821T161458-427@post.gmane.org>
References: <4FB44EF1.9050809@am.sony.com> <4FB44FD0.4090800@am.sony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 83.64.51.210 (Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20100101 Firefox/14.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Rowand <frank.rowand <at> am.sony.com> writes:

> 
> 
> Updates console-make-rt-friendly.patch
> 
> #ifdef CONFIG_PREEMPT_RT_FULL, printk() output is never flushed by
> printk() because:
> ...
> 
> On system boot some printk() output is flushed because register_console()
> and tty_open() call console_unlock().
> 
> This change also fixes the problem that was previously fixed by
> preempt-rt-allow-immediate-magic-sysrq-output-for-preempt_rt_full.patch
> 
> Signed-off-by: Frank Rowand <frank.rowand <at> am.sony.com>
> 
> ---
>  kernel/printk.c |    2 	1 +	1 -	0 !
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/kernel/printk.c
> ===================================================================
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -847,7 +847,7 @@ static int console_trylock_for_printk(un
>  	int retval = 0, wake = 0;
>  #ifdef CONFIG_PREEMPT_RT_FULL
>  	int lock = !early_boot_irqs_disabled && !irqs_disabled_flags(flags) &&
> -		!preempt_count();
> +		(preempt_count() <= 1);
>  #else
>  	int lock = 1;
>  #endif
> 
> 

I have seen that this patch is applied in the 3.4 stable rt series.
As we are using the 3.0 stable rt kernel I have tested this patch on this
kernel series (on a Freescale i.MX31 based board) and have not found any
problems so far.
Is there something I have missed why this patch has not found its way
in the 3.0 series ?

Thanks in advance,
Michael


