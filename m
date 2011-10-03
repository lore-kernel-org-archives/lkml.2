Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab1JCFjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 01:39:47 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:49560 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755041Ab1JCFjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 01:39:40 -0400
Message-ID: <4E894A95.5030107@ti.com>
Date: Mon, 03 Oct 2011 11:09:33 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/30] ARM: omap: select CPU_FREQ_TABLE where needed
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-29-git-send-email-arnd@arndb.de>
In-Reply-To: <1317566760-25681-29-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 October 2011 08:15 PM, Arnd Bergmann wrote:
> The omap platform requires CPU_FREQ_TABLE support to be enabled for its
> CPU_FREQ implementations, so automatically select that when CPU_FREQ
> is enabled.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/plat-omap/Kconfig |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
> index bb8f4a6..f7ef9f4 100644
> --- a/arch/arm/plat-omap/Kconfig
> +++ b/arch/arm/plat-omap/Kconfig
> @@ -217,6 +217,11 @@ config OMAP_PM_NOOP
>  
>  endchoice
>  
> +config OMAP_CPU_FREQ
> +	def_bool "y"
> +	depends on CPU_FREQ
> +	select CPU_FREQ_TABLE
> +
>  endmenu
With CPUFREQ series from Kevin [1], I don't think we need this any-more.
More so, I didn't find OMAP_CPU_FREQ is being used anywhere on mainline.

Regards
Santosh
[1] http://www.mail-archive.com/linux-omap@vger.kernel.org/msg56288.html

