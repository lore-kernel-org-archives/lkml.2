Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab2D3WeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 18:34:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:33360 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756939Ab2D3WeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 18:34:14 -0400
Message-ID: <1335825246.20866.66.camel@pasglop>
Subject: Re: [patch 19/29] powerpc: Use generic init_task
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Date: Tue, 01 May 2012 08:34:06 +1000
In-Reply-To: <20120430194846.731265237@linutronix.de>
References: <20120430194725.763322463@linutronix.de>
	 <20120430194846.731265237@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-30 at 20:16 +0000, Thomas Gleixner wrote:
> plain text document attachment (powerpc-use-generic-init-task.patch)
> Same code. Use the generic version.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  arch/powerpc/Kconfig            |    1 +
>  arch/powerpc/kernel/Makefile    |    2 +-
>  arch/powerpc/kernel/init_task.c |   29 -----------------------------
>  3 files changed, 2 insertions(+), 30 deletions(-)
> 
> Index: tip/arch/powerpc/Kconfig
> ===================================================================
> --- tip.orig/arch/powerpc/Kconfig
> +++ tip/arch/powerpc/Kconfig
> @@ -145,6 +145,7 @@ config PPC
>  	select HAVE_ARCH_JUMP_LABEL
>  	select ARCH_HAVE_NMI_SAFE_CMPXCHG
>  	select GENERIC_SMP_IDLE_THREAD
> +	select HAVE_GENERIC_INIT_TASK
>  
>  config EARLY_PRINTK
>  	bool
> Index: tip/arch/powerpc/kernel/Makefile
> ===================================================================
> --- tip.orig/arch/powerpc/kernel/Makefile
> +++ tip/arch/powerpc/kernel/Makefile
> @@ -28,7 +28,7 @@ endif
>  
>  obj-y				:= cputable.o ptrace.o syscalls.o \
>  				   irq.o align.o signal_32.o pmc.o vdso.o \
> -				   init_task.o process.o systbl.o idle.o \
> +				   process.o systbl.o idle.o \
>  				   signal.o sysfs.o cacheinfo.o time.o \
>  				   prom.o traps.o setup-common.o \
>  				   udbg.o misc.o io.o dma.o \
> Index: tip/arch/powerpc/kernel/init_task.c
> ===================================================================
> --- tip.orig/arch/powerpc/kernel/init_task.c
> +++ /dev/null
> @@ -1,29 +0,0 @@
> -#include <linux/mm.h>
> -#include <linux/export.h>
> -#include <linux/sched.h>
> -#include <linux/init.h>
> -#include <linux/init_task.h>
> -#include <linux/fs.h>
> -#include <linux/mqueue.h>
> -#include <asm/uaccess.h>
> -
> -static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
> -static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
> -/*
> - * Initial thread structure.
> - *
> - * We need to make sure that this is 16384-byte aligned due to the
> - * way process stacks are handled. This is done by having a special
> - * "init_task" linker map entry..
> - */
> -union thread_union init_thread_union __init_task_data =
> -	{ INIT_THREAD_INFO(init_task) };
> -
> -/*
> - * Initial task structure.
> - *
> - * All other task structs will be allocated on slabs in fork.c
> - */
> -struct task_struct init_task = INIT_TASK(init_task);
> -
> -EXPORT_SYMBOL(init_task);
> 


