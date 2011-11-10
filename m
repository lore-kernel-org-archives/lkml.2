Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab1KJW5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 17:57:48 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51355 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab1KJW5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 17:57:46 -0500
Date: Thu, 10 Nov 2011 22:57:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 16/16] ARM: LPAE: Add the Kconfig entries
Message-ID: <20111110225737.GX12913@n2100.arm.linux.org.uk>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com> <1320682618-1182-17-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320682618-1182-17-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 04:16:58PM +0000, Catalin Marinas wrote:
> This patch adds the ARM_LPAE and ARCH_PHYS_ADDR_T_64BIT Kconfig entries
> allowing LPAE support to be compiled into the kernel.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm/Kconfig    |    2 +-
>  arch/arm/mm/Kconfig |   17 +++++++++++++++++
>  2 files changed, 18 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 44789ef..885c04e 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1959,7 +1959,7 @@ endchoice
>  
>  config XIP_KERNEL
>  	bool "Kernel Execute-In-Place from ROM"
> -	depends on !ZBOOT_ROM
> +	depends on !ZBOOT_ROM && !ARM_LPAE
>  	help
>  	  Execute-In-Place allows the kernel to run from non-volatile storage
>  	  directly addressable by the CPU, such as NOR flash. This saves RAM
> diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
> index 67f75a0..d289cdb 100644
> --- a/arch/arm/mm/Kconfig
> +++ b/arch/arm/mm/Kconfig
> @@ -629,6 +629,23 @@ config IO_36
>  
>  comment "Processor Features"
>  
> +config ARM_LPAE
> +	bool "Support for the Large Physical Address Extension"
> +	depends on MMU && CPU_V7
> +	help
> +	  Say Y if you have an ARMv7 processor supporting the LPAE page
> +	  table format and you would like to access memory beyond the
> +	  4GB limit. The resulting kernel image will not run on
> +	  processors without the LPA extension.
> +
> +	  If unsure, say N.
> +
> +config ARCH_PHYS_ADDR_T_64BIT
> +	def_bool ARM_LPAE
> +
> +config ARCH_DMA_ADDR_T_64BIT
> +	def_bool ARM_LPAE
> +

I still say this shouldn't depend on the host page table format.  LPAE
itself has nothing to do with whether 64-bit DMA addresses are supported
by the system.
