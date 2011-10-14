Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379Ab1JNSEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:04:52 -0400
Received: from relais.videotron.ca ([24.201.245.36]:8788 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933344Ab1JNSEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:04:51 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Fri, 14 Oct 2011 14:04:50 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Olof Johansson <olof@lixom.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, ccross@android.com, arnd@arndb.de,
        swarren@nvidia.com, pdeschrijver@nvidia.com
Subject: Re: [PATCH] ARM: mutually exclude ZBOOT_ROM and AUTO_ZRELADDR
In-reply-to: <1318607945-6807-1-git-send-email-olof@lixom.net>
Message-id: <alpine.LFD.2.02.1110141404060.17040@xanadu.home>
References: <20111014071500.GP21648@n2100.arm.linux.org.uk>
 <1318607945-6807-1-git-send-email-olof@lixom.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Olof Johansson wrote:

> This way platforms that want it can select AUTO_ZRELADDR without issues caused by
> someone manually also enabling ZBOOT_ROM.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>

Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>

Certainly harmless for the time being.



> ---
>  arch/arm/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> 
> Russell King wrote at Friday, October 14, 2011 1:15 AM:
> 
> > I'll point out that this makes Tegra incompatible with ZBOOT_ROM, which
> > can still be enabled.  ZBOOT_ROM=y AUTO_ZRELADDR=y is an invalid
> > configuration at runtime.
> 
> Ah, looks like the dependency is only one-way. Since they are mutually
> exclusive, how about the below?
> 
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 82973b2..2ad58e8 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1814,6 +1814,7 @@ config ZBOOT_ROM_BSS
>  config ZBOOT_ROM
>  	bool "Compressed boot loader in ROM/flash"
>  	depends on ZBOOT_ROM_TEXT != ZBOOT_ROM_BSS
> +	depends on !AUTO_ZRELADDR
>  	help
>  	  Say Y here if you intend to execute your compressed kernel image
>  	  (zImage) directly from ROM or flash.  If unsure, say N.
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
