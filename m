Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab1JCF2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 01:28:33 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:49706 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755041Ab1JCF2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 01:28:30 -0400
Message-ID: <4E8947F7.2070108@ti.com>
Date: Mon, 03 Oct 2011 10:58:23 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 26/30] ARM: omap: add board autoselection
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-27-git-send-email-arnd@arndb.de>
In-Reply-To: <1317566760-25681-27-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 October 2011 08:15 PM, Arnd Bergmann wrote:
> At least one board file needs to be selected to successfully build
> a kernel, so this one adds logic to the omap Kconfig file to
> pick one default board file when all others are disabled. Since
> the available boards depend on the SoC family (omap2/3/4) being
> selected first, this adds one default for each family.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-omap2/Kconfig |   39 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 39 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index 3c9fb89..fd0ab18 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -120,6 +120,45 @@ config MACH_OMAP_GENERIC
>  	depends on ARCH_OMAP2
>  	default y
>  
> +config MACH_OMAP_AUTO_BOARD
> +	def_bool y
> +	depends on !MACH_OMAP2_TUSB6010
> +	depends on !MACH_OMAP_H4
> +	depends on !MACH_OMAP_APOLLON
> +	depends on !MACH_OMAP_APOLLON
> +	depends on !MACH_OMAP_2430SDP
> +	depends on !MACH_OMAP3_BEAGLE
> +	depends on !MACH_DEVKIT8000
> +	depends on !MACH_OMAP_LDP
> +	depends on !MACH_OMAP3530_LV_SOM
> +	depends on !MACH_OMAP3_TORPEDO
> +	depends on !MACH_OVERO
> +	depends on !MACH_OMAP3EVM
> +	depends on !MACH_OMAP3517EVM
> +	depends on !MACH_CRANEBOARD
> +	depends on !MACH_OMAP3_PANDORA
> +	depends on !MACH_OMAP3_TOUCHBOOK
> +	depends on !MACH_NOKIA_N8X0
> +	depends on !MACH_NOKIA_RM680
> +	depends on !MACH_NOKIA_RX51
> +	depends on !MACH_OMAP_ZOOM2
> +	depends on !MACH_OMAP_ZOOM3
> +	depends on !MACH_CM_T35
> +	depends on !MACH_CM_T3517
> +	depends on !MACH_IGEP0020
> +	depends on !MACH_IGEP0030
> +	depends on !MACH_SBC3530
> +	depends on !MACH_OMAP_3630SDP
> +	depends on !MACH_TI8168EVM
> +	depends on !MACH_OMAP4_PANDA
Do we need all above 'depends on *' ?
Even if they get selected for one of the below
ARCH along with default machine, build should be happy.
Right ?

> +	select MACH_OMAP_GENERIC if ARCH_OMAP2
> +	select MACH_OMAP_3430SDP if ARCH_OMAP3 && !ARCH_OMAP2
> +	select MACH_OMAP_4430SDP if ARCH_OMAP4 && !ARCH_OMAP3 && !ARCH_OMAP2
This is fine.
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
