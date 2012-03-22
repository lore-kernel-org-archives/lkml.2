Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab2CVOPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 10:15:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:41094 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab2CVOPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 10:15:42 -0400
Date: Thu, 22 Mar 2012 15:15:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Gordeev <agordeev@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] genirq: Get rid of unneeded force parameter in
 irq_finalize_oneshot()
In-Reply-To: <20120322110606.GD17233@dhcp-26-207.brq.redhat.com>
Message-ID: <alpine.LFD.2.02.1203221514290.2542@ionos>
References: <20120319145848.GG2147@dhcp-26-207.brq.redhat.com> <alpine.LFD.2.02.1203221128260.2542@ionos> <20120322110606.GD17233@dhcp-26-207.brq.redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2012, Alexander Gordeev wrote:

> On Thu, Mar 22, 2012 at 11:32:26AM +0100, Thomas Gleixner wrote:
> > Wrong.
> > 
> > CPU 0				CPU 1
> > 
> >     do_exit()
> > 				check(PF_EXITING)
> > 				set_bit(IRQTF_RUNTHREAD)
> > 				...
> >     set(PF_EXITING)
> >     exit_irq_thread()
> 
> Thomas,
> 
> Did not you pick this code with 7140ea1 commit?
> 
> @@ -845,6 +842,13 @@ void exit_irq_thread(void)
>  
>  	desc = irq_to_desc(action->irq);
>  
> +	/*
> +	 * If IRQTF_RUNTHREAD is set, we need to decrement
> +	 * desc->threads_active and wake possible waiters.
> +	 */
> +	if (test_and_clear_bit(IRQTF_RUNTHREAD, &action->thread_flags))
> +		wake_threads_waitq(desc);
> +

Gah crap. Was looking on the wrong branch. That's what you get for
looking at patches before coffee hit brain.

Thanks,

	tglx
