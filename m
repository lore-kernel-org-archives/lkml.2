Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab2HVOkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:40:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34577 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756491Ab2HVOkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:40:13 -0400
Date: Wed, 22 Aug 2012 15:39:46 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ARM: allow PID_IN_CONTEXTIDR only for ARMv7
Message-ID: <20120822143946.GM9093@mudshark.cambridge.arm.com>
References: <1345645780-2749-1-git-send-email-arnd@arndb.de>
 <1345645780-2749-3-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345645780-2749-3-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Wed, Aug 22, 2012 at 03:29:38PM +0100, Arnd Bergmann wrote:
> When ARMv6 is enabled, we build the kernel with -march=armv6 or
> -march=armv6k, which means the bfi instruction is not available.
> Instead, it only works with -march=armv6t2 or -march=armv7-a.
> 
> Without this patch, building rand-enIHAOL results in:
> 
> /tmp/ccwCsCXC.s: Assembler messages:
> /tmp/ccwCsCXC.s:49: Error: selected processor does not support ARM mode `bfi r3,r2,#0,#8'
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  arch/arm/Kconfig.debug |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index f15f82b..11b9ff4 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -398,6 +398,7 @@ config ARM_KPROBES_TEST
>  config PID_IN_CONTEXTIDR
>  	bool "Write the current PID to the CONTEXTIDR register"
>  	depends on CPU_COPY_V6
> +	depends on CPU_V7 && !CPU_V6
>  	help
>  	  Enabling this option causes the kernel to write the current PID to
>  	  the PROCID field of the CONTEXTIDR register, at the expense of some

Nah, I'll fix the contextidr_notifier instead. I forgot that this stuff gets
used on non-SMP v6 platforms.

Cheers,

Will
