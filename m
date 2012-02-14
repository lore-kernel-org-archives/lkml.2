Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915Ab2BNUiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 15:38:08 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:53109 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760717Ab2BNUiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 15:38:06 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/wJzsq6pnerPBN4wYU4jFw
Date: Tue, 14 Feb 2012 12:38:01 -0800
From: Tony Lindgren <tony@atomide.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH 3.3 v2] OMAP4: PRM: fix build breakage when CONFIG_OF
 is not defined
Message-ID: <20120214203801.GU1426@atomide.com>
References: <1328699683-19357-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328699683-19357-1-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luciano Coelho <coelho@ti.com> [120208 02:43]:
> Since 3.3-rc1, prm44xx.c build breaks if CONFIG_OF is not set:
> 
> arch/arm/mach-omap2/prm44xx.c:41: error: 'OMAP44XX_IRQ_PRCM' undeclared here (not in a function)
> make[1]: *** [arch/arm/mach-omap2/prm44xx.o] Error 1
> 
> This is because of a missing include, which is added indirectly if
> CONFIG_OF is defined.  This problem was introduced in commit
> 2f31b51 (ARM: OMAP4: PRM: use PRCM interrupt handler).
> 
> Cc: Tero Kristo <t-kristo@ti.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>

A similar patch should be already in mainline kernel queued by Russell.

Tony

> ---
> v2: changed the commit log to use abbrev sha and include the commit subject
> 
>  arch/arm/mach-omap2/prm44xx.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/prm44xx.c b/arch/arm/mach-omap2/prm44xx.c
> index 33dd655..f2e06ad 100644
> --- a/arch/arm/mach-omap2/prm44xx.c
> +++ b/arch/arm/mach-omap2/prm44xx.c
> @@ -20,6 +20,7 @@
>  #include "common.h"
>  #include <plat/cpu.h>
>  #include <plat/prcm.h>
> +#include <plat/irqs.h>
>  
>  #include "vp.h"
>  #include "prm44xx.h"
> -- 
> 1.7.5.4
> 
