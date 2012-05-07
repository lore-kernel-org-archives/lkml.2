Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab2EGNMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:12:36 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51605 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab2EGNMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:12:35 -0400
Date: Mon, 7 May 2012 15:12:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 apic: only compile local function if used
Message-ID: <20120507131229.GF23858@gmail.com>
References: <4F89FD7C.2060707@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F89FD7C.2060707@freemail.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Németh Márton <nm127@freemail.hu> wrote:

> From: Márton Németh <nm127@freemail.hu>
> 
> The local function io_apic_level_ack_pending() is only called from
> io_apic_level_ack_pending(). The later function is only compiled
> if CONFIG_GENERIC_PENDING_IRQ is defined. Use this define around
> io_apic_level_ack_pending() function as well.
> 
> This will remove the following warning message during compiling
> without CONFIG_GENERIC_PENDING_IRQ defined:
>  * arch/x86/kernel/apic/io_apic.c:382: warning: ‘io_apic_level_ack_pending’ defined but not used
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index e88300d..9b85009 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -379,6 +379,7 @@ static void __io_apic_modify(unsigned int apic, unsigned int reg, unsigned int v
>  	writel(value, &io_apic->data);
>  }
> 
> +#ifdef CONFIG_GENERIC_PENDING_IRQ
>  static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
>  {
>  	struct irq_pin_list *entry;
> @@ -401,6 +402,7 @@ static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
> 
>  	return false;
>  }
> +#endif
> 
>  union entry_union {
>  	struct { u32 w1, w2; };

it would be better/cleaner to just move this function into the 
already existing #ifdef CONFIG_GENERIC_PENDING_IRQ block.

Thanks,

	Ingo
