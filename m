Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab2BWRIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:08:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab2BWRIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:08:00 -0500
Date: Thu, 23 Feb 2012 18:07:49 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] genirq: Mark IRQ thread handlers with irq_thread flag
Message-ID: <20120223170748.GD1978@dhcp-26-207.brq.redhat.com>
References: <20120220173156.GE9313@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220173156.GE9313@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas!

Self-NAK on this patch. This hunk is reported wrong..

> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -896,7 +896,7 @@ void do_exit(long code)
>  
>  	WARN_ON(blk_needs_flush_plug(tsk));
>  
> -	if (unlikely(in_interrupt()))
> +	if (unlikely(!tsk->irq_thread && in_interrupt()))
>  		panic("Aiee, killing interrupt handler!");
>  	if (unlikely(!tsk->pid))
>  		panic("Attempted to kill the idle task!");

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
