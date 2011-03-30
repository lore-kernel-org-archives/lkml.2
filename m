Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab1C3LVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 07:21:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43094 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab1C3LVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 07:21:41 -0400
Message-ID: <4D931241.3010803@monstr.eu>
Date: Wed, 30 Mar 2011 13:21:37 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: Fix level/edge irq sensibility
References: <1301483979-3175-1-git-send-email-monstr@monstr.eu>
In-Reply-To: <1301483979-3175-1-git-send-email-monstr@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek wrote:
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
>   2:          2  Xilinx INTC-edge      eth0
>   3:          2  Xilinx INTC-edge      eth0
>   4:        241  Xilinx INTC-level     timer
>   6:        108  Xilinx INTC-edge      serial
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  arch/microblaze/kernel/intc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
> index 5ba7e16..71efa51 100644
> --- a/arch/microblaze/kernel/intc.c
> +++ b/arch/microblaze/kernel/intc.c
> @@ -158,11 +158,11 @@ void __init init_IRQ(void)
>  	for (i = 0; i < nr_irq; ++i) {
>  		if (intr_type & (0x00000001 << i)) {
>  			irq_set_chip_and_handler_name(i, &intc_dev,
> -				handle_edge_irq, intc_dev.name);
> +				handle_edge_irq, "level");
>  			irq_clear_status_flags(i, IRQ_LEVEL);
>  		} else {
>  			irq_set_chip_and_handler_name(i, &intc_dev,
> -				handle_level_irq, intc_dev.name);
> +				handle_level_irq, "edge");

oou - vice-versa - this is level and above is edge.
Will send v2

M



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
