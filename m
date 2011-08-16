Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab1HPTfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:35:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:39529 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab1HPTfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:35:06 -0400
Subject: Re: [PATCH] powerpc/eeh: remove eeh_event_handler()->daemonize()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>,
        Linas Vepstas <linasvepstas@gmail.com>,
        Matt Fleming <matt@console-pimps.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110816190858.GA4890@redhat.com>
References: <20110816190858.GA4890@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Aug 2011 14:17:15 -0500
Message-ID: <1313522235.3664.70.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-16 at 21:08 +0200, Oleg Nesterov wrote:
> daemonize() is only needed when a user-space task does kernel_thread().
> 
> eeh_event_handler() thread is created by the worker kthread, and thus
> it doesn't need the soon-to-be-deprecated daemonize().
> 
> Note: looks like eeh_event_wq can be static and it can do all work
> itself without kernel_thread().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---

Right, but don't bother cleaning that code too much tho :-) I'm quite
close to reworking/refactoring most of it anyways.

Cheers,
Ben.

>  arch/powerpc/platforms/pseries/eeh_event.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- 3.1/arch/powerpc/platforms/pseries/eeh_event.c~3_daemonize_eeh	2011-04-06 21:33:42.000000000 +0200
> +++ 3.1/arch/powerpc/platforms/pseries/eeh_event.c	2011-08-16 21:03:56.000000000 +0200
> @@ -60,7 +60,7 @@ static int eeh_event_handler(void * dumm
>  	struct eeh_event	*event;
>  	struct pci_dn *pdn;
>  
> -	daemonize ("eehd");
> +	set_task_comm(current, "eehd");
>  	set_current_state(TASK_INTERRUPTIBLE);
>  
>  	spin_lock_irqsave(&eeh_eventlist_lock, flags);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


