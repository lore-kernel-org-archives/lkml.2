Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab2EBLZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 07:25:06 -0400
Received: from ra.se.axis.com ([195.60.68.13]:51150 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791Ab2EBLZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 07:25:01 -0400
Date: Wed, 2 May 2012 13:24:58 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [patch 07/29] cris: Use generic init_task
Message-ID: <20120502112458.GB19174@axis.com>
References: <20120430194725.763322463@linutronix.de> <20120430194845.972721401@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120430194845.972721401@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 10:15:55PM +0200, Thomas Gleixner wrote:
> Same code. Use the generic version.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> ---
>  arch/cris/Kconfig          |    1 +
>  arch/cris/kernel/process.c |   28 ----------------------------
>  2 files changed, 1 insertion(+), 28 deletions(-)
> 
> Index: tip/arch/cris/Kconfig
> ===================================================================
> --- tip.orig/arch/cris/Kconfig
> +++ tip/arch/cris/Kconfig
> @@ -50,6 +50,7 @@ config CRIS
>  	select GENERIC_IRQ_SHOW
>  	select GENERIC_IOMAP
>  	select GENERIC_SMP_IDLE_THREAD if ETRAX_ARCH_V32
> +	select HAVE_GENERIC_INIT_TASK
>  
>  config HZ
>  	int
> Index: tip/arch/cris/kernel/process.c
> ===================================================================
> --- tip.orig/arch/cris/kernel/process.c
> +++ tip/arch/cris/kernel/process.c
> @@ -29,34 +29,6 @@
>  //#define DEBUG
>  
>  /*
> - * Initial task structure. Make this a per-architecture thing,
> - * because different architectures tend to have different
> - * alignment requirements and potentially different initial
> - * setup.
> - */
> -
> -static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
> -static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
> -/*
> - * Initial thread structure.
> - *
> - * We need to make sure that this is 8192-byte aligned due to the
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
> -
> -/*
>   * The hlt_counter, disable_hlt and enable_hlt is just here as a hook if
>   * there would ever be a halt sequence (for power save when idle) with
>   * some largish delay when halting or resuming *and* a driver that can't
> 

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
