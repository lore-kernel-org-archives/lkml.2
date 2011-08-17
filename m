Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab1HQHgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 03:36:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:50188 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab1HQHgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 03:36:07 -0400
Date: Wed, 17 Aug 2011 09:36:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Axel Lin <axel.lin@gmail.com>
cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Footbridge: select CLKEVT_I8253 for
 ARCH_NETWINDER
In-Reply-To: <1313562543.2024.1.camel@phoenix>
Message-ID: <alpine.LFD.2.02.1108170935450.2807@ionos>
References: <1313562543.2024.1.camel@phoenix>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Aug 2011, Axel Lin wrote:

> Since commit 8560a6cfc9818edde1fd8677961714b264ffa03d
> "arm: Footbridge: Use common i8253 clockevent",
> ARCH_NETWINDER nees to select CLKEVT_I8253.
> 
> This patch fixes below build error with "make netwinder_defconfig".
> 
>   LD      .tmp_vmlinux1
> arch/arm/mach-footbridge/built-in.o: In function `isa_timer_init':
> isa-rtc.c:(.init.text+0x12c8): undefined reference to `clockevent_i8253_init'
> isa-rtc.c:(.init.text+0x12d0): undefined reference to `i8253_clockevent'
> arch/arm/mach-footbridge/built-in.o:(.data+0x198): undefined reference to `i8253_clockevent'
> make: *** [.tmp_vmlinux1] Error 1
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>


> ---
>  arch/arm/mach-footbridge/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-footbridge/Kconfig b/arch/arm/mach-footbridge/Kconfig
> index dc26fff..c8e7afc 100644
> --- a/arch/arm/mach-footbridge/Kconfig
> +++ b/arch/arm/mach-footbridge/Kconfig
> @@ -62,6 +62,7 @@ config ARCH_EBSA285_HOST
>  config ARCH_NETWINDER
>  	bool "NetWinder"
>  	select CLKSRC_I8253
> +	select CLKEVT_I8253
>  	select FOOTBRIDGE_HOST
>  	select ISA
>  	select ISA_DMA
> -- 
> 1.7.4.1
> 
> 
> 
> 
