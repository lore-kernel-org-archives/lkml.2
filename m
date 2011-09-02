Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab1IBIHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 04:07:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757947Ab1IBIHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 04:07:14 -0400
Date: Fri, 2 Sep 2011 01:10:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.0.3 kernel BUG at kernel/timer.c:1035
Message-Id: <20110902011058.c5bad476.akpm@linux-foundation.org>
In-Reply-To: <20110824130238.GA24543@janus>
References: <20110824130238.GA24543@janus>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011 15:02:38 +0200 Frank van Maarseveen <frankvm@frankvm.com> wrote:

> Got several of these (logged via netconsole):
> 
>  kernel BUG at kernel/timer.c:1035!
>  invalid opcode: 0000 [#1]
>  PREEMPT
>  SMP
> 
> ...
>
>  Call Trace:
>   [<c107af48>] run_timer_softirq+0x148/0x1e0
>   [<c1069265>] ? rebalance_domains+0x135/0x160
>   [<c106a28b>] ? get_parent_ip+0xb/0x40
>   [<c106a28b>] ? get_parent_ip+0xb/0x40
>   [<c1075098>] __do_softirq+0x78/0x100
>   [<c1075020>] ? local_bh_enable+0xa0/0xa0
>   <IRQ>
> 
>   [<c10753ad>] ? irq_exit+0x5d/0x70
>   [<c104df53>] ? smp_apic_timer_interrupt+0x53/0x90
>   [<c178fa22>] ? apic_timer_interrupt+0x2a/0x30
>   [<c103d3ed>] ? mwait_idle+0x4d/0x80
>   [<c1034b0a>] ? cpu_idle+0x3a/0x80
>   [<c176dc3b>] ? rest_init+0x7b/0x80
>   [<c1b1471b>] ? start_kernel+0x2e2/0x2e8
>   [<c1b141c1>] ? loglevel+0x1a/0x1a
>   [<c1b140b3>] ? i386_start_kernel+0xb3/0xbb
> 
> 

Could be that a timer was freed while still running.

Please ensure that all kernel debugging options are enabled. 
Especially 

CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y

CONFIG_DEBUG_OBJECTS_TIMERS might catch this one.
