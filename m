Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935146Ab1IOVgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 17:36:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52964 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935035Ab1IOVgn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 17:36:43 -0400
MIME-Version: 1.0
In-Reply-To: <1316105551-17505-2-git-send-email-marc.zyngier@arm.com>
References: <1316105551-17505-1-git-send-email-marc.zyngier@arm.com> <1316105551-17505-2-git-send-email-marc.zyngier@arm.com>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Thu, 15 Sep 2011 23:36:23 +0200
Message-ID: <CAHXqBFKOQNOePc00yuzfotrYP6wT0ue_CJfv7rKdC+gEkomunA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] genirq: add support for per-cpu dev_id interrupts
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/15 Marc Zyngier <marc.zyngier@arm.com>:
[...]
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index a103732..f9b7fa3 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -95,6 +95,7 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
>  * @flags:     flags (see IRQF_* above)
>  * @name:      name of the device
>  * @dev_id:    cookie to identify the device
> + * @percpu_dev_id:     cookie to identify the device
>  * @next:      pointer to the next irqaction for shared interrupts
>  * @irq:       interrupt number
>  * @dir:       pointer to the proc/irq/NN/name entry
> @@ -104,17 +105,20 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
>  * @thread_mask:       bitmask for keeping track of @thread activity
>  */
>  struct irqaction {
[...]
> +       void                    *dev_id;
> +#ifdef CONFIG_IRQ_PERCPU_DEVID
> +       void __percpu           *percpu_dev_id;
> +#endif

Those two can share the memory (in a anonymous union), if I read the
idea correctly.

Best Regards,
Michał Mirosław
