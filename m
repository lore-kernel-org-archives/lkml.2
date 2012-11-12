Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab2KLUIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 15:08:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:48813 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab2KLUIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 15:08:10 -0500
Date: Mon, 12 Nov 2012 21:08:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC PATCH v1 12/31] ARC: Interrupt Handling
In-Reply-To: <1352281674-2186-13-git-send-email-vgupta@synopsys.com>
Message-ID: <alpine.LFD.2.02.1211122059101.10000@ionos>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-13-git-send-email-vgupta@synopsys.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012, Vineet Gupta wrote:
> +void __init init_IRQ(void)
> +{
> +	const int irq = TIMER0_IRQ;
> +
> +	/*
> +	 * Each CPU needs to register irq of it's private TIMER0.
> +	 * The APIs request_percpu_irq()/enable_percpu_irq() will not be
> +	 * functional, if we don't "prep" the generic IRQ sub-system with
> +	 * the following:
> +	 * -Ensure that devid passed to request_percpu_irq() is indeed per cpu
> +	 * -disable NOAUTOEN, w/o which the device handler never gets called

What sets NOAUTOEN in the first place? The core code definitely does
not.

> +	 */
> +	irq_set_percpu_devid(irq);
> +	irq_modify_status(irq, IRQ_NOAUTOEN, 0);

Aside of that we have irq_clear_status_flags() for this.

> +	plat_init_IRQ();
> +}

> +int __init get_hw_config_num_irq(void)

How is that function used ?

> +{
> +	uint32_t val = read_aux_reg(ARC_REG_VECBASE_BCR);
> +
> +	switch (val & 0x03) {
> +	case 0:
> +		return 16;
> +	case 1:
> +		return 32;
> +	case 2:
> +		return 8;
> +	default:
> +		return 0;
> +	}
> +
> +	return 0;
> +}

Thanks,

	tglx
