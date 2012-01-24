Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab2AXI0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 03:26:45 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42791 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab2AXI0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 03:26:44 -0500
Message-ID: <4F1E6B40.3000400@monstr.eu>
Date: Tue, 24 Jan 2012 09:26:40 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Daniel Borkmann <danborkmann@iogearbox.net>
CC: linux-kernel@vger.kernel.org, Ariane Keller <ariane.keller@tik.ee.ethz.ch>
Subject: Re: [PATCH] microblaze: generic atomic64 support
References: <4F180069.6090805@iogearbox.net>
In-Reply-To: <4F180069.6090805@iogearbox.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Borkmann wrote:
> This tiny patch adds generic atomic64 support for the Microblaze
> architecture.
> 
> The patch is against the latest linux-2.6-microblaze tree. It also
> fixes the kernel build for microblaze:
> 
> CC kernel/trace/trace_clock.o 
> kernel/trace/trace_clock.c:117: error: expected '=', ',', ';', 'asm' 
> or '__attribute__' before 'trace_counter' 
> kernel/trace/trace_clock.c: In function 'trace_clock_counter': 
> kernel/trace/trace_clock.c:126: error: implicit declaration of 
> function 'atomic64_add_return' 
> kernel/trace/trace_clock.c:126: error: 'trace_counter' undeclared 
> (first use in this function) 
> kernel/trace/trace_clock.c:126: error: (Each undeclared identifier is 
> reported only once 
> kernel/trace/trace_clock.c:126: error: for each function it appears in.) 
> make[2]: *** [kernel/trace/trace_clock.o] Error 1 
> make[1]: *** [kernel/trace] Error 2 
> make: *** [kernel] Error 2 
> 
> (the patch got corrupted beforehand, to that's why the resend)
> 
> 
> Signed-off-by: Ariane Keller <ariane.keller@tik.ee.ethz.ch>
> Signed-off-by: Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>
> ---
>  arch/microblaze/Kconfig              |    1 +
>  arch/microblaze/include/asm/atomic.h |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
> index 74f23a4..c8d6efb 100644
> --- a/arch/microblaze/Kconfig
> +++ b/arch/microblaze/Kconfig
> @@ -19,6 +19,7 @@ config MICROBLAZE
>  	select GENERIC_IRQ_SHOW
>  	select GENERIC_PCI_IOMAP
>  	select GENERIC_CPU_DEVICES
> +	select GENERIC_ATOMIC64
>  
>  config SWAP
>  	def_bool n
> diff --git a/arch/microblaze/include/asm/atomic.h b/arch/microblaze/include/asm/atomic.h
> index 6d2e1d4..615f539 100644
> --- a/arch/microblaze/include/asm/atomic.h
> +++ b/arch/microblaze/include/asm/atomic.h
> @@ -2,6 +2,7 @@
>  #define _ASM_MICROBLAZE_ATOMIC_H
>  
>  #include <asm-generic/atomic.h>
> +#include <asm-generic/atomic64.h>
>  
>  /*
>   * Atomically test *v and decrement if it is greater than 0.

Applied to microblaze next branch.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
