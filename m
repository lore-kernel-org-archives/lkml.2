Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab0FORlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 13:41:04 -0400
Received: from tex.lwn.net ([70.33.254.29]:49409 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758093Ab0FORlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 13:41:03 -0400
Date: Tue, 15 Jun 2010 11:40:58 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH 06/12] irq: implement irq_schedule_poll()
Message-ID: <20100615114058.32e58afd@bike.lwn.net>
In-Reply-To: <1276443098-20653-7-git-send-email-tj@kernel.org>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
	<1276443098-20653-7-git-send-email-tj@kernel.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jun 2010 17:31:32 +0200
Tejun Heo <tj@kernel.org> wrote:

> Implement and use irq_schedule_poll() to schedule desc->poll_timer
> instead of calling mod_timer directly.  irq_schedule_poll() is called
> with desc->lock held and schedules the timer iff necessary - ie. if
> the timer is offline or scheduled to expire later than requested.
> This will be used to share desc->poll_timer.

One quick question...

> diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
> index 0bce0e3..0b8fd0a 100644
> --- a/kernel/irq/spurious.c
> +++ b/kernel/irq/spurious.c
> @@ -23,6 +23,8 @@ enum {
>  
>  	/* IRQ polling common parameters */
>  	IRQ_POLL_INTV			= HZ / 100,	/* from the good ol' 100HZ tick */
> +
> +	IRQ_POLL_SLACK			= HZ / 1000,	/* 10% slack */
>  };

Why would IRQ_POLL_SLACK be anything other than zero for HZ < 1000?
It seems like you'd get no slack at all on most systems.  Am I missing
something?

Thanks,

jon
