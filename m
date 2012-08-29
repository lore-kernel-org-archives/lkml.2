Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab2H2Vsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 17:48:53 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36906 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab2H2Vsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 17:48:52 -0400
Message-ID: <503E8E6E.1010101@wwwdotorg.org>
Date: Wed, 29 Aug 2012 14:49:34 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] clk: Make the generic clock API available by default
References: <1346186104-4083-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1346186104-4083-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/12 13:35, Mark Brown wrote:
> Rather than requiring platforms to select the generic clock API to make
> it available make the API available as a user selectable option unless the
> user either selects HAVE_CUSTOM_CLK (if they have their own implementation)
> or selects COMMON_CLK (if they depend on the generic implementation).
>
> All current architectures that HAVE_CLK but don't use the common clock
> framework have selects of HAVE_CUSTOM_CLK added.
>
> This allows drivers to use the generic API on platforms which have no need
> for the clock API at platform level.

> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig

> @@ -674,6 +676,7 @@ config ARCH_TEGRA
>   	select GENERIC_CLOCKEVENTS
>   	select GENERIC_GPIO
>   	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK

For 3.7, Tegra will switch to the common clock framework. I think this 
patch would then disable that. How should we resolve this - rebase the 
Tegra common-clk tree on top of any branch containing this patch in 
order to remove that select statement?
