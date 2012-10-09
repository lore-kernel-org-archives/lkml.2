Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab2JIQU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:20:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:39199 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab2JIQUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:20:25 -0400
Date: Tue, 9 Oct 2012 18:20:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Magnus Damm <damm@opensource.se>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2/9] ARM: export set_irq_flags
In-Reply-To: <1349796183-30648-3-git-send-email-arnd@arndb.de>
Message-ID: <alpine.LFD.2.02.1210091820020.10988@ionos>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de> <1349796183-30648-3-git-send-email-arnd@arndb.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Oct 2012, Arnd Bergmann wrote:

> The recently added Emma Mobile GPIO driver calls set_irq_flags
> and irq_set_chip_and_handler for the interrupts it exports and
> it can be built as a module, which currently fails with
> 
> ERROR: "set_irq_flags" [drivers/gpio/gpio-em.ko] undefined!
> 
> We either need to replace the call to set_irq_flags with something
> else or export that function. This patch does the latter.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Magnus Damm <damm@opensource.se>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Thomas Gleixner <tglx@linutronix.de>

Acked-by-me

> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  arch/arm/kernel/irq.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
> index 16cedb4..8961650 100644
> --- a/arch/arm/kernel/irq.c
> +++ b/arch/arm/kernel/irq.c
> @@ -34,6 +34,7 @@
>  #include <linux/list.h>
>  #include <linux/kallsyms.h>
>  #include <linux/proc_fs.h>
> +#include <linux/export.h>
>  
>  #include <asm/exception.h>
>  #include <asm/mach/arch.h>
> @@ -109,6 +110,7 @@ void set_irq_flags(unsigned int irq, unsigned int iflags)
>  	/* Order is clear bits in "clr" then set bits in "set" */
>  	irq_modify_status(irq, clr, set & ~clr);
>  }
> +EXPORT_SYMBOL_GPL(set_irq_flags);
>  
>  void __init init_IRQ(void)
>  {
> -- 
> 1.7.10
> 
> 
