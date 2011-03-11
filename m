Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1CKPHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:07:45 -0500
Received: from mail4.comsite.net ([205.238.176.238]:28483 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1CKPHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:07:43 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
Subject: Re: [01/22] sched: Provide scheduler_ipi() callback in response to
 smp_send_reschedule()
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-Id: <sched-ipi-callback-comment@mdm.bga.com>
In-Reply-To: <20110302174120.313761743@chello.nl>
References: <20110302174120.313761743@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>
Date: Fri, 11 Mar 2011 09:07:13 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Mar 2011 17:38:32 -0000, To: Peter Zijlstra wrote:

> For future rework of try_to_wake_up() we'd like to push part of that
> onto the CPU the task is actually going to run on, in order to do so we
> need a generic callback from the existing scheduler IPI.
> 
> This patch introduces such a generic callback: scheduler_ipi() and
> implements it as a NOP.
> 
> BenH notes: PowerPC might use this IPI on offline CPUs under rare
> conditions!!
..
> Index: linux-2.6/arch/powerpc/kernel/smp.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/kernel/smp.c
> +++ linux-2.6/arch/powerpc/kernel/smp.c
> @@ -98,6 +98,7 @@ void smp_message_recv(int msg)
>  		break;
>  	case PPC_MSG_RESCHEDULE:
>  		/* we notice need_resched on exit */

This comment should also be removed, as it was documenting the empty action.

> +		scheduler_ipi();
>  		break;
>  	case PPC_MSG_CALL_FUNC_SINGLE:
>  		generic_smp_call_function_single_interrupt();
> @@ -127,7 +128,7 @@ static irqreturn_t call_function_action(
>  
>  static irqreturn_t reschedule_action(int irq, void *data)
>  {
> -	/* we just need the return path side effect of checking need_resched */
> +	scheduler_ipi();
>  	return IRQ_HANDLED;
>  }
>  

Thanks,
milton
