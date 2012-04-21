Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2DUKqq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 06:46:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36649 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2DUKqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 06:46:45 -0400
Date: Sat, 21 Apr 2012 11:46:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/17] ARM clps711x: Simple optimise debug_macro by
	removing one NOP
Message-ID: <20120421104627.GD24211@n2100.arm.linux.org.uk>
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru> <1334999490-27177-13-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334999490-27177-13-git-send-email-shc_work@mail.ru>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 01:11:25PM +0400, Alexander Shiyan wrote:
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  arch/arm/mach-clps711x/include/mach/debug-macro.S |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-clps711x/include/mach/debug-macro.S b/arch/arm/mach-clps711x/include/mach/debug-macro.S
> index 118b3d9..37c4d8a 100644
> --- a/arch/arm/mach-clps711x/include/mach/debug-macro.S
> +++ b/arch/arm/mach-clps711x/include/mach/debug-macro.S
> @@ -14,10 +14,8 @@
>  #include <mach/hardware.h>
>  
>  		.macro	addruart, rp, rv, tmp
> -#ifndef CONFIG_DEBUG_CLPS711X_UART2
> -		mov	\rp, #0x0000	@ UART1
> -#else
> -		mov	\rp, #0x1000	@ UART2
> +#ifdef CONFIG_DEBUG_CLPS711X_UART2
> +		mov	\rp, #0x1000	@ Add offset for UART2 base reg
>  #endif

This looks wrong.  How is rp initialized if CONFIG_DEBUG_CLPS711X_UART2 is
not set?
