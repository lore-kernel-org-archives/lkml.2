Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab1C3MD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 08:03:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:51118 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681Ab1C3MDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 08:03:55 -0400
Date: Wed, 30 Mar 2011 14:03:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Simek <monstr@monstr.eu>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] microblaze: Fix level/edge irq sensibility
In-Reply-To: <1301484264-6220-1-git-send-email-monstr@monstr.eu>
Message-ID: <alpine.LFD.2.00.1103301403290.22418@localhost6.localdomain6>
References: <1301484264-6220-1-git-send-email-monstr@monstr.eu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Michal Simek wrote:

> Patches:
> "microblaze: Convert to new irq function names"
> sha (4adc192ec7d977c74c750320f289af9d61c1caca)
> and
> "microblaze: Use generic show_interrupts()"
> sha(9d61c18b25726306c9231428c17db42e3ff29ba7)
> 
> should also setup edge/level in irq_set_chip_and_handler_name
> name parameter.
> 
> Error log:
> ~ # cat /proc/interrupts
>            CPU0
>   2:          2  Xilinx INTC-Xilinx INTC  eth0
>   3:          2  Xilinx INTC-Xilinx INTC  eth0
>   4:        241  Xilinx INTC-Xilinx INTC  timer
>   6:        108  Xilinx INTC-Xilinx INTC  serial
> 
> Fixed:
> ~ # cat /proc/interrupts
>            CPU0
>   2:          2  Xilinx INTC-level     eth0
>   3:          2  Xilinx INTC-level     eth0
>   4:        238  Xilinx INTC-edge      timer
>   6:        108  Xilinx INTC-level     serial
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>

Should I pick that up for the urgent fixes ?
 
> ---
> 
> v2: Fix exchanged edge and level
> ---
>  arch/microblaze/kernel/intc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
> index 5ba7e16..c88f066 100644
> --- a/arch/microblaze/kernel/intc.c
> +++ b/arch/microblaze/kernel/intc.c
> @@ -158,11 +158,11 @@ void __init init_IRQ(void)
>  	for (i = 0; i < nr_irq; ++i) {
>  		if (intr_type & (0x00000001 << i)) {
>  			irq_set_chip_and_handler_name(i, &intc_dev,
> -				handle_edge_irq, intc_dev.name);
> +				handle_edge_irq, "edge");
>  			irq_clear_status_flags(i, IRQ_LEVEL);
>  		} else {
>  			irq_set_chip_and_handler_name(i, &intc_dev,
> -				handle_level_irq, intc_dev.name);
> +				handle_level_irq, "level");
>  			irq_set_status_flags(i, IRQ_LEVEL);
>  		}
>  	}
> -- 
> 1.5.5.6
> 
> 
