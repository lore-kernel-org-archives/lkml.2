Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab2CIPRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:17:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757049Ab2CIPRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:17:36 -0500
Date: Fri, 9 Mar 2012 16:06:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] genirq: Get rid of unnecessary IRQTF_DIED flag
Message-ID: <20120309150612.GA7353@redhat.com>
References: <20120309135958.GD2114@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309135958.GD2114@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Of course I can't ack this, but afaics the whole series looks fine.

Only one minor nit,

On 03/09, Alexander Gordeev wrote:
>
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -60,8 +60,8 @@ static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
>  	 * device interrupt, so no irq storm is lurking. If the
>  	 * RUNTHREAD bit is already set, nothing to do.
>  	 */
> -	if (test_bit(IRQTF_DIED, &action->thread_flags) ||
> -	    test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
> +	if (test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags) ||
> +	    (action->thread->flags & PF_EXITING))
>  		return;

perhaps it makes sense to check PF_EXITING first, we do not want
to set IRQTF_RUNTHREAD in this case. I think this doesn't really
matter (and the check is obviously racy anyway), just looks a bit
confusing.

Oleg.

