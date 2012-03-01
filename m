Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab2CAUFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:05:41 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49965 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284Ab2CAUFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:05:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of olof@lixom.net designates 10.236.157.10 as permitted sender) smtp.mail=olof@lixom.net
MIME-Version: 1.0
X-Originating-IP: [172.22.162.26]
In-Reply-To: <1330630010-11241-4-git-send-email-alan@signal11.us>
References: <1330630010-11241-1-git-send-email-alan@signal11.us>
	<1330630010-11241-4-git-send-email-alan@signal11.us>
Date: Thu, 1 Mar 2012 12:05:37 -0800
Message-ID: <CAOesGMiFbggUz6_GH-5htzFJuaXzeYhXpTfHafy-LSPAEmkQnw@mail.gmail.com>
Subject: Re: [PATCH 3/8] ARM: tegra: select CPU_FREQ_TABLE
From: Olof Johansson <olof@lixom.net>
To: Alan Ott <alan@signal11.us>
Cc: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 1, 2012 at 11:26 AM, Alan Ott <alan@signal11.us> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> The tegra cpufreq implementation relies on the cpu_freq_table
> code, so make sure that this is always there when needed.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-tegra/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
> index 373652d..b2a038e 100644
> --- a/arch/arm/mach-tegra/Kconfig
> +++ b/arch/arm/mach-tegra/Kconfig
> @@ -10,6 +10,7 @@ config ARCH_TEGRA_2x_SOC
>        select USB_ARCH_HAS_EHCI if USB_SUPPORT
>        select USB_ULPI if USB_SUPPORT
>        select USB_ULPI_VIEWPORT if USB_SUPPORT
> +       select CPU_FREQ_TABLE if CPU_FREQ

The corresponding chance is needed for T30 as well.

(the cpufreq driver should probably be moved out to drivers/cpufreq
and given its own but that's a separate issue)


-Olof
