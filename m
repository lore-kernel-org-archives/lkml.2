Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab0EFTqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 15:46:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49331 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075Ab0EFTqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 15:46:31 -0400
Date: Thu, 6 May 2010 20:36:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jiri Olsa <jolsa@redhat.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       ysato@users.sourceforge.jp, tony.luck@intel.com, dhowells@redhat.com,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       jgarzik@pobox.com, hare@suse.de, felipe.balbi@nokia.com
Subject: Re: [PATCH 03/13] arm: removing redundant ifdefs
Message-ID: <20100506193613.GA26818@n2100.arm.linux.org.uk>
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com> <1273167377-14270-4-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273167377-14270-4-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, it's finally come through.

On Thu, May 06, 2010 at 07:36:07PM +0200, Jiri Olsa wrote:
> --- a/arch/arm/include/asm/processor.h
> +++ b/arch/arm/include/asm/processor.h
> @@ -22,11 +22,9 @@
>  #include <asm/ptrace.h>
>  #include <asm/types.h>
>  
> -#ifdef __KERNEL__
>  #define STACK_TOP	((current->personality & ADDR_LIMIT_32BIT) ? \
>  			 TASK_SIZE : TASK_SIZE_26)
>  #define STACK_TOP_MAX	TASK_SIZE
> -#endif

This one is correct.

> --- a/arch/arm/mach-ixp23xx/include/mach/platform.h
> +++ b/arch/arm/mach-ixp23xx/include/mach/platform.h
> @@ -43,7 +43,6 @@ extern struct sys_timer ixp23xx_timer;
>  
>  #define IXP23XX_UART_XTAL		14745600
>  
> -#ifndef __ASSEMBLY__
>  /*
>   * Is system memory on the XSI or CPP bus?
>   */
> @@ -51,7 +50,5 @@ static inline unsigned ixp23xx_cpp_boot(void)
>  {
>  	return (*IXP23XX_EXP_CFG0 & IXP23XX_EXP_CFG0_XSI_NOT_PRES);
>  }
> -#endif

Ok too.

> --- a/arch/arm/plat-omap/include/plat/clock.h
> +++ b/arch/arm/plat-omap/include/plat/clock.h
> @@ -133,17 +133,12 @@ struct clk {
>  	__s8			usecount;
>  	u8			fixed_div;
>  	u8			flags;
> -#ifdef CONFIG_ARCH_OMAP2PLUS
>  	void __iomem		*clksel_reg;
>  	u32			clksel_mask;
>  	const struct clksel	*clksel;
>  	struct dpll_data	*dpll_data;
>  	const char		*clkdm_name;
>  	struct clockdomain	*clkdm;
> -#else
> -	__u8			rate_offset;
> -	__u8			src_offset;
> -#endif

This is wrong.  There is a preceding #ifdef CONFIG_ARCH_OMAP2PLUS, but
there's also a preceding #endif terminating that conditional section.
