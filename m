Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1KEQAk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 12:00:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56498 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab1KEQAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 12:00:39 -0400
Date: Sat, 5 Nov 2011 16:00:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Weber <weber@corscience.de>
Cc: tony@atomide.com, arnd@arndb.de,
        "open list:OMAP SUPPORT" <linux-omap@vger.kernel.org>,
        "open list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP3: Fix dependencies for OMAP3_EMU
Message-ID: <20111105160020.GA15294@n2100.arm.linux.org.uk>
References: <1320512279-9032-1-git-send-email-weber@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320512279-9032-1-git-send-email-weber@corscience.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 05, 2011 at 05:57:59PM +0100, Thomas Weber wrote:
> This patch fixes the dependencies for OMAP3_EMU after
> commit 53eebb0df85e4005
> ARM: OC_ETM should not select ARM_AMBA
> 
> When "OMAP3 debugging peripherals" is selected the warning:
> (OMAP3_EMU) selects OC_ETM which
> has unmet direct dependencies (ARM_AMBA)

There is a patch from Arnd addressing this which was sent in October.
It was acked by Santosh and Tony.  What happened to it?

> appears, which results in:
> 
> arch/arm/kernel/built-in.o: In function `etm_remove':
> arch/arm/kernel/etm.c:608:
> undefined reference to `amba_release_regions'
> arch/arm/kernel/built-in.o: In function `etb_remove':
> arch/arm/kernel/etm.c:408:
> undefined reference to `amba_release_regions'
> arch/arm/kernel/built-in.o: In function `etm_init':
> arch/arm/kernel/etm.c:639:
> undefined reference to `amba_driver_register'
> arch/arm/kernel/etm.c:645:
> undefined reference to `amba_driver_register'
> arch/arm/kernel/etm.c:647:
> undefined reference to `amba_driver_unregister'
> arch/arm/kernel/built-in.o: In function `etm_probe':
> arch/arm/kernel/etm.c:544:
> undefined reference to `amba_request_regions'
> arch/arm/kernel/etm.c:594:
> undefined reference to `amba_release_regions'
> arch/arm/kernel/built-in.o: In function `etb_probe':
> arch/arm/kernel/etm.c:346:
> undefined reference to `amba_request_regions'
> arch/arm/kernel/etm.c:391:
> undefined reference to `amba_release_regions'
> arch/arm/mach-omap2/built-in.o: In function `emu_init':
> arch/arm/mach-omap2/emu.c:62:
> undefined reference to `amba_device_register'
> arch/arm/mach-omap2/emu.c:63:
> undefined reference to `amba_device_register'
> make: *** [.tmp_vmlinux1] Error 1
> 
> Signed-off-by: Thomas Weber <weber@corscience.de>
> ---
>  arch/arm/mach-omap2/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index c3d530b..9c5354a 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -30,6 +30,7 @@ config ARCH_OMAP3
>  	bool "TI OMAP3"
>  	depends on ARCH_OMAP2PLUS
>  	default y
> +	select ARM_AMBA
>  	select CPU_V7
>  	select USB_ARCH_HAS_EHCI
>  	select ARM_L1_CACHE_SHIFT_6 if !ARCH_OMAP4
> -- 
> 1.7.7.2
> 
