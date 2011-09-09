Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab1IINZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 09:25:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:49206 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559Ab1IINY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 09:24:57 -0400
Date: Fri, 9 Sep 2011 15:24:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Kuo <rkuo@codeaurora.org>
cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linas Vepstas <linas@codeaurora.org>
Subject: Re: [patch v3 21/36] Hexagon: Add SMP support
In-Reply-To: <20110909010916.709728186@codeaurora.org>
Message-ID: <alpine.LFD.2.02.1109091517420.2723@ionos>
References: <20110909010847.294039464@codeaurora.org> <20110909010916.709728186@codeaurora.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Sep 2011, Richard Kuo wrote:

> +	/*  Set the memory struct  */
> +	atomic_inc(&init_mm.mm_count);
> +	current->active_mm = &init_mm;
> +
> +	cpu = smp_processor_id();
> +
> +	setup_irq(BASE_IPI_IRQ + cpu, &ipi_intdesc);
> +
> +	/*  Register the clock_event dummy  */
> +	setup_percpu_clockdev();
> +
> +	printk(KERN_INFO "%s cpu %d\n", __func__, current_thread_info()->cpu);
> +
> +	local_irq_enable();
> +	set_cpu_online(cpu, true);

This wants to be:

     	set_cpu_online(cpu, true);
        while (!cpumask_test_cpu(cpu, cpu_active_mask))
                cpu_relax();
	local_irq_enable();

See x86/kernel/smpboot.c and 
http://lists.arm.linux.org.uk/lurker/message/20110908.215756.a2ffbe5f.en.html

Thanks,

	tglx
