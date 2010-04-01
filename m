Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0DAVHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 17:07:25 -0400
Received: from www.tglx.de ([62.245.132.106]:47791 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab0DAVHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 17:07:22 -0400
Date: Thu, 1 Apr 2010 23:07:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] 2.6.33.1-rt11 - BUG?
In-Reply-To: <m2qe6bf505b1004011344hbf36fb5bt78b925ad75e64b19@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1004012306090.32352@localhost.localdomain>
References: <l2me6bf505b1004011042oce87e64fn94bef56c78a1b10d@mail.gmail.com>  <alpine.LFD.2.00.1004012015070.32352@localhost.localdomain>  <s2xe6bf505b1004011146l201605ccz92a2aa99af11a57a@mail.gmail.com>
 <m2qe6bf505b1004011344hbf36fb5bt78b925ad75e64b19@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, Xianghua Xiao wrote:

Can you please stop top posting ?

> Here is the new dmesg output:
> BUG: sleeping function called from invalid context at kernel/rtmutex.c:684
> pcnt: 1 0 in_atomic(): 1, irqs_disabled(): 1, pid: 5770, name: insmod
> Call Trace:
> [ce935dc0] [c00096cc] show_stack+0x6c/0x1a4 (unreliable)
> [ce935df0] [c001f928] __might_sleep+0x104/0x108
> [ce935e00] [c03cb414] rt_spin_lock+0xa0/0xa4
> [ce935e10] [c00a4098] kmem_cache_alloc+0x50/0x17c
> [ce935e40] [c0073570] irq_to_desc_alloc_node+0x104/0x5ec
> [ce935e60] [c00064e0] irq_setup_virq+0x30/0xa8
> [ce935e80] [c000665c] irq_create_mapping+0x104/0x168
> [ce935ea0] [d1f69bc4] dma_init+0x118/0x1f0 [ipc]
> [ce935ee0] [d1f75018] ipc_init+0x18/0x140 [ipc]
> [ce935ef0] [c00038e0] do_one_initcall+0x54/0x210
> [ce935f20] [c005e424] sys_init_module+0x120/0x240
> [ce935f40] [c00139d4] ret_from_syscall+0x0/0x38
> 
> I chased from ipc_init to irq_to_desc_alloc_node and found no
> interrupt-disabling.
> 
> By looking at irq_to_desc_alloc_node (kernel/irq/handler.c) it has
> raw_spin_lock_irqsave(), with this raw spinlock irqsave I'm not sure
> if it causes trouble at kmem_cache_alloc after rt11 is applied, still
> checking on that.

Can you please disabled CONFIG_SPARSE_IRQ ?

Thanks,

	tglx
