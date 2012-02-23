Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab2BWNTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 08:19:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab2BWNTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 08:19:45 -0500
Date: Thu, 23 Feb 2012 14:19:43 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Oleg Nesterov <onestero@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] genirq: Mark IRQ thread handlers with irq_thread flag
Message-ID: <20120223131942.GC1978@dhcp-26-207.brq.redhat.com>
References: <20120220173156.GE9313@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120220173156.GE9313@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Олег,

Ты совершенно прав. Эта проверка -- кривая. Мне лучше отправить self-nack на
этот конкретный патч или заслать всю серию без этого патча заново?

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
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index a94466d..d02d4f6 100644

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
