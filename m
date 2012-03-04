Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2CDSkT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 13:40:19 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46673 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab2CDSkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 13:40:18 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of olof@lixom.net designates 10.68.233.36 as permitted sender) smtp.mail=olof@lixom.net
Date: Sun, 4 Mar 2012 10:40:15 -0800
From: Olof Johansson <olof@lixom.net>
To: Alan Ott <alan@signal11.us>
Cc: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 5/6] ARM: tegra: USB_ULPI needs USB
Message-ID: <20120304184015.GE31064@quad.lixom.net>
References: <1330721919-8800-1-git-send-email-alan@signal11.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330721919-8800-1-git-send-email-alan@signal11.us>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 03:58:39PM -0500, Alan Ott wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The USB_ULPI driver is selected by tegra, but can only be
> built if at least one of USB or USB_GADGET is enabled.
> The kernel fails to link if both are off.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Alan Ott <alan@signal11.us>
> ---
>  arch/arm/mach-tegra/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
> index 60f3e4b..9bb8a37 100644
> --- a/arch/arm/mach-tegra/Kconfig
> +++ b/arch/arm/mach-tegra/Kconfig
> @@ -10,6 +10,7 @@ config ARCH_TEGRA_2x_SOC
>  	select USB_ARCH_HAS_EHCI if USB_SUPPORT
>  	select USB_ULPI if USB_SUPPORT
>  	select USB_ULPI_VIEWPORT if USB_SUPPORT
> +	select USB_GADGET if USB_SUPPORT && !USB
>  	select CPU_FREQ_TABLE if CPU_FREQ
>  	help
>  	  Support for NVIDIA Tegra AP20 and T20 processors, based on the

This is another patch that needs the same change for T30.


-Olof
