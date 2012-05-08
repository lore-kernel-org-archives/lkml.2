Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab2EHJhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:37:42 -0400
Received: from mail.southpole.se ([193.12.106.18]:52297 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2EHJhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:37:40 -0400
Message-ID: <1336469873.22631.18.camel@crucifix>
Subject: Re: [patch V2 19/31] openrisc: Use generic init_task
From: Jonas Bonn <jonas@southpole.se>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 08 May 2012 11:37:53 +0200
In-Reply-To: <20120503085035.083343435@linutronix.de>
References: <20120503083859.991965503@linutronix.de>
	 <20120503085035.083343435@linutronix.de>
Organization: South Pole AB
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu5 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 69857-04365
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Looks good; nice cleanup and everything still works!  Sorry for the
delay in responding.

Acked-by: Jonas Bonn <jonas@southpole.se>

/Jonas

On Thu, 2012-05-03 at 09:02 +0000, Thomas Gleixner wrote:
> plain text document attachment (openrisc-use-generic-init-task.patch)
> Same code. Use the generic version. The special Makefile treatment is
> pointless anyway as init_task.o contains only data which is handled by
> the linker script. So no point on being treated like head text.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jonas Bonn <jonas@southpole.se>
> ---
>  arch/openrisc/Kconfig            |    1 
>  arch/openrisc/Makefile           |    2 -
>  arch/openrisc/kernel/Makefile    |    2 -
>  arch/openrisc/kernel/init_task.c |   42 ---------------------------------------
>  4 files changed, 3 insertions(+), 44 deletions(-)
> 
> Index: tip/arch/openrisc/Kconfig
> ===================================================================
> --- tip.orig/arch/openrisc/Kconfig
> +++ tip/arch/openrisc/Kconfig
> @@ -17,6 +17,7 @@ config OPENRISC
>  	select GENERIC_IOMAP
>  	select GENERIC_CPU_DEVICES
>  	select GENERIC_ATOMIC64
> +	select HAVE_GENERIC_INIT_TASK
>  
>  config MMU
>  	def_bool y
> Index: tip/arch/openrisc/Makefile
> ===================================================================
> --- tip.orig/arch/openrisc/Makefile
> +++ tip/arch/openrisc/Makefile
> @@ -38,7 +38,7 @@ else
>  	KBUILD_CFLAGS += $(call cc-option,-msoft-div)
>  endif
>  
> -head-y 		:= arch/openrisc/kernel/head.o arch/openrisc/kernel/init_task.o
> +head-y 		:= arch/openrisc/kernel/head.o
>  
>  core-y		+= arch/openrisc/lib/ \
>  		   arch/openrisc/kernel/ \
> Index: tip/arch/openrisc/kernel/Makefile
> ===================================================================
> --- tip.orig/arch/openrisc/kernel/Makefile
> +++ tip/arch/openrisc/kernel/Makefile
> @@ -2,7 +2,7 @@
>  # Makefile for the linux kernel.
>  #
>  
> -extra-y	:= head.o vmlinux.lds init_task.o
> +extra-y	:= head.o vmlinux.lds
>  
>  obj-y	:= setup.o idle.o or32_ksyms.o process.o dma.o \
>  	   traps.o time.o irq.o entry.o ptrace.o signal.o sys_or32.o \
> Index: tip/arch/openrisc/kernel/init_task.c
> ===================================================================
> --- tip.orig/arch/openrisc/kernel/init_task.c
> +++ /dev/null
> @@ -1,42 +0,0 @@
> -/*
> - * OpenRISC init_task.c
> - *
> - * Linux architectural port borrowing liberally from similar works of
> - * others.  All original copyrights apply as per the original source
> - * declaration.
> - *
> - * Modifications for the OpenRISC architecture:
> - * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
> - * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
> - *
> - *      This program is free software; you can redistribute it and/or
> - *      modify it under the terms of the GNU General Public License
> - *      as published by the Free Software Foundation; either version
> - *      2 of the License, or (at your option) any later version.
> - */
> -
> -#include <linux/init_task.h>
> -#include <linux/mqueue.h>
> -#include <linux/export.h>
> -
> -static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
> -static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
> -
> -/*
> - * Initial thread structure.
> - *
> - * We need to make sure that this is THREAD_SIZE aligned due to the
> - * way process stacks are handled. This is done by having a special
> - * "init_task" linker map entry..
> - */
> -union thread_union init_thread_union __init_task_data = {
> -	INIT_THREAD_INFO(init_task)
> -};
> -
> -/*
> - * Initial task structure.
> - *
> - * All other task structs will be allocated on slabs in fork.c
> - */
> -struct task_struct init_task = INIT_TASK(init_task);
> -EXPORT_SYMBOL(init_task);
> 
> 


